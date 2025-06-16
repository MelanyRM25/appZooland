plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter debe ir al final
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.zooland"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.zooland"
        minSdk = 24 // Android 7.0
        targetSdk = 34 // 🔧 Cambiado de 33 a 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // ⚠️ Si vas a publicar el APK, usa aquí tu keystore de release
            // minifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
