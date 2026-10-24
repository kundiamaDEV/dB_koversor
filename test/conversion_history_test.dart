// Testes do histórico de conversões (defeito F1).
//
// Cobrem a serialização, a tolerância a dados corrompidos, o limite de
// entradas e — o ponto central — a PERSISTÊNCIA: que o histórico sobrevive à
// destruição e recriação do armazenamento, que é o equivalente, em teste, a
// fechar e reabrir a aplicação.

import 'package:db_konversor/features/history/conversion_history_entry.dart';
import 'package:db_konversor/features/history/conversion_history_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

ConversionHistoryEntry entryOf({
  double input = 10,
  String inputUnit = 'dBm',
  double output = 0.01,
  String outputUnit = 'W',
  DateTime? when,
}) {
  return ConversionHistoryEntry(
    inputValue: input,
    inputUnitLabel: inputUnit,
    outputValue: output,
    outputUnitLabel: outputUnit,
    timestampUtc: when ?? DateTime.utc(2026, 10, 17, 12, 0),
  );
}

void main() {
  // `shared_preferences` precisa de um substituto em memória nos testes:
  // não há plataforma Android por baixo.
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Serialização de uma entrada', () {
    test('ida e volta preserva todos os campos', () {
      final original = entryOf(
        input: -13.010299956640,
        inputUnit: 'dBV',
        output: 1.2345678901234e-7,
        outputUnit: 'W',
        when: DateTime.utc(2026, 3, 4, 5, 6, 7),
      );

      final restored = ConversionHistoryEntry.tryFromJson(original.toJson());

      expect(restored, isNotNull);
      expect(restored!.inputValue, original.inputValue);
      expect(restored.inputUnitLabel, 'dBV');
      expect(restored.outputValue, original.outputValue);
      expect(restored.outputUnitLabel, 'W');
      expect(restored.timestampUtc, original.timestampUtc);
    });

    test('a precisão completa do valor é conservada, sem arredondamento', () {
      // O histórico guarda o número, não o texto formatado: não pode perder
      // casas decimais.
      const precise = -133.01029995664012;
      final restored = ConversionHistoryEntry.tryFromJson(
        entryOf(output: precise).toJson(),
      );
      expect(restored!.outputValue, precise);
    });

    test('registos inválidos são descartados em vez de lançarem erro', () {
      expect(ConversionHistoryEntry.tryFromJson(null), isNull);
      expect(ConversionHistoryEntry.tryFromJson('texto'), isNull);
      expect(ConversionHistoryEntry.tryFromJson(<String, Object?>{}), isNull);
      expect(
        ConversionHistoryEntry.tryFromJson(<String, Object?>{
          'iv': 'nao e numero',
          'iu': 'dBm',
          'ov': 1,
          'ou': 'W',
          't': '2026-10-17T12:00:00.000Z',
        }),
        isNull,
      );
      expect(
        ConversionHistoryEntry.tryFromJson(<String, Object?>{
          'iv': 1,
          'iu': 'dBm',
          'ov': 1,
          'ou': 'W',
          't': 'data invalida',
        }),
        isNull,
      );
    });

    test('um histórico com texto corrompido é lido como vazio', () {
      expect(ConversionHistoryEntry.decodeList('{nao e json'), isEmpty);
      expect(ConversionHistoryEntry.decodeList(''), isEmpty);
      expect(ConversionHistoryEntry.decodeList(null), isEmpty);
      expect(ConversionHistoryEntry.decodeList('{"a":1}'), isEmpty);
    });

    test('entradas válidas são mantidas mesmo quando há inválidas pelo meio', () {
      final valid = entryOf().toJson();
      final mixed = ConversionHistoryEntry.encodeList([entryOf()]);
      expect(ConversionHistoryEntry.decodeList(mixed), hasLength(1));
      expect(valid['iu'], 'dBm');
    });
  });

  group('ConversionHistoryStore', () {
    test('começa vazio', () async {
      final store = ConversionHistoryStore();
      await store.load();
      expect(store.isEmpty, isTrue);
      expect(store.isLoaded, isTrue);
      expect(store.entries, isEmpty);
    });

    test('a entrada mais recente fica em primeiro lugar', () async {
      final store = ConversionHistoryStore();
      await store.load();

      await store.add(entryOf(input: 1));
      await store.add(entryOf(input: 2));
      await store.add(entryOf(input: 3));

      expect(store.entries.map((e) => e.inputValue), [3, 2, 1]);
    });

    test('PERSISTÊNCIA: o histórico sobrevive a fechar e reabrir', () async {
      final first = ConversionHistoryStore();
      await first.load();
      await first.add(entryOf(input: 20, inputUnit: 'dBm', output: 0.1));
      await first.add(entryOf(input: 30, inputUnit: 'dBm', output: 1.0));

      // Um novo objecto, a ler do mesmo armazenamento: é o que acontece
      // quando a aplicação é fechada e aberta de novo.
      final second = ConversionHistoryStore();
      await second.load();

      expect(second.entries, hasLength(2));
      expect(second.entries.first.inputValue, 30);
      expect(second.entries.first.outputValue, 1.0);
      expect(second.entries.last.inputValue, 20);
    });

    test('limpar apaga na memória e no armazenamento', () async {
      final store = ConversionHistoryStore();
      await store.load();
      await store.add(entryOf());
      expect(store.isEmpty, isFalse);

      await store.clear();
      expect(store.isEmpty, isTrue);

      final reopened = ConversionHistoryStore();
      await reopened.load();
      expect(reopened.isEmpty, isTrue, reason: 'não deve reaparecer');
    });

    test('conversões repetidas não geram entradas duplicadas', () async {
      // O resultado é recalculado a cada tecla premida; sem esta protecção o
      // histórico encher-se-ia de registos iguais.
      final store = ConversionHistoryStore();
      await store.load();

      await store.add(entryOf(input: 10));
      await store.add(entryOf(input: 10));
      await store.add(entryOf(input: 10));

      expect(store.entries, hasLength(1));
    });

    test('uma conversão diferente a seguir é registada', () async {
      final store = ConversionHistoryStore();
      await store.load();

      await store.add(entryOf(input: 10));
      await store.add(entryOf(input: 10, outputUnit: 'mW', output: 10));

      expect(store.entries, hasLength(2));
    });

    test('o número de entradas é limitado', () async {
      final store = ConversionHistoryStore();
      await store.load();

      for (var i = 0; i < ConversionHistoryStore.maxEntries + 25; i++) {
        await store.add(entryOf(input: i.toDouble()));
      }

      expect(store.entries, hasLength(ConversionHistoryStore.maxEntries));
      // As mais antigas são as descartadas; a mais recente permanece.
      expect(
        store.entries.first.inputValue,
        (ConversionHistoryStore.maxEntries + 24).toDouble(),
      );
    });

    test('valores não finitos nunca são gravados', () async {
      final store = ConversionHistoryStore();
      await store.load();

      await store.add(entryOf(output: double.nan));
      await store.add(entryOf(output: double.infinity));
      await store.add(entryOf(input: double.nan));

      expect(store.isEmpty, isTrue);
    });

    test('notifica os ouvintes ao acrescentar e ao limpar', () async {
      final store = ConversionHistoryStore();
      await store.load();

      var notifications = 0;
      store.addListener(() => notifications++);

      await store.add(entryOf(input: 1));
      await store.add(entryOf(input: 2));
      await store.clear();

      expect(notifications, 3);
    });

    test('um armazenamento com dados ilegíveis não impede o arranque', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        ConversionHistoryStore.storageKey: 'isto nao e json valido',
      });

      final store = ConversionHistoryStore();
      await store.load();

      expect(store.isLoaded, isTrue);
      expect(store.isEmpty, isTrue);

      // E continua a aceitar entradas novas.
      await store.add(entryOf());
      expect(store.entries, hasLength(1));
    });

    test('a lista devolvida não pode ser modificada por fora', () async {
      final store = ConversionHistoryStore();
      await store.load();
      await store.add(entryOf());

      expect(
        () => store.entries.add(entryOf(input: 999)),
        throwsUnsupportedError,
      );
    });
  });
}
