import 'dart:math' as math;

import '../../../../core/models/conversion_error.dart';
import '../../../../core/models/conversion_result.dart';
import '../../core/power_unit.dart';
import '../../utils/math_utils.dart';
import '../../utils/validators.dart';

class PowerConverterService {
  ConversionResult convert({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
    double? impedance,
    double? referenceValue,
  }) {
    if (!inputValue.isFinite) {
      return ConversionResult.failure(
        message: 'Introduza um valor numérico válido.',
        error: ConversionError.nonFiniteInput,
      );
    }

    if (from == to) {
      return ConversionResult.success(
        value: inputValue,
        outputUnitLabel: to.label,
        formula: '${to.label} = ${from.label}',
        note: 'Nenhuma conversão foi necessária.',
      );
    }

    // Conversões relativas envolvendo dB exigem uma referência.
    if (from == PowerUnit.db || to == PowerUnit.db) {
      return _convertWithDbReference(
        inputValue: inputValue,
        from: from,
        to: to,
        referenceValue: referenceValue,
      );
    }

    if (_requiresImpedance(from: from, to: to)) {
      final impedanceError = Validators.validateImpedance(impedance);

      if (impedanceError != null) {
        return ConversionResult.failure(
          message: impedanceError.message,
          error: impedanceError.error,
          note:
              'A impedância é necessária para relacionar tensão e potência.',
        );
      }
    }

    if (from.isPowerUnit && to.isPowerUnit) {
      return _convertPowerToPower(
        inputValue: inputValue,
        from: from,
        to: to,
      );
    }

    if (from.isVoltageLogUnit && to.isVoltageLogUnit) {
      return _convertVoltageLogToVoltageLog(
        inputValue: inputValue,
        from: from,
        to: to,
      );
    }

    if (from.isVoltageLogUnit && to.isPowerUnit) {
      return _convertVoltageLogToPower(
        inputValue: inputValue,
        from: from,
        to: to,
        impedance: impedance!,
      );
    }

    if (from.isPowerUnit && to.isVoltageLogUnit) {
      return _convertPowerToVoltageLog(
        inputValue: inputValue,
        from: from,
        to: to,
        impedance: impedance!,
      );
    }

    return ConversionResult.failure(
      message: 'Esta combinação de unidades não é suportada.',
      error: ConversionError.unsupportedCombination,
      note: 'Verifique as unidades seleccionadas.',
    );
  }

