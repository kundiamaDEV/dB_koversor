import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Página da Política de Privacidade dentro da aplicação.
///
/// INTRODUZIDA NA AUDITORIA DE 2026-10-17 (bloqueador B4).
///
/// Porque foi necessária
/// ---------------------
/// A auditoria inicial não encontrou qualquer Política de Privacidade no
/// código nem no repositório, ao contrário do que se presumia. A Google Play
/// exige uma política acessível, e ter a mesma informação dentro da aplicação
/// é a forma de a tornar consultável sem ligação à Internet — coerente com uma
/// aplicação que não pede a permissão de rede.
///
/// Coerência com o comportamento real
/// ----------------------------------
/// O texto apresentado aqui é o mesmo que está nos ficheiros ARB e deriva da
/// auditoria técnica em `docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`. Se
/// o tratamento de dados mudar (por exemplo, se alguma versão futura passar a
/// comunicar com um servidor), **este texto tem de ser actualizado ao mesmo
/// tempo**, bem como a declaração na Play Console.
///
/// A identidade visual segue a do conversor: fundo azul-escuro, destaques em
/// ciano, cartões com borda azul.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  /// Data da última revisão do texto da política.
  ///
  /// Mantida aqui, junto do conteúdo, para que quem altera o texto veja que
  /// tem de a actualizar. Formatada segundo o idioma activo.
  static final DateTime lastUpdated = DateTime.utc(2026, 10, 17);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final sections = <(String, String)>[
      (l10n.privacyNoCollectionTitle, l10n.privacyNoCollectionBody),
      (l10n.privacyLocalDataTitle, l10n.privacyLocalDataBody),
      (l10n.privacyRetentionTitle, l10n.privacyRetentionBody),
      (l10n.privacyPermissionsTitle, l10n.privacyPermissionsBody),
      (l10n.privacyThirdPartyTitle, l10n.privacyThirdPartyBody),
      (l10n.privacyChildrenTitle, l10n.privacyChildrenBody),
      (l10n.privacyRightsTitle, l10n.privacyRightsBody),
      (l10n.privacyContactTitle, l10n.privacyContactBody),
      (l10n.privacyChangesTitle, l10n.privacyChangesBody),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF04142D),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.privacyTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          // O mesmo limite de largura do conversor: em tablets o texto não se
          // estica numa linha demasiado longa para ser confortável de ler.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                Text(
                  l10n.privacyUpdated(_formatDate(locale.languageCode)),
                  style: const TextStyle(
                    color: Color(0xFF22C7FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                _Paragraph(l10n.privacyIntro),
                const SizedBox(height: 8),
                for (final (title, body) in sections)
                  _Section(title: title, body: body),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formata a data de revisão de forma legível em cada idioma.
  ///
  /// Evita depender de `intl` com inicialização de locais: a data é fixa e só
  /// a ordem dos campos muda. O inglês usa ano-mês-dia (ISO), que é
  /// inequívoco; o chinês usa o formato com caracteres de ano/mês/dia; os
  /// restantes idiomas usam dia/mês/ano.
  String _formatDate(String languageCode) {
    final year = lastUpdated.year.toString().padLeft(4, '0');
    final month = lastUpdated.month.toString().padLeft(2, '0');
    final day = lastUpdated.day.toString().padLeft(2, '0');

    switch (languageCode) {
      case 'en':
        return '$year-$month-$day';
      case 'zh':
        return '$year年$month月$day日';
      default:
        return '$day/$month/$year';
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF04142D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF123E83)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFFB6C6E3),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFD5E0F2),
        fontSize: 14.5,
        height: 1.6,
      ),
    );
  }
}
