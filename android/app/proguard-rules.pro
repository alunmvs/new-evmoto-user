# -------------------------------------------------
# Gson: do not obfuscate model classes
# -------------------------------------------------
-keep class com.driver.evmototrip.model.** { *; }

# -------------------------------------------------
# Retrofit: interfaces should not be obfuscated
# -------------------------------------------------
-keep interface com.driver.evmototrip.network.** { *; }

# -------------------------------------------------
# Room: entity, dao, database
# -------------------------------------------------
-keep class androidx.room.** { *; }
-keepclassmembers class * {
    @androidx.room.* <methods>;
}
-keepclassmembers class * {
    @androidx.room.* <fields>;
}

# -------------------------------------------------
# Dagger / Hilt
# -------------------------------------------------
-keep class dagger.** { *; }
-keep class javax.inject.** { *; }
-keep class hilt_aggregated_deps.** { *; }

# -------------------------------------------------
# Keep Activity, Fragment, ViewBinding
# -------------------------------------------------
-keep class * extends android.app.Activity
-keep class * extends androidx.fragment.app.Fragment
-keep class * extends android.view.View
-keep class * extends androidx.viewbinding.ViewBinding

# -------------------------------------------------
# Keep methods annotated with @Keep
# -------------------------------------------------
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# -------------------------------------------------
# Optional: Log / Debug removal
# -------------------------------------------------
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

#ffmpeg_kit
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class org.ffmpeg.** { *; }
-dontwarn com.arthenica.ffmpegkit.**
-dontwarn org.ffmpeg.**
-keep class com.antonkarpenko.ffmpegkit.** { *; }