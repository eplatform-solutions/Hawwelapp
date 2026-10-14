# Flutter entrypoints and plugin registrant.
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep Firebase Messaging + notification callback entry points.
-keep class com.google.firebase.messaging.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Kotlin metadata annotations used by some libraries.
-keep class kotlin.Metadata { *; }

# Flutter references Play Core deferred-component APIs optionally.
# We do not ship deferred components, so ignore those missing classes
# instead of depending on the deprecated Play Core monolith.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
