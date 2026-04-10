# -------------------------------------------------
# Keep classes and methods
# -------------------------------------------------
-keep class com.hiennv.flutter_callkit_incoming.** { *; }
-keep class com.driver.evmototrip.model.** { *; }
-keep interface com.driver.evmototrip.network.** { *; }
-keep class androidx.room.** { *; }
-keepclassmembers class * { @androidx.room.* <methods>; @androidx.room.* <fields>; }
-keep class dagger.** { *; }
-keep class javax.inject.** { *; }
-keep class hilt_aggregated_deps.** { *; }
-keep class * extends android.app.Activity
-keep class * extends androidx.fragment.app.Fragment
-keep class * extends android.view.View
-keep class * extends androidx.viewbinding.ViewBinding
-keepclassmembers class * { @androidx.annotation.Keep *; }
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class org.ffmpeg.** { *; }
-keep class com.antonkarpenko.ffmpegkit.** { *; }
-keep class com.sendbird.** { *; }
-keep class com.sendbird.calls.** { *; }
-keep interface com.sendbird.calls.handler.** { *; }
-keep class com.sendbird.calls.SendBirdException { *; }
-keep class com.sendbird.calls.AudioDevice { *; }
-keep class com.google.gson.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep @interface androidx.annotation.** { *; }
-keep class kotlin.Metadata { *; }
-keep class com.baseflow.permissionhandler.** { *; }
-keepclassmembers class * { @com.baseflow.permissionhandler.** <methods>; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class androidx.security.crypto.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-keep class com.google.android.gms.location.** { *; }
-keep class org.webrtc.** { *; }
-keep class org.webrtc.WebRtcClassLoader { *; }


# -------------------------------------------------
# Keep enum methods
# -------------------------------------------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# -------------------------------------------------
# Keep methods for permissions and Bluetooth
# -------------------------------------------------
-keepclassmembers class * { public void requestBluetooth*(...); }
-keepclassmembers class android.app.Activity { public void requestPermissions(java.lang.String[], int); }
-keepclassmembers class android.content.Context { public android.content.pm.PackageManager getPackageManager(); }

# -------------------------------------------------
# Keep reflection-based Serializable and Gson
# -------------------------------------------------
-keep class * implements java.io.Serializable { *; }
-keepclassmembers class * { @com.google.gson.annotations.SerializedName <fields>; }

# -------------------------------------------------
# Remove logging side effects
# -------------------------------------------------
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# -------------------------------------------------
# Don't warn
# -------------------------------------------------
-dontwarn org.conscrypt.Conscrypt$ProviderBuilder
-dontwarn org.conscrypt.Conscrypt
-dontwarn com.arthenica.ffmpegkit.**
-dontwarn org.ffmpeg.**
-dontwarn com.sendbird.**
-dontwarn com.google.gson.**
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.google.android.gms.common.annotation.NoNullnessRewrite
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keepattributes *Annotation*
-keep class io.flutter.plugins.** { *; }
-keep class androidx.browser.customtabs.** { *; }
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication

-keepclassmembers class * {
    public <init>(...);
}