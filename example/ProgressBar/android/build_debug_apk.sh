clear
echo BUILD --------------------------------------------------------------
PANDROID=/usr/local/pandroid
PROJECT=/usr/local/pandroid/example/ProgressBar
SDK=/usr/local/pandroid/sdk
TYPHON=/usr/local/codetyphon


cd $PROJECT/android

rm -rf bin
rm -rf gen
rm -rf Rjava.pas

echo Deleted -----------------------------------
mkdir -p bin
mkdir -p gen
mkdir -p bin/classes

echo compile R.java -------------------------------------
$SDK/build-tools/23.0.3/aapt package -m -J gen -M AndroidManifest.xml -S res -I $SDK/platforms/android-15/android.jar -S res -m -J gen

echo compile Rjava.pas ----------------------------------
$PANDROID/pandroid R ProgressBar zeljus.com.progressbar $PROJECT/android/gen/zeljus/com/progressbar/R.java $PROJECT/Rjava.pas

echo ppcjvm ---------------------------------------------
$TYPHON/fpc/fpc64/bin/x86_64-linux/ppcjvm @$TYPHON/fpcsrc/rtl/android/jvm/rtl.cfg -Ur -Tandroid -Pjvm -Ur -Xs -O2 -n -Fi$TYPHON/fpcsrc/rtl/inc -Fi$TYPHON/fpcsrc/rtl/jvm -Fi$TYPHON/fpcsrc/rtl/java -FE. -Fi$TYPHON/fpcsrc/rtl/android/jvm -FUbin/classes -djvm -dRELEASE -Us -Sg $TYPHON/fpcsrc/rtl/java/system.pp
$TYPHON/fpc/fpc64/bin/x86_64-linux/ppcjvm @$TYPHON/fpcsrc/rtl/android/jvm/rtl.cfg -Ur -Tandroid -Pjvm -Ur -Xs -O2 -n -Fi$TYPHON/fpcsrc/rtl/inc -Fi$TYPHON/fpcsrc/rtl/jvm -Fi$TYPHON/fpcsrc/rtl/java -FE. -Fi$TYPHON/fpcsrc/rtl/android/jvm -FUbin/classes -djvm -dRELEASE $TYPHON/fpcsrc/rtl/inc/uuchar.pp
$TYPHON/fpc/fpc64/bin/x86_64-linux/ppcjvm @$TYPHON/fpcsrc/rtl/android/jvm/rtl.cfg -Ur -Tandroid -Pjvm -Ur -Xs -O2 -n -Fi$TYPHON/fpcsrc/rtl/inc -Fi$TYPHON/fpcsrc/rtl/jvm -Fi$TYPHON/fpcsrc/rtl/java -FE. -Fi$TYPHON/fpcsrc/rtl/android/jvm -FUbin/classes -djvm -dRELEASE $TYPHON/fpcsrc/rtl/java/objpas.pp
$TYPHON/fpc/fpc64/bin/x86_64-linux/ppcjvm @$TYPHON/fpcsrc/rtl/android/jvm/rtl.cfg -Ur -Tandroid -Pjvm -Ur -Xs -O2 -n -Fi$TYPHON/fpcsrc/rtl/inc -Fi$TYPHON/fpcsrc/rtl/jvm -Fi$TYPHON/fpcsrc/rtl/java -FE. -Fi$TYPHON/fpcsrc/rtl/android/jvm -Fu$PANDROID/units -FUbin/classes -djvm -dRELEASE $PROJECT/ProgressBar.lpr

#$PANDROID/compiler/ppcjvm -n -Tandroid -Fu$PANDROID/units/typhon -Fu$PANDROID/units -FEbin/classes $PROJECT/ProgressBar.lpr

echo ANT DEBUG ==========================================
ant -verbose release

jarsigner -verify -verbose -certs $PROJECT/ProgressBar.apk


adb shell pm uninstall -k zeljus.com.progressbar
adb install -r $PROJECT/ProgressBar.apk

adb shell am start -n zeljus.com.progressbar/zeljus.com.progressbar.MainActivity

Delete android/bin and android/gen ===========================
rm -rf bin
rm -rf gen
