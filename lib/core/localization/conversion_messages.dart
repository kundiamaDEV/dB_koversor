import '../../l10n/generated/app_localizations.dart';
import '../models/conversion_error.dart';
import '../models/conversion_result.dart';
import '../power_unit.dart';

/// Tradução dos códigos devolvidos pela camada de cálculo.
///
/// INTRODUZIDO NA AUDITORIA DE 2026-10-17 (Fase 4, internacionalização).
///
/// Porque existe
/// -------------
/// `PowerConverterService` e `Validators` são código puro, sem acesso à
/// interface, e devolvem **códigos** (`ConversionError`) em vez de frases. É
/// aqui — e só aqui — que esses códigos se transformam em texto no idioma do
/// utilizador. Essa separação mantém a matemática testável sem `BuildContext` e
/// evita strings traduzidas espalhadas pelos widgets.
///
/// Regra de manutenção
/// -------------------
/// `localizedError` cobre explicitamente **todos** os valores de
/// `ConversionError`. Se um valor novo for acrescentado ao enum, o analisador
/// assinala o `switch` incompleto, o que impede que um erro chegue ao
/// utilizador sem tradução. É deliberado não existir aqui um `default`.
extension ConversionMessages on AppLocalizations {
  /// Texto a apresentar para um resultado que falhou.
  ///
  /// Quando o código é desconhecido (resultado antigo sem código), recorre à
  /// mensagem de reserva em português que acompanha o resultado.
  String describeFailure(ConversionResult result) {
    final error = result.error;

    if (error == null) {
      return result.errorMessage ?? errComputationFailed;
    }

    return localizedError(error, unitLabel: result.errorUnitLabel);
  }

  /// Traduz um código de erro, usando [unitLabel] quando a mensagem o exige.
  ///
  /// Os símbolos de unidades (`dBm`, `W`, ...) não são traduzidos: são notação
  /// técnica internacional.
  String localizedError(ConversionError error, {String? unitLabel}) {
    final unit = unitLabel ?? '';

    switch (error) {
      case ConversionError.nonFiniteInput:
        return errNonFiniteInput;
      case ConversionError.emptyInput:
        return errEmptyInput;
      case ConversionError.invalidNumber:
        return errInvalidNumber;
      case ConversionError.nonPositiveForLog:
        return errNonPositiveForLog(unit);
      case ConversionError.negativePower:
        return errNegativePower(unit);
      case ConversionError.missingImpedance:
        return errMissingImpedance;
      case ConversionError.nonPositiveImpedance:
        return errNonPositiveImpedance;
      case ConversionError.missingReference:
        return errMissingReference;
      case ConversionError.nonPositiveReference:
        return errNonPositiveReference;
      case ConversionError.outOfRange:
        return errOutOfRange(unit);
      case ConversionError.resultOutOfRange:
        return errResultOutOfRange;
      case ConversionError.unsupportedCombination:
        return errUnsupportedCombination;
      case ConversionError.incompatibleReference:
        return errIncompatibleReference;
      case ConversionError.computationFailed:
        return errComputationFailed;
    }
  }

  /// Descrição traduzida de uma unidade, para o menu de consulta.
  ///
  /// Substitui `PowerUnitX.description`, que estava escrita em português no
  /// próprio enum. O enum mantém essa descrição como reserva de diagnóstico,
  /// mas a interface usa esta versão.
  String describeUnit(PowerUnit unit) {
    switch (unit) {
      case PowerUnit.watt:
        return unitDescWatt;
      case PowerUnit.milliwatt:
        return unitDescMilliwatt;
      case PowerUnit.db:
        return unitDescDb;
      case PowerUnit.dbm:
        return unitDescDbm;
      case PowerUnit.dbw:
        return unitDescDbw;
      case PowerUnit.dbu:
        return unitDescDbu;
      case PowerUnit.dbv:
        return unitDescDbv;
    }
  }
}
