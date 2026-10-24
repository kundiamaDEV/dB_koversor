// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'dB Konversor';

  @override
  String get appTagline => '精确、简便地\n换算分贝。';

  @override
  String get splashLoading => '加载中...';

  @override
  String splashVersion(String version) {
    return '版本 $version';
  }

  @override
  String get sectionInputValue => '输入值';

  @override
  String get sectionOutputValue => '输出值';

  @override
  String get sectionInputUnit => '输入单位';

  @override
  String get sectionOutputUnit => '输出单位';

  @override
  String get sectionImpedance => '阻抗';

  @override
  String get sectionReference => '参考值';

  @override
  String get inputHint => '请输入数值';

  @override
  String get impedanceHint => '例如：50';

  @override
  String get referenceHelper => '参考值必须使用所示的单位。';

  @override
  String get resultPlaceholder => '--';

  @override
  String get buttonFormula => '公式';

  @override
  String get dialogFormulaTitle => '公式';

  @override
  String get formulaEmpty => '换算完成后将在此显示公式。';

  @override
  String get actionClose => '关闭';

  @override
  String get actionUnderstood => '知道了';

  @override
  String get actionCancel => '取消';

  @override
  String get actionClear => '清除';

  @override
  String get helpTitle => '帮助';

  @override
  String get helpInstructions =>
      '输入数值，然后选择输入单位和输出单位。系统提示时，请一并输入阻抗或参考值。结果会显示在输出栏中。';

  @override
  String get helpMadeBy => '开发者：KUNDIAMA';

  @override
  String helpContact(String phones) {
    return '电话：$phones';
  }

  @override
  String helpEmail(String email) {
    return '电子邮箱：$email';
  }

  @override
  String get historyTitle => '最近记录';

  @override
  String get historyEmpty => '暂无换算记录。';

  @override
  String get historyEmptyHint => '您所做的换算将显示在此处，仅保存在本设备上。';

  @override
  String get historyClearTitle => '要清除记录吗？';

  @override
  String get historyClearMessage => '本设备上保存的所有换算记录都将被删除。此操作无法撤销。';

  @override
  String get historyCleared => '记录已清除。';

  @override
  String get historyJustNow => '刚刚';

  @override
  String historyMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟前',
    );
    return '$_temp0';
  }

  @override
  String historyHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours 小时前',
    );
    return '$_temp0';
  }

  @override
  String get historyLocalOnly => '仅保存在本设备上。';

  @override
  String get drawerUnitsTitle => '可用单位';

  @override
  String get drawerUseAsInput => '用作输入单位';

  @override
  String get drawerUseAsOutput => '用作输出单位';

  @override
  String get drawerAboutTitle => '关于 dB Konversor';

  @override
  String get drawerAboutSubtitle => '用于通信、电子与音频领域的功率与对数电平换算。';

  @override
  String get drawerPrivacy => '隐私政策';

  @override
  String get tooltipMenu => '打开单位菜单';

  @override
  String get tooltipHelp => '帮助';

  @override
  String get tooltipSwap => '交换单位';

  @override
  String get tooltipHistory => '换算记录';

  @override
  String semanticsResult(String value, String unit) {
    return '结果：$value $unit';
  }

  @override
  String get semanticsNoResult => '暂无结果。';

  @override
  String get promptEnterData => '请输入数据以进行计算。';

  @override
  String referenceLabelForUnit(String unit) {
    return '参考值（$unit）';
  }

  @override
  String referencePowerLabel(String unit) {
    return '参考功率（$unit）';
  }

  @override
  String get referenceGenericLabel => '参考值';

  @override
  String referenceHintForUnit(String unit) {
    return '例如：0 $unit';
  }

  @override
  String get referenceHintGeneric => '请输入参考值';

  @override
  String get typeRatioReference => '对数比值与参考电平';

  @override
  String get typePower => '功率换算';

  @override
  String get typeVoltageLevel => '对数电压电平';

  @override
  String get typePowerVoltageImpedance => '功率与电压（含阻抗）';

  @override
  String get typeTechnical => '技术换算';

  @override
  String get describeRatioReference => '若要计算以分贝表示的比值或绝对电平，请输入与所选单位相符的参考值。';

  @override
  String get describeImpedance => '此换算涉及电压与功率的关系。请输入正确的系统阻抗，才能得到有效结果。';

  @override
  String get unitDescWatt => '以瓦为单位的线性功率。';

  @override
  String get unitDescMilliwatt => '以毫瓦为单位的线性功率。';

  @override
  String get unitDescDb => '两个量之间的对数比值。需要参考值才能得出绝对电平。';

  @override
  String get unitDescDbm => '以 1 mW 为基准的绝对功率。';

  @override
  String get unitDescDbw => '以 1 W 为基准的绝对功率。0 dBW = 30 dBm。';

  @override
  String get unitDescDbu => '以 0.775 V 为基准的电压电平。';

  @override
  String get unitDescDbv => '以 1 V 为基准的电压电平。';

  @override
  String get errEmptyInput => '请输入数值。';

  @override
  String get errInvalidNumber => '请输入有效的数字。';

  @override
  String get errNonFiniteInput => '请输入有限的数字。';

  @override
  String errNonPositiveForLog(String unit) {
    return '以 $unit 表示的数值必须大于零：零或负数的对数没有定义。';
  }

  @override
  String errNegativePower(String unit) {
    return '以 $unit 表示的数值不能为负：耗散功率不是负值。';
  }

  @override
  String get errMissingImpedance => '此换算需要输入阻抗。';

  @override
  String get errNonPositiveImpedance => '阻抗必须大于零。';

  @override
  String get errMissingReference => '请输入有效的参考值。';

  @override
  String get errNonPositiveReference => '参考功率必须大于零。';

  @override
  String errOutOfRange(String unit) {
    return '以 $unit 表示的数值超出了本应用可表示的范围。';
  }

  @override
  String get errResultOutOfRange => '结果超出了可表示的数值范围。';

  @override
  String get errUnsupportedCombination => '不支持此单位组合。';

  @override
  String get errIncompatibleReference => '此参考值与所选单位不匹配。';

  @override
  String get errComputationFailed => '无法使用所输入的数值完成计算。';

  @override
  String get privacyTitle => '隐私政策';

  @override
  String privacyUpdated(String date) {
    return '最后更新：$date';
  }

  @override
  String get privacyIntro =>
      '本政策说明由 KUNDIAMA Tecnologia e Inovação 开发的 dB Konversor 如何处理信息。本政策是在对应用源代码进行审计的基础上撰写的。';

  @override
  String get privacyNoCollectionTitle => '我们不收集的数据';

  @override
  String get privacyNoCollectionBody =>
      '本应用不创建用户账户，不索取姓名、电子邮箱、电话号码或位置信息。应用内没有广告，也没有使用情况分析工具。我们不会将您的数据发送到任何服务器，因为本应用不与任何服务器通信。';

  @override
  String get privacyLocalDataTitle => '保存在您设备上的数据';

  @override
  String get privacyLocalDataBody =>
      '您的换算记录——输入的数值、所选单位、结果和日期——保存在您设备上本应用的私有存储空间内。这些信息绝不会离开您的设备，KUNDIAMA 也无法访问。';

  @override
  String get privacyRetentionTitle => '保存与删除';

  @override
  String get privacyRetentionBody =>
      '记录会一直保存，直到您将其删除。您可以随时在记录页面使用清除功能删除。卸载应用也会一并删除应用保存的全部数据。';

  @override
  String get privacyPermissionsTitle => '权限';

  @override
  String get privacyPermissionsBody =>
      '本应用的正式发布版本不申请网络访问权限，也不申请任何其他 Android 系统权限。';

  @override
  String get privacyThirdPartyTitle => '第三方服务';

  @override
  String get privacyThirdPartyBody =>
      '本应用未集成任何收集数据的第三方服务。应用通过 Google Play 分发，Google Play 会按照 Google 的政策收集其自身的安装数据，这不在 KUNDIAMA 的控制范围内。';

  @override
  String get privacyChildrenTitle => '未成年人使用';

  @override
  String get privacyChildrenBody =>
      '本应用是一款技术计算工具，适合学生使用。由于不收集个人数据，因此也不会处理未成年人的信息。';

  @override
  String get privacyRightsTitle => '您的权利';

  @override
  String get privacyRightsBody =>
      '由于我们的系统不存储任何个人数据，我们这边不存在可供查阅、更正或删除的您的信息。应用所保存的数据完全由您在自己的设备上直接掌控。';

  @override
  String get privacyContactTitle => '联系方式';

  @override
  String get privacyContactBody => '如对本政策有任何疑问，请使用应用“帮助”页面所列的联系方式。';

  @override
  String get privacyChangesTitle => '本政策的变更';

  @override
  String get privacyChangesBody => '如果未来版本中的数据处理方式发生变化，我们将更新本政策并修改更新日期。';
}
