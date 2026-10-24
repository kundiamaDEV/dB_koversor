import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DbKonversorApp());
}

class DbKonversorApp extends StatelessWidget {
  const DbKonversorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // O título da aplicação deixa de ser uma constante escrita aqui e passa
      // a vir dos recursos de localização, para que o sistema operativo o
      // apresente no idioma do utilizador. `dB Konversor` é uma marca e o seu
      // valor é igual em todos os idiomas, mas o mecanismo fica correcto.
      // Fase 4 da auditoria de 2026-10-17.
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,

      // Delegados de localização. `AppLocalizations.localizationsDelegates`
      // já inclui os delegados do próprio Flutter (Material, Widgets e
      // Cupertino), necessários para que os widgets do sistema — campos de
      // texto, menus de selecção, diálogos — apareçam traduzidos. É por isso
      // que `flutter_localizations` não precisa de ser importado aqui, apesar
      // de ser uma dependência obrigatória no pubspec.yaml.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Escolha do idioma quando o dispositivo pede um que não é suportado.
      //
      // Por omissão, o Flutter cairia na primeira língua da lista. Esta
      // resolução é explícita: tenta o idioma exacto, depois qualquer variante
      // do mesmo idioma (por exemplo pt-BR -> pt, zh-Hant -> zh) e só no fim
      // usa o português como reserva.
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales != null) {
          for (final locale in locales) {
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale.languageCode) {
                return supported;
              }
            }
          }
        }
        return const Locale('pt');
      },

      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
