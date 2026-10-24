import java.util.Properties

plugins {
    id("com.android.application")

    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Configuracao de assinatura de lancamento (bloqueador B2 da auditoria de
// 2026-10-17).
//
// PORQUE FOI NECESSARIO
// A variante `release` estava a usar `signingConfigs.getByName("debug")`, isto
// e, a chave de depuracao gerada automaticamente pelo SDK. Um pacote assinado
// com essa chave e rejeitado pela Google Play. Alem disso, a chave de
// depuracao e diferente em cada maquina, pelo que nem seria reproduzivel.
//
// COMO FUNCIONA
// Os dados da chave real NAO estao neste ficheiro nem em qualquer ficheiro
// versionado. Sao lidos de `android/key.properties`, que esta excluido pelo
// .gitignore e tem de ser criado pelo proprietario com:
//
//   storeFile=C:/caminho/para/db-konversor-upload.jks
//   storePassword=...
//   keyAlias=upload
//   keyPassword=...
//
// Se o ficheiro nao existir, a compilacao de `release` NAO falha: continua a
// usar a chave de depuracao, para que `flutter run --release` e os testes de
// desempenho funcionem numa maquina de desenvolvimento. Mas e impressa uma
// advertencia bem visivel, porque esse pacote nao serve para publicar.
//
// NENHUMA CHAVE FOI GERADA PELA AUDITORIA: criar uma chave privada de
// assinatura e uma acao irreversivel (perder essa chave impede para sempre a
// actualizacao da aplicacao publicada) e exige decisao do proprietario.
// Os passos estao em docs/RELATORIO_FINAL_AUDITORIA.md.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseKeystore = keystorePropertiesFile.exists()

if (hasReleaseKeystore) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "ao.kundiama.dbkonversor"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Identificador definitivo da aplicacao na Google Play. Depois da
        // primeira publicacao NAO pode ser alterado: mudar este valor cria uma
        // aplicacao diferente na loja.
        applicationId = "ao.kundiama.dbkonversor"

        // minSdk, targetSdk e compileSdk sao herdados do Flutter, para
        // acompanharem automaticamente os requisitos actuais da Google Play
        // sem terem de ser fixados a mao aqui.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                logger.warn(
                    "AVISO dB Konversor: android/key.properties nao encontrado. " +
                        "A variante release vai ser assinada com a chave de DEPURACAO " +
                        "e NAO pode ser publicada na Google Play. " +
                        "Ver docs/RELATORIO_FINAL_AUDITORIA.md."
                )
                signingConfigs.getByName("debug")
            }

            // Reducao e ofuscacao de codigo desactivadas de forma explicita.
            //
            // A aplicacao nao usa reflexao nem serializacao por nome de classe,
            // pelo que a reducao seria segura, mas activa-la sem a verificar num
            // dispositivo real e um risco desnecessario nesta fase: um erro de
            // regras R8 so se manifesta em tempo de execucao, na versao de
            // lancamento. Fica registado como melhoria futura, a validar com
            // testes em dispositivo.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
