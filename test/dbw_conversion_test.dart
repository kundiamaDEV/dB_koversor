// Testes da unidade dBW, acrescentada na auditoria de 2026-10-17 (defeito M2).
//
// dBW é uma potência absoluta referenciada a 1 W:
//   P_dBW = 10·log₁₀(P_W)
//   P_W   = 10^(P_dBW/10)
//   P_dBm = P_dBW + 30   (porque 1 W = 1000 mW e 10·log₁₀(1000) = 30)
//
// Os valores de referência vêm de `reference_values.dart`, que não importa
// nada de `lib/`.

import 'package:db_konversor/core/power_unit.dart';
import 'package:db_konversor/features/converter/power_converter_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'reference_values.dart';

const double dbTolerance = 1e-9;

void main() {
  late PowerConverterService service;

  setUp(() {
    service = PowerConverterService();
  });

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
    return result.value!;
  }

  void expectRelative(double actual, double expected, {String? reason}) {
    final denominator = expected == 0 ? 1.0 : expected.abs();
    expect(
      (actual - expected).abs() / denominator,
      lessThan(1e-12),
      reason: reason ?? 'esperado $expected, obtido $actual',
    );
  }

  group('dBW existe e está integrada', () {
    test('a unidade está declarada com o rótulo correcto', () {
      expect(PowerUnit.values, contains(PowerUnit.dbw));
      expect(PowerUnit.dbw.label, 'dBW');
    });

    test('é tratada como unidade de potência, não de tensão nem de razão', () {
      expect(PowerUnit.dbw.isPowerUnit, isTrue);
      expect(PowerUnit.dbw.isVoltageLogUnit, isFalse);
      expect(PowerUnit.dbw.isRatioUnit, isFalse);
      expect(PowerUnit.dbw.category, UnitCategory.powerLogAbsolute);
    });

    test('a descrição não está vazia e identifica a referência de 1 W', () {
      expect(PowerUnit.dbw.description, isNotEmpty);
      expect(PowerUnit.dbw.description, contains('1 W'));
    });
  });

  group('dBW ↔ W (âncoras exactas)', () {
    test('dBW → W em todas as âncoras de definição', () {
      for (final (dbw, watt) in dbwToWattAnchors) {
        expectRelative(
          ok(input: dbw, from: PowerUnit.dbw, to: PowerUnit.watt),
          watt,
          reason: '$dbw dBW deve ser $watt W',
        );
      }
    });

    test('W → dBW em todas as âncoras de definição', () {
      for (final (dbw, watt) in dbwToWattAnchors) {
        expect(
          ok(input: watt, from: PowerUnit.watt, to: PowerUnit.dbw),
          closeTo(dbw, dbTolerance),
          reason: '$watt W deve ser $dbw dBW',
        );
      }
    });

    test('0 dBW = 1 W, por definição', () {
      expectRelative(ok(input: 0.0, from: PowerUnit.dbw, to: PowerUnit.watt), 1.0);
    });
  });

  group('A relação dBm = dBW + 30', () {
    test('o deslocamento é exactamente 30 dB em toda a gama', () {
      for (double dbw = -90; dbw <= 90; dbw += 7.5) {
        final asDbm = ok(input: dbw, from: PowerUnit.dbw, to: PowerUnit.dbm);
        expect(
          asDbm - dbw,
          closeTo(dbmMinusDbw, dbTolerance),
          reason: '$dbw dBW deve ser ${dbw + 30} dBm',
        );
      }
    });

    test('0 dBW = 30 dBm e 0 dBm = −30 dBW', () {
      expect(
        ok(input: 0.0, from: PowerUnit.dbw, to: PowerUnit.dbm),
        closeTo(30.0, dbTolerance),
      );
      expect(
        ok(input: 0.0, from: PowerUnit.dbm, to: PowerUnit.dbw),
        closeTo(-30.0, dbTolerance),
      );
    });

    test('caso prático: emissor de 50 dBm é 20 dBW (100 W)', () {
      expect(
        ok(input: 50.0, from: PowerUnit.dbm, to: PowerUnit.dbw),
        closeTo(20.0, dbTolerance),
      );
      expectRelative(
        ok(input: 20.0, from: PowerUnit.dbw, to: PowerUnit.watt),
        100.0,
      );
    });
  });

  group('dBW ↔ mW', () {
    test('−30 dBW = 1 mW = 0 dBm', () {
      expectRelative(
        ok(input: -30.0, from: PowerUnit.dbw, to: PowerUnit.milliwatt),
        1.0,
      );
      expect(
        ok(input: 1.0, from: PowerUnit.milliwatt, to: PowerUnit.dbw),
        closeTo(-30.0, dbTolerance),
      );
    });

    test('dBW → mW contra a forma fechada 10^((dBW+30)/10)', () {
      for (double dbw = -60; dbw <= 60; dbw += 5) {
        expectRelative(
          ok(input: dbw, from: PowerUnit.dbw, to: PowerUnit.milliwatt),
          pow10((dbw + 30.0) / 10.0),
          reason: '$dbw dBW → mW',
        );
      }
    });
  });

  group('dBW com impedância (para níveis de tensão)', () {
    test('exige impedância para dBV e dBu', () {
      expect(
        service.requiresImpedance(from: PowerUnit.dbw, to: PowerUnit.dbv),
        isTrue,
      );
      expect(
        service.requiresImpedance(from: PowerUnit.dbu, to: PowerUnit.dbw),
        isTrue,
      );
      expect(
        service
            .convert(
              inputValue: 0.0,
              from: PowerUnit.dbw,
              to: PowerUnit.dbv,
            )
            .isSuccess,
        isFalse,
      );
    });

    test('dBW → dBV contra a forma fechada, sem raiz quadrada', () {
      for (final ohms in <double>[50.0, 75.0, 600.0]) {
        for (double dbw = -150; dbw <= 60; dbw += 10) {
          final watts = pow10(dbw / 10.0);
          expect(
            ok(
              input: dbw,
              from: PowerUnit.dbw,
              to: PowerUnit.dbv,
              impedance: ohms,
            ),
            closeTo(dbvFromWatts(watts, ohms), 1e-6),
            reason: '$dbw dBW em $ohms Ω → dBV',
          );
        }
      }
    });

    test('1 W em 50 Ω: 0 dBW equivale a 16,9897 dBV', () {
      // 10·log₁₀(1 × 50) = 10 × 1,69897000434 = 16,9897000434 dBV
      expect(
        ok(
          input: 0.0,
          from: PowerUnit.dbw,
          to: PowerUnit.dbv,
          impedance: 50.0,
        ),
        closeTo(16.9897000434, 1e-9),
      );
    });

    test('conversão inversa dBW → dBu → dBW recupera o valor', () {
      const double ohms = 600.0;
      for (final dbw in <double>[-120, -40, 0, 17.5, 60]) {
        final dbu = ok(
          input: dbw,
          from: PowerUnit.dbw,
          to: PowerUnit.dbu,
          impedance: ohms,
        );
        expect(
          ok(
            input: dbu,
            from: PowerUnit.dbu,
            to: PowerUnit.dbw,
            impedance: ohms,
          ),
          closeTo(dbw, 1e-6),
          reason: 'ida e volta de $dbw dBW',
        );
      }
    });
  });

  group('dBW em conversões relativas (dB)', () {
    test('dBW → dB é a diferença face à referência em dBW', () {
      expect(
        ok(
          input: 23.0,
          from: PowerUnit.dbw,
          to: PowerUnit.db,
          reference: 20.0,
        ),
        closeTo(3.0, dbTolerance),
      );
    });

    test('dB → dBW é a soma com a referência em dBW', () {
      expect(
        ok(
          input: -6.0,
          from: PowerUnit.db,
          to: PowerUnit.dbw,
          reference: 20.0,
        ),
        closeTo(14.0, dbTolerance),
      );
    });

    test('a referência é obrigatória', () {
      expect(
        service
            .convert(
              inputValue: 3.0,
              from: PowerUnit.dbw,
              to: PowerUnit.db,
            )
            .isSuccess,
        isFalse,
      );
    });
  });

  group('dBW: conversões inversas e limites', () {
    test('ida e volta dBW → W → dBW em toda a gama útil', () {
      for (double dbw = -120; dbw <= 120; dbw += 3.25) {
        final watts = ok(input: dbw, from: PowerUnit.dbw, to: PowerUnit.watt);
        expect(
          ok(input: watts, from: PowerUnit.watt, to: PowerUnit.dbw),
          closeTo(dbw, 1e-9),
          reason: 'ida e volta de $dbw dBW',
        );
      }
    });

    test('ida e volta dBW → dBm → dBW é exacta', () {
      for (double dbw = -90; dbw <= 90; dbw += 11) {
        final dbm = ok(input: dbw, from: PowerUnit.dbw, to: PowerUnit.dbm);
        expect(
          ok(input: dbm, from: PowerUnit.dbm, to: PowerUnit.dbw),
          closeTo(dbw, 1e-9),
        );
      }
    });

    test('0 W → dBW é rejeitado: log₁₀(0) não existe', () {
      final result = service.convert(
        inputValue: 0.0,
        from: PowerUnit.watt,
        to: PowerUnit.dbw,
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('dBW extremamente baixo é rejeitado em vez de devolver zero', () {
      // 10^(-4000/10) = 10^-400 é zero em ponto flutuante de dupla precisão.
      // O serviço deve recusar, nunca devolver "0 W" como se fosse exacto.
      final result = service.convert(
        inputValue: -4000.0,
        from: PowerUnit.dbw,
        to: PowerUnit.watt,
      );
      expect(result.isSuccess, isFalse);
    });

    test('dBW extremamente alto é rejeitado em vez de devolver infinito', () {
      final result = service.convert(
        inputValue: 4000.0,
        from: PowerUnit.dbw,
        to: PowerUnit.watt,
      );
      expect(result.isSuccess, isFalse);
    });

    test('dBW → dBW devolve o valor intacto', () {
      final result = service.convert(
        inputValue: 42.5,
        from: PowerUnit.dbw,
        to: PowerUnit.dbw,
      );
      expect(result.isSuccess, isTrue);
      expect(result.value, 42.5);
    });
  });
}
