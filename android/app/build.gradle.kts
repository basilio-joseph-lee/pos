plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    defaultConfig {
        applicationId = "com.devops.current_weather"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = (System.getenv("CM_BUILD_ID") ?: "1").toInt()
        versionName = "1.0.${System.getenv("CM_BUILD_ID") ?: "1"}"
    }

    signingConfigs {
        create("release") {
            storeFile = file("android/upload-keystore.jks")
            storePassword = System.getenv("CM_KEYSTORE_PASSWORD")
            keyAlias = System.getenv("CM_KEY_ALIAS")
            keyPassword = System.getenv("CM_KEY_PASSWORD")
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

}


flutter {
    source = "../.."
}
