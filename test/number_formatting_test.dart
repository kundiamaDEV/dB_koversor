// Testes da formatação de apresentação (defeito M6).
//
// A formatação só afecta o que se vê; o valor interno nunca é arredondado.
// Estes testes fixam as regras para que uma alteração futura não as mude por
// acidente.

import 'package:db_konversor/utils/math_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MathUtils.formatResult', () {
    test('zero é apresentado como "0"', () {
      expect(MathUtils.formatResult(0), '0');
      expect(MathUtils.formatResult(-0.0), '0');
    });

    test('valores não finitos nunca aparecem como NaN ou Infinity', () {
      expect(MathUtils.formatResult(double.nan), '--');
      expect(MathUtils.formatResult(double.infinity), '--');
      expect(MathUtils.formatResult(double.negativeInfinity), '--');
    });

    test('zeros finais irrelevantes são removidos', () {
      expect(MathUtils.formatResult(100), '100');
      expect(MathUtils.formatResult(1), '1');
      expect(MathUtils.formatResult(2.5), '2.5');
      expect(MathUtils.formatResult(-20), '-20');
    });

    test('casas decimais significativas são preservadas', () {
      expect(MathUtils.formatResult(3.0103), '3.0103');
      expect(MathUtils.formatResult(-13.0103), '-13.0103');
      expect(MathUtils.formatResult(0.775), '0.775');
    });

    test('valores grandes usam duas casas decimais', () {
      expect(MathUtils.formatResult(1234.5678), '1234.57');
      expect(MathUtils.formatResult(99999.5), '99999.5');
    });

    test('valores muito grandes usam notação científica', () {
      expect(MathUtils.formatResult(1e9), '1e+9');
      expect(MathUtils.formatResult(2.5e12), '2.5e+12');
    });

    test('valores muito pequenos usam notação científica', () {
      expect(MathUtils.formatResult(1e-9), '1e-9');
      expect(MathUtils.formatResult(1e-15), '1e-15');
    });

    test('a mantissa da notação científica também é limpa', () {
      // A implementação anterior deixava "1.0000e-9" porque a expressão
      // regular não tocava na mantissa quando havia expoente.
      expect(MathUtils.formatResult(1e-9), isNot(contains('0000')));
      expect(MathUtils.formatResult(3.5e-8), '3.5e-8');
    });

    test('um valor negativo muito pequeno não é apresentado como "-0"', () {
      final formatted = MathUtils.formatResult(-1e-20);
      expect(formatted, isNot('-0'));
      expect(formatted, isNot('0'));
      expect(formatted, contains('e-'));
    });

    test('nunca devolve texto vazio nem acaba no separador decimal', () {
      const values = <double>[
        0,
        1,
        -1,
        0.5,
        -0.5,
        1e-5,
        1e-4,
        999.999,
        1000,
        1e6,
        -1e6,
        1e300,
        -1e-300,
        3.010299956639812,
        -133.01029995664,
      ];

      for (final value in values) {
        final formatted = MathUtils.formatResult(value);
        expect(formatted, isNotEmpty, reason: 'valor $value');
        expect(formatted.endsWith('.'), isFalse, reason: 'valor $value');
        expect(formatted, isNot(contains('NaN')), reason: 'valor $value');
        expect(
          formatted,
          isNot(contains('Infinity')),
          reason: 'valor $value',
        );
      }
    });

    test('o sinal é preservado', () {
      expect(MathUtils.formatResult(-13.010299956640).startsWith('-'), isTrue);
      expect(MathUtils.formatResult(13.010299956640).startsWith('-'), isFalse);
    });

    test('a formatação não altera o valor interno', () {
      // Garantia explícita de que formatar é uma operação de leitura: o texto
      // apresentado perde precisão, mas o double de origem fica intacto e é
      // esse que alimenta qualquer cálculo seguinte.
      const original = -133.01029995664012;
      final shown = MathUtils.formatResult(original);
      expect(shown, '-133.0103');
      expect(original, -133.01029995664012);
      expect(double.parse(shown), isNot(original));
    });
  });

  group('MathUtils.log10num e pow10', () {
    test('log10 de potências de dez é exacto o suficiente', () {
      for (var exponent = -12; exponent <= 12; exponent++) {
        expect(
          MathUtils.log10num(MathUtils.pow10(exponent.toDouble())),
          closeTo(exponent.toDouble(), 1e-9),
        );
      }
    });

    test('pow10 e log10num são inversas', () {
      for (final value in <double>[-7.5, -1, 0, 0.25, 3, 11.75]) {
        expect(
          MathUtils.log10num(MathUtils.pow10(value)),
          closeTo(value, 1e-12),
        );
      }
    });
  });
}
