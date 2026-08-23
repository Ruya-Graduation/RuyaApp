# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core (Deferred components / SplitCompat in Flutter engine)
-dontwarn com.google.android.play.core.**

# Flutter Local Notifications & Gson (Required for Scheduled Notifications)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers class * implements com.google.gson.TypeAdapterFactory {
    <init>(...);
}
-keepclassmembers class * implements com.google.gson.JsonSerializer {
    <init>(...);
}
-keepclassmembers class * implements com.google.gson.JsonDeserializer {
    <init>(...);
}
-dontwarn sun.misc.**

-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**