  /// Converte dB relativamente a uma referência explícita.
  ///
  /// A referência deve estar na mesma unidade de nível ou de potência
  /// correspondente à operação:
  ///
  /// W/mW -> dB: referência em W/mW, respectivamente.
  /// dB -> W/mW: referência em W/mW, respectivamente.
  /// dBm <-> dB: referência em dBm.
  /// dBW <-> dB: referência em dBW.
  /// dBV <-> dB: referência em dBV.
  /// dBu <-> dB: referência em dBu.
  ConversionResult _convertWithDbReference({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
    required double? referenceValue,
  }) {
    if (referenceValue == null || !referenceValue.isFinite) {
      return ConversionResult.failure(
        message: 'Introduza um valor de referência válido.',
        error: ConversionError.missingReference,
        note:
            'A referência é necessária para calcular a razão em decibéis.',
      );
    }

    final reference = referenceValue;

    // W ou mW -> dB relativo a uma potência de referência.
    if ((from == PowerUnit.watt ||
            from == PowerUnit.milliwatt) &&
        to == PowerUnit.db) {
      if (inputValue <= 0 || reference <= 0) {
        return ConversionResult.failure(
          message:
              'A potência e a referência devem ser superiores a zero.',
          error: ConversionError.nonPositiveReference,
        );
      }

      final ratio = inputValue / reference;
      final value = 10 * MathUtils.log10num(ratio);

      return _success(
        value: value,
        unit: 'dB',
        formula: 'dB = 10 × log10(P / Pref)',
        note:
            'Razão de potência relativamente à referência informada.',
      );
    }

    // dB -> W ou mW, relativamente à potência de referência.
    if (from == PowerUnit.db &&
        (to == PowerUnit.watt ||
            to == PowerUnit.milliwatt)) {
      if (reference <= 0) {
        return ConversionResult.failure(
          message:
              'A potência de referência deve ser superior a zero.',
          error: ConversionError.nonPositiveReference,
        );
      }

      final factor = MathUtils.pow10(inputValue / 10);
      final value = reference * factor;

      if (!value.isFinite) {
        return ConversionResult.failure(
          message: 'O resultado excede o intervalo numérico suportado.',
          error: ConversionError.resultOutOfRange,
        );
      }

      return _success(
        value: value,
        unit: to.label,
        formula: 'P = Pref × 10^(dB / 10)',
        note:
            'Potência calculada relativamente à referência informada.',
      );
    }

    // dBm -> dB: diferença entre dois níveis de potência.
    if (from == PowerUnit.dbm && to == PowerUnit.db) {
      return _success(
        value: inputValue - reference,
        unit: 'dB',
        formula: 'dB = dBm − dBm(ref)',
        note:
            'Diferença relativamente ao nível de referência em dBm.',
      );
    }

    // dB -> dBm: nível absoluto a partir de uma diferença.
    if (from == PowerUnit.db && to == PowerUnit.dbm) {
      return _success(
        value: inputValue + reference,
        unit: 'dBm',
        formula: 'dBm = dB + dBm(ref)',
        note:
            'Nível calculado relativamente à referência em dBm.',
      );
    }

    // dBW -> dB (M2): tal como no dBm, a diferenca entre dois niveis
    // logaritmicos da mesma escala e directamente uma razao em dB.
    if (from == PowerUnit.dbw && to == PowerUnit.db) {
      return _success(
        value: inputValue - reference,
        unit: 'dB',
        formula: 'dB = dBW − dBW(ref)',
        note: 'Diferença relativamente ao nível de referência em dBW.',
      );
    }

    // dB -> dBW (M2).
    if (from == PowerUnit.db && to == PowerUnit.dbw) {
      return _success(
        value: inputValue + reference,
        unit: 'dBW',
        formula: 'dBW = dB + dBW(ref)',
        note: 'Nível calculado relativamente à referência em dBW.',
      );
    }

    // dBV -> dB: diferença entre níveis de tensão.
    if (from == PowerUnit.dbv && to == PowerUnit.db) {
      return _success(
        value: inputValue - reference,
        unit: 'dB',
        formula: 'dB = dBV − dBV(ref)',
        note:
            'Diferença relativamente ao nível de referência em dBV.',
      );
    }

    // dB -> dBV.
    if (from == PowerUnit.db && to == PowerUnit.dbv) {
      return _success(
        value: inputValue + reference,
        unit: 'dBV',
        formula: 'dBV = dB + dBV(ref)',
        note:
            'Nível calculado relativamente à referência em dBV.',
      );
    }

    // dBu -> dB.
    if (from == PowerUnit.dbu && to == PowerUnit.db) {
      return _success(
        value: inputValue - reference,
        unit: 'dB',
        formula: 'dB = dBu − dBu(ref)',
        note:
            'Diferença relativamente ao nível de referência em dBu.',
      );
    }

    // dB -> dBu.
    if (from == PowerUnit.db && to == PowerUnit.dbu) {
      return _success(
        value: inputValue + reference,
        unit: 'dBu',
        formula: 'dBu = dB + dBu(ref)',
        note:
            'Nível calculado relativamente à referência em dBu.',
      );
    }

    return ConversionResult.failure(
      message:
          'Não é possível usar esta referência para as unidades seleccionadas.',
      error: ConversionError.incompatibleReference,
      note:
          'Introduza uma referência compatível com a conversão pretendida.',
    );
  }

  /// Junta os passos de uma conversao numa unica formula legivel (correccao M4).
  ///
  /// Antes, uma conversao em dois passos como "W -> dBm" mostrava apenas o
  /// ultimo passo ("dBm = 10 x log10(mW)") e escondia a passagem intermedia
  /// ("mW = W x 1000"), o que tornava a formula apresentada incompleta. Como a
  /// exibicao da formula e um dos argumentos pedagogicos da aplicacao, os
  /// passos passam a ser todos mostrados, pela ordem em que sao aplicados.
  ///
  /// Passos de identidade (por exemplo "mW = mW", quando a entrada ja esta na
  /// unidade do pivo) sao omitidos porque nada acrescentam.
  String _chainFormula(List<String> steps) {
    final meaningful = steps.where((step) {
      if (step.trim().isEmpty) return false;
      final parts = step.split('=');
      // Descarta identidades do tipo "mW = mW".
      if (parts.length == 2 && parts[0].trim() == parts[1].trim()) return false;
      return true;
    }).toList();

    if (meaningful.isEmpty) return steps.isEmpty ? '-' : steps.last;

    return meaningful.join('  |  ');
  }

