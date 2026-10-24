// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'dB Konversor';

  @override
  String get appTagline => 'Convierta decibelios con\nprecisión y sencillez.';

  @override
  String get splashLoading => 'Cargando...';

  @override
  String splashVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get sectionInputValue => 'VALOR DE ENTRADA';

  @override
  String get sectionOutputValue => 'VALOR DE SALIDA';

  @override
  String get sectionInputUnit => 'UNIDAD DE ENTRADA';

  @override
  String get sectionOutputUnit => 'UNIDAD DE SALIDA';

  @override
  String get sectionImpedance => 'IMPEDANCIA';

  @override
  String get sectionReference => 'VALOR DE REFERENCIA';

  @override
  String get inputHint => 'Introduzca un valor';

  @override
  String get impedanceHint => 'Ej.: 50';

  @override
  String get referenceHelper =>
      'La referencia debe expresarse en la unidad indicada.';

  @override
  String get resultPlaceholder => '--';

  @override
  String get buttonFormula => 'FÓRMULA';

  @override
  String get dialogFormulaTitle => 'Fórmula';

  @override
  String get formulaEmpty =>
      'La fórmula aparecerá aquí después de la conversión.';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionUnderstood => 'Entendido';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionClear => 'Borrar';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get helpInstructions =>
      'Introduzca el valor de entrada y elija la unidad de entrada y la unidad de salida. Cuando se le solicite, introduzca también la impedancia o el valor de referencia. El resultado aparece en el campo de salida.';

  @override
  String get helpMadeBy => 'Desarrollado por: KUNDIAMA';

  @override
  String helpContact(String phones) {
    return 'Teléfono: $phones';
  }

  @override
  String helpEmail(String email) {
    return 'Correo electrónico: $email';
  }

  @override
  String get historyTitle => 'Historial reciente';

  @override
  String get historyEmpty => 'Todavía no hay conversiones registradas.';

  @override
  String get historyEmptyHint =>
      'Las conversiones que realice aparecen aquí, guardadas solo en este dispositivo.';

  @override
  String get historyClearTitle => '¿Borrar el historial?';

  @override
  String get historyClearMessage =>
      'Se eliminarán todas las conversiones guardadas en este dispositivo. Esta acción no se puede deshacer.';

  @override
  String get historyCleared => 'Historial borrado.';

  @override
  String get historyJustNow => 'Ahora mismo';

  @override
  String historyMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Hace $minutes minutos',
      one: 'Hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String historyHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Hace $hours horas',
      one: 'Hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String get historyLocalOnly => 'Guardado solo en este dispositivo.';

  @override
  String get drawerUnitsTitle => 'UNIDADES DISPONIBLES';

  @override
  String get drawerUseAsInput => 'Usar como entrada';

  @override
  String get drawerUseAsOutput => 'Usar como salida';

  @override
  String get drawerAboutTitle => 'Acerca de dB Konversor';

  @override
  String get drawerAboutSubtitle =>
      'Conversiones de potencia y niveles logarítmicos utilizados en telecomunicaciones, electrónica y audio.';

  @override
  String get drawerPrivacy => 'Política de Privacidad';

  @override
  String get tooltipMenu => 'Abrir el menú de unidades';

  @override
  String get tooltipHelp => 'Ayuda';

  @override
  String get tooltipSwap => 'Invertir las unidades';

  @override
  String get tooltipHistory => 'Historial de conversiones';

  @override
  String semanticsResult(String value, String unit) {
    return 'Resultado: $value $unit';
  }

  @override
  String get semanticsNoResult => 'Todavía no hay resultado.';

  @override
  String get promptEnterData => 'Introduzca los datos para calcular.';

  @override
  String referenceLabelForUnit(String unit) {
    return 'Referencia ($unit)';
  }

  @override
  String referencePowerLabel(String unit) {
    return 'Potencia de referencia ($unit)';
  }

  @override
  String get referenceGenericLabel => 'Valor de referencia';

  @override
  String referenceHintForUnit(String unit) {
    return 'Ej.: 0 $unit';
  }

  @override
  String get referenceHintGeneric => 'Introduzca la referencia';

  @override
  String get typeRatioReference => 'Relación logarítmica y nivel de referencia';

  @override
  String get typePower => 'Conversión de potencia';

  @override
  String get typeVoltageLevel => 'Nivel logarítmico de tensión';

  @override
  String get typePowerVoltageImpedance => 'Potencia y tensión con impedancia';

  @override
  String get typeTechnical => 'Conversión técnica';

  @override
  String get describeRatioReference =>
      'Para calcular una relación en decibelios o un nivel absoluto, introduzca la referencia correspondiente a las unidades seleccionadas.';

  @override
  String get describeImpedance =>
      'Esta conversión relaciona tensión y potencia. Introduzca la impedancia correcta del sistema para obtener un resultado válido.';

  @override
  String get unitDescWatt => 'Potencia lineal en vatios.';

  @override
  String get unitDescMilliwatt => 'Potencia lineal en milivatios.';

  @override
  String get unitDescDb =>
      'Relación logarítmica entre dos magnitudes. Necesita un valor de referencia para dar un nivel absoluto.';

  @override
  String get unitDescDbm => 'Potencia absoluta referida a 1 mW.';

  @override
  String get unitDescDbw => 'Potencia absoluta referida a 1 W. 0 dBW = 30 dBm.';

  @override
  String get unitDescDbu => 'Nivel de tensión referido a 0,775 V.';

  @override
  String get unitDescDbv => 'Nivel de tensión referido a 1 V.';

  @override
  String get errEmptyInput => 'Introduzca un valor de entrada.';

  @override
  String get errInvalidNumber => 'Introduzca un número válido.';

  @override
  String get errNonFiniteInput => 'Introduzca un número finito.';

  @override
  String errNonPositiveForLog(String unit) {
    return 'El valor en $unit debe ser mayor que cero: el logaritmo de cero o de un número negativo no está definido.';
  }

  @override
  String errNegativePower(String unit) {
    return 'El valor en $unit no puede ser negativo: la potencia disipada no es una magnitud negativa.';
  }

  @override
  String get errMissingImpedance =>
      'Introduzca la impedancia para esta conversión.';

  @override
  String get errNonPositiveImpedance =>
      'La impedancia debe ser mayor que cero.';

  @override
  String get errMissingReference => 'Introduzca un valor de referencia válido.';

  @override
  String get errNonPositiveReference =>
      'La potencia de referencia debe ser mayor que cero.';

  @override
  String errOutOfRange(String unit) {
    return 'El valor en $unit está fuera del intervalo que la aplicación puede representar.';
  }

  @override
  String get errResultOutOfRange =>
      'El resultado supera el intervalo numérico representable.';

  @override
  String get errUnsupportedCombination =>
      'Esta combinación de unidades no es compatible.';

  @override
  String get errIncompatibleReference =>
      'Esta referencia no es compatible con las unidades seleccionadas.';

  @override
  String get errComputationFailed =>
      'No se pudo completar el cálculo con los valores introducidos.';

  @override
  String get privacyTitle => 'Política de Privacidad';

  @override
  String privacyUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get privacyIntro =>
      'Esta política explica cómo dB Konversor, desarrollado por KUNDIAMA Tecnologia e Inovação, trata la información. Se ha redactado a partir de una auditoría del código fuente de la aplicación.';

  @override
  String get privacyNoCollectionTitle => 'Datos que no recogemos';

  @override
  String get privacyNoCollectionBody =>
      'La aplicación no crea ninguna cuenta de usuario y no solicita nombre, correo electrónico, número de teléfono ni ubicación. No incluye publicidad ni herramientas de análisis de uso. No enviamos sus datos a ningún servidor, porque la aplicación no se comunica con ningún servidor.';

  @override
  String get privacyLocalDataTitle => 'Datos guardados en su dispositivo';

  @override
  String get privacyLocalDataBody =>
      'Su historial de conversiones —el valor introducido, las unidades elegidas, el resultado y la fecha— se guarda en el almacenamiento privado de la aplicación, en su propio dispositivo. Esta información nunca sale del dispositivo y no es accesible para KUNDIAMA.';

  @override
  String get privacyRetentionTitle => 'Conservación y eliminación';

  @override
  String get privacyRetentionBody =>
      'El historial se conserva hasta que usted lo borre. Puede borrarlo en cualquier momento desde la pantalla de historial, mediante la opción de borrado. Desinstalar la aplicación también elimina todo lo que haya guardado.';

  @override
  String get privacyPermissionsTitle => 'Permisos';

  @override
  String get privacyPermissionsBody =>
      'La versión de producción de la aplicación no solicita permiso de acceso a Internet ni ningún otro permiso del sistema Android.';

  @override
  String get privacyThirdPartyTitle => 'Servicios de terceros';

  @override
  String get privacyThirdPartyBody =>
      'La aplicación no integra servicios de terceros que recojan datos. La distribución se realiza a través de Google Play, que recoge sus propios datos de instalación según las políticas de Google, fuera del control de KUNDIAMA.';

  @override
  String get privacyChildrenTitle => 'Uso por menores';

  @override
  String get privacyChildrenBody =>
      'La aplicación es una herramienta de cálculo técnico, adecuada para estudiantes. Como no recoge datos personales, no trata información de menores.';

  @override
  String get privacyRightsTitle => 'Sus derechos';

  @override
  String get privacyRightsBody =>
      'Como no almacenamos datos personales en nuestros sistemas, no existe información suya que podamos mostrar, corregir o eliminar por nuestra parte. Los datos que guarda la aplicación están bajo su control directo, en su dispositivo.';

  @override
  String get privacyContactTitle => 'Contacto';

  @override
  String get privacyContactBody =>
      'Para cualquier consulta sobre esta política, utilice los datos de contacto que figuran en la pantalla de Ayuda de la aplicación.';

  @override
  String get privacyChangesTitle => 'Cambios en esta política';

  @override
  String get privacyChangesBody =>
      'Si el tratamiento de datos cambia en una versión futura, esta política se actualizará y se modificará la fecha de actualización.';
}
