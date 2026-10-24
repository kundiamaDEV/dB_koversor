import 'dart:math';

/// Utilitários numéricos da aplicação.
///
/// ALTERADO NA AUDITORIA DE 2026-10-17 (defeito M6).
///
/// Porque foi necessário
/// ---------------------
/// Existiam **dois** formatadores numéricos com regras diferentes:
/// `MathUtils.formatResult` (usado por um widget que já não era referenciado) e
/// `_ConverterScreenState._formatValue` (usado pela interface real). Limiares e
/// número de casas decimais divergiam, não havia nenhum teste, e qualquer
/// correcção aplicada a um deles não chegava ao outro.
///
/// Passa a existir uma única implementação, aqui, coberta por
/// `test/number_formatting_test.dart`.
///
/// REGRA IMPORTANTE
/// ----------------
/// Esta formatação é **exclusivamente de apresentação**. O valor devolvido por
/// `PowerConverterService` nunca é arredondado: o arredondamento acontece só no
/// momento de desenhar o texto no ecrã. Nenhuma conversão parte de um valor já
/// formatado, pelo que o arredondamento visível jamais se propaga para um
/// cálculo seguinte.
class MathUtils {
  static double log10num(double value) {
    return log(value) / ln10;
  }

  static double pow10(double exponent) {
    return pow(10, exponent).toDouble();
  }

  /// Formata um valor para apresentação.
  ///
  /// Regras, escolhidas para manter cerca de 4 a 6 algarismos significativos
  /// em toda a gama útil sem encher o ecrã de zeros:
  ///
  /// * não finito  → `--` (a interface nunca deve mostrar `NaN` nem `Infinity`)
  /// * exactamente 0 → `0`
  /// * |v| ≥ 1e6 ou |v| < 1e-4 → notação científica com 4 decimais
  /// * |v| ≥ 1000 → 2 decimais
  /// * |v| ≥ 1    → 4 decimais
  /// * restantes  → 6 decimais
  ///
  /// Os zeros finais são removidos, para que `100.0000` apareça como `100`,
  /// mas o separador decimal nunca fica pendurado no fim.
  static String formatResult(double value) {
    if (!value.isFinite) return '--';
    if (value == 0) return '0';

    final abs = value.abs();

    if (abs >= 1e6 || abs < 1e-4) {
      return _trimTrailingZeros(value.toStringAsExponential(4));
    }

    final String formatted;
    if (abs >= 1000) {
      formatted = value.toStringAsFixed(2);
    } else if (abs >= 1) {
      formatted = value.toStringAsFixed(4);
    } else {
      formatted = value.toStringAsFixed(6);
    }

    return _trimTrailingZeros(formatted);
  }

  /// Remove zeros finais irrelevantes da parte decimal.
  ///
  /// Trata também a notação científica, onde os zeros a remover estão na
  /// mantissa e não no fim do texto (`1.2300e-7` → `1.23e-7`). A implementação
  /// anterior usava uma expressão regular aplicada ao texto inteiro e, por
  /// isso, não mexia na mantissa quando havia expoente.
  static String _trimTrailingZeros(String text) {
    final exponentIndex = text.indexOf('e');

    if (exponentIndex == -1) {
      return _trimMantissa(text);
    }

    final mantissa = _trimMantissa(text.substring(0, exponentIndex));
    return '$mantissa${text.substring(exponentIndex)}';
  }

  static String _trimMantissa(String mantissa) {
    if (!mantissa.contains('.')) return mantissa;

    var trimmed = mantissa;
    while (trimmed.endsWith('0')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    if (trimmed.endsWith('.')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }

    // Casos como "-0" ou "-0." resultantes de valores muito pequenos mas não
    // nulos nunca devem aparecer como zero com sinal.
    if (trimmed == '-0') return '0';

    return trimmed;
  }
}