  ConversionResult _success({
    required double value,
    required String unit,
    required String formula,
    required String note,
  }) {
    if (!value.isFinite) {
      return ConversionResult.failure(
        message: 'O resultado excede o intervalo numérico suportado.',
        error: ConversionError.resultOutOfRange,
      );
    }

    return ConversionResult.success(
      value: value,
      outputUnitLabel: unit,
      formula: formula,
      note: note,
    );
  }

  bool requiresImpedance({
    required PowerUnit from,
    required PowerUnit to,
  }) {
    return _requiresImpedance(from: from, to: to);
  }

  bool _requiresImpedance({
    required PowerUnit from,
    required PowerUnit to,
  }) {
    final involvesVoltage =
        from.isVoltageLogUnit || to.isVoltageLogUnit;
    final involvesPower =
        from.isPowerUnit || to.isPowerUnit;

    return involvesVoltage && involvesPower;
  }

  ConversionResult _convertPowerToPower({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
  }) {
    final mwResult = _toMilliwatt(inputValue, from);
    if (!mwResult.isSuccess) return mwResult;

    final outputResult = _fromMilliwatt(
      mwResult.value!,
      to,
      inputUnitLabel: from.label,
    );
    if (!outputResult.isSuccess) return outputResult;

    return ConversionResult.success(
      value: outputResult.value!,
      outputUnitLabel: to.label,
      formula: _chainFormula([mwResult.formula, outputResult.formula]),
      note: 'Conversão concluída entre unidades de potência.',
    );
  }

  ConversionResult _convertVoltageLogToVoltageLog({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
  }) {
    final voltsResult = _toVoltage(inputValue, from);
    if (!voltsResult.isSuccess) return voltsResult;

    final outputResult = _fromVoltage(
      voltsResult.value!,
      to,
      inputUnitLabel: from.label,
    );
    if (!outputResult.isSuccess) return outputResult;

    return ConversionResult.success(
      value: outputResult.value!,
      outputUnitLabel: to.label,
      formula: _chainFormula([voltsResult.formula, outputResult.formula]),
      note:
          'Conversão concluída entre níveis logarítmicos de tensão.',
    );
  }

  ConversionResult _convertVoltageLogToPower({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
    required double impedance,
  }) {
    final voltsResult = _toVoltage(inputValue, from);
    if (!voltsResult.isSuccess) return voltsResult;

    final volts = voltsResult.value!;
    final watts = (volts * volts) / impedance;
    final milliwatt = watts * 1000.0;

    if (!milliwatt.isFinite || milliwatt <= 0) {
      return ConversionResult.failure(
        message:
            'Não foi possível calcular a potência com os valores fornecidos.',
        error: ConversionError.computationFailed,
      );
    }

    final outputResult = _fromMilliwatt(
      milliwatt,
      to,
      inputUnitLabel: from.label,
    );
    if (!outputResult.isSuccess) return outputResult;

    return ConversionResult.success(
      value: outputResult.value!,
      outputUnitLabel: to.label,
      formula: _chainFormula([
        voltsResult.formula,
        'P = V² / R',
        outputResult.formula,
      ]),
      note:
          'A conversão utilizou a impedância informada.',
    );
  }

  ConversionResult _convertPowerToVoltageLog({
    required double inputValue,
    required PowerUnit from,
    required PowerUnit to,
    required double impedance,
  }) {
    final mwResult = _toMilliwatt(inputValue, from);
    if (!mwResult.isSuccess) return mwResult;

    final milliwatt = mwResult.value!;
    if (milliwatt <= 0) {
      return ConversionResult.failure(
        message:
            'A potência deve ser superior a zero para esta conversão.',
        error: ConversionError.nonPositiveForLog,
        errorUnitLabel: from.label,
      );
    }

    final watts = milliwatt / 1000.0;

    // CORRECCAO M1 (auditoria 2026-10-17).
    //
    // Aqui existia uma raiz quadrada escrita a mao: 20 iteracoes de
    // Newton-Raphson a partir de x0 = valor/2. Esse metodo precisa de cerca de
    // log2(valor) iteracoes so para chegar a ordem de grandeza correcta, pelo
    // que 20 iteracoes eram insuficientes fora de uma gama estreita. O erro
    // medido chegava a 18,7 dB a -120 dBm e a 28,6 dB a -130 dBm, precisamente
    // na gama de sensibilidade de receptores de radiofrequencia.
    //
    // `dart:math.sqrt` usa a instrucao de raiz quadrada do processador, e
    // exacta ao ultimo bit (erro <= 0,5 ulp) e esta disponivel sem qualquer
    // dependencia. Nao havia motivo para a implementacao manual.
    //
    // Teste de regressao: test/power_converter_service_test.dart, grupo
    // "Potencia <-> nivel de tensao, com impedancia".
    final volts = math.sqrt(watts * impedance);

    if (!volts.isFinite || volts <= 0) {
      return ConversionResult.failure(
        message:
            'Não foi possível calcular a tensão com os valores fornecidos.',
        error: ConversionError.computationFailed,
      );
    }

    final outputResult = _fromVoltage(
      volts,
      to,
      inputUnitLabel: from.label,
    );
    if (!outputResult.isSuccess) return outputResult;

    return ConversionResult.success(
      value: outputResult.value!,
      outputUnitLabel: to.label,
      formula: _chainFormula([
        mwResult.formula,
        'V = √(P × R)',
        outputResult.formula,
      ]),
      note:
          'A conversão utilizou a impedância informada.',
    );
  }

