import '../core/models/conversion_error.dart';

/// Resultado de uma validação: um código traduzível mais uma mensagem de
/// reserva em português.
///
/// ALTERADO NA AUDITORIA DE 2026-10-17 (Fase 4, internacionalização).
///
/// Antes, estes validadores devolviam `String?` com a frase já escrita em
/// português, o que impedia a tradução. Passam a devolver um objecto com o
/// **código** do erro, traduzido só na interface, e opcionalmente o símbolo da
/// unidade envolvida. A mensagem em português permanece para diagnóstico e
/// para os testes. Ver `lib/core/models/conversion_error.dart`.
class ValidationFailure {
  /// Código estável do erro. Não é traduzido nem apresentado directamente.
  final ConversionError error;

  /// Mensagem de reserva em português, para diagnóstico.
  final String message;

  /// Símbolo da unidade envolvida, quando o erro se refere a uma (ex.: `dBm`).
  /// Símbolos de unidades não são traduzidos.
  final String? unitLabel;

  const ValidationFailure({
    required this.error,
    required this.message,
    this.unitLabel,
  });
}

class Validators {
  /// Valida o texto introduzido pelo utilizador como número.
  ///
  /// Aceita a vírgula como separador decimal, porque é o separador usado em
  /// português, francês e espanhol. A substituição é feita apenas para a
  /// leitura do número e não altera a precisão do valor.
  static ValidationFailure? validateNumericInput(String text) {
    final sanitized = text.trim().replaceAll(',', '.');

    if (sanitized.isEmpty) {
      return const ValidationFailure(
        error: ConversionError.emptyInput,
        message: 'Informe um valor de entrada.',
      );
    }

    final value = double.tryParse(sanitized);
    if (value == null) {
      return const ValidationFailure(
        error: ConversionError.invalidNumber,
        message: 'Informe um número válido.',
      );
    }

    // Um texto como "Infinity" ou "NaN" é aceite por `double.tryParse`, mas
    // não é um valor utilizável numa conversão.
    if (!value.isFinite) {
      return const ValidationFailure(
        error: ConversionError.nonFiniteInput,
        message: 'Informe um número finito.',
      );
    }

    return null;
  }

  /// Rejeita argumentos não positivos de um logaritmo.
  ///
  /// `log10(x)` só está definido para `x > 0`; em `x = 0` tende para menos
  /// infinito. [unitLabel] é o símbolo da unidade que o utilizador escolheu,
  /// para que a mensagem fale da unidade dele e não do pivô interno de cálculo
  /// (correcção M3).
  static ValidationFailure? validatePositiveForLogInput(
    double value,
    String unitLabel,
  ) {
    if (value <= 0) {
      return ValidationFailure(
        error: ConversionError.nonPositiveForLog,
        message:
            'O valor em $unitLabel deve ser maior que zero para esta conversão.',
        unitLabel: unitLabel,
      );
    }
    return null;
  }

  /// Valida a impedância usada nas relações entre potência e tensão.
  ///
  /// `P = V²/R` e `V = √(P·R)` exigem `R > 0`: uma impedância nula provocaria
  /// uma divisão por zero e uma impedância negativa não tem significado físico
  /// num cálculo de potência dissipada.
  static ValidationFailure? validateImpedance(double? impedance) {
    if (impedance == null || !impedance.isFinite) {
      return const ValidationFailure(
        error: ConversionError.missingImpedance,
        message: 'Informe a impedância para esta conversão.',
      );
    }
    if (impedance <= 0) {
      return const ValidationFailure(
        error: ConversionError.nonPositiveImpedance,
        message: 'A impedância deve ser maior que zero.',
      );
    }
    return null;
  }
}
