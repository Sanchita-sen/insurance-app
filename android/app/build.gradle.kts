plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.insurance_app"
    compileSdk = 35  // ✅ Updated to fix SDK version compatibility

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.insurance_app"
        minSdk = 21           // Minimum supported Android version
        targetSdk = 35        // ✅ Updated to match compileSdk
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // You should use a real keystore in production
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}



