import 'package:flutter/material.dart';

import '../../core/models/conversion_error.dart';
import '../../core/models/conversion_result.dart';
import '../../core/power_unit.dart';
import '../../utils/validators.dart';
import '../history/conversion_history_entry.dart';
import '../history/conversion_history_store.dart';
import 'power_converter_service.dart';

/// Tipo de conversão em curso, para a interface escolher o texto a apresentar.
///
/// ALTERADO NA AUDITORIA DE 2026-10-17 (Fase 4).
/// Antes, o controlador devolvia frases em português (`'Conversão de
/// potência'`). Passa a devolver um valor desta enumeração, traduzido na
/// interface, pela mesma razão que levou aos códigos de erro: a lógica não
/// deve conter texto para o utilizador.
enum ConversionKind {
  ratioWithReference,
  power,
  voltageLevel,
  powerAndVoltage,
  technical,
}

/// Natureza do rótulo do campo de referência.
enum ReferenceLabelKind {
  /// Referência num nível logarítmico (dBm, dBW, dBV, dBu).
  level,

  /// Referência numa potência linear (W, mW).
  power,

  /// Sem unidade determinada.
  generic,
}

class ConverterController extends ChangeNotifier {
  ConverterController({ConversionHistoryStore? historyStore})
    : history = historyStore ?? ConversionHistoryStore();

  final PowerConverterService _service = PowerConverterService();

  /// Histórico real das conversões, persistido no dispositivo (defeito F1).
  final ConversionHistoryStore history;

  final TextEditingController valueController = TextEditingController(
    text: '10.0',
  );

  final TextEditingController impedanceController = TextEditingController(
    text: '50',
  );

  /// Referência usada nas conversões relativas em dB.
  final TextEditingController referenceController = TextEditingController();

  PowerUnit fromUnit = PowerUnit.dbm;
  PowerUnit toUnit = PowerUnit.watt;

  ConversionResult? result;

  /// Código do erro de entrada, quando existe. Traduzido na interface.
  ConversionError? inputError;

  List<PowerUnit> get availableUnits => PowerUnit.values;

  bool get shouldShowImpedance {
    return _service.requiresImpedance(from: fromUnit, to: toUnit);
  }

  /// Mostra a referência quando uma das unidades é dB.
  bool get shouldShowReference {
    return fromUnit.isRatioUnit || toUnit.isRatioUnit;
  }

  String get inputUnitLabel => fromUnit.label;

  String get outputUnitLabel => toUnit.label;

  /// Unidade em que a referência deve ser introduzida, e a sua natureza.
  ///
  /// A ordem de verificação não é arbitrária: numa conversão com dB, a outra
  /// unidade é que determina a referência. Os níveis logarítmicos são
  /// verificados primeiro porque, quando estão presentes, é neles que a
  /// referência tem de ser expressa.
  ///
  /// `dBW` foi acrescentado nesta auditoria (defeito M2).
  (ReferenceLabelKind, String) get referenceUnit {
    if (fromUnit == PowerUnit.dbm || toUnit == PowerUnit.dbm) {
      return (ReferenceLabelKind.level, PowerUnit.dbm.label);
    }
    if (fromUnit == PowerUnit.dbw || toUnit == PowerUnit.dbw) {
      return (ReferenceLabelKind.level, PowerUnit.dbw.label);
    }
    if (fromUnit == PowerUnit.dbv || toUnit == PowerUnit.dbv) {
      return (ReferenceLabelKind.level, PowerUnit.dbv.label);
    }
    if (fromUnit == PowerUnit.dbu || toUnit == PowerUnit.dbu) {
      return (ReferenceLabelKind.level, PowerUnit.dbu.label);
    }
    if (fromUnit == PowerUnit.watt || toUnit == PowerUnit.watt) {
      return (ReferenceLabelKind.power, PowerUnit.watt.label);
    }
    if (fromUnit == PowerUnit.milliwatt || toUnit == PowerUnit.milliwatt) {
      return (ReferenceLabelKind.power, PowerUnit.milliwatt.label);
    }
    return (ReferenceLabelKind.generic, '');
  }

