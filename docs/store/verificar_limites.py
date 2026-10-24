#!/usr/bin/env python3
"""Verifica os limites de caracteres das fichas da Google Play.

Porque existe
-------------
Os textos das fichas estao escritos em ficheiros Markdown, dentro de blocos de
codigo. Um texto que exceda o limite da loja so e rejeitado no momento da
submissao, o que e tarde. Este script conta os caracteres de cada bloco e
compara com o limite, para que o problema seja detectado antes.

Tambem verifica se a contagem declarada no proprio documento ("**71
caracteres.**") corresponde a realidade -- uma contagem escrita a mao fica
desactualizada assim que o texto e retocado.

Como usar
---------
    python docs/store/verificar_limites.py

Codigo de saida 0 se tudo esta dentro dos limites, 1 se houver excessos ou
contagens declaradas erradas.

Nota sobre a contagem
---------------------
A Google Play conta CARACTERES (pontos de codigo Unicode), nao bytes. Um
caractere chines conta 1, como uma letra latina. E o que `len()` faz em
Python 3.

Os limites abaixo eram os praticados pela Google Play em 2026-10-17. A Google
pode alterar-los; neste caso, actualizar o dicionario LIMITES.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

# A consola do Windows usa por omissao a pagina de codigos cp1252, que nao
# representa caracteres chineses. Sem isto, imprimir uma amostra do texto em
# chines faz o script falhar com UnicodeEncodeError -- o que seria um erro da
# ferramenta, nao do conteudo. `errors="replace"` troca o que nao e
# representavel por "?" em vez de abortar.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

LIMITES = {
    "nome": 30,
    "curta": 80,
    "completa": 4000,
}

# Ordem dos blocos de codigo relevantes em cada ficheiro:
# 1.o bloco  -> nome da aplicacao
# 2.o bloco  -> nome alternativo (opcional, tambem limitado a 30)
# bloco longo -> descricao completa
# Em vez de depender da ordem, cada bloco e classificado pela seccao em que
# aparece, lida dos titulos "## N. ...".
SECCAO_TIPO = [
    (re.compile(r"^##\s*1\."), "nome"),
    (re.compile(r"^##\s*2\."), "curta"),
    (re.compile(r"^##\s*3\."), "completa"),
]


def classificar_seccoes(linhas: list[str]) -> list[str | None]:
    """Devolve, para cada linha, o tipo de limite em vigor nessa linha."""
    tipos: list[str | None] = []
    actual: str | None = None

    for linha in linhas:
        if linha.startswith("## "):
            actual = None
            for padrao, tipo in SECCAO_TIPO:
                if padrao.match(linha):
                    actual = tipo
                    break
        tipos.append(actual)

    return tipos


def extrair_blocos(texto: str) -> list[tuple[str | None, int, str]]:
    """Extrai os blocos de codigo com o tipo de limite e a linha de inicio."""
    linhas = texto.split("\n")
    tipos = classificar_seccoes(linhas)

    blocos: list[tuple[str | None, int, str]] = []
    dentro = False
    inicio = 0
    acumulado: list[str] = []

    for numero, linha in enumerate(linhas):
        if linha.strip().startswith("```"):
            if not dentro:
                dentro = True
                inicio = numero
                acumulado = []
            else:
                dentro = False
                blocos.append((tipos[inicio], inicio + 1, "\n".join(acumulado)))
            continue

        if dentro:
            acumulado.append(linha)

    return blocos


def contagens_declaradas(texto: str) -> list[tuple[int, int]]:
    """Encontra as contagens escritas no documento, como "**71 caracteres.**".

    Aceita separador de milhares por espaco normal ou fino ("1 932"), e as
    variantes em varios idiomas usadas nas fichas.
    """
    padrao = re.compile(
        r"\*\*(?:cerca de |aproximadamente |about |约\s*)?"
        r"([\d   ]+)\s*"
        r"(?:caract[eè]res|caract[eè]re|characters|character|car\.|个字符)",
        re.IGNORECASE,
    )

    resultados: list[tuple[int, int]] = []
    for linha_numero, linha in enumerate(texto.split("\n"), start=1):
        for achado in padrao.finditer(linha):
            bruto = achado.group(1)
            limpo = re.sub(r"[  \s]", "", bruto)
            if limpo.isdigit():
                resultados.append((linha_numero, int(limpo)))

    return resultados


def main() -> int:
    pasta = Path(__file__).resolve().parent
    ficheiros = sorted(pasta.glob("PLAY_STORE_*.md"))

    if not ficheiros:
        print("Nenhum ficheiro PLAY_STORE_*.md encontrado em", pasta)
        return 1

    problemas = 0
    print("Verificacao dos limites de caracteres da Google Play")
    print("Limites aplicados:", ", ".join(f"{k}={v}" for k, v in LIMITES.items()))
    print()

    for ficheiro in ficheiros:
        texto = ficheiro.read_text(encoding="utf-8")
        print(f"=== {ficheiro.name} ===")

        medidos: list[int] = []

        for tipo, linha, conteudo in extrair_blocos(texto):
            if tipo is None:
                continue

            tamanho = len(conteudo)
            medidos.append(tamanho)
            limite = LIMITES[tipo]
            folga = limite - tamanho

            if tamanho > limite:
                estado = f"EXCEDE em {-folga}"
                problemas += 1
            else:
                estado = f"ok (folga {folga})"

            primeira = conteudo.split("\n", 1)[0]
            amostra = primeira[:46] + ("..." if len(primeira) > 46 else "")
            print(
                f"  linha {linha:>4}  {tipo:<9} {tamanho:>5}/{limite:<5} "
                f"{estado:<18} | {amostra}"
            )

        # Confronta as contagens escritas no documento com as medidas.
        declaradas = [valor for _, valor in contagens_declaradas(texto)]
        for linha_numero, valor in contagens_declaradas(texto):
            if valor not in medidos:
                aproximado = any(abs(valor - m) <= 30 for m in medidos)
                if aproximado:
                    print(
                        f"  linha {linha_numero:>4}  NOTA: contagem declarada "
                        f"{valor} e aproximada (medido: "
                        f"{min(medidos, key=lambda m: abs(m - valor))})"
                    )
                else:
                    print(
                        f"  linha {linha_numero:>4}  ERRO: contagem declarada "
                        f"{valor} nao corresponde a nenhum bloco medido "
                        f"{medidos}"
                    )
                    problemas += 1

        if not declaradas:
            print("  (sem contagens declaradas no documento)")

        print()

    if problemas:
        print(f"RESULTADO: {problemas} problema(s) encontrado(s).")
        return 1

    print("RESULTADO: todos os textos estao dentro dos limites e as contagens")
    print("declaradas correspondem as medidas.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
