// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'dB Konversor';

  @override
  String get appTagline => 'Converta decibéis com precisão\ne simplicidade.';

  @override
  String get splashLoading => 'A carregar...';

  @override
  String splashVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get sectionInputValue => 'VALOR DE ENTRADA';

  @override
  String get sectionOutputValue => 'VALOR DE SAÍDA';

  @override
  String get sectionInputUnit => 'UNIDADE DE ENTRADA';

  @override
  String get sectionOutputUnit => 'UNIDADE DE SAÍDA';

  @override
  String get sectionImpedance => 'IMPEDÂNCIA';

  @override
  String get sectionReference => 'VALOR DE REFERÊNCIA';

  @override
  String get inputHint => 'Digite o valor';

  @override
  String get impedanceHint => 'Ex.: 50';

  @override
  String get referenceHelper =>
      'A referência deve corresponder à unidade indicada.';

  @override
  String get resultPlaceholder => '--';

  @override
  String get buttonFormula => 'FÓRMULA';

  @override
  String get dialogFormulaTitle => 'Fórmula';

  @override
  String get formulaEmpty => 'A fórmula aparecerá aqui após a conversão.';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionUnderstood => 'Entendi';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionClear => 'Limpar';

  @override
  String get helpTitle => 'Ajuda';

  @override
  String get helpInstructions =>
      'Introduza o valor de entrada, escolha a unidade de entrada e a unidade de saída. Quando for pedido, introduza também a impedância ou o valor de referência. O resultado aparece no campo de saída.';

  @override
  String get helpMadeBy => 'Desenvolvido por: KUNDIAMA';

  @override
  String helpContact(String phones) {
    return 'Contacto: $phones';
  }

  @override
  String helpEmail(String email) {
    return 'E-mail: $email';
  }

  @override
  String get historyTitle => 'Histórico recente';

  @override
  String get historyEmpty => 'Ainda não há conversões registadas.';

  @override
  String get historyEmptyHint =>
      'As conversões que fizer aparecem aqui, guardadas apenas neste dispositivo.';

  @override
  String get historyClearTitle => 'Limpar o histórico?';

  @override
  String get historyClearMessage =>
      'Todas as conversões guardadas neste dispositivo serão apagadas. Esta acção não pode ser desfeita.';

  @override
  String get historyCleared => 'Histórico apagado.';

  @override
  String get historyJustNow => 'Agora mesmo';

  @override
  String historyMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Há $minutes minutos',
      one: 'Há 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String historyHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Há $hours horas',
      one: 'Há 1 hora',
    );
    return '$_temp0';
  }

  @override
  String get historyLocalOnly => 'Guardado apenas neste dispositivo.';

  @override
  String get drawerUnitsTitle => 'UNIDADES DISPONÍVEIS';

  @override
  String get drawerUseAsInput => 'Usar como entrada';

  @override
  String get drawerUseAsOutput => 'Usar como saída';

  @override
  String get drawerAboutTitle => 'Sobre o dB Konversor';

  @override
  String get drawerAboutSubtitle =>
      'Conversões de potência e níveis logarítmicos usados em telecomunicações, electrónica e áudio.';

  @override
  String get drawerPrivacy => 'Política de Privacidade';

  @override
  String get tooltipMenu => 'Abrir o menu de unidades';

  @override
  String get tooltipHelp => 'Ajuda';

  @override
  String get tooltipSwap => 'Inverter as unidades';

  @override
  String get tooltipHistory => 'Histórico de conversões';

  @override
  String semanticsResult(String value, String unit) {
    return 'Resultado: $value $unit';
  }

  @override
  String get semanticsNoResult => 'Ainda não há resultado.';

  @override
  String get promptEnterData => 'Introduza os dados para calcular.';

  @override
  String referenceLabelForUnit(String unit) {
    return 'Referência ($unit)';
  }

  @override
  String referencePowerLabel(String unit) {
    return 'Potência de referência ($unit)';
  }

  @override
  String get referenceGenericLabel => 'Valor de referência';

  @override
  String referenceHintForUnit(String unit) {
    return 'Ex.: 0 $unit';
  }

  @override
  String get referenceHintGeneric => 'Introduza a referência';

  @override
  String get typeRatioReference => 'Razão logarítmica e nível de referência';

  @override
  String get typePower => 'Conversão de potência';

  @override
  String get typeVoltageLevel => 'Nível logarítmico de tensão';

  @override
  String get typePowerVoltageImpedance => 'Potência e tensão com impedância';

  @override
  String get typeTechnical => 'Conversão técnica';

  @override
  String get describeRatioReference =>
      'Para calcular uma razão em decibéis ou um nível absoluto, introduza a referência compatível com as unidades seleccionadas.';

  @override
  String get describeImpedance =>
      'Esta conversão relaciona tensão e potência. Introduza a impedância correcta do sistema para obter um resultado válido.';

  @override
  String get unitDescWatt => 'Potência linear em watts.';

  @override
  String get unitDescMilliwatt => 'Potência linear em miliwatts.';

  @override
  String get unitDescDb =>
      'Relação logarítmica entre duas grandezas. Precisa de um valor de referência para dar um nível absoluto.';

  @override
  String get unitDescDbm => 'Potência absoluta referenciada a 1 mW.';

  @override
  String get unitDescDbw =>
      'Potência absoluta referenciada a 1 W. 0 dBW = 30 dBm.';

  @override
  String get unitDescDbu => 'Nível de tensão referenciado a 0,775 V.';

  @override
  String get unitDescDbv => 'Nível de tensão referenciado a 1 V.';

  @override
  String get errEmptyInput => 'Introduza um valor de entrada.';

  @override
  String get errInvalidNumber => 'Introduza um número válido.';

  @override
  String get errNonFiniteInput => 'Introduza um número finito.';

  @override
  String errNonPositiveForLog(String unit) {
    return 'O valor em $unit tem de ser maior que zero: o logaritmo de zero ou de um número negativo não está definido.';
  }

  @override
  String errNegativePower(String unit) {
    return 'O valor em $unit não pode ser negativo: a potência dissipada não é uma grandeza negativa.';
  }

  @override
  String get errMissingImpedance =>
      'Introduza a impedância para esta conversão.';

  @override
  String get errNonPositiveImpedance =>
      'A impedância tem de ser maior que zero.';

  @override
  String get errMissingReference => 'Introduza um valor de referência válido.';

  @override
  String get errNonPositiveReference =>
      'A potência de referência tem de ser maior que zero.';

  @override
  String errOutOfRange(String unit) {
    return 'O valor em $unit está fora do intervalo que a aplicação consegue representar.';
  }

  @override
  String get errResultOutOfRange =>
      'O resultado excede o intervalo numérico representável.';

  @override
  String get errUnsupportedCombination =>
      'Esta combinação de unidades não é suportada.';

  @override
  String get errIncompatibleReference =>
      'Esta referência não é compatível com as unidades seleccionadas.';

  @override
  String get errComputationFailed =>
      'Não foi possível concluir o cálculo com os valores introduzidos.';

  @override
  String get privacyTitle => 'Política de Privacidade';

  @override
  String privacyUpdated(String date) {
    return 'Última actualização: $date';
  }

  @override
  String get privacyIntro =>
      'Esta política explica como o dB Konversor, desenvolvido pela KUNDIAMA Tecnologia e Inovação, trata a informação. Foi escrita a partir de uma auditoria ao código da aplicação.';

  @override
  String get privacyNoCollectionTitle => 'Dados que não recolhemos';

  @override
  String get privacyNoCollectionBody =>
      'A aplicação não cria conta de utilizador, não pede nome, e-mail, número de telefone nem localização. Não integra publicidade nem ferramentas de análise de utilização. Não enviamos os seus dados para nenhum servidor, porque a aplicação não comunica com nenhum servidor.';

  @override
  String get privacyLocalDataTitle => 'Dados guardados no seu dispositivo';

  @override
  String get privacyLocalDataBody =>
      'O histórico de conversões — o valor que introduziu, as unidades escolhidas, o resultado e a data — é guardado no armazenamento privado da aplicação, no seu próprio dispositivo. Esta informação nunca sai do dispositivo e não é acessível à KUNDIAMA.';

  @override
  String get privacyRetentionTitle => 'Conservação e eliminação';

  @override
  String get privacyRetentionBody =>
      'O histórico fica guardado até o apagar. Pode apagá-lo em qualquer momento no ecrã de histórico, através da opção de limpar. Desinstalar a aplicação elimina também todos os dados que ela tenha guardado.';

  @override
  String get privacyPermissionsTitle => 'Permissões';

  @override
  String get privacyPermissionsBody =>
      'A versão de lançamento da aplicação não pede a permissão de acesso à Internet nem qualquer outra permissão do sistema Android.';

  @override
  String get privacyThirdPartyTitle => 'Serviços de terceiros';

  @override
  String get privacyThirdPartyBody =>
      'A aplicação não integra serviços de terceiros que recolham dados. A distribuição é feita pela Google Play, que recolhe os seus próprios dados de instalação segundo as políticas da Google, fora do controlo da KUNDIAMA.';

  @override
  String get privacyChildrenTitle => 'Utilização por menores';

  @override
  String get privacyChildrenBody =>
      'A aplicação é uma ferramenta de cálculo técnico, adequada a estudantes. Como não recolhe dados pessoais, não trata informação de menores.';

  @override
  String get privacyRightsTitle => 'Os seus direitos';

  @override
  String get privacyRightsBody =>
      'Como não guardamos dados pessoais nos nossos sistemas, não há informação sua para consultar, corrigir ou apagar do nosso lado. Os dados que a aplicação guarda estão sob o seu controlo directo, no seu dispositivo.';

  @override
  String get privacyContactTitle => 'Contacto';

  @override
  String get privacyContactBody =>
      'Para qualquer questão sobre esta política, use os contactos indicados no ecrã de Ajuda da aplicação.';

  @override
  String get privacyChangesTitle => 'Alterações a esta política';

  @override
  String get privacyChangesBody =>
      'Se o tratamento de dados mudar numa versão futura, esta política será actualizada e a data de actualização alterada.';
}
