import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/localization/conversion_messages.dart';
import '../../core/models/conversion_result.dart';
import '../../core/power_unit.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/math_utils.dart';
import '../history/conversion_history_entry.dart';
import '../history/conversion_history_store.dart';
import '../privacy/privacy_policy_screen.dart';
import 'converter_controller.dart';

/// Ecrã principal do conversor.
///
/// ALTERADO NA AUDITORIA DE 2026-10-17. Alterações profundas, todas elas
/// preservando a identidade visual (fundo azul-escuro, destaques em ciano e
/// azul eléctrico, cartões com borda azul, animações existentes):
///
/// 1. **Internacionalização (defeito F2).** Todos os textos visíveis passaram
///    para os recursos de localização. Não há nenhuma frase escrita neste
///    ficheiro; `AppLocalizations` é consultado em `build`. Os símbolos
///    técnicos (`dB`, `dBm`, `Ω`) continuam a ser notação universal e não são
///    traduzidos.
///
/// 2. **Histórico real (defeito F1).** O painel de histórico mostrava a
///    conversão corrente e duas entradas fabricadas no código. Passa a ler o
///    `ConversionHistoryStore`, que grava as conversões efectivamente
///    realizadas e as conserva entre reinícios, com opção de limpar.
///
/// 3. **Formatação unificada (defeito M6).** O método local `_formatValue` foi
///    removido em favor de `MathUtils.formatResult`, que é a única
///    implementação e tem testes.
///
/// 4. **Dupla conversão (defeito F6).** As chamadas `controller.convert()` que
///    seguiam imediatamente `setFromUnit`/`setToUnit`/`invertUnits` foram
///    retiradas: esses métodos já convertem.
///
/// 5. **Política de Privacidade (bloqueador B4)** acessível pelo menu lateral.
///
/// 6. **Acessibilidade.** Os botões só com ícone passaram a ter `tooltip` e o
///    resultado tem rótulo semântico para leitores de ecrã.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with TickerProviderStateMixin {
  late final ConverterController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _swapGlowController;
  late final AnimationController _resultPulseController;
  late final AnimationController _unitsSwitchController;

  PowerUnit? _previousFromUnit;
  PowerUnit? _previousToUnit;
  String _lastOutputText = '';

  @override
  void initState() {
    super.initState();

    controller = ConverterController()..convert();

    // Lê o histórico gravado no dispositivo. Não é aguardado: o conversor já
    // está utilizável e o painel actualiza-se quando a leitura terminar.
    controller.history.load();

    _previousFromUnit = controller.fromUnit;
    _previousToUnit = controller.toUnit;

    _swapGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _resultPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _unitsSwitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _swapGlowController.dispose();
    _resultPulseController.dispose();
    _unitsSwitchController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final ConversionResult? currentResult = controller.result;

        final bool hasValue =
            currentResult != null &&
            currentResult.isSuccess &&
            currentResult.value != null;

        final String outputText = hasValue
            ? MathUtils.formatResult(currentResult.value!)
            : '';

        // Mensagem de erro já traduzida a partir do código devolvido pela
        // camada de cálculo (ver core/localization/conversion_messages.dart).
        final String? errorText =
            currentResult != null && !currentResult.isSuccess
            ? l10n.describeFailure(currentResult)
            : null;

        _handleAnimatedState(outputText);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFF020817),
          drawer: _UnitsDrawer(
            units: controller.availableUnits,
            onSelectFrom: (unit) {
              controller.setFromUnit(unit);
              Navigator.of(context).pop();
            },
            onSelectTo: (unit) {
              controller.setToUnit(unit);
              Navigator.of(context).pop();
            },
            onOpenPrivacy: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            tooltip: l10n.tooltipHistory,
            backgroundColor: const Color(0xFF081C3F),
            foregroundColor: const Color(0xFF22C7FF),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFF123E83)),
            ),
            onPressed: () => _showHistorySheet(context),
            child: const Icon(Icons.history_rounded),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBar(
                        menuTooltip: l10n.tooltipMenu,
                        helpTooltip: l10n.tooltipHelp,
                        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                        onHelpTap: () => _showHelpDialog(context),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF04142D), Color(0xFF071C3C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: const Color(0xFF123E83)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x220B58F4),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(
                              icon: Icons.arrow_circle_up_outlined,
                              text: l10n.sectionInputValue,
                            ),
                            const SizedBox(height: 10),
                            _InputBox(
                              child: TextField(
                                controller: controller.valueController,
                                onChanged: (_) => controller.convert(),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: true,
                                    ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.inputHint,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF6F86B5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            FadeTransition(
                              opacity: Tween<double>(
                                begin: 0.88,
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                  parent: _unitsSwitchController,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.02, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _unitsSwitchController,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _UnitSelectionCard(
                                        title: l10n.sectionInputUnit,
                                        value: controller.fromUnit,
                                        items: controller.availableUnits,
                                        onChanged: (unit) {
                                          if (unit != null) {
                                            // Defeito F6: setFromUnit já
                                            // converte; não voltar a chamar.
                                            controller.setFromUnit(unit);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _SwapButton(
                                      controller: _swapGlowController,
                                      tooltip: l10n.tooltipSwap,
                                      onTap: controller.invertUnits,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _UnitSelectionCard(
                                        title: l10n.sectionOutputUnit,
                                        value: controller.toUnit,
                                        items: controller.availableUnits,
                                        onChanged: (unit) {
                                          if (unit != null) {
                                            controller.setToUnit(unit);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.shouldShowImpedance) ...[
                              const SizedBox(height: 18),
                              _SectionTitle(
                                icon: Icons.tune_rounded,
                                text: l10n.sectionImpedance,
                              ),
                              const SizedBox(height: 10),
                              _InputBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            controller.impedanceController,
                                        onChanged: (_) => controller.convert(),
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                              signed: false,
                                            ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: l10n.impedanceHint,
                                          hintStyle: const TextStyle(
                                            color: Color(0xFF6F86B5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Ohm: símbolo do SI, igual em todos os
                                    // idiomas.
                                    const Text(
                                      'Ω',
                                      style: TextStyle(
                                        color: Color(0xFF22C7FF),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (controller.shouldShowReference) ...[
                              const SizedBox(height: 18),
                              _SectionTitle(
                                icon: Icons.tune_rounded,
                                text: l10n.sectionReference,
                              ),
                              const SizedBox(height: 10),
                              _InputBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _referenceLabel(l10n),
                                      style: const TextStyle(
                                        color: Color(0xFF22C7FF),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controller.referenceController,
                                      onChanged: (_) => controller.convert(),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                            signed: true,
                                          ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _referenceHint(l10n),
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF6F86B5),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.referenceHelper,
                                style: const TextStyle(
                                  color: Color(0xFFB6C6E3),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            _SectionTitle(
                              icon: Icons.arrow_circle_down_outlined,
                              text: l10n.sectionOutputValue,
                            ),
                            const SizedBox(height: 10),
                            _InputBox(
                              child: Semantics(
                                label: hasValue
                                    ? l10n.semanticsResult(
                                        outputText,
                                        currentResult.outputUnitLabel,
                                      )
                                    : l10n.semanticsNoResult,
                                child: AnimatedBuilder(
                                  animation: _resultPulseController,
                                  builder: (context, child) {
                                    final t = Curves.easeOut.transform(
                                      _resultPulseController.value,
                                    );
                                    final scale = 1 + (0.045 * (1 - t));
                                    final glow = 14 * (1 - t);

                                    return Transform.scale(
                                      scale: scale,
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: outputText.isEmpty
                                              ? const []
                                              : [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0x3322C7FF,
                                                    ).withValues(alpha: 0.20),
                                                    blurRadius: glow,
                                                    spreadRadius: 0.5,
                                                  ),
                                                ],
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 260,
                                          ),
                                          switchInCurve: Curves.easeOutCubic,
                                          switchOutCurve: Curves.easeInCubic,
                                          transitionBuilder: (child, animation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0, 0.10),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            outputText.isEmpty
                                                ? l10n.resultPlaceholder
                                                : outputText,
                                            key: ValueKey(outputText),
                                            style: TextStyle(
                                              color: outputText.isEmpty
                                                  ? const Color(0xFF6F86B5)
                                                  : const Color(0xFF22C7FF),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (errorText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 2, top: 4),
                                child: Text(
                                  errorText,
                                  style: const TextStyle(
                                    color: Color(0xFFFF6B7A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 18),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _showFormulaDialog(
                                      context,
                                      title: l10n.dialogFormulaTitle,
                                      content:
                                          (currentResult != null &&
                                              currentResult.formula.isNotEmpty &&
                                              currentResult.formula != '-')
                                          ? currentResult.formula
                                          : l10n.formulaEmpty,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF020B1D),
                                    foregroundColor: const Color(0xFF22C7FF),
                                    side: const BorderSide(
                                      color: Color(0xFF123E83),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.buttonFormula,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Rótulo do campo de referência, já traduzido.
  String _referenceLabel(AppLocalizations l10n) {
    final (kind, unit) = controller.referenceUnit;

    switch (kind) {
      case ReferenceLabelKind.level:
        return l10n.referenceLabelForUnit(unit);
      case ReferenceLabelKind.power:
        return l10n.referencePowerLabel(unit);
      case ReferenceLabelKind.generic:
        return l10n.referenceGenericLabel;
    }
  }

  String _referenceHint(AppLocalizations l10n) {
    final (kind, unit) = controller.referenceUnit;

    if (kind == ReferenceLabelKind.generic) {
      return l10n.referenceHintGeneric;
    }
    return l10n.referenceHintForUnit(unit);
  }

  void _handleAnimatedState(String outputText) {
    final bool unitsChanged =
        _previousFromUnit != controller.fromUnit ||
        _previousToUnit != controller.toUnit;

    if (unitsChanged) {
      _previousFromUnit = controller.fromUnit;
      _previousToUnit = controller.toUnit;
      _unitsSwitchController.forward(from: 0);
    }

    if (outputText != _lastOutputText && outputText.isNotEmpty) {
      _lastOutputText = outputText;
      _resultPulseController.forward(from: 0);
    } else if (outputText.isEmpty && _lastOutputText.isNotEmpty) {
      _lastOutputText = '';
    }
  }

  void _showFormulaDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF071326),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF123E83)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF020B1D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF173A74)),
                  ),
                  // A fórmula pode ter vários passos encadeados; permite
                  // deslocamento horizontal em vez de ficar cortada.
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      content,
                      style: const TextStyle(
                        color: Color(0xFFB6C6E3),
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      l10n.actionClose,
                      style: const TextStyle(
                        color: Color(0xFF22C7FF),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF071326),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF123E83)),
          ),
          title: Text(
            l10n.helpTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              '${l10n.helpInstructions}\n\n'
              '${l10n.helpMadeBy}\n'
              '${l10n.helpContact(_contactPhones)}\n'
              '${l10n.helpEmail(_contactEmail)}',
              style: const TextStyle(color: Color(0xFFB6C6E3), height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.actionUnderstood,
                style: const TextStyle(
                  color: Color(0xFF22C7FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Contactos apresentados na Ajuda.
  ///
  /// Mantidos como constantes num só lugar (antes estavam escritos dentro do
  /// texto do diálogo) para que a sua alteração não obrigue a mexer no texto
  /// traduzido: são valores, não frases, e por isso não estão nos ficheiros
  /// ARB. Confirmados pelo proprietário na auditoria de 2026-10-17.
  static const String _contactPhones = '945560400 / 952142799';
  static const String _contactEmail = 'diassilua.simao@gmail.com';

  /// Painel do histórico real de conversões (defeito F1).
  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      // O histórico pode ter até 50 entradas: a folha tem de poder crescer e
      // deslocar-se, em vez de ficar limitada à altura mínima.
      isScrollControlled: true,
      builder: (sheetContext) {
        return _HistorySheet(
          store: controller.history,
          onClear: () => _confirmClearHistory(sheetContext),
        );
      },
    );
  }

  Future<void> _confirmClearHistory(BuildContext sheetContext) async {
    final l10n = AppLocalizations.of(sheetContext);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: sheetContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF071326),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF123E83)),
          ),
          title: Text(
            l10n.historyClearTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            l10n.historyClearMessage,
            style: const TextStyle(color: Color(0xFFB6C6E3), height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                l10n.actionCancel,
                style: const TextStyle(color: Color(0xFFB6C6E3)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.actionClear,
                style: const TextStyle(
                  color: Color(0xFFFF6B7A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await controller.history.clear();

    if (!mounted) return;

    // Fecha a folha do histórico, que agora está vazia, e confirma a acção.
    if (sheetContext.mounted) {
      Navigator.of(sheetContext).pop();
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.historyCleared),
        backgroundColor: const Color(0xFF081C3F),
      ),
    );
  }
}

/// Folha do histórico. Observa o armazenamento para se actualizar sozinha
/// quando uma conversão nova é registada ou quando o histórico é limpo.
class _HistorySheet extends StatelessWidget {
  final ConversionHistoryStore store;
  final VoidCallback onClear;

  const _HistorySheet({required this.store, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final entries = store.entries;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF071326),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Color(0x330B58F4),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF173A74),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.history_rounded, color: Color(0xFF22C7FF)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.historyTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (entries.isNotEmpty)
                    TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Color(0xFFFF6B7A),
                      ),
                      label: Text(
                        l10n.actionClear,
                        style: const TextStyle(
                          color: Color(0xFFFF6B7A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (entries.isEmpty)
                _HistoryEmptyState(l10n: l10n)
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return _HistoryTile(entry: entries[index], l10n: l10n);
                    },
                  ),
                ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.phone_android_rounded,
                    size: 14,
                    color: Color(0xFF6F86B5),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.historyLocalOnly,
                      style: const TextStyle(
                        color: Color(0xFF6F86B5),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _HistoryEmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
      decoration: BoxDecoration(
        color: const Color(0xFF020B1D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF173A74)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            color: Color(0xFF6F86B5),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.historyEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.historyEmptyHint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB6C6E3),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ConversionHistoryEntry entry;
  final AppLocalizations l10n;

  const _HistoryTile({required this.entry, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Os valores são formatados no momento da apresentação, a partir dos
    // números guardados: o histórico mantém a precisão completa e acompanha
    // qualquer mudança nas regras de formatação.
    final text =
        '${MathUtils.formatResult(entry.inputValue)} ${entry.inputUnitLabel}'
        '  →  '
        '${MathUtils.formatResult(entry.outputValue)} ${entry.outputUnitLabel}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF020B1D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF173A74)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _relativeTime(entry.timestampUtc),
            style: const TextStyle(color: Color(0xFFB6C6E3), fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Momento da conversão em linguagem relativa, traduzida.
  ///
  /// Usa tempo relativo até 24 horas e uma data absoluta a partir daí. Assim
  /// evita-se depender da inicialização dos dados de local do `intl` para
  /// formatar datas, e o resultado é mais útil para um histórico recente.
  /// Os cálculos são feitos em UTC, o que torna o resultado imune a mudanças
  /// de fuso horário.
  String _relativeTime(DateTime timestampUtc) {
    final elapsed = DateTime.now().toUtc().difference(timestampUtc);

    if (elapsed.inMinutes < 1) return l10n.historyJustNow;
    if (elapsed.inMinutes < 60) return l10n.historyMinutesAgo(elapsed.inMinutes);
    if (elapsed.inHours < 24) return l10n.historyHoursAgo(elapsed.inHours);

    final local = timestampUtc.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/${local.year} • $hour:$minute';
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onHelpTap;
  final String menuTooltip;
  final String helpTooltip;

  const _TopBar({
    required this.onMenuTap,
    required this.onHelpTap,
    required this.menuTooltip,
    required this.helpTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF04142D), Color(0xFF071C3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF123E83)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220B58F4),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            tooltip: menuTooltip,
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          // Nome do produto: marca, igual em todos os idiomas.
          const Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'dB ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: 'Konversor',
                      style: TextStyle(
                        color: Color(0xFF22C7FF),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onHelpTap,
            tooltip: helpTooltip,
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SectionTitle({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF0B58F4)),
        const SizedBox(width: 8),
        // Expanded: os títulos traduzidos podem ser mais longos do que em
        // português (por exemplo em francês) e não devem transbordar.
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF22C7FF),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  final Widget child;

  const _InputBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF020B1D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF173A74)),
      ),
      child: child,
    );
  }
}

class _UnitSelectionCard extends StatelessWidget {
  final String title;
  final PowerUnit value;
  final List<PowerUnit> items;
  final ValueChanged<PowerUnit?> onChanged;

  const _UnitSelectionCard({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF020B1D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF173A74)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120B58F4),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            // Os rótulos traduzidos variam de comprimento; duas linhas evitam
            // o corte sem alterar a altura do cartão na maioria dos idiomas.
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF22C7FF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton<PowerUnit>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
              dropdownColor: const Color(0xFF071326),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              items: items
                  .map(
                    (unit) => DropdownMenuItem<PowerUnit>(
                      value: unit,
                      // Símbolo da unidade: notação técnica, não traduzida.
                      child: Text(unit.label),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onTap;
  final String tooltip;

  const _SwapButton({
    required this.controller,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final glowValue = 0.5 + (0.5 * math.sin(controller.value * 2 * math.pi));
        final blur = 10 + (18 * glowValue);
        final spread = 0.5 + (1.2 * glowValue);

        return Tooltip(
          message: tooltip,
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: onTap,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF081C3F),
                border: Border.all(color: const Color(0xFF0B58F4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0x330B58F4,
                    ).withValues(alpha: 0.18 + (0.20 * glowValue)),
                    blurRadius: blur,
                    spreadRadius: spread,
                  ),
                  BoxShadow(
                    color: const Color(
                      0x2222C7FF,
                    ).withValues(alpha: 0.10 + (0.12 * glowValue)),
                    blurRadius: blur * 0.7,
                    spreadRadius: spread * 0.4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Color(0xFF22C7FF),
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UnitsDrawer extends StatelessWidget {
  final List<PowerUnit> units;
  final ValueChanged<PowerUnit> onSelectFrom;
  final ValueChanged<PowerUnit> onSelectTo;
  final VoidCallback onOpenPrivacy;

  const _UnitsDrawer({
    required this.units,
    required this.onSelectFrom,
    required this.onSelectTo,
    required this.onOpenPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: const Color(0xFF06142A),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.drawerUnitsTitle,
                style: const TextStyle(
                  color: Color(0xFF22C7FF),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: units.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final unit = units[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF081C3F),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF123E83)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0B58F4),
                          child: Text(
                            unit.label.length <= 2
                                ? unit.label
                                : unit.label.substring(0, 2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          unit.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Descrição traduzida (antes vinha em português do
                        // próprio enum).
                        subtitle: Text(
                          l10n.describeUnit(unit),
                          style: const TextStyle(
                            color: Color(0xFFB6C6E3),
                            fontSize: 12,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          color: const Color(0xFF071326),
                          iconColor: const Color(0xFF22C7FF),
                          onSelected: (value) {
                            if (value == 'from') {
                              onSelectFrom(unit);
                            } else {
                              onSelectTo(unit);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'from',
                              child: Text(
                                l10n.drawerUseAsInput,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'to',
                              child: Text(
                                l10n.drawerUseAsOutput,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(color: Color(0xFF173A74)),
              // Acesso à Política de Privacidade (bloqueador B4).
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: Color(0xFF22C7FF),
                ),
                title: Text(
                  l10n.drawerPrivacy,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF6F86B5),
                ),
                onTap: onOpenPrivacy,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  l10n.drawerAboutTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  l10n.drawerAboutSubtitle,
                  style: const TextStyle(color: Color(0xFFB6C6E3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
