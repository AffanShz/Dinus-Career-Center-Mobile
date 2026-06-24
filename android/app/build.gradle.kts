plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "id.ac.dinus.dcc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Runtime applicationId intentionally differs from the `id.ac.dinus.dcc`
        // namespace: the Google Cloud project "dinus-career-center" only has an
        // Android OAuth client registered for `com.dcc_mobile` (+ debug SHA-1).
        // Google Sign-In matches the running app's applicationId against that
        // client, so it must stay `com.dcc_mobile` or login fails with
        // ApiException 10 (DEVELOPER_ERROR). To switch to id.ac.dinus.dcc,
        // register a new Android OAuth client for that package + SHA-1 in the
        // Google Cloud Console, then change this back.
        applicationId = "com.dcc_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing configuration should be provided via environment variables or keystore properties
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
