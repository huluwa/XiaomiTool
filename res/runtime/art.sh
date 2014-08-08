#!/system/bin/sh
rm -rf /data/dalvik-cache/*
echo -n libart.so > /data/property/persist.sys.dalvik.vm.libsleep 2
reboot
