allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    // isarの対策
    // Android Gradle Plugin 8以前だとnamespaceが必要になるため、手動で付与
    plugins.withId("com.android.library") {
        val android = extensions.findByName("android") as? com.android.build.gradle.LibraryExtension
        if (android != null && android.namespace == null) {
            android.namespace = "dev.isar.${project.name}"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