  ConversionResult _toMilliwatt(
    double inputValue,
    PowerUnit from,
  ) {
    switch (from) {
      case PowerUnit.watt:
        if (inputValue < 0) {
          return ConversionResult.failure(
            message: 'O valor em W não pode ser negativo.',
            error: ConversionError.negativePower,
            errorUnitLabel: 'W',
          );
        }

        return ConversionResult.success(
          value: inputValue * 1000.0,
          outputUnitLabel: 'mW',
          formula: 'mW = W × 1000',
          note: '',
        );

      case PowerUnit.milliwatt:
        if (inputValue < 0) {
          return ConversionResult.failure(
            message: 'O valor em mW não pode ser negativo.',
            error: ConversionError.negativePower,
            errorUnitLabel: 'mW',
          );
        }

        return ConversionResult.success(
          value: inputValue,
          outputUnitLabel: 'mW',
          formula: 'mW = mW',
          note: '',
        );

      case PowerUnit.dbm:
        final value = MathUtils.pow10(inputValue / 10);

        if (!value.isFinite || value <= 0) {
          return ConversionResult.failure(
            message: 'O valor em dBm está fora do intervalo suportado.',
            error: ConversionError.outOfRange,
            errorUnitLabel: 'dBm',
          );
        }

        return ConversionResult.success(
          value: value,
          outputUnitLabel: 'mW',
          formula: 'mW = 10^(dBm / 10)',
          note: '',
        );

      // dBW -> mW (M2). O dBW refere-se a 1 W; como 1 W = 1000 mW, a conversao
      // directa para o pivo em mW e 10^((dBW + 30) / 10). Somar 30 ao expoente
      // em dB e preferivel a multiplicar o resultado por 1000: evita calcular
      // um valor intermedio em watts que poderia ser desnecessariamente
      // pequeno ou grande antes da multiplicacao.
      case PowerUnit.dbw:
        final value = MathUtils.pow10((inputValue + 30.0) / 10);

        if (!value.isFinite || value <= 0) {
          return ConversionResult.failure(
            message: 'O valor em dBW está fora do intervalo suportado.',
            error: ConversionError.outOfRange,
            errorUnitLabel: 'dBW',
          );
        }

        return ConversionResult.success(
          value: value,
          outputUnitLabel: 'mW',
          formula: 'mW = 10^((dBW + 30) / 10)',
          note: '',
        );

      default:
        return ConversionResult.failure(
          message:
              'A unidade ${from.label} não pode ser convertida para mW neste contexto.',
          error: ConversionError.unsupportedCombination,
        );
    }
  }

