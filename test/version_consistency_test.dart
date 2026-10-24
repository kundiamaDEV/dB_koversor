// Coerência da versão entre o pubspec.yaml e o texto apresentado no ecrã de
// abertura.
//
// Porquê um teste para isto: a versão aparece em dois sítios independentes —
// o campo `version` do pubspec.yaml (que alimenta o versionName do Android e a
// Google Play) e a constante apresentada no ecrã de abertura. Sem verificação,
// uma subida de versão altera um e esquece o outro, e a aplicação publicada
// passa a mostrar ao utilizador uma versão que não corresponde à instalada.

import 'dart:io';

import 'package:db_konversor/features/splash/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a versão do ecrã de abertura coincide com a do pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    final match = RegExp(
      r'^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec);

    expect(
      match,
      isNotNull,
      reason:
          'o pubspec.yaml deve ter uma linha "version: x.y.z+n"; '
          'esse formato alimenta o versionName e o versionCode do Android',
    );

    final pubspecVersion = match!.group(1);

    expect(
      _SplashVersionProbe.versionShown,
      pubspecVersion,
      reason:
          'o texto da versão no ecrã de abertura '
          '(${_SplashVersionProbe.versionShown}) não coincide com o '
          'pubspec.yaml ($pubspecVersion). Actualize '
          'lib/features/splash/splash_screen.dart.',
    );
  });

  test('o versionCode do pubspec é um inteiro positivo', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec);

    final buildNumber = int.parse(match!.group(1)!);

    // A Google Play exige um versionCode estritamente crescente a cada
    // publicação; zero ou negativo seria rejeitado.
    expect(buildNumber, greaterThan(0));
  });
}

/// Acesso à constante de versão do ecrã de abertura.
///
/// A constante é estática e pública em `SplashScreen`; esta classe existe
/// apenas para documentar a ligação entre o teste e a fonte do valor.
class _SplashVersionProbe {
  static String get versionShown => splashAppVersion;
}
