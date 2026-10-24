import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// Nome do produto. Não traduzir em nenhum idioma.
  ///
  /// In pt, this message translates to:
  /// **'dB Konversor'**
  String get appTitle;

  /// Frase do ecrã de abertura. Contém uma quebra de linha intencional.
  ///
  /// In pt, this message translates to:
  /// **'Converta decibéis com precisão\ne simplicidade.'**
  String get appTagline;

  /// No description provided for @splashLoading.
  ///
  /// In pt, this message translates to:
  /// **'A carregar...'**
  String get splashLoading;

  /// No description provided for @splashVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão {version}'**
  String splashVersion(String version);

  /// Título de secção, apresentado em maiúsculas.
  ///
  /// In pt, this message translates to:
  /// **'VALOR DE ENTRADA'**
  String get sectionInputValue;

  /// No description provided for @sectionOutputValue.
  ///
  /// In pt, this message translates to:
  /// **'VALOR DE SAÍDA'**
  String get sectionOutputValue;

  /// No description provided for @sectionInputUnit.
  ///
  /// In pt, this message translates to:
  /// **'UNIDADE DE ENTRADA'**
  String get sectionInputUnit;

  /// No description provided for @sectionOutputUnit.
  ///
  /// In pt, this message translates to:
  /// **'UNIDADE DE SAÍDA'**
  String get sectionOutputUnit;

  /// No description provided for @sectionImpedance.
  ///
  /// In pt, this message translates to:
  /// **'IMPEDÂNCIA'**
  String get sectionImpedance;

  /// No description provided for @sectionReference.
  ///
  /// In pt, this message translates to:
  /// **'VALOR DE REFERÊNCIA'**
  String get sectionReference;

  /// No description provided for @inputHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite o valor'**
  String get inputHint;

  /// No description provided for @impedanceHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: 50'**
  String get impedanceHint;

  /// No description provided for @referenceHelper.
  ///
  /// In pt, this message translates to:
  /// **'A referência deve corresponder à unidade indicada.'**
  String get referenceHelper;

  /// Marcador apresentado quando ainda não há resultado. Igual em todos os idiomas.
  ///
  /// In pt, this message translates to:
  /// **'--'**
  String get resultPlaceholder;

  /// No description provided for @buttonFormula.
  ///
  /// In pt, this message translates to:
  /// **'FÓRMULA'**
  String get buttonFormula;

  /// No description provided for @dialogFormulaTitle.
  ///
  /// In pt, this message translates to:
  /// **'Fórmula'**
  String get dialogFormulaTitle;

  /// No description provided for @formulaEmpty.
  ///
  /// In pt, this message translates to:
  /// **'A fórmula aparecerá aqui após a conversão.'**
  String get formulaEmpty;

  /// No description provided for @actionClose.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get actionClose;

  /// No description provided for @actionUnderstood.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get actionUnderstood;

  /// No description provided for @actionCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get actionCancel;

  /// No description provided for @actionClear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get actionClear;

  /// No description provided for @helpTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda'**
  String get helpTitle;

  /// No description provided for @helpInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Introduza o valor de entrada, escolha a unidade de entrada e a unidade de saída. Quando for pedido, introduza também a impedância ou o valor de referência. O resultado aparece no campo de saída.'**
  String get helpInstructions;

  /// O nome KUNDIAMA é uma marca e não se traduz.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvido por: KUNDIAMA'**
  String get helpMadeBy;

  /// No description provided for @helpContact.
  ///
  /// In pt, this message translates to:
  /// **'Contacto: {phones}'**
  String helpContact(String phones);

  /// No description provided for @helpEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail: {email}'**
  String helpEmail(String email);

  /// No description provided for @historyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico recente'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não há conversões registadas.'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In pt, this message translates to:
  /// **'As conversões que fizer aparecem aqui, guardadas apenas neste dispositivo.'**
  String get historyEmptyHint;

  /// No description provided for @historyClearTitle.
  ///
  /// In pt, this message translates to:
  /// **'Limpar o histórico?'**
  String get historyClearTitle;

  /// No description provided for @historyClearMessage.
  ///
  /// In pt, this message translates to:
  /// **'Todas as conversões guardadas neste dispositivo serão apagadas. Esta acção não pode ser desfeita.'**
  String get historyClearMessage;

  /// No description provided for @historyCleared.
  ///
  /// In pt, this message translates to:
  /// **'Histórico apagado.'**
  String get historyCleared;

  /// No description provided for @historyJustNow.
  ///
  /// In pt, this message translates to:
  /// **'Agora mesmo'**
  String get historyJustNow;

  /// No description provided for @historyMinutesAgo.
  ///
  /// In pt, this message translates to:
  /// **'{minutes, plural, =1{Há 1 minuto} other{Há {minutes} minutos}}'**
  String historyMinutesAgo(int minutes);

  /// No description provided for @historyHoursAgo.
  ///
  /// In pt, this message translates to:
  /// **'{hours, plural, =1{Há 1 hora} other{Há {hours} horas}}'**
  String historyHoursAgo(int hours);

  /// No description provided for @historyLocalOnly.
  ///
  /// In pt, this message translates to:
  /// **'Guardado apenas neste dispositivo.'**
  String get historyLocalOnly;

  /// No description provided for @drawerUnitsTitle.
  ///
  /// In pt, this message translates to:
  /// **'UNIDADES DISPONÍVEIS'**
  String get drawerUnitsTitle;

  /// No description provided for @drawerUseAsInput.
  ///
  /// In pt, this message translates to:
  /// **'Usar como entrada'**
  String get drawerUseAsInput;

  /// No description provided for @drawerUseAsOutput.
  ///
  /// In pt, this message translates to:
  /// **'Usar como saída'**
  String get drawerUseAsOutput;

  /// No description provided for @drawerAboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o dB Konversor'**
  String get drawerAboutTitle;

  /// No description provided for @drawerAboutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Conversões de potência e níveis logarítmicos usados em telecomunicações, electrónica e áudio.'**
  String get drawerAboutSubtitle;

  /// No description provided for @drawerPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get drawerPrivacy;

  /// No description provided for @tooltipMenu.
  ///
  /// In pt, this message translates to:
  /// **'Abrir o menu de unidades'**
  String get tooltipMenu;

  /// No description provided for @tooltipHelp.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda'**
  String get tooltipHelp;

  /// No description provided for @tooltipSwap.
  ///
  /// In pt, this message translates to:
  /// **'Inverter as unidades'**
  String get tooltipSwap;

  /// No description provided for @tooltipHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de conversões'**
  String get tooltipHistory;

  /// Texto lido pelos leitores de ecrã.
  ///
  /// In pt, this message translates to:
  /// **'Resultado: {value} {unit}'**
  String semanticsResult(String value, String unit);

  /// No description provided for @semanticsNoResult.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não há resultado.'**
  String get semanticsNoResult;

  /// No description provided for @promptEnterData.
  ///
  /// In pt, this message translates to:
  /// **'Introduza os dados para calcular.'**
  String get promptEnterData;

  /// O símbolo da unidade não se traduz.
  ///
  /// In pt, this message translates to:
  /// **'Referência ({unit})'**
  String referenceLabelForUnit(String unit);

  /// No description provided for @referencePowerLabel.
  ///
  /// In pt, this message translates to:
  /// **'Potência de referência ({unit})'**
  String referencePowerLabel(String unit);

  /// No description provided for @referenceGenericLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor de referência'**
  String get referenceGenericLabel;

  /// No description provided for @referenceHintForUnit.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: 0 {unit}'**
  String referenceHintForUnit(String unit);

  /// No description provided for @referenceHintGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Introduza a referência'**
  String get referenceHintGeneric;

  /// No description provided for @typeRatioReference.
  ///
  /// In pt, this message translates to:
  /// **'Razão logarítmica e nível de referência'**
  String get typeRatioReference;

  /// No description provided for @typePower.
  ///
  /// In pt, this message translates to:
  /// **'Conversão de potência'**
  String get typePower;

  /// No description provided for @typeVoltageLevel.
  ///
  /// In pt, this message translates to:
  /// **'Nível logarítmico de tensão'**
  String get typeVoltageLevel;

  /// No description provided for @typePowerVoltageImpedance.
  ///
  /// In pt, this message translates to:
  /// **'Potência e tensão com impedância'**
  String get typePowerVoltageImpedance;

  /// No description provided for @typeTechnical.
  ///
  /// In pt, this message translates to:
  /// **'Conversão técnica'**
  String get typeTechnical;

  /// No description provided for @describeRatioReference.
  ///
  /// In pt, this message translates to:
  /// **'Para calcular uma razão em decibéis ou um nível absoluto, introduza a referência compatível com as unidades seleccionadas.'**
  String get describeRatioReference;

  /// No description provided for @describeImpedance.
  ///
  /// In pt, this message translates to:
  /// **'Esta conversão relaciona tensão e potência. Introduza a impedância correcta do sistema para obter um resultado válido.'**
  String get describeImpedance;

  /// No description provided for @unitDescWatt.
  ///
  /// In pt, this message translates to:
  /// **'Potência linear em watts.'**
  String get unitDescWatt;

  /// No description provided for @unitDescMilliwatt.
  ///
  /// In pt, this message translates to:
  /// **'Potência linear em miliwatts.'**
  String get unitDescMilliwatt;

  /// No description provided for @unitDescDb.
  ///
  /// In pt, this message translates to:
  /// **'Relação logarítmica entre duas grandezas. Precisa de um valor de referência para dar um nível absoluto.'**
  String get unitDescDb;

  /// No description provided for @unitDescDbm.
  ///
  /// In pt, this message translates to:
  /// **'Potência absoluta referenciada a 1 mW.'**
  String get unitDescDbm;

  /// No description provided for @unitDescDbw.
  ///
  /// In pt, this message translates to:
  /// **'Potência absoluta referenciada a 1 W. 0 dBW = 30 dBm.'**
  String get unitDescDbw;

  /// No description provided for @unitDescDbu.
  ///
  /// In pt, this message translates to:
  /// **'Nível de tensão referenciado a 0,775 V.'**
  String get unitDescDbu;

  /// No description provided for @unitDescDbv.
  ///
  /// In pt, this message translates to:
  /// **'Nível de tensão referenciado a 1 V.'**
  String get unitDescDbv;

  /// No description provided for @errEmptyInput.
  ///
  /// In pt, this message translates to:
  /// **'Introduza um valor de entrada.'**
  String get errEmptyInput;

  /// No description provided for @errInvalidNumber.
  ///
  /// In pt, this message translates to:
  /// **'Introduza um número válido.'**
  String get errInvalidNumber;

  /// No description provided for @errNonFiniteInput.
  ///
  /// In pt, this message translates to:
  /// **'Introduza um número finito.'**
  String get errNonFiniteInput;

  /// O símbolo da unidade não se traduz.
  ///
  /// In pt, this message translates to:
  /// **'O valor em {unit} tem de ser maior que zero: o logaritmo de zero ou de um número negativo não está definido.'**
  String errNonPositiveForLog(String unit);

  /// No description provided for @errNegativePower.
  ///
  /// In pt, this message translates to:
  /// **'O valor em {unit} não pode ser negativo: a potência dissipada não é uma grandeza negativa.'**
  String errNegativePower(String unit);

  /// No description provided for @errMissingImpedance.
  ///
  /// In pt, this message translates to:
  /// **'Introduza a impedância para esta conversão.'**
  String get errMissingImpedance;

  /// No description provided for @errNonPositiveImpedance.
  ///
  /// In pt, this message translates to:
  /// **'A impedância tem de ser maior que zero.'**
  String get errNonPositiveImpedance;

  /// No description provided for @errMissingReference.
  ///
  /// In pt, this message translates to:
  /// **'Introduza um valor de referência válido.'**
  String get errMissingReference;

  /// No description provided for @errNonPositiveReference.
  ///
  /// In pt, this message translates to:
  /// **'A potência de referência tem de ser maior que zero.'**
  String get errNonPositiveReference;

  /// No description provided for @errOutOfRange.
  ///
  /// In pt, this message translates to:
  /// **'O valor em {unit} está fora do intervalo que a aplicação consegue representar.'**
  String errOutOfRange(String unit);

  /// No description provided for @errResultOutOfRange.
  ///
  /// In pt, this message translates to:
  /// **'O resultado excede o intervalo numérico representável.'**
  String get errResultOutOfRange;

  /// No description provided for @errUnsupportedCombination.
  ///
  /// In pt, this message translates to:
  /// **'Esta combinação de unidades não é suportada.'**
  String get errUnsupportedCombination;

  /// No description provided for @errIncompatibleReference.
  ///
  /// In pt, this message translates to:
  /// **'Esta referência não é compatível com as unidades seleccionadas.'**
  String get errIncompatibleReference;

  /// No description provided for @errComputationFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir o cálculo com os valores introduzidos.'**
  String get errComputationFailed;

  /// No description provided for @privacyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyTitle;

  /// No description provided for @privacyUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Última actualização: {date}'**
  String privacyUpdated(String date);

  /// No description provided for @privacyIntro.
  ///
  /// In pt, this message translates to:
  /// **'Esta política explica como o dB Konversor, desenvolvido pela KUNDIAMA Tecnologia e Inovação, trata a informação. Foi escrita a partir de uma auditoria ao código da aplicação.'**
  String get privacyIntro;

  /// No description provided for @privacyNoCollectionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dados que não recolhemos'**
  String get privacyNoCollectionTitle;

  /// No description provided for @privacyNoCollectionBody.
  ///
  /// In pt, this message translates to:
  /// **'A aplicação não cria conta de utilizador, não pede nome, e-mail, número de telefone nem localização. Não integra publicidade nem ferramentas de análise de utilização. Não enviamos os seus dados para nenhum servidor, porque a aplicação não comunica com nenhum servidor.'**
  String get privacyNoCollectionBody;

  /// No description provided for @privacyLocalDataTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dados guardados no seu dispositivo'**
  String get privacyLocalDataTitle;

  /// No description provided for @privacyLocalDataBody.
  ///
  /// In pt, this message translates to:
  /// **'O histórico de conversões — o valor que introduziu, as unidades escolhidas, o resultado e a data — é guardado no armazenamento privado da aplicação, no seu próprio dispositivo. Esta informação nunca sai do dispositivo e não é acessível à KUNDIAMA.'**
  String get privacyLocalDataBody;

  /// No description provided for @privacyRetentionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conservação e eliminação'**
  String get privacyRetentionTitle;

  /// No description provided for @privacyRetentionBody.
  ///
  /// In pt, this message translates to:
  /// **'O histórico fica guardado até o apagar. Pode apagá-lo em qualquer momento no ecrã de histórico, através da opção de limpar. Desinstalar a aplicação elimina também todos os dados que ela tenha guardado.'**
  String get privacyRetentionBody;

  /// No description provided for @privacyPermissionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Permissões'**
  String get privacyPermissionsTitle;

  /// No description provided for @privacyPermissionsBody.
  ///
  /// In pt, this message translates to:
  /// **'A versão de lançamento da aplicação não pede a permissão de acesso à Internet nem qualquer outra permissão do sistema Android.'**
  String get privacyPermissionsBody;

  /// No description provided for @privacyThirdPartyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Serviços de terceiros'**
  String get privacyThirdPartyTitle;

  /// No description provided for @privacyThirdPartyBody.
  ///
  /// In pt, this message translates to:
  /// **'A aplicação não integra serviços de terceiros que recolham dados. A distribuição é feita pela Google Play, que recolhe os seus próprios dados de instalação segundo as políticas da Google, fora do controlo da KUNDIAMA.'**
  String get privacyThirdPartyBody;

  /// No description provided for @privacyChildrenTitle.
  ///
  /// In pt, this message translates to:
  /// **'Utilização por menores'**
  String get privacyChildrenTitle;

  /// No description provided for @privacyChildrenBody.
  ///
  /// In pt, this message translates to:
  /// **'A aplicação é uma ferramenta de cálculo técnico, adequada a estudantes. Como não recolhe dados pessoais, não trata informação de menores.'**
  String get privacyChildrenBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Os seus direitos'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In pt, this message translates to:
  /// **'Como não guardamos dados pessoais nos nossos sistemas, não há informação sua para consultar, corrigir ou apagar do nosso lado. Os dados que a aplicação guarda estão sob o seu controlo directo, no seu dispositivo.'**
  String get privacyRightsBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In pt, this message translates to:
  /// **'Contacto'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In pt, this message translates to:
  /// **'Para qualquer questão sobre esta política, use os contactos indicados no ecrã de Ajuda da aplicação.'**
  String get privacyContactBody;

  /// No description provided for @privacyChangesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Alterações a esta política'**
  String get privacyChangesTitle;

  /// No description provided for @privacyChangesBody.
  ///
  /// In pt, this message translates to:
  /// **'Se o tratamento de dados mudar numa versão futura, esta política será actualizada e a data de actualização alterada.'**
  String get privacyChangesBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
