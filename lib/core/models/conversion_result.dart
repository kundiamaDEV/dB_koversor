import 'conversion_error.dart';

class ConversionResult {
  final bool isSuccess;
  final double? value;
  final String outputUnitLabel;
  final String formula;
  final String note;

  /// Mensagem em português, para diagnóstico e testes.
  ///
  /// A interface localizada apresenta o texto obtido a partir de [error]; esta
  /// mensagem é o recurso de reserva quando não existe localização.
  /// Ver `conversion_error.dart`.
  final String? errorMessage;

  /// Código estável do erro, para tradução na interface.
  ///
  /// Acrescentado na auditoria de 2026-10-17 (Fase 4, internacionalização).
  final ConversionError? error;

  /// Argumento do erro, normalmente o símbolo de uma unidade (ex.: `dBm`).
  ///
  /// Símbolos de unidades não são traduzidos.
  final String? errorUnitLabel;

  const ConversionResult({
    required this.isSuccess,
    required this.value,
    required this.outputUnitLabel,
    required this.formula,
    required this.note,
    this.errorMessage,
    this.error,
    this.errorUnitLabel,
  });

  factory ConversionResult.success({
    required double value,
    required String outputUnitLabel,
    required String formula,
    required String note,
  }) {
    return ConversionResult(
      isSuccess: true,
      value: value,
      outputUnitLabel: outputUnitLabel,
      formula: formula,
      note: note,
    );
  }

  factory ConversionResult.failure({
    required String message,
    ConversionError? error,
    String? errorUnitLabel,
    String formula = '-',
    String note = '',
  }) {
    return ConversionResult(
      isSuccess: false,
      value: null,
      outputUnitLabel: '',
      formula: formula,
      note: note,
      errorMessage: message,
      error: error,
      errorUnitLabel: errorUnitLabel,
    );
  }
}
