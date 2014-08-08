#!/system/bin/sh
rm -rf /data/dalvik-cache/*
echo -n libdalvik.so > /data/property/persist.sys.dalvik.vm.libsleep 2
reboot
