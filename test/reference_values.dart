// Valores e fórmulas de referência para os testes do dB Konversor.
//
// REGRA DESTE FICHEIRO
// --------------------
// Nada aqui pode importar `lib/`. O objectivo é dispor de uma fonte de verdade
// **independente** da implementação em teste. Se os testes reutilizassem as
// funções de produção, reproduziriam também os seus erros e passariam sempre.
//
// Duas estratégias são usadas:
//
// 1. ÂNCORAS EXACTAS — valores que decorrem da definição das unidades e que não
//    precisam de cálculo (0 dBm = 1 mW, 30 dBm = 1 W, 0 dBV = 1 V, ...).
//    Estão escritos como literais.
//
// 2. FORMA FECHADA DE UM SÓ PASSO — para as conversões entre potência e nível de
//    tensão, a referência é deduzida algebricamente de modo a **eliminar a raiz
//    quadrada**:
//
//        V = √(P·R)   e   L_dBV = 20·log₁₀(V)
//     ⇒  L_dBV = 20·log₁₀(√(P·R)) = 20·(½)·log₁₀(P·R) = 10·log₁₀(P·R)
//
//    A implementação de produção segue o caminho em dois passos (calcula V com
//    uma raiz quadrada e só depois o logaritmo); a referência segue o caminho
//    de um só passo (sem raiz quadrada). São algebricamente equivalentes mas
//    computacionalmente distintos, pelo que um erro na raiz quadrada do código
//    de produção é obrigatoriamente detectado.
//
//    Analogamente, para dBu (referência de 0,775 V):
//
//        L_dBu = 20·log₁₀(√(P·R)/0,775) = 10·log₁₀(P·R / 0,775²)

import 'dart:math' as math;

/// Referência de tensão do dBu, em volts: 0 dBu = 0,775 V.
///
/// Historicamente corresponde à tensão que dissipa 1 mW em 600 Ω
/// (√(0,001 × 600) = 0,7746 V), arredondada por convenção para 0,775 V.
/// A indústria de áudio usa 0,775 V como valor normativo, e é esse que o
/// dB Konversor aplica.
const double dbuReferenceVolts = 0.775;

/// log₁₀ independente, a partir do logaritmo natural.
double log10(double value) => math.log(value) / math.ln10;

/// 10^[exponent], a partir da biblioteca padrão.
///
/// Usa `dart:math.pow`, que não é código do dB Konversor, pelo que mantém a
/// independência exigida a este ficheiro.
double pow10(double exponent) => math.pow(10, exponent).toDouble();

// ---------------------------------------------------------------------------
// Formas fechadas de um só passo (sem raiz quadrada)
// ---------------------------------------------------------------------------

/// Nível em dBV de uma potência [watts] dissipada numa resistência [ohms].
///
/// L_dBV = 10·log₁₀(P·R) — ver nota 2 no topo do ficheiro.
double dbvFromWatts(double watts, double ohms) => 10 * log10(watts * ohms);

/// Nível em dBu de uma potência [watts] dissipada numa resistência [ohms].
///
/// L_dBu = 10·log₁₀(P·R / 0,775²)
double dbuFromWatts(double watts, double ohms) =>
    10 * log10((watts * ohms) / (dbuReferenceVolts * dbuReferenceVolts));

/// Potência em watts correspondente a um nível [dbv] numa resistência [ohms].
///
/// P = V²/R = (10^(L/20))²/R = 10^(L/10)/R — também sem raiz quadrada.
double wattsFromDbv(double dbv, double ohms) =>
    math.pow(10, dbv / 10).toDouble() / ohms;

/// Potência em watts correspondente a um nível [dbu] numa resistência [ohms].
double wattsFromDbu(double dbu, double ohms) =>
    (math.pow(10, dbu / 10).toDouble() *
        (dbuReferenceVolts * dbuReferenceVolts)) /
    ohms;

// ---------------------------------------------------------------------------
// Âncoras exactas, por definição das unidades
// ---------------------------------------------------------------------------

// Nota: as âncoras são listas de pares e não mapas constantes, porque em Dart
// um `double` não tem igualdade primitiva e não pode ser chave de um `const Map`.

/// dBm → mW. Pares exactos por definição (0 dBm ≡ 1 mW).
const List<(double, double)> dbmToMilliwattAnchors = <(double, double)>[
  (-30.0, 0.001),
  (-20.0, 0.01),
  (-10.0, 0.1),
  (0.0, 1.0),
  (10.0, 10.0),
  (20.0, 100.0),
  (30.0, 1000.0),
  (40.0, 10000.0),
];

/// dBW → W. Pares exactos por definição (0 dBW ≡ 1 W).
const List<(double, double)> dbwToWattAnchors = <(double, double)>[
  (-30.0, 0.001),
  (-20.0, 0.01),
  (-10.0, 0.1),
  (0.0, 1.0),
  (10.0, 10.0),
  (20.0, 100.0),
  (30.0, 1000.0),
];

/// dBV → V. Pares exactos por definição (0 dBV ≡ 1 V).
const List<(double, double)> dbvToVoltAnchors = <(double, double)>[
  (-40.0, 0.01),
  (-20.0, 0.1),
  (0.0, 1.0),
  (20.0, 10.0),
  (40.0, 100.0),
];

/// Diferença constante entre as escalas dBm e dBW.
///
/// P_dBm = 10·log₁₀(P_mW) = 10·log₁₀(1000·P_W) = 10·log₁₀(P_W) + 10·log₁₀(1000)
///       = P_dBW + 30
const double dbmMinusDbw = 30.0;

/// 0 dBu expresso em dBV: 20·log₁₀(0,775).
///
/// Valor verificado independentemente com 12 casas decimais:
/// log₁₀(0,775) = −0,110698297494
/// ⇒ 20 × (−0,110698297494) = −2,213965949874
const double zeroDbuInDbv = -2.213965949874;

/// 0 dBV expresso em dBu: 20·log₁₀(1/0,775) = +2,213965949874
const double zeroDbvInDbu = 2.213965949874;

/// 1 mW em 50 Ω expresso em dBV: 10·log₁₀(0,001 × 50) = 10·log₁₀(0,05).
///
/// log₁₀(0,05) = log₁₀(5) − 2 = 0,69897000434 − 2 = −1,30102999566
/// ⇒ −13,0102999566 dBV
const double zeroDbmAt50OhmsInDbv = -13.010299956640;

/// Caso crítico de potência baixa, usado como teste de regressão do defeito M1.
///
/// −120 dBm = 1e−15 W. Em 50 Ω:
///   L_dBV = 10·log₁₀(1e−15 × 50) = 10·log₁₀(5e−14)
///         = 10 × (0,69897000434 − 14) = −133,0102999566 dBV
///
/// A implementação original, com uma raiz quadrada iterativa truncada em 20
/// iterações, devolvia aproximadamente −114,352 dBV — um erro de 18,66 dB.
const double minus120DbmAt50OhmsInDbv = -133.010299956640;