  /// Converte o pivo em mW para a unidade de saida.
  ///
  /// [inputUnitLabel] e a unidade que o utilizador escolheu na entrada. Serve
  /// apenas para as mensagens de erro (correccao M3) e nao participa no calculo.
  ConversionResult _fromMilliwatt(
    double milliwatt,
    PowerUnit to, {
    required String inputUnitLabel,
  }) {
    switch (to) {
      case PowerUnit.watt:
        return ConversionResult.success(
          value: milliwatt / 1000.0,
          outputUnitLabel: 'W',
          formula: 'W = mW / 1000',
          note: '',
        );

      case PowerUnit.milliwatt:
        return ConversionResult.success(
          value: milliwatt,
          outputUnitLabel: 'mW',
          formula: 'mW = mW',
          note: '',
        );

      case PowerUnit.dbm:
        // CORRECCAO M3: a mensagem nomeia a unidade que o utilizador escolheu
        // (`inputUnitLabel`) e nao o pivo interno em mW. Antes, converter
        // "0 W -> dBm" produzia "O valor em mW deve ser maior que zero",
        // referindo uma unidade que o utilizador nunca introduziu.
        final validation = Validators.validatePositiveForLogInput(
          milliwatt,
          inputUnitLabel,
        );

        if (validation != null) {
          return ConversionResult.failure(
            message: validation.message,
            error: validation.error,
            errorUnitLabel: validation.unitLabel,
          );
        }

        return ConversionResult.success(
          value: 10 * MathUtils.log10num(milliwatt),
          outputUnitLabel: 'dBm',
          formula: 'dBm = 10 × log10(mW)',
          note: '',
        );

      // mW -> dBW (M2): dBW = 10 x log10(mW) - 30, equivalente a
      // 10 x log10(mW / 1000) = 10 x log10(W).
      case PowerUnit.dbw:
        final validation = Validators.validatePositiveForLogInput(
          milliwatt,
          inputUnitLabel,
        );

        if (validation != null) {
          return ConversionResult.failure(
            message: validation.message,
            error: validation.error,
            errorUnitLabel: validation.unitLabel,
          );
        }

        return ConversionResult.success(
          value: 10 * MathUtils.log10num(milliwatt) - 30.0,
          outputUnitLabel: 'dBW',
          formula: 'dBW = 10 × log10(W)',
          note: '',
        );

      default:
        return ConversionResult.failure(
          message:
              'A unidade ${to.label} não pode ser calculada a partir de mW neste contexto.',
          error: ConversionError.unsupportedCombination,
        );
    }
  }

  ConversionResult _toVoltage(
    double inputValue,
    PowerUnit from,
  ) {
    switch (from) {
      case PowerUnit.dbv:
        final value = MathUtils.pow10(inputValue / 20);

        if (!value.isFinite || value <= 0) {
          return ConversionResult.failure(
            message: 'O valor em dBV está fora do intervalo suportado.',
            error: ConversionError.outOfRange,
            errorUnitLabel: 'dBV',
          );
        }

        return ConversionResult.success(
          value: value,
          outputUnitLabel: 'V',
          formula: 'V = 10^(dBV / 20)',
          note: '',
        );

      case PowerUnit.dbu:
        final value = 0.775 * MathUtils.pow10(inputValue / 20);

        if (!value.isFinite || value <= 0) {
          return ConversionResult.failure(
            message: 'O valor em dBu está fora do intervalo suportado.',
            error: ConversionError.outOfRange,
            errorUnitLabel: 'dBu',
          );
        }

        return ConversionResult.success(
          value: value,
          outputUnitLabel: 'V',
          formula: 'V = 0,775 × 10^(dBu / 20)',
          note: '',
        );

      default:
        return ConversionResult.failure(
          message:
              'A unidade ${from.label} não é um nível de tensão suportado.',
          error: ConversionError.unsupportedCombination,
        );
    }
  }

  /// Converte uma tensao em volts para a unidade de nivel de saida.
  ///
  /// [inputUnitLabel] serve apenas para as mensagens de erro (correccao M3).
  ConversionResult _fromVoltage(
    double voltage,
    PowerUnit to, {
    required String inputUnitLabel,
  }) {
    switch (to) {
      case PowerUnit.dbv:
        final validation = Validators.validatePositiveForLogInput(
          voltage,
          inputUnitLabel,
        );

        if (validation != null) {
          return ConversionResult.failure(
            message: validation.message,
            error: validation.error,
            errorUnitLabel: validation.unitLabel,
          );
        }

        return ConversionResult.success(
          value: 20 * MathUtils.log10num(voltage),
          outputUnitLabel: 'dBV',
          formula: 'dBV = 20 × log10(V)',
          note: '',
        );

      case PowerUnit.dbu:
        final validation = Validators.validatePositiveForLogInput(
          voltage,
          inputUnitLabel,
        );

        if (validation != null) {
          return ConversionResult.failure(
            message: validation.message,
            error: validation.error,
            errorUnitLabel: validation.unitLabel,
          );
        }

        return ConversionResult.success(
          value: 20 * MathUtils.log10num(voltage / 0.775),
          outputUnitLabel: 'dBu',
          formula: 'dBu = 20 × log10(V / 0,775)',
          note: '',
        );

      default:
        return ConversionResult.failure(
          message:
              'A unidade ${to.label} não é um nível de tensão suportado.',
          error: ConversionError.unsupportedCombination,
        );
    }
  }

}
