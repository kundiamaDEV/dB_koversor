// Testes de localização (Fase 4).
//
// O que aqui se verifica, e porquê:
//
// 1. Todos os idiomas prometidos estão declarados e carregam.
// 2. Nenhuma chave fica sem tradução em nenhum idioma (um texto em branco ou
//    igual ao português num idioma estrangeiro é um defeito que passa
//    facilmente sem ser notado).
// 3. Os símbolos técnicos não são traduzidos.
// 4. Os códigos de erro têm TODOS tradução em TODOS os idiomas — a garantia de
//    que nenhum erro chega ao utilizador em branco.
// 5. As descrições de todas as unidades, incluindo a nova dBW, estão
//    traduzidas em todos os idiomas.

import 'package:db_konversor/core/localization/conversion_messages.dart';
import 'package:db_konversor/core/models/conversion_error.dart';
import 'package:db_konversor/core/models/conversion_result.dart';
import 'package:db_konversor/core/power_unit.dart';
import 'package:db_konversor/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Idiomas que o produto promete suportar.
const List<String> expectedLanguages = <String>['pt', 'en', 'fr', 'es', 'zh'];

Future<AppLocalizations> loadFor(String languageCode) {
  return AppLocalizations.delegate.load(Locale(languageCode));
}

void main() {
  group('Idiomas suportados', () {
    test('os cinco idiomas estão declarados', () {
      final codes = AppLocalizations.supportedLocales
          .map((locale) => locale.languageCode)
          .toList();

      for (final language in expectedLanguages) {
        expect(
          codes,
          contains(language),
          reason: 'o idioma $language devia estar suportado',
        );
      }
      expect(codes, hasLength(expectedLanguages.length));
    });

    test('todos carregam sem erro', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);
        expect(l10n, isNotNull, reason: language);
      }
    });

    test('o delegado aceita exactamente os idiomas suportados', () {
      for (final language in expectedLanguages) {
        expect(AppLocalizations.delegate.isSupported(Locale(language)), isTrue);
      }
      expect(
        AppLocalizations.delegate.isSupported(const Locale('de')),
        isFalse,
        reason: 'alemão não está previsto nesta fase',
      );
    });
  });

  group('Nenhum texto fica por traduzir', () {
    test('as cadeias principais não estão vazias em nenhum idioma', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        final strings = <String, String>{
          'sectionInputValue': l10n.sectionInputValue,
          'sectionOutputValue': l10n.sectionOutputValue,
          'sectionInputUnit': l10n.sectionInputUnit,
          'sectionOutputUnit': l10n.sectionOutputUnit,
          'sectionImpedance': l10n.sectionImpedance,
          'sectionReference': l10n.sectionReference,
          'inputHint': l10n.inputHint,
          'impedanceHint': l10n.impedanceHint,
          'referenceHelper': l10n.referenceHelper,
          'buttonFormula': l10n.buttonFormula,
          'dialogFormulaTitle': l10n.dialogFormulaTitle,
          'formulaEmpty': l10n.formulaEmpty,
          'actionClose': l10n.actionClose,
          'actionUnderstood': l10n.actionUnderstood,
          'actionCancel': l10n.actionCancel,
          'actionClear': l10n.actionClear,
          'helpTitle': l10n.helpTitle,
          'helpInstructions': l10n.helpInstructions,
          'historyTitle': l10n.historyTitle,
          'historyEmpty': l10n.historyEmpty,
          'historyEmptyHint': l10n.historyEmptyHint,
          'historyClearTitle': l10n.historyClearTitle,
          'historyClearMessage': l10n.historyClearMessage,
          'historyCleared': l10n.historyCleared,
          'historyJustNow': l10n.historyJustNow,
          'historyLocalOnly': l10n.historyLocalOnly,
          'drawerUnitsTitle': l10n.drawerUnitsTitle,
          'drawerUseAsInput': l10n.drawerUseAsInput,
          'drawerUseAsOutput': l10n.drawerUseAsOutput,
          'drawerAboutTitle': l10n.drawerAboutTitle,
          'drawerAboutSubtitle': l10n.drawerAboutSubtitle,
          'drawerPrivacy': l10n.drawerPrivacy,
          'tooltipMenu': l10n.tooltipMenu,
          'tooltipHelp': l10n.tooltipHelp,
          'tooltipSwap': l10n.tooltipSwap,
          'tooltipHistory': l10n.tooltipHistory,
          'promptEnterData': l10n.promptEnterData,
          'referenceGenericLabel': l10n.referenceGenericLabel,
          'referenceHintGeneric': l10n.referenceHintGeneric,
          'typeRatioReference': l10n.typeRatioReference,
          'typePower': l10n.typePower,
          'typeVoltageLevel': l10n.typeVoltageLevel,
          'typePowerVoltageImpedance': l10n.typePowerVoltageImpedance,
          'typeTechnical': l10n.typeTechnical,
          'describeRatioReference': l10n.describeRatioReference,
          'describeImpedance': l10n.describeImpedance,
          'privacyTitle': l10n.privacyTitle,
          'privacyIntro': l10n.privacyIntro,
          'splashLoading': l10n.splashLoading,
          'appTagline': l10n.appTagline,
        };

        strings.forEach((key, value) {
          expect(
            value.trim(),
            isNotEmpty,
            reason: 'chave "$key" vazia no idioma $language',
          );
        });
      }
    });

    test('todas as secções da política de privacidade têm texto', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        final sections = <String>[
          l10n.privacyNoCollectionTitle,
          l10n.privacyNoCollectionBody,
          l10n.privacyLocalDataTitle,
          l10n.privacyLocalDataBody,
          l10n.privacyRetentionTitle,
          l10n.privacyRetentionBody,
          l10n.privacyPermissionsTitle,
          l10n.privacyPermissionsBody,
          l10n.privacyThirdPartyTitle,
          l10n.privacyThirdPartyBody,
          l10n.privacyChildrenTitle,
          l10n.privacyChildrenBody,
          l10n.privacyRightsTitle,
          l10n.privacyRightsBody,
          l10n.privacyContactTitle,
          l10n.privacyContactBody,
          l10n.privacyChangesTitle,
          l10n.privacyChangesBody,
        ];

        for (final section in sections) {
          expect(section.trim(), isNotEmpty, reason: 'idioma $language');
        }
      }
    });

    test('as traduções diferem realmente do português', () async {
      // Protege contra o caso em que um ficheiro ARB é copiado e fica com o
      // texto português por traduzir.
      //
      // A comparação é feita sobre frases longas, e não sobre rótulos curtos.
      // Motivo: entre português e espanhol há rótulos que coincidem
      // legitimamente — «VALOR DE ENTRADA» e «VALOR DE SALIDA» são a tradução
      // correcta, não uma tradução esquecida. Uma frase inteira, com verbos e
      // ligações, já não coincide por acaso entre dois idiomas distintos, pelo
      // que é o indicador fiável.
      final pt = await loadFor('pt');

      for (final language in <String>['en', 'fr', 'es', 'zh']) {
        final l10n = await loadFor(language);

        expect(
          l10n.historyEmpty,
          isNot(pt.historyEmpty),
          reason: '$language parece não estar traduzido',
        );
        expect(
          l10n.privacyNoCollectionBody,
          isNot(pt.privacyNoCollectionBody),
          reason: '$language parece não estar traduzido',
        );
        expect(
          l10n.helpInstructions,
          isNot(pt.helpInstructions),
          reason: '$language parece não estar traduzido',
        );
        expect(
          l10n.describeImpedance,
          isNot(pt.describeImpedance),
          reason: '$language parece não estar traduzido',
        );
      }

      // Nos idiomas sem raiz comum com o português, até os rótulos curtos têm
      // de diferir.
      for (final language in <String>['en', 'fr', 'zh']) {
        final l10n = await loadFor(language);
        expect(
          l10n.sectionInputValue,
          isNot(pt.sectionInputValue),
          reason: '$language parece não estar traduzido',
        );
      }
    });
  });

  group('Símbolos técnicos permanecem invariáveis', () {
    test('o nome do produto é igual em todos os idiomas', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);
        expect(l10n.appTitle, 'dB Konversor', reason: language);
      }
    });

    test('o marcador de resultado vazio é igual em todos os idiomas', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);
        expect(l10n.resultPlaceholder, '--', reason: language);
      }
    });

    test('as unidades passadas como argumento não são alteradas', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        expect(l10n.referenceLabelForUnit('dBm'), contains('dBm'));
        expect(l10n.referencePowerLabel('W'), contains('W'));
        expect(l10n.errNonPositiveForLog('mW'), contains('mW'));
        expect(l10n.errOutOfRange('dBW'), contains('dBW'));
        expect(l10n.semanticsResult('12.5', 'dBV'), contains('dBV'));
      }
    });

    test('as descrições de dBm, dBW, dBu e dBV mantêm as referências', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        expect(l10n.unitDescDbm, contains('mW'), reason: language);
        expect(l10n.unitDescDbw, contains('dBm'), reason: language);
        expect(l10n.unitDescDbu, contains('0'), reason: language);
        expect(l10n.unitDescDbv, contains('V'), reason: language);
      }
    });
  });

  group('Mensagens de erro', () {
    test('todos os códigos têm tradução em todos os idiomas', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        for (final error in ConversionError.values) {
          final message = l10n.localizedError(error, unitLabel: 'dBm');

          expect(
            message.trim(),
            isNotEmpty,
            reason: 'erro $error sem texto no idioma $language',
          );
          // Um erro nunca deve mostrar o nome interno do código.
          expect(
            message,
            isNot(contains('ConversionError')),
            reason: 'erro $error expõe o identificador interno em $language',
          );
        }
      }
    });

    test('describeFailure traduz o código de um resultado falhado', () async {
      final result = ConversionResult.failure(
        message: 'mensagem de reserva em português',
        error: ConversionError.nonPositiveImpedance,
      );

      final en = await loadFor('en');
      final fr = await loadFor('fr');

      expect(en.describeFailure(result), en.errNonPositiveImpedance);
      expect(fr.describeFailure(result), fr.errNonPositiveImpedance);
      expect(en.describeFailure(result), isNot(fr.describeFailure(result)));
    });

    test('um resultado sem código recorre à mensagem de reserva', () async {
      final result = ConversionResult.failure(message: 'reserva');
      final en = await loadFor('en');
      expect(en.describeFailure(result), 'reserva');
    });

    test('a unidade aparece nas mensagens que a exigem', () async {
      final result = ConversionResult.failure(
        message: 'reserva',
        error: ConversionError.nonPositiveForLog,
        errorUnitLabel: 'dBW',
      );

      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);
        expect(l10n.describeFailure(result), contains('dBW'), reason: language);
      }
    });
  });

  group('Descrição das unidades', () {
    test('todas as unidades têm descrição em todos os idiomas', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);

        for (final unit in PowerUnit.values) {
          expect(
            l10n.describeUnit(unit).trim(),
            isNotEmpty,
            reason: 'unidade ${unit.label} sem descrição em $language',
          );
        }
      }
    });

    test('as descrições são distintas entre unidades', () async {
      final l10n = await loadFor('pt');
      final descriptions = PowerUnit.values
          .map((unit) => l10n.describeUnit(unit))
          .toSet();
      expect(descriptions, hasLength(PowerUnit.values.length));
    });
  });

  group('Plurais', () {
    test('singular e plural são distintos nos idiomas que os têm', () async {
      for (final language in <String>['pt', 'en', 'fr', 'es']) {
        final l10n = await loadFor(language);
        expect(
          l10n.historyMinutesAgo(1),
          isNot(l10n.historyMinutesAgo(5)),
          reason: language,
        );
      }
    });

    test('o número aparece na forma plural', () async {
      for (final language in expectedLanguages) {
        final l10n = await loadFor(language);
        expect(l10n.historyMinutesAgo(42), contains('42'), reason: language);
        expect(l10n.historyHoursAgo(7), contains('7'), reason: language);
      }
    });
  });
}
