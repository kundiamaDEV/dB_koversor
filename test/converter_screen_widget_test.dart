// Testes de widget do ecrã do conversor.
//
// Cobrem o que os testes unitários não alcançam: arranque, introdução de
// valores, troca de unidades, apresentação do resultado e da fórmula,
// histórico real, acesso à Política de Privacidade e comportamento em
// diferentes dimensões de ecrã.
//
// Em particular, o grupo "Histórico" é o teste de regressão do defeito F1:
// verifica que NÃO aparecem as entradas fabricadas que estavam escritas no
// código.

import 'package:db_konversor/core/power_unit.dart';
import 'package:db_konversor/features/converter/converter_screen.dart';
import 'package:db_konversor/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Envolve o ecrã com as localizações, como `main.dart` faz.
Widget wrap({Locale locale = const Locale('pt')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const ConverterScreen(),
  );
}

Future<AppLocalizations> l10nFor(String language) =>
    AppLocalizations.delegate.load(Locale(language));

/// Avanca um numero fixo de fotogramas.
///
/// PORQUE NAO SE USA `pumpAndSettle` NESTE ECRA
/// O botao de inversao de unidades tem um brilho pulsante permanente,
/// implementado com `AnimationController.repeat(reverse: true)`. Essa animacao
/// nunca termina — e deliberado, faz parte da identidade visual —, pelo que a
/// arvore de widgets nunca atinge um estado estavel e `pumpAndSettle` expira
/// sempre, por muito que se espere.
///
/// 8 fotogramas de 120 ms cobrem 960 ms, o que e mais do que suficiente para
/// todas as transicoes do ecra: gaveta lateral (246 ms), dialogos (150 ms),
/// folha inferior (~250 ms), troca de unidades (320 ms), `AnimatedSwitcher` do
/// resultado (260 ms) e pulsacao do resultado (520 ms).
Future<void> settle(WidgetTester tester, {int frames = 8}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

/// Usa um ecra alto durante o teste.
///
/// PORQUE E NECESSARIO
/// As listas do menu lateral e da pagina de privacidade sao `ListView`, que
/// constroi apenas os elementos visiveis. No ecra pequeno por omissao do
/// ambiente de teste (800x600), os ultimos elementos nunca chegam a existir na
/// arvore e `find.text(...)` nao os encontra — o que seria confundido com um
/// defeito da aplicacao. Com um ecra alto, a lista inteira e construida e a
/// verificacao passa a ser sobre o conteudo, nao sobre a virtualizacao.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Arranque e apresentação', () {
    testWidgets('o ecrã arranca e mostra um resultado', (tester) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      // Valor inicial 10 dBm -> W = 0,01 W.
      expect(find.text('0.01'), findsOneWidget);
      expect(find.text('dBm'), findsWidgets);
      expect(find.text('W'), findsWidgets);
    });

    testWidgets('as secções aparecem com os títulos traduzidos', (
      tester,
    ) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      expect(find.text(l10n.sectionInputValue), findsOneWidget);
      expect(find.text(l10n.sectionOutputValue), findsOneWidget);
      expect(find.text(l10n.sectionInputUnit), findsOneWidget);
      expect(find.text(l10n.sectionOutputUnit), findsOneWidget);
    });

    testWidgets('em inglês a interface aparece em inglês', (tester) async {
      final en = await l10nFor('en');

      await tester.pumpWidget(wrap(locale: const Locale('en')));
      await settle(tester);

      expect(find.text(en.sectionInputValue), findsOneWidget);
      expect(find.text('INPUT VALUE'), findsOneWidget);
      // E não em português.
      expect(find.text('VALOR DE ENTRADA'), findsNothing);
    });

    testWidgets('não há texto em português quando o idioma é chinês', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(locale: const Locale('zh')));
      await settle(tester);

      expect(find.text('VALOR DE ENTRADA'), findsNothing);
      expect(find.text('输入值'), findsOneWidget);
    });
  });

  group('Introdução de valores e conversão', () {
    testWidgets('escrever um valor novo actualiza o resultado', (tester) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, '30');
      await settle(tester);

      // 30 dBm = 1 W.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('a vírgula é aceite como separador decimal', (tester) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, '33,0103');
      await settle(tester);

      // 33,0103 dBm ≈ 2 W.
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('um valor inválido mostra uma mensagem de erro', (
      tester,
    ) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, 'abc');
      await settle(tester);

      expect(find.text(l10n.errInvalidNumber), findsOneWidget);
      expect(find.text(l10n.resultPlaceholder), findsOneWidget);
    });

    testWidgets('o campo vazio mostra a mensagem correspondente', (
      tester,
    ) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, '');
      await settle(tester);

      expect(find.text(l10n.errEmptyInput), findsOneWidget);
    });

    testWidgets('a mensagem de erro aparece traduzida', (tester) async {
      final en = await l10nFor('en');

      await tester.pumpWidget(wrap(locale: const Locale('en')));
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, 'xyz');
      await settle(tester);

      expect(find.text(en.errInvalidNumber), findsOneWidget);
    });
  });

  group('Inversão de unidades', () {
    testWidgets('o botão de inversão troca a entrada com a saída', (
      tester,
    ) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      final swap = find.byIcon(Icons.swap_horiz_rounded);
      expect(swap, findsOneWidget);

      await tester.tap(swap);
      await settle(tester);

      // Era dBm -> W; depois da inversão é W -> dBm, pelo que 10 W = 40 dBm.
      expect(find.text('40'), findsOneWidget);
    });

    testWidgets('inverter duas vezes devolve ao estado inicial', (
      tester,
    ) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      final swap = find.byIcon(Icons.swap_horiz_rounded);
      await tester.tap(swap);
      await settle(tester);
      await tester.tap(swap);
      await settle(tester);

      expect(find.text('0.01'), findsOneWidget);
    });
  });

  group('Campos contextuais', () {
    testWidgets('a impedância só aparece quando é necessária', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      // dBm -> W não precisa de impedância.
      expect(find.text(l10n.sectionImpedance), findsNothing);
      expect(find.text(l10n.sectionReference), findsNothing);
    });

    testWidgets('dBm para dBV revela o campo de impedância', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      // Troca a unidade de saída para dBV através do menu suspenso.
      await tester.tap(find.byType(DropdownButton<PowerUnit>).last);
      await settle(tester);
      await tester.tap(find.text('dBV').last);
      await settle(tester);

      expect(find.text(l10n.sectionImpedance), findsOneWidget);
      // Impedância de 50 Ω por omissão: 10 dBm em 50 Ω = −3,0103 dBV.
      expect(find.text('-3.0103'), findsOneWidget);
    });

    testWidgets('dB revela o campo de referência', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byType(DropdownButton<PowerUnit>).last);
      await settle(tester);
      await tester.tap(find.text('dB').last);
      await settle(tester);

      expect(find.text(l10n.sectionReference), findsOneWidget);
      expect(find.text(l10n.referenceLabelForUnit('dBm')), findsOneWidget);
    });
  });

  group('Diálogos de fórmula e de ajuda', () {
    testWidgets('o botão de fórmula mostra a fórmula aplicada', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.text(l10n.buttonFormula));
      await settle(tester);

      expect(find.text(l10n.dialogFormulaTitle), findsOneWidget);
      // dBm -> W passa por mW: a fórmula encadeada deve mostrar os dois passos
      // (correcção M4).
      expect(find.textContaining('10^(dBm / 10)'), findsOneWidget);
      expect(find.textContaining('W = mW / 1000'), findsOneWidget);

      await tester.tap(find.text(l10n.actionClose));
      await settle(tester);
      expect(find.text(l10n.dialogFormulaTitle), findsNothing);
    });

    testWidgets('a ajuda abre e fecha', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byIcon(Icons.help_outline_rounded));
      await settle(tester);

      expect(find.text(l10n.helpTitle), findsOneWidget);
      expect(find.textContaining('KUNDIAMA'), findsOneWidget);

      await tester.tap(find.text(l10n.actionUnderstood));
      await settle(tester);
      expect(find.text(l10n.helpTitle), findsNothing);
    });
  });

  group('Histórico (regressão do defeito F1)', () {
    testWidgets('NÃO aparecem as entradas fabricadas da versão anterior', (
      tester,
    ) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await settle(tester);

      // Estes eram os dados falsos escritos no código, um deles com um valor
      // matematicamente errado (defeito M7). Nunca devem voltar.
      expect(find.text('20.0 dBm → 100.00 mW'), findsNothing);
      expect(find.text('0.775 dBu → 0.614 dBV'), findsNothing);
      expect(find.textContaining('21/04/2026'), findsNothing);
      expect(find.textContaining('15:48'), findsNothing);
    });

    testWidgets('começa vazio e explica que está vazio', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await settle(tester);

      expect(find.text(l10n.historyTitle), findsOneWidget);
      expect(find.text(l10n.historyEmpty), findsOneWidget);
      // Sem entradas, não há botão de limpar.
      expect(find.text(l10n.actionClear), findsNothing);
    });

    testWidgets('registá uma conversão feita pelo utilizador', (tester) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.enterText(find.byType(TextField).first, '30');
      await settle(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await settle(tester);

      // 30 dBm -> 1 W, com a seta de conversão.
      expect(find.textContaining('30 dBm'), findsOneWidget);
      expect(find.textContaining('1 W'), findsOneWidget);
    });

    testWidgets('o histórico indica que os dados ficam no dispositivo', (
      tester,
    ) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await settle(tester);

      expect(find.text(l10n.historyLocalOnly), findsOneWidget);
    });

    testWidgets('as conversões feitas antes já estão carregadas no arranque', (
      tester,
    ) async {
      // Simula uma sessão anterior já gravada no dispositivo.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'conversion_history_v1':
            '[{"iv":47.0,"iu":"dBm","ov":50.0,"ou":"W",'
                '"t":"2026-10-17T10:00:00.000Z"}]',
      });

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await settle(tester);

      expect(find.textContaining('47 dBm'), findsOneWidget);
      expect(find.textContaining('50 W'), findsOneWidget);
    });
  });

  group('Política de Privacidade (bloqueador B4)', () {
    testWidgets('é acessível pelo menu lateral', (tester) async {
      final l10n = await l10nFor('pt');

      useTallScreen(tester);
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);

      expect(find.text(l10n.drawerPrivacy), findsOneWidget);

      await tester.tap(find.text(l10n.drawerPrivacy));
      await settle(tester);

      // A página abriu e tem o conteúdo esperado.
      expect(find.text(l10n.privacyNoCollectionTitle), findsOneWidget);
      expect(find.text(l10n.privacyLocalDataTitle), findsOneWidget);
      expect(find.text(l10n.privacyPermissionsTitle), findsOneWidget);
    });

    testWidgets('é possível voltar ao conversor', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);
      await tester.tap(find.text(l10n.drawerPrivacy));
      await settle(tester);

      await tester.tap(find.byType(BackButton));
      await settle(tester);

      expect(find.text(l10n.sectionInputValue), findsOneWidget);
    });

    testWidgets('aparece no idioma seleccionado', (tester) async {
      final fr = await l10nFor('fr');

      await tester.pumpWidget(wrap(locale: const Locale('fr')));
      await settle(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);
      await tester.tap(find.text(fr.drawerPrivacy));
      await settle(tester);

      expect(find.text(fr.privacyNoCollectionTitle), findsOneWidget);
    });
  });

  group('Menu de unidades', () {
    testWidgets('lista as sete unidades, incluindo dBW', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap());
      await settle(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);

      for (final label in <String>['W', 'mW', 'dB', 'dBm', 'dBW', 'dBu', 'dBV']) {
        expect(
          find.text(label),
          findsWidgets,
          reason: 'a unidade $label devia constar do menu',
        );
      }
    });

    testWidgets('as descrições das unidades aparecem traduzidas', (
      tester,
    ) async {
      final en = await l10nFor('en');

      useTallScreen(tester);
      await tester.pumpWidget(wrap(locale: const Locale('en')));
      await settle(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await settle(tester);

      expect(find.text(en.unitDescDbm), findsOneWidget);
    });
  });

  group('Acessibilidade', () {
    testWidgets('os botões só com ícone têm descrição', (tester) async {
      final l10n = await l10nFor('pt');

      await tester.pumpWidget(wrap());
      await settle(tester);

      expect(
        find.byTooltip(l10n.tooltipMenu),
        findsOneWidget,
        reason: 'o botão de menu precisa de descrição para leitores de ecrã',
      );
      expect(find.byTooltip(l10n.tooltipHelp), findsOneWidget);
      expect(find.byTooltip(l10n.tooltipSwap), findsOneWidget);
      expect(find.byTooltip(l10n.tooltipHistory), findsOneWidget);
    });

    testWidgets('o resultado tem rótulo semântico', (tester) async {
      await tester.pumpWidget(wrap());
      await settle(tester);

      final semantics = tester.getSemantics(
        find.bySemanticsLabel(RegExp(r'0\.01')),
      );
      expect(semantics, isNotNull);
    });
  });

  group('Dimensões de ecrã e orientação', () {
    testWidgets('telemóvel pequeno: sem transbordo', (tester) async {
      tester.view.physicalSize = const Size(320 * 3, 568 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap());
      await settle(tester);

      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet de 10 polegadas: sem transbordo', (tester) async {
      tester.view.physicalSize = const Size(1600 * 2, 2560 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap());
      await settle(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('0.01'), findsOneWidget);
    });

    testWidgets('horizontal, com teclado reduzido: sem transbordo', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900 * 2, 400 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap());
      await settle(tester);

      expect(tester.takeException(), isNull);
    });

    testWidgets('textos longos em francês não provocam transbordo', (
      tester,
    ) async {
      // O francês tem as cadeias mais longas do conjunto; num ecrã estreito é
      // o pior caso de layout.
      tester.view.physicalSize = const Size(320 * 3, 568 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(locale: const Locale('fr')));
      await settle(tester);

      expect(tester.takeException(), isNull);
    });

    testWidgets('com letra ampliada não há transbordo', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: wrap(),
        ),
      );
      await settle(tester);

      expect(tester.takeException(), isNull);
    });
  });
}
