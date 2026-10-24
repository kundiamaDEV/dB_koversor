// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'dB Konversor';

  @override
  String get appTagline =>
      'Convertissez les décibels avec\nprécision et simplicité.';

  @override
  String get splashLoading => 'Chargement...';

  @override
  String splashVersion(String version) {
    return 'Version $version';
  }

  @override
  String get sectionInputValue => 'VALEUR D\'ENTRÉE';

  @override
  String get sectionOutputValue => 'VALEUR DE SORTIE';

  @override
  String get sectionInputUnit => 'UNITÉ D\'ENTRÉE';

  @override
  String get sectionOutputUnit => 'UNITÉ DE SORTIE';

  @override
  String get sectionImpedance => 'IMPÉDANCE';

  @override
  String get sectionReference => 'VALEUR DE RÉFÉRENCE';

  @override
  String get inputHint => 'Saisissez une valeur';

  @override
  String get impedanceHint => 'ex. : 50';

  @override
  String get referenceHelper =>
      'La référence doit être exprimée dans l\'unité indiquée.';

  @override
  String get resultPlaceholder => '--';

  @override
  String get buttonFormula => 'FORMULE';

  @override
  String get dialogFormulaTitle => 'Formule';

  @override
  String get formulaEmpty => 'La formule apparaîtra ici après la conversion.';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionUnderstood => 'Compris';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionClear => 'Effacer';

  @override
  String get helpTitle => 'Aide';

  @override
  String get helpInstructions =>
      'Saisissez la valeur d\'entrée, puis choisissez l\'unité d\'entrée et l\'unité de sortie. Lorsque cela est demandé, saisissez également l\'impédance ou la valeur de référence. Le résultat s\'affiche dans le champ de sortie.';

  @override
  String get helpMadeBy => 'Développé par : KUNDIAMA';

  @override
  String helpContact(String phones) {
    return 'Téléphone : $phones';
  }

  @override
  String helpEmail(String email) {
    return 'E-mail : $email';
  }

  @override
  String get historyTitle => 'Historique récent';

  @override
  String get historyEmpty => 'Aucune conversion enregistrée pour le moment.';

  @override
  String get historyEmptyHint =>
      'Les conversions que vous effectuez apparaissent ici, enregistrées uniquement sur cet appareil.';

  @override
  String get historyClearTitle => 'Effacer l\'historique ?';

  @override
  String get historyClearMessage =>
      'Toutes les conversions enregistrées sur cet appareil seront supprimées. Cette action est irréversible.';

  @override
  String get historyCleared => 'Historique effacé.';

  @override
  String get historyJustNow => 'À l\'instant';

  @override
  String historyMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Il y a $minutes minutes',
      one: 'Il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String historyHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Il y a $hours heures',
      one: 'Il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String get historyLocalOnly => 'Enregistré uniquement sur cet appareil.';

  @override
  String get drawerUnitsTitle => 'UNITÉS DISPONIBLES';

  @override
  String get drawerUseAsInput => 'Utiliser comme entrée';

  @override
  String get drawerUseAsOutput => 'Utiliser comme sortie';

  @override
  String get drawerAboutTitle => 'À propos de dB Konversor';

  @override
  String get drawerAboutSubtitle =>
      'Conversions de puissance et de niveaux logarithmiques utilisées en télécommunications, en électronique et en audio.';

  @override
  String get drawerPrivacy => 'Politique de confidentialité';

  @override
  String get tooltipMenu => 'Ouvrir le menu des unités';

  @override
  String get tooltipHelp => 'Aide';

  @override
  String get tooltipSwap => 'Inverser les unités';

  @override
  String get tooltipHistory => 'Historique des conversions';

  @override
  String semanticsResult(String value, String unit) {
    return 'Résultat : $value $unit';
  }

  @override
  String get semanticsNoResult => 'Pas encore de résultat.';

  @override
  String get promptEnterData => 'Saisissez les données pour calculer.';

  @override
  String referenceLabelForUnit(String unit) {
    return 'Référence ($unit)';
  }

  @override
  String referencePowerLabel(String unit) {
    return 'Puissance de référence ($unit)';
  }

  @override
  String get referenceGenericLabel => 'Valeur de référence';

  @override
  String referenceHintForUnit(String unit) {
    return 'ex. : 0 $unit';
  }

  @override
  String get referenceHintGeneric => 'Saisissez la référence';

  @override
  String get typeRatioReference =>
      'Rapport logarithmique et niveau de référence';

  @override
  String get typePower => 'Conversion de puissance';

  @override
  String get typeVoltageLevel => 'Niveau de tension logarithmique';

  @override
  String get typePowerVoltageImpedance => 'Puissance et tension avec impédance';

  @override
  String get typeTechnical => 'Conversion technique';

  @override
  String get describeRatioReference =>
      'Pour calculer un rapport en décibels ou un niveau absolu, saisissez la référence correspondant aux unités sélectionnées.';

  @override
  String get describeImpedance =>
      'Cette conversion relie la tension et la puissance. Saisissez l\'impédance correcte du système pour obtenir un résultat valide.';

  @override
  String get unitDescWatt => 'Puissance linéaire en watts.';

  @override
  String get unitDescMilliwatt => 'Puissance linéaire en milliwatts.';

  @override
  String get unitDescDb =>
      'Rapport logarithmique entre deux grandeurs. Nécessite une valeur de référence pour donner un niveau absolu.';

  @override
  String get unitDescDbm => 'Puissance absolue référencée à 1 mW.';

  @override
  String get unitDescDbw =>
      'Puissance absolue référencée à 1 W. 0 dBW = 30 dBm.';

  @override
  String get unitDescDbu => 'Niveau de tension référencé à 0,775 V.';

  @override
  String get unitDescDbv => 'Niveau de tension référencé à 1 V.';

  @override
  String get errEmptyInput => 'Saisissez une valeur d\'entrée.';

  @override
  String get errInvalidNumber => 'Saisissez un nombre valide.';

  @override
  String get errNonFiniteInput => 'Saisissez un nombre fini.';

  @override
  String errNonPositiveForLog(String unit) {
    return 'La valeur en $unit doit être supérieure à zéro : le logarithme de zéro ou d\'un nombre négatif n\'est pas défini.';
  }

  @override
  String errNegativePower(String unit) {
    return 'La valeur en $unit ne peut pas être négative : la puissance dissipée n\'est pas une grandeur négative.';
  }

  @override
  String get errMissingImpedance =>
      'Saisissez l\'impédance pour cette conversion.';

  @override
  String get errNonPositiveImpedance =>
      'L\'impédance doit être supérieure à zéro.';

  @override
  String get errMissingReference => 'Saisissez une valeur de référence valide.';

  @override
  String get errNonPositiveReference =>
      'La puissance de référence doit être supérieure à zéro.';

  @override
  String errOutOfRange(String unit) {
    return 'La valeur en $unit est en dehors de la plage que l\'application peut représenter.';
  }

  @override
  String get errResultOutOfRange =>
      'Le résultat dépasse la plage numérique représentable.';

  @override
  String get errUnsupportedCombination =>
      'Cette combinaison d\'unités n\'est pas prise en charge.';

  @override
  String get errIncompatibleReference =>
      'Cette référence n\'est pas compatible avec les unités sélectionnées.';

  @override
  String get errComputationFailed =>
      'Le calcul n\'a pas pu être effectué avec les valeurs saisies.';

  @override
  String get privacyTitle => 'Politique de confidentialité';

  @override
  String privacyUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get privacyIntro =>
      'Cette politique explique comment dB Konversor, développé par KUNDIAMA Tecnologia e Inovação, traite les informations. Elle a été rédigée à partir d\'un audit du code source de l\'application.';

  @override
  String get privacyNoCollectionTitle => 'Données que nous ne collectons pas';

  @override
  String get privacyNoCollectionBody =>
      'L\'application ne crée aucun compte utilisateur et ne demande ni nom, ni adresse e-mail, ni numéro de téléphone, ni localisation. Elle ne contient aucune publicité et aucun outil d\'analyse d\'utilisation. Nous n\'envoyons vos données à aucun serveur, car l\'application ne communique avec aucun serveur.';

  @override
  String get privacyLocalDataTitle => 'Données enregistrées sur votre appareil';

  @override
  String get privacyLocalDataBody =>
      'Votre historique de conversions — la valeur saisie, les unités choisies, le résultat et la date — est enregistré dans le stockage privé de l\'application, sur votre propre appareil. Ces informations ne quittent jamais l\'appareil et ne sont pas accessibles à KUNDIAMA.';

  @override
  String get privacyRetentionTitle => 'Conservation et suppression';

  @override
  String get privacyRetentionBody =>
      'L\'historique est conservé jusqu\'à ce que vous le supprimiez. Vous pouvez le supprimer à tout moment depuis l\'écran d\'historique, à l\'aide de l\'option d\'effacement. La désinstallation de l\'application supprime également tout ce qu\'elle a enregistré.';

  @override
  String get privacyPermissionsTitle => 'Autorisations';

  @override
  String get privacyPermissionsBody =>
      'La version de production de l\'application ne demande aucune autorisation d\'accès à Internet ni aucune autre autorisation du système Android.';

  @override
  String get privacyThirdPartyTitle => 'Services tiers';

  @override
  String get privacyThirdPartyBody =>
      'L\'application n\'intègre aucun service tiers collectant des données. La distribution est assurée par Google Play, qui collecte ses propres données d\'installation selon les politiques de Google, en dehors du contrôle de KUNDIAMA.';

  @override
  String get privacyChildrenTitle => 'Utilisation par des mineurs';

  @override
  String get privacyChildrenBody =>
      'L\'application est un outil de calcul technique, adapté aux étudiants. Comme elle ne collecte aucune donnée personnelle, elle ne traite aucune information concernant des mineurs.';

  @override
  String get privacyRightsTitle => 'Vos droits';

  @override
  String get privacyRightsBody =>
      'Comme nous ne conservons aucune donnée personnelle sur nos systèmes, il n\'existe de notre côté aucune information vous concernant à consulter, corriger ou supprimer. Les données enregistrées par l\'application sont sous votre contrôle direct, sur votre appareil.';

  @override
  String get privacyContactTitle => 'Contact';

  @override
  String get privacyContactBody =>
      'Pour toute question concernant cette politique, utilisez les coordonnées indiquées dans l\'écran d\'aide de l\'application.';

  @override
  String get privacyChangesTitle => 'Modifications de cette politique';

  @override
  String get privacyChangesBody =>
      'Si le traitement des données change dans une version future, cette politique sera mise à jour et la date de mise à jour modifiée.';
}
