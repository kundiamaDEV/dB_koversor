// Testes da matemática de conversão do dB Konversor.
//
// Os valores de referência vêm de `reference_values.dart`, que não importa
// nada de `lib/`. Ver a nota no topo desse ficheiro para a justificação.
//
// TOLERÂNCIAS
// -----------
// Não se exige igualdade exacta entre doubles: as operações log/pow introduzem
// erro de arredondamento da ordem do épsilon da máquina (2,22e−16 relativo).
// Tolerâncias usadas:
//   • 1e-9  absoluto, para grandezas em dB (uma milionésima de dB é
//           muitíssimo mais fina do que qualquer instrumento real);
//   • 1e-12 relativo, para grandezas lineares (W, mW, V), comparadas por
//           razão para serem válidas em qualquer ordem de grandeza.

import 'package:db_konversor/core/power_unit.dart';
import 'package:db_konversor/features/converter/power_converter_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'reference_values.dart';

/// Tolerância absoluta para comparações de valores em decibéis.
const double dbTolerance = 1e-9;

/// Tolerância relativa para comparações de valores lineares.
const double linearRelativeTolerance = 1e-12;

void main() {
  late PowerConverterService service;

  setUp(() {
    service = PowerConverterService();
  });

  /// Converte e exige sucesso, devolvendo o valor numérico.
  double ok({
    required double input,
    required PowerUnit from,
    required PowerUnit to,
    double? impedance,
    double? reference,
  }) {
    final result = service.convert(
      inputValue: input,
      from: from,
      to: to,
      impedance: impedance,
      referenceValue: reference,
    );

    expect(
      result.isSuccess,
      isTrue,
      reason:
          'Esperava sucesso em $input ${from.label} → ${to.label}, '
          'mas falhou com: ${result.errorMessage}',
    );
    expect(result.value, isNotNull);
    expect(result.value!.isFinite, isTrue);
    return result.value!;
  }

  /// Compara valores lineares por erro relativo.
  void expectRelative(double actual, double expected, {String? reason}) {
    final denominator = expected == 0 ? 1.0 : expected.abs();
    final relative = (actual - expected).abs() / denominator;
    expect(
      relative,
      lessThan(linearRelativeTolerance),
      reason:
          reason ??
          'esperado $expected, obtido $actual '
              '(erro relativo ${relative.toStringAsExponential(3)})',
    );
  }

  // =========================================================================
  group('Potência linear ↔ potência linear', () {
    test('W → mW multiplica por 1000', () {
      expectRelative(
        ok(input: 1.0, from: PowerUnit.watt, to: PowerUnit.milliwatt),
        1000.0,
      );
      expectRelative(
        ok(input: 0.0005, from: PowerUnit.watt, to: PowerUnit.milliwatt),
        0.5,
      );
    });

    test('mW → W divide por 1000', () {
      expectRelative(
        ok(input: 2500.0, from: PowerUnit.milliwatt, to: PowerUnit.watt),
        2.5,
      );
    });

    test('zero watt é um valor linear válido', () {
      expectRelative(
        ok(input: 0.0, from: PowerUnit.watt, to: PowerUnit.milliwatt),
        0.0,
      );
    });

    test('potência negativa é rejeitada (não tem significado físico)', () {
      final result = service.convert(
        inputValue: -5.0,
        from: PowerUnit.watt,
        to: PowerUnit.milliwatt,
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
      expect(result.errorMessage, isNotEmpty);
    });
  });

  // =========================================================================
  group('dBm ↔ potência linear (âncoras exactas)', () {
    test('dBm → mW em todas as âncoras de definição', () {
      for (final (dbm, milliwatt) in dbmToMilliwattAnchors) {
        expectRelative(
          ok(input: dbm, from: PowerUnit.dbm, to: PowerUnit.milliwatt),
          milliwatt,
          reason: '$dbm dBm deve ser $milliwatt mW',
        );
      }
    });

    test('mW → dBm em todas as âncoras de definição', () {
      for (final (dbm, milliwatt) in dbmToMilliwattAnchors) {
        expect(
          ok(input: milliwatt, from: PowerUnit.milliwatt, to: PowerUnit.dbm),
          closeTo(dbm, dbTolerance),
          reason: '$milliwatt mW deve ser $dbm dBm',
        );
      }
    });

    test('30 dBm = 1 W', () {
      expectRelative(
        ok(input: 30.0, from: PowerUnit.dbm, to: PowerUnit.watt),
        1.0,
      );
      expect(
        ok(input: 1.0, from: PowerUnit.watt, to: PowerUnit.dbm),
        closeTo(30.0, dbTolerance),
      );
    });

    test('duplicar a potência acrescenta 3,0103 dB', () {
      final a = ok(input: 1.0, from: PowerUnit.milliwatt, to: PowerUnit.dbm);
      final b = ok(input: 2.0, from: PowerUnit.milliwatt, to: PowerUnit.dbm);
      expect(b - a, closeTo(10 * log10(2.0), dbTolerance));
      expect(b - a, closeTo(3.010299956640, 1e-9));
    });

    test('0 mW → dBm é rejeitado: log₁₀(0) não existe', () {
      final result = service.convert(
        inputValue: 0.0,
        from: PowerUnit.milliwatt,
        to: PowerUnit.dbm,
      );
      expect(result.isSuccess, isFalse);
    });

    test('conversão inversa dBm → mW → dBm recupera o valor', () {
      for (final dbm in <double>[-90, -40.5, -3, 0, 7.25, 33, 57.125]) {
        final milliwatt = ok(
          input: dbm,
          from: PowerUnit.dbm,
          to: PowerUnit.milliwatt,
        );
        final back = ok(
          input: milliwatt,
          from: PowerUnit.milliwatt,
          to: PowerUnit.dbm,
        );
        expect(back, closeTo(dbm, dbTolerance), reason: 'ida e volta de $dbm dBm');
      }
    });
  });

  // =========================================================================
  group('Níveis logarítmicos de tensão (dBV ↔ dBu)', () {
    test('dBu → dBV: 0 dBu equivale a 20·log₁₀(0,775) dBV', () {
      expect(
        ok(input: 0.0, from: PowerUnit.dbu, to: PowerUnit.dbv),
        closeTo(zeroDbuInDbv, dbTolerance),
      );
    });

    test('dBV → dBu: 0 dBV equivale a +2,2139659 dBu', () {
      expect(
        ok(input: 0.0, from: PowerUnit.dbv, to: PowerUnit.dbu),
        closeTo(zeroDbvInDbu, dbTolerance),
      );
    });

    test('dBu e dBV diferem por um deslocamento constante', () {
      // Ambas as escalas são 20·log₁₀ de uma tensão; só a referência difere.
      // Logo a diferença dBu − dBV não depende do nível.
      for (final level in <double>[-60, -12, 0, 4, 24, 80]) {
        final asDbv = ok(input: level, from: PowerUnit.dbu, to: PowerUnit.dbv);
        expect(
          level - asDbv,
          closeTo(zeroDbvInDbu, dbTolerance),
          reason: 'o deslocamento deve ser constante em $level dBu',
        );
      }
    });

    test('conversão inversa dBu → dBV → dBu recupera o valor', () {
      for (final dbu in <double>[-70, -18.4, 0, 4, 21.75]) {
        final dbv = ok(input: dbu, from: PowerUnit.dbu, to: PowerUnit.dbv);
        final back = ok(input: dbv, from: PowerUnit.dbv, to: PowerUnit.dbu);
        expect(back, closeTo(dbu, dbTolerance), reason: 'ida e volta de $dbu dBu');
      }
    });

    test('níveis de tensão aceitam valores negativos (são relativos)', () {
      final result = service.convert(
        inputValue: -40.0,
        from: PowerUnit.dbv,
        to: PowerUnit.dbu,
      );
      expect(result.isSuccess, isTrue);
    });
  });

  // =========================================================================
  group('Potência ↔ nível de tensão, com impedância', () {
    test('1 mW em 50 Ω é −13,0103 dBV', () {
      expect(
        ok(
          input: 0.0,
          from: PowerUnit.dbm,
          to: PowerUnit.dbv,
          impedance: 50.0,
        ),
        closeTo(zeroDbmAt50OhmsInDbv, dbTolerance),
      );
    });

    test(
      'REGRESSÃO M1 — −120 dBm em 50 Ω é −133,0103 dBV, não −114,35 dBV',
      () {
        // Este teste falha com a raiz quadrada iterativa original, que
        // truncava em 20 iterações e devolvia ≈ −114,352 dBV (erro de 18,66 dB).
        // Ver docs/AUDITORIA_INICIAL.md, defeito M1.
        expect(
          ok(
            input: -120.0,
            from: PowerUnit.dbm,
            to: PowerUnit.dbv,
            impedance: 50.0,
          ),
          closeTo(minus120DbmAt50OhmsInDbv, 1e-6),
        );
      },
    );

    test(
      'REGRESSÃO M1 — gama completa de −130 a +150 dBm contra a forma fechada',
      () {
        // Referência de um só passo: L_dBV = 10·log₁₀(P_W·R), sem raiz quadrada.
        const double ohms = 50.0;
        for (double dbm = -130; dbm <= 150; dbm += 5) {
          final watts = pow10(dbm / 10) / 1000.0;
          final expected = dbvFromWatts(watts, ohms);
          final actual = ok(
            input: dbm,
            from: PowerUnit.dbm,
            to: PowerUnit.dbv,
            impedance: ohms,
          );
          expect(
            actual,
            closeTo(expected, 1e-6),
            reason:
                '$dbm dBm em $ohms Ω: esperado '
                '${expected.toStringAsFixed(6)} dBV, '
                'obtido ${actual.toStringAsFixed(6)} dBV',
          );
        }
      },
    );

    test('potência → dBu contra a forma fechada, em 600 Ω e 50 Ω', () {
      for (final ohms in <double>[50.0, 600.0]) {
        for (double dbm = -120; dbm <= 60; dbm += 10) {
          final watts = pow10(dbm / 10) / 1000.0;
          expect(
            ok(
              input: dbm,
              from: PowerUnit.dbm,
              to: PowerUnit.dbu,
              impedance: ohms,
            ),
            closeTo(dbuFromWatts(watts, ohms), 1e-6),
            reason: '$dbm dBm em $ohms Ω → dBu',
          );
        }
      }
    });

    test('dBV → potência contra a forma fechada', () {
      for (final ohms in <double>[8.0, 50.0, 75.0, 600.0]) {
        for (double dbv = -120; dbv <= 60; dbv += 10) {
          expect(
            ok(
              input: dbv,
              from: PowerUnit.dbv,
              to: PowerUnit.watt,
              impedance: ohms,
            ),
            closeTo(
              wattsFromDbv(dbv, ohms),
              wattsFromDbv(dbv, ohms).abs() * 1e-9,
            ),
            reason: '$dbv dBV em $ohms Ω → W',
          );
        }
      }
    });

    test('dBu → potência contra a forma fechada', () {
      const double ohms = 600.0;
      for (double dbu = -60; dbu <= 30; dbu += 6) {
        expect(
          ok(
            input: dbu,
            from: PowerUnit.dbu,
            to: PowerUnit.watt,
            impedance: ohms,
          ),
          closeTo(
            wattsFromDbu(dbu, ohms),
            wattsFromDbu(dbu, ohms).abs() * 1e-9,
          ),
          reason: '$dbu dBu em $ohms Ω → W',
        );
      }
    });

    test('conversão inversa dBm → dBV → dBm recupera o valor', () {
      const double ohms = 50.0;
      for (final dbm in <double>[-110, -60, -20, 0, 13, 43, 90]) {
        final dbv = ok(
          input: dbm,
          from: PowerUnit.dbm,
          to: PowerUnit.dbv,
          impedance: ohms,
        );
        final back = ok(
          input: dbv,
          from: PowerUnit.dbv,
          to: PowerUnit.dbm,
          impedance: ohms,
        );
        expect(back, closeTo(dbm, 1e-6), reason: 'ida e volta de $dbm dBm');
      }
    });

    test('a impedância altera o resultado de forma previsível', () {
      // Duplicar a impedância a potência constante acrescenta 10·log₁₀(2) ao
      // nível de tensão, porque V² = P·R.
      final at50 = ok(
        input: 0.0,
        from: PowerUnit.dbm,
        to: PowerUnit.dbv,
        impedance: 50.0,
      );
      final at100 = ok(
        input: 0.0,
        from: PowerUnit.dbm,
        to: PowerUnit.dbv,
        impedance: 100.0,
      );
      expect(at100 - at50, closeTo(10 * log10(2.0), 1e-9));
    });

    test('impedância ausente é rejeitada quando é necessária', () {
      final result = service.convert(
        inputValue: 0.0,
        from: PowerUnit.dbm,
        to: PowerUnit.dbv,
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('impedância nula ou negativa é rejeitada', () {
      for (final bad in <double>[0.0, -50.0]) {
        final result = service.convert(
          inputValue: 0.0,
          from: PowerUnit.dbm,
          to: PowerUnit.dbv,
          impedance: bad,
        );
        expect(
          result.isSuccess,
          isFalse,
          reason: 'impedância $bad Ω deve ser rejeitada',
        );
      }
    });

    test('a impedância NÃO é exigida quando não é necessária', () {
      // dBu → dBV é uma mudança de referência de tensão: não envolve potência.
      expect(
        service.requiresImpedance(from: PowerUnit.dbu, to: PowerUnit.dbv),
        isFalse,
      );
      // W → dBm é potência para potência.
      expect(
        service.requiresImpedance(from: PowerUnit.watt, to: PowerUnit.dbm),
        isFalse,
      );
      // Potência para nível de tensão: é necessária.
      expect(
        service.requiresImpedance(from: PowerUnit.watt, to: PowerUnit.dbv),
        isTrue,
      );
      expect(
        service.requiresImpedance(from: PowerUnit.dbv, to: PowerUnit.watt),
        isTrue,
      );
    });
  });

  // =========================================================================
  group('dB relativo, com valor de referência', () {
    test('razão de potências em dB: 10·log₁₀(P/Pref)', () {
      expect(
        ok(
          input: 2.0,
          from: PowerUnit.watt,
          to: PowerUnit.db,
          reference: 1.0,
        ),
        closeTo(10 * log10(2.0), dbTolerance),
      );
      expect(
        ok(
          input: 100.0,
          from: PowerUnit.milliwatt,
          to: PowerUnit.db,
          reference: 1.0,
        ),
        closeTo(20.0, dbTolerance),
      );
    });

    test('potência igual à referência dá 0 dB', () {
      expect(
        ok(
          input: 7.3,
          from: PowerUnit.watt,
          to: PowerUnit.db,
          reference: 7.3,
        ),
        closeTo(0.0, dbTolerance),
      );
    });

    test('dB → potência: P = Pref × 10^(dB/10)', () {
      expectRelative(
        ok(
          input: 20.0,
          from: PowerUnit.db,
          to: PowerUnit.watt,
          reference: 0.5,
        ),
        50.0,
      );
    });

    test('dBm ± dB é uma soma algébrica', () {
      expect(
        ok(
          input: 23.0,
          from: PowerUnit.dbm,
          to: PowerUnit.db,
          reference: 20.0,
        ),
        closeTo(3.0, dbTolerance),
      );
      expect(
        ok(
          input: 3.0,
          from: PowerUnit.db,
          to: PowerUnit.dbm,
          reference: 20.0,
        ),
        closeTo(23.0, dbTolerance),
      );
    });

    test('conversão inversa em dB recupera o valor', () {
      final db = ok(
        input: 4.0,
        from: PowerUnit.watt,
        to: PowerUnit.db,
        reference: 0.25,
      );
      expectRelative(
        ok(
          input: db,
          from: PowerUnit.db,
          to: PowerUnit.watt,
          reference: 0.25,
        ),
        4.0,
      );
    });

    test('referência ausente é rejeitada', () {
      final result = service.convert(
        inputValue: 3.0,
        from: PowerUnit.db,
        to: PowerUnit.dbm,
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('referência de potência nula ou negativa é rejeitada', () {
      for (final bad in <double>[0.0, -1.0]) {
        expect(
          service
              .convert(
                inputValue: 2.0,
                from: PowerUnit.watt,
                to: PowerUnit.db,
                referenceValue: bad,
              )
              .isSuccess,
          isFalse,
          reason: 'referência $bad W deve ser rejeitada',
        );
      }
    });
  });

  // =========================================================================
  group('Valores-limite e entradas inválidas', () {
    test('a mesma unidade na entrada e na saída devolve o valor intacto', () {
      for (final unit in PowerUnit.values) {
        final result = service.convert(
          inputValue: 12.5,
          from: unit,
          to: unit,
        );
        expect(result.isSuccess, isTrue, reason: '${unit.label} → ${unit.label}');
        expect(result.value, 12.5);
      }
    });

    test('NaN é rejeitado', () {
      final result = service.convert(
        inputValue: double.nan,
        from: PowerUnit.dbm,
        to: PowerUnit.watt,
      );
      expect(result.isSuccess, isFalse);
    });

    test('infinito positivo e negativo são rejeitados', () {
      for (final value in <double>[double.infinity, double.negativeInfinity]) {
        final result = service.convert(
          inputValue: value,
          from: PowerUnit.dbm,
          to: PowerUnit.watt,
        );
        expect(result.isSuccess, isFalse, reason: 'entrada $value');
      }
    });

    test('nenhuma conversão devolve um resultado não finito', () {
      // Varredura ampla: nenhuma combinação pode devolver sucesso com NaN
      // ou infinito. Se o resultado estourar a gama, deve ser uma falha
      // explícita, nunca um sucesso com valor inválido.
      const extremes = <double>[
        -1e300,
        -5000,
        -1000,
        -120,
        -1,
        0,
        1,
        120,
        1000,
        5000,
        1e300,
      ];

      for (final from in PowerUnit.values) {
        for (final to in PowerUnit.values) {
          for (final value in extremes) {
            final result = service.convert(
              inputValue: value,
              from: from,
              to: to,
              impedance: 50.0,
              referenceValue: 1.0,
            );
            if (result.isSuccess) {
              expect(
                result.value,
                isNotNull,
                reason: 'sucesso sem valor em $value ${from.label}→${to.label}',
              );
              expect(
                result.value!.isFinite,
                isTrue,
                reason:
                    'valor não finito (${result.value}) devolvido como sucesso '
                    'em $value ${from.label} → ${to.label}',
              );
            } else {
              expect(
                result.errorMessage,
                isNotNull,
                reason:
                    'falha sem mensagem em $value ${from.label} → ${to.label}',
              );
            }
          }
        }
      }
    });

    test('toda a falha traz uma mensagem de erro não vazia', () {
      final failures = <Map<String, Object?>>[
        {'v': 0.0, 'from': PowerUnit.milliwatt, 'to': PowerUnit.dbm},
        {'v': -1.0, 'from': PowerUnit.watt, 'to': PowerUnit.dbm},
        {'v': double.nan, 'from': PowerUnit.dbm, 'to': PowerUnit.watt},
      ];

      for (final case_ in failures) {
        final result = service.convert(
          inputValue: case_['v']! as double,
          from: case_['from']! as PowerUnit,
          to: case_['to']! as PowerUnit,
        );
        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, isNotNull);
        expect(result.errorMessage!.trim(), isNotEmpty);
        expect(result.value, isNull);
      }
    });

    test('toda a conversão bem-sucedida traz unidade e fórmula', () {
      final result = service.convert(
        inputValue: 0.0,
        from: PowerUnit.dbm,
        to: PowerUnit.watt,
      );
      expect(result.isSuccess, isTrue);
      expect(result.outputUnitLabel, isNotEmpty);
      expect(result.formula, isNotEmpty);
    });
  });
}
