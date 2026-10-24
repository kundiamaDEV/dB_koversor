// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'dB Konversor';

  @override
  String get appTagline => 'Convert decibels accurately\nand simply.';

  @override
  String get splashLoading => 'Loading...';

  @override
  String splashVersion(String version) {
    return 'Version $version';
  }

  @override
  String get sectionInputValue => 'INPUT VALUE';

  @override
  String get sectionOutputValue => 'OUTPUT VALUE';

  @override
  String get sectionInputUnit => 'INPUT UNIT';

  @override
  String get sectionOutputUnit => 'OUTPUT UNIT';

  @override
  String get sectionImpedance => 'IMPEDANCE';

  @override
  String get sectionReference => 'REFERENCE VALUE';

  @override
  String get inputHint => 'Enter a value';

  @override
  String get impedanceHint => 'e.g. 50';

  @override
  String get referenceHelper => 'The reference must be in the unit shown.';

  @override
  String get resultPlaceholder => '--';

  @override
  String get buttonFormula => 'FORMULA';

  @override
  String get dialogFormulaTitle => 'Formula';

  @override
  String get formulaEmpty => 'The formula will appear here after a conversion.';

  @override
  String get actionClose => 'Close';

  @override
  String get actionUnderstood => 'Got it';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionClear => 'Clear';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpInstructions =>
      'Enter the input value, then choose the input and output units. When prompted, also enter the impedance or the reference value. The result appears in the output field.';

  @override
  String get helpMadeBy => 'Developed by: KUNDIAMA';

  @override
  String helpContact(String phones) {
    return 'Phone: $phones';
  }

  @override
  String helpEmail(String email) {
    return 'Email: $email';
  }

  @override
  String get historyTitle => 'Recent history';

  @override
  String get historyEmpty => 'No conversions recorded yet.';

  @override
  String get historyEmptyHint =>
      'The conversions you make appear here, stored on this device only.';

  @override
  String get historyClearTitle => 'Clear history?';

  @override
  String get historyClearMessage =>
      'All conversions stored on this device will be deleted. This cannot be undone.';

  @override
  String get historyCleared => 'History cleared.';

  @override
  String get historyJustNow => 'Just now';

  @override
  String historyMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String historyHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get historyLocalOnly => 'Stored on this device only.';

  @override
  String get drawerUnitsTitle => 'AVAILABLE UNITS';

  @override
  String get drawerUseAsInput => 'Use as input';

  @override
  String get drawerUseAsOutput => 'Use as output';

  @override
  String get drawerAboutTitle => 'About dB Konversor';

  @override
  String get drawerAboutSubtitle =>
      'Power and logarithmic level conversions used in telecommunications, electronics and audio.';

  @override
  String get drawerPrivacy => 'Privacy Policy';

  @override
  String get tooltipMenu => 'Open the units menu';

  @override
  String get tooltipHelp => 'Help';

  @override
  String get tooltipSwap => 'Swap the units';

  @override
  String get tooltipHistory => 'Conversion history';

  @override
  String semanticsResult(String value, String unit) {
    return 'Result: $value $unit';
  }

  @override
  String get semanticsNoResult => 'No result yet.';

  @override
  String get promptEnterData => 'Enter the values to calculate.';

  @override
  String referenceLabelForUnit(String unit) {
    return 'Reference ($unit)';
  }

  @override
  String referencePowerLabel(String unit) {
    return 'Reference power ($unit)';
  }

  @override
  String get referenceGenericLabel => 'Reference value';

  @override
  String referenceHintForUnit(String unit) {
    return 'e.g. 0 $unit';
  }

  @override
  String get referenceHintGeneric => 'Enter the reference';

  @override
  String get typeRatioReference => 'Logarithmic ratio and reference level';

  @override
  String get typePower => 'Power conversion';

  @override
  String get typeVoltageLevel => 'Logarithmic voltage level';

  @override
  String get typePowerVoltageImpedance => 'Power and voltage with impedance';

  @override
  String get typeTechnical => 'Technical conversion';

  @override
  String get describeRatioReference =>
      'To compute a ratio in decibels or an absolute level, enter the reference matching the units you selected.';

  @override
  String get describeImpedance =>
      'This conversion relates voltage and power. Enter the correct system impedance to get a valid result.';

  @override
  String get unitDescWatt => 'Linear power in watts.';

  @override
  String get unitDescMilliwatt => 'Linear power in milliwatts.';

  @override
  String get unitDescDb =>
      'Logarithmic ratio between two quantities. Needs a reference value to give an absolute level.';

  @override
  String get unitDescDbm => 'Absolute power referenced to 1 mW.';

  @override
  String get unitDescDbw => 'Absolute power referenced to 1 W. 0 dBW = 30 dBm.';

  @override
  String get unitDescDbu => 'Voltage level referenced to 0.775 V.';

  @override
  String get unitDescDbv => 'Voltage level referenced to 1 V.';

  @override
  String get errEmptyInput => 'Enter an input value.';

  @override
  String get errInvalidNumber => 'Enter a valid number.';

  @override
  String get errNonFiniteInput => 'Enter a finite number.';

  @override
  String errNonPositiveForLog(String unit) {
    return 'The value in $unit must be greater than zero: the logarithm of zero or of a negative number is undefined.';
  }

  @override
  String errNegativePower(String unit) {
    return 'The value in $unit cannot be negative: dissipated power is not a negative quantity.';
  }

  @override
  String get errMissingImpedance => 'Enter the impedance for this conversion.';

  @override
  String get errNonPositiveImpedance =>
      'The impedance must be greater than zero.';

  @override
  String get errMissingReference => 'Enter a valid reference value.';

  @override
  String get errNonPositiveReference =>
      'The reference power must be greater than zero.';

  @override
  String errOutOfRange(String unit) {
    return 'The value in $unit is outside the range the app can represent.';
  }

  @override
  String get errResultOutOfRange =>
      'The result exceeds the representable numeric range.';

  @override
  String get errUnsupportedCombination =>
      'This combination of units is not supported.';

  @override
  String get errIncompatibleReference =>
      'This reference is not compatible with the units you selected.';

  @override
  String get errComputationFailed =>
      'The calculation could not be completed with the values entered.';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String privacyUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyIntro =>
      'This policy explains how dB Konversor, developed by KUNDIAMA Tecnologia e Inovação, handles information. It was written from an audit of the application\'s source code.';

  @override
  String get privacyNoCollectionTitle => 'Data we do not collect';

  @override
  String get privacyNoCollectionBody =>
      'The app creates no user account and asks for no name, email address, phone number or location. It contains no advertising and no usage analytics. We do not send your data to any server, because the app does not communicate with any server.';

  @override
  String get privacyLocalDataTitle => 'Data stored on your device';

  @override
  String get privacyLocalDataBody =>
      'Your conversion history — the value you entered, the units you chose, the result and the date — is saved in the app\'s private storage on your own device. This information never leaves the device and is not accessible to KUNDIAMA.';

  @override
  String get privacyRetentionTitle => 'Retention and deletion';

  @override
  String get privacyRetentionBody =>
      'The history is kept until you delete it. You can delete it at any time from the history screen, using the clear option. Uninstalling the app also removes everything it has stored.';

  @override
  String get privacyPermissionsTitle => 'Permissions';

  @override
  String get privacyPermissionsBody =>
      'The release version of the app requests no internet access permission and no other Android system permission.';

  @override
  String get privacyThirdPartyTitle => 'Third-party services';

  @override
  String get privacyThirdPartyBody =>
      'The app integrates no third-party services that collect data. Distribution is through Google Play, which collects its own installation data under Google\'s policies, outside KUNDIAMA\'s control.';

  @override
  String get privacyChildrenTitle => 'Use by minors';

  @override
  String get privacyChildrenBody =>
      'The app is a technical calculation tool, suitable for students. Because it collects no personal data, it processes no information about minors.';

  @override
  String get privacyRightsTitle => 'Your rights';

  @override
  String get privacyRightsBody =>
      'Because we store no personal data on our systems, there is no information of yours for us to show, correct or delete on our side. The data the app stores is under your direct control, on your device.';

  @override
  String get privacyContactTitle => 'Contact';

  @override
  String get privacyContactBody =>
      'For any question about this policy, use the contact details shown on the app\'s Help screen.';

  @override
  String get privacyChangesTitle => 'Changes to this policy';

  @override
  String get privacyChangesBody =>
      'If data handling changes in a future version, this policy will be updated and the update date changed.';
}
