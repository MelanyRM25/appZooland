plugins {
    // No fijamos versión de com.android.application porque Flutter ya la incluye
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
    id("com.google.gms.google-services") version "4.4.2" apply false // Firebase
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Cambiar directorio de build para que Flutter compile en el lugar correcto
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tarea de limpieza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
