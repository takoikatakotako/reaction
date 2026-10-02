# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# ---- このアプリ固有のルール ----

# Gson はフィールド名をそのまま JSON のキーとして扱う。R8 がフィールドを
# 改名すると対応が取れなくなり、値がすべて null になる。
#
# gson 同梱の consumer ルールが保持するのは @SerializedName を付けた
# フィールドだけで、このアプリのモデルには付けていないため守られない。
# API のレスポンスに使うクラスは明示的に名前を保持する。
#
# モデルを追加したらここにも足すこと。
-keep class com.swiswiswift.chemist.Reaction { *; }
-keep class com.swiswiswift.chemist.ReactionContent { *; }

# Crashlytics のスタックトレースを行番号まで記号化するために必要。
# mapping のアップロードは app/build.gradle.kts で有効にしている。
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