  void setFromUnit(PowerUnit value) {
    fromUnit = value;
    _clearTransientError();
    convert();
  }

  void setToUnit(PowerUnit value) {
    toUnit = value;
    _clearTransientError();
    convert();
  }

  void invertUnits() {
    final oldFrom = fromUnit;
    fromUnit = toUnit;
    toUnit = oldFrom;

    _clearTransientError();
    convert();
  }

  /// Recalcula o resultado e, se a conversão tiver êxito, registá-la no
  /// histórico.
  ///
  /// NOTA SOBRE O DEFEITO F6: `setFromUnit`, `setToUnit` e `invertUnits` já
  /// chamam este método. A interface **não** deve chamá-lo outra vez a seguir,
  /// como acontecia antes, porque duplicava o cálculo e a notificação.
  void convert() {
    final validation = Validators.validateNumericInput(valueController.text);
    inputError = validation?.error;

    if (validation != null) {
      result = ConversionResult.failure(
        message: validation.message,
        error: validation.error,
      );
      notifyListeners();
      return;
    }

    final inputValue = double.parse(
      valueController.text.trim().replaceAll(',', '.'),
    );

    double? impedance;
    if (shouldShowImpedance) {
      impedance = double.tryParse(
        impedanceController.text.trim().replaceAll(',', '.'),
      );
    }

    double? referenceValue;
    if (shouldShowReference) {
      referenceValue = double.tryParse(
        referenceController.text.trim().replaceAll(',', '.'),
      );
    }

    final conversion = _service.convert(
      inputValue: inputValue,
      from: fromUnit,
      to: toUnit,
      impedance: impedance,
      referenceValue: referenceValue,
    );

    result = conversion;
    notifyListeners();

    _recordInHistory(conversion, inputValue);
  }

  /// Grava a conversão no histórico, sem bloquear a interface.
  ///
  /// Só as conversões com êxito são registadas: um erro de digitação não é uma
  /// conversão. A gravação é deliberadamente não aguardada — o resultado já
  /// está no ecrã e a escrita em disco não deve atrasar o próximo cálculo. As
  /// falhas de escrita são tratadas dentro do `ConversionHistoryStore`.
  void _recordInHistory(ConversionResult conversion, double inputValue) {
    if (!conversion.isSuccess) return;

    final value = conversion.value;
    if (value == null || !value.isFinite) return;

    // Conversões entre a mesma unidade não acrescentam informação ao
    // histórico.
    if (fromUnit == toUnit) return;

    history.add(
      ConversionHistoryEntry(
        inputValue: inputValue,
        inputUnitLabel: fromUnit.label,
        outputValue: value,
        outputUnitLabel: conversion.outputUnitLabel,
        timestampUtc: DateTime.now().toUtc(),
      ),
    );
  }

  /// Classifica a conversão corrente, para a interface traduzir o rótulo.
  ConversionKind get conversionKind {
    if (fromUnit.isRatioUnit || toUnit.isRatioUnit) {
      return ConversionKind.ratioWithReference;
    }
    if (fromUnit.isPowerUnit && toUnit.isPowerUnit) {
      return ConversionKind.power;
    }
    if (fromUnit.isVoltageLogUnit && toUnit.isVoltageLogUnit) {
      return ConversionKind.voltageLevel;
    }
    if ((fromUnit.isVoltageLogUnit && toUnit.isPowerUnit) ||
        (fromUnit.isPowerUnit && toUnit.isVoltageLogUnit)) {
      return ConversionKind.powerAndVoltage;
    }
    return ConversionKind.technical;
  }

  void _clearTransientError() {
    inputError = null;
  }

  @override
  void dispose() {
    valueController.dispose();
    impedanceController.dispose();
    referenceController.dispose();
    super.dispose();
  }
}
