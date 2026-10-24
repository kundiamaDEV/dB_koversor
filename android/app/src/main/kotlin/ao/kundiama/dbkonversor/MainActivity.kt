package ao.kundiama.dbkonversor

import io.flutter.embedding.android.FlutterActivity

/**
 * Actividade única que aloja a interface Flutter.
 *
 * REESCRITA NA AUDITORIA DE 2026-10-17 (bloqueador B1).
 *
 * Porque foi necessário
 * ---------------------
 * Este ficheiro continha, por engano, o *script PowerShell* usado para migrar
 * o pacote de `com.example.db_konversor` para `ao.kundiama.dbkonversor`: o
 * script foi gravado sobre o seu próprio destino. Em consequência, a classe
 * `MainActivity` declarada em `AndroidManifest.xml` (`android:name=".MainActivity"`)
 * não existia e a compilação Android falhava.
 *
 * O conteúdo correcto é a actividade padrão do Flutter. Não é necessário
 * registar plugins à mão: `GeneratedPluginRegistrant` é invocado pelo
 * `FlutterActivity` do embedding v2, que o manifesto já declara
 * (`flutterEmbedding` = 2).
 *
 * O nome do pacote tem de coincidir com `namespace` e `applicationId` em
 * `android/app/build.gradle.kts` (`ao.kundiama.dbkonversor`) e com a estrutura
 * de directórios deste ficheiro.
 */
class MainActivity : FlutterActivity()
