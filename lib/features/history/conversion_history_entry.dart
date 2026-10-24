import 'dart:convert';

/// Uma conversão efectivamente realizada pelo utilizador.
///
/// INTRODUZIDO NA AUDITORIA DE 2026-10-17 (defeito F1).
///
/// Porque foi necessário
/// ---------------------
/// O painel de histórico anterior não registava nada: construía a lista em
/// cada abertura com a conversão corrente e **duas entradas fixas escritas no
/// código**, com datas inventadas (21/04/2026). Uma delas estava até
/// matematicamente errada (`0.775 dBu → 0.614 dBV`, quando o valor correcto é
/// −1,452 dBV — defeito M7). Numa aplicação cuja proposta de valor é a
/// exactidão, mostrar dados falsos é um problema de confiança, e anunciar
/// "histórico" na loja sem o ter seria uma declaração falsa de funcionalidade.
///
/// Decisão de modelação
/// --------------------
/// Guarda-se o **valor numérico** da entrada e do resultado, e não o texto já
/// formatado. Assim a apresentação pode mudar (número de casas decimais,
/// idioma) sem reescrever o que está gravado, e o valor permanece na precisão
/// completa de dupla precisão.
///
/// Os símbolos das unidades são gravados como texto (`dBm`, `W`) em vez do
/// índice do enum: se a ordem de `PowerUnit` mudar numa versão futura, o
/// histórico já gravado continua legível. É uma troca deliberada de alguns
/// bytes por compatibilidade.
class ConversionHistoryEntry {
  /// Valor introduzido pelo utilizador, na precisão em que foi usado.
  final double inputValue;

  /// Símbolo da unidade de entrada (`dBm`, `W`, ...). Não traduzido.
  final String inputUnitLabel;

  /// Resultado da conversão, sem arredondamento de apresentação.
  final double outputValue;

  /// Símbolo da unidade de saída. Não traduzido.
  final String outputUnitLabel;

  /// Momento em que a conversão foi registada, em UTC.
  ///
  /// Guardado em UTC para que uma mudança de fuso horário ou de horário de
  /// verão não altere a ordem nem desloque as horas já gravadas. A conversão
  /// para a hora local acontece só na apresentação.
  final DateTime timestampUtc;

  const ConversionHistoryEntry({
    required this.inputValue,
    required this.inputUnitLabel,
    required this.outputValue,
    required this.outputUnitLabel,
    required this.timestampUtc,
  });

  Map<String, Object?> toJson() => <String, Object?>{
    'iv': inputValue,
    'iu': inputUnitLabel,
    'ov': outputValue,
    'ou': outputUnitLabel,
    't': timestampUtc.toIso8601String(),
  };

  /// Lê uma entrada gravada.
  ///
  /// Devolve `null` quando o registo está incompleto ou corrompido, em vez de
  /// lançar uma excepção: um histórico danificado não deve impedir a aplicação
  /// de arrancar. Quem chama descarta os `null`.
  static ConversionHistoryEntry? tryFromJson(Object? raw) {
    if (raw is! Map) return null;

    final inputValue = raw['iv'];
    final outputValue = raw['ov'];
    final inputUnit = raw['iu'];
    final outputUnit = raw['ou'];
    final timestamp = raw['t'];

    if (inputValue is! num || outputValue is! num) return null;
    if (inputUnit is! String || outputUnit is! String) return null;
    if (timestamp is! String) return null;

    final parsedTime = DateTime.tryParse(timestamp);
    if (parsedTime == null) return null;

    final input = inputValue.toDouble();
    final output = outputValue.toDouble();

    // Um registo não finito nunca deveria ter sido gravado; se existir, é
    // sinal de corrupção e é descartado.
    if (!input.isFinite || !output.isFinite) return null;

    return ConversionHistoryEntry(
      inputValue: input,
      inputUnitLabel: inputUnit,
      outputValue: output,
      outputUnitLabel: outputUnit,
      timestampUtc: parsedTime.toUtc(),
    );
  }

  /// Codifica uma lista de entradas para gravação.
  static String encodeList(List<ConversionHistoryEntry> entries) =>
      jsonEncode(entries.map((entry) => entry.toJson()).toList());

  /// Descodifica uma lista gravada, ignorando registos inválidos.
  static List<ConversionHistoryEntry> decodeList(String? stored) {
    if (stored == null || stored.isEmpty) return <ConversionHistoryEntry>[];

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! List) return <ConversionHistoryEntry>[];

      return decoded
          .map(ConversionHistoryEntry.tryFromJson)
          .whereType<ConversionHistoryEntry>()
          .toList();
    } on FormatException {
      // Dados ilegíveis: trata-se como histórico vazio em vez de falhar.
      return <ConversionHistoryEntry>[];
    }
  }

  /// Duas conversões iguais seguidas não devem gerar duas entradas.
  ///
  /// Sem isto, cada tecla premida no campo de valor criaria um registo: o
  /// resultado é recalculado a cada alteração de texto.
  bool hasSameConversionAs(ConversionHistoryEntry other) {
    return inputValue == other.inputValue &&
        inputUnitLabel == other.inputUnitLabel &&
        outputUnitLabel == other.outputUnitLabel &&
        outputValue == other.outputValue;
  }
}
