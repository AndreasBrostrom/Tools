@echo off

adb push %1 /sdcard/Download/%2
echo %1: have been pushed to ./sdcard/Download/%2