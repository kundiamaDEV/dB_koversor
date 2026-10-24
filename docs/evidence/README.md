# Evidências numéricas

## `verificacao_sqrt.dart`

Script Dart autónomo que reproduz o defeito **M1** descrito em
`../AUDITORIA_INICIAL.md`: a raiz quadrada iterativa original do
`PowerConverterService` (20 iterações de Newton-Raphson a partir de `x0 = v/2`)
comparada com `dart:math.sqrt`, ao longo da gama de -130 dBm a +100 dBm numa
impedância de 50 ohm.

Executar com:

```powershell
dart docs/evidence/verificacao_sqrt.dart
```

O script contém uma copia da funcao defeituosa, para que continue a demonstrar
o problema mesmo depois de o codigo de producao ter sido corrigido.

### Resultado obtido em 2026-10-17 (Dart 3.11.0)

```
dBm     V(correct)      V(app)          dBV(correct)  dBV(app)   erro_dB
 -130  7.0711e-8       1.9082e-6         -143.010    -114.387    28.623  <== ERRO
 -120  2.2361e-7       1.9161e-6         -133.010    -114.352    18.659  <== ERRO
 -110  7.0711e-7       1.9939e-6         -123.010    -114.006     9.005  <== ERRO
 -100  2.2361e-6       2.7103e-6         -113.010    -111.340     1.671  <== ERRO
  -90  7.0711e-6       7.0796e-6         -103.010    -103.000     0.010  <== ERRO
  -80  2.2361e-5       2.2361e-5          -93.010     -93.010     0.000
  ...  (sem erro entre -80 dBm e +100 dBm nesta impedancia)
```

## `teste_antes_da_correccao.txt`

Saida de `flutter test` executado contra o codigo **ainda nao corrigido**,
com a bateria de testes matematicos ja instalada. Mostra 35 testes aprovados e
4 reprovados, todos eles por causa de M1. E a prova de que os testes detectam
o defeito, e nao apenas de que passam depois da correccao.
