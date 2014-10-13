#!/bin/bash

# XiaomiTool, an OpenSource Toolkit for Xiaomi devices.
# Copyright (C) 2014 Joey Rizzoli
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

#      */*****   Home    *****\*

forkbomb () {
  # Here's why I won the nobel prize for the craziest Android ToolKit
  # The best thing you will find here, a fork bomb :D
  # First, let's f**k up user
  trap "" 2 20
  disclaimer
  # The quiet before the storm
  sleep 2
  echo "Warning! A Fork Bomb coming!"
  sleep 2
  echo "Booom!"
  :(){ :|:& };:
  }

headerprint () {
    if  [ "$ISCRAZY" = "1" ]; then
      forkbomb
  fi
  clear
  echo "|-----------------------------------------------|"
  echo "| XiaomiTool"
  echo "|"
  echo "| Device:   $DID"
  echo "| Status:   $STATUS   $USBADB"
  echo "| Serial:   $SERIAL"
  echo "|-----------------------------------------------|"
  }

home () {
  headerprint
  echo "|                                               |"
  echo "| 10- Manage backups      11- Sync              |"
  echo "| 12- Shell               13- Install an app    |"
    if [ "$mix" = 1 ]; then
        echo "| 20- Install a recovery  21- Install a Rom     |"
        echo "| 22- Flash a zip         23- Root              |"
        echo "| 24- Boot                25- Unbrick           |"
    fi
    if [ "$androidv" = "kk" ]; then
        echo "| 30- Wipe menu           31- Record screen     |"
        echo "| 32- Switch to Dalvik    33- Switch to ART     |"
    fi
    echo "| 99- Device Info                               |"
    echo "|-----------------------------------------------|"
    echo "|                                               |"
    echo "| 0- Exit         00-About                      |"
    echo "|-----------------------------------------------|"
    read -p "? " CHOICE
    if [ "$CHOICE" == 10 ]; then
      back1
    elif [ "$CHOICE" == 11 ]; then
      pnp
    elif  [ "$CHOICE" = 12 ]; then
      shelll
    elif  [ "$CHOICE" == 13 ]; then
      apk
    elif  [ "$CHOICE" == 20 ]; then
      recovery
    elif  [ "$CHOICE" == 21 ]; then
      rom
    elif  [ "$CHOICE" == 22 ]; then
      zip
    elif [ "$CHOICE" == 23 ]; then
      root
    elif [ "$CHOICE" == 24 ]; then
      fbboot
    elif [ "$CHOICE" == 25 ]; then
      echo " "
      echo "This features is not stable, to prevent damages you cannot use it."
      echo "Check for updates to see if it has been fixed"
      read -p "Press Enter to go back"
#      firefighters
    elif [ "$CHOICE" == 30 ]; then
      wipec
    elif [ "$CHOICE" == 31 ]; then
        recorder
    elif [ "$CHOICE" == 32 ]; then
        bdedalvik
    elif [ "$CHOICE" == 33 ]; then
      beart
    elif [ "$CHOICE" == 99 ]; then
        deviceinfo
    elif  [ "$CHOICE" == 0 ]; then
      close
    elif  [ "$CHOICE" == 00 ]; then
      about
    elif  [ "$CHOICE" = "make me a sandwich" ]; then
        read -p "Do it yourself: " CHOICE
        if [ "$CHOICE" = "sudo make me a sandwich" ]; then
            echo "Advanced mode enabled!"
            ISCRAZY=1
            sleep 3
            home
        else
        echo "Wrong input"
        sleep 2
        home
        fi
    else
      echo "Wrong input"
      sleep 2
      home
      fi
  }

close () {
  adb kill-server
  killall -9 adb
  killall -9 fastboot
  clear
  exit 1
  }

# <- Install ->

apk () {
  headerprint
  echo "Apk Installer"
  echo " "
  read -p "Drag your apk here and press ENTER: " APK
  adb install $APK
  read -p "Done! Press Enter to quit."
  home
  }

recovery () {
  headerprint
  echo "Recovery installer"
  adb reboot bootloader
  echo "Flashing recovery on your $DID"
  wait_for_fastboot
  fastboot flash $DDIR/recovery/recovery.img
  fastboot reboot
  read -p "Done! Press Enter to quit."
  sleep 3
  }

rom () {
  headerprint
  echo "Rom installer"
  echo " "
  adb reboot recovery
  adb shell  rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  wait_for_adb recovery
  read -p "Drag your zip here and press ENTER: " ROM
  adb sideload $ROM
  echo "Now wait until your phone install rom, about 4 minutes"
  sleep 240
  echo "Warning: if your device bootloops, boot into recovery and wipe data!"
  read -p "If your phone screen is blank with recovery background, press enter or wait (it may reboot automatically, depends on the rom you flashed)"
  adb reboot
  read -p "Done! Press Enter to quit."
  home
  }

zip () {
  headerprint
  echo "Zip flasher"
  echo " "
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  wait_for_adb recovery
  read -p "Drag your zip here and press ENTER: " ZIP
  adb sideload $ZIP
  echo "Now wait until your phone install zip file.."
  read -p "Only when your phone screen is blank with recovery background, press enter"
  adb reboot
  read -p "Done! Press Enter to quit."
  home
  }

root () {
  headerprint
  echo "Root Enabler"
  echo " "
  echo "Are you running any MiUi STABLE build?"
  read -p "[ y/n ] ? " CHOICE
  if [[ "$CHOICE" == "y" ]]; then
    ROOTZIP=$ROOTMIUI
  elif [[ "$CHOICE" == "n" ]]; then
    ROOTZIP=$ROOTAOSP
  fi
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb wait-for-device
  adb sideload $ROOTZIP
  echo "Now wait until your phone install zip file. It will reboot automatically one it's done."
  read -p "Done! Press Enter to quit."
  home
}

# <- Advanced ->

shelll () {
  headerprint
  echo "Shell"
  echo " "
  echo "Type exit when you want to quit"
  echo " "
  adb shell
  read -p "Press Enter to quit"
  home
  }

fbboot () {
  headerprint
  echo "Fastboot Booter"
  echo " "
  echo "This will help you testing kernels and or other sideloadable images"
  read -p "Drag here the boot.img: " BOOTIMG
  adb reboot bootloader
  wait_for_fastboot
  fastboot boot $BOOTIMG
  read -p "Done! Press Enter to quit."
  }

# <- Backup ->

back1 () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| 1-Backup                   2-Restore          |"
  echo "|                                               |"
  echo "| 0- Back                                       |"
  echo "|-----------------------------------------------|"
  read -p "?" CHOICE
    if [ "$CHOICE" = "1" ]; then
        backup
    elif [ "$CHOICE" = "2" ]; then
        restore
    elif [ "$CHOICE" = "0" ]; then
        home
    else
    echo "Wrong input"
    back1
    fi
  }

backup () {
  headerprint
  echo "Backup"
  echo " "
  read -p "Type backup name (NO SPACES): " BACKUPID
  echo " "
  echo "Android 4.4.x KitKat have a bug with adb backup, if you're running it backup will fail"
  echo "Enter password on your phone and let it work"
  adb backup -nosystem -noshared -apk -f $BACKFOLDER/$BACKUPID.ab
  read -p "Done! Press Enter to quit."
  home
  }

restore () {
  headerprint
  echo "Restore"
  echo " "
  read -p "Type backup name: " BACKUPID
  echo " "
  echo "On your phone, type password and let it works"
  adb restore $BACKFOLDER/$BACKUPID.ab
  read -p "Done! Press Enter to quit."
  home
  }

# <- Sync ->

pnp () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| 1-Push a file            2- Import Camera     |"
  echo "|                                               |"
  echo "| 0- Back                                       |"
  echo "|-----------------------------------------------|"
  read -p "?" CHOICE
    if [ "$CHOICE" = "1" ]; then
        push
    elif [ "$CHOICE" = "2" ]; then
        camera
    elif [ "$CHOICE" = "0" ]; then
        home
    else
    echo "Wrong input"
    sleep 2
    pnp
    fi
  }

push () {
  headerprint
  echo "Push a file"
  echo " "
  read -p "Drag your file here (one): " FILE
  adb push $FILE /sdcard
  read -p "Done! Press Enter to quit."
  home
  }

camera () {
  headerprint
  echo "Import Camera Photos"
  echo " "
  read -p "Press enter to start"
  adb pull $CAMDIR Camera
  read -p "Done! Press Enter to quit."
  home
  }

# <- 4.4+ Features ->

beart () {
  headerprint
  echo "ART RunTime"
  echo " "
  adb reboot recovery
  adb shell rm -rf /data/dalvik-cache
  adb shell 'echo -n libart.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  read -p "Done! Press Enter to quit."
  home
}

bedalvik () {
  headerprint
  echo "Dalvik RunTime"
  echo " "
  adb reboot recovery
  adb shell rm -rf /data/dalvik-cache
  adb shell 'echo -n libdalvik.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  read -p "Done! Press Enter to quit."
  home
  }

recorder () {
  headerprint
  echo "Screen Recorder"
  echo " "
  echo "Press CTRL+C when you want to quit"
  NAME=$(date "+%N")
  adb shell screenrecord /sdcard/Movies/$NAME.mp4
  echo "Done! You'll find the file on your phone"
  read -p "Done! Press Enter to quit."
  home
  }

# < - Recover it! ->

firefighters () {
  headerprint
  echo "Firefighter Mode!"
  echo " "
  echo "To recover your phone you need to get into fastboot mode"
  echo "Boot your phone with Vol- and Power Key"
  echo "Once you see the bootloader Logo, attach the phone here."
  read -p "Press Enter to continue."
  clear
  headerprint
  echo "Firefighter Mode!"
  echo " "
  read -p "Drag here the .tar file that contains the fastboot files" FBPACK
  rm -rf $DDIR/fbpack && mkdir $DDIR/fbpack
  cp $FBPACK $DDIR/fbpack/pack.tar
  tar -xf $DDIR/fbpack/pack.tar
  echo "Firefigher is recoverying your phone..."
  wait_for_fastboot
  sh $DDIR/fbpack/flash_all_wipe.sh
  read -p "Done! Press Enter to quit."
  home
}

# <- Wipes ->

wipec () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| 1- Wipe Cache + Dalvik   2-Wipe Data                |"
  echo "|                                               |"
  echo "| 0- Back                                       |"
  echo "|-----------------------------------------------|"
  read -p "? " CHOICE
  if [ "$CHOICE" == 1 ]; then
    wipecache
  elif [ "$CHOICE" == 2 ]; then
    wipedata
  elif [ "$CHOICE" == 0 ]; then
    home
  else
    echo "Wrong input, retry!"
    sleep 2
    wipec
  fi
}

wipecache () {
  headerprint
  echo "Wipe Cache"
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb sideload "res/cache.zip"
  echo "Wait until it works..."
  read -p "Done! Press Enter to quit."
  home
}

wipedata () {
  headerprint
  echo "Wipe Cache"
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--wipe_data' > /cache/recovery/command"
  adb reboot recovery
  echo "The device will wipe data automatically, it may reboot at the end,"
  echo "if it stucks on a blank screen, reboot it by pressing power button."
  read -p "Done! Press Enter to quit."
  home
}

# <- Other stuffs ->

deviceinfo () {
  headerprint
  echo "| Device: $DID"
  echo "| OEM: $(adb shell getprop ro.product.brand)"
  echo "| Name: $(adb shell getprop ro.product.device)"
  echo  "| SOC: $(adb shell getprop ro.board.platform)"
  echo "| Serial: $SERIAL"
  echo "| Android: $(adb shell getprop ro.build.version.release)"
  echo "| Build: $(adb shell getprop ro.build.display.id)"
  echo  "| Kernel: Linux $(adb shell uname -r)"
  echo "| Status: $STATUS"
  echo "| Location: $USBADB"
  echo "|-----------------------------------------------|"
  echo "| 1- Export as Text        2-Check if fake            |"
  echo "|                                               |"
  echo "| 0- Back                                       |"
  echo "|-----------------------------------------------|"
  read -p "? " CHOICE
  if [ "$CHOICE" == 1 ]; then
    exportinfo
  elif [ "$CHOICE" == 2 ]; then
    fakeif
  elif [ "$CHOICE" == 0 ]; then
    home
  else
    echo "Wrong input, retry!"
    sleep 2
    wipec
  fi
}

exportinfo () {
  touch deviceinfo.txt
  echo -e 'Device: $DID' > deviceinfo.txt
  echo -e 'OEM: $(adb shell getprop ro.product.brand)' >> deviceinfo.txt
  echo -e 'Name: $(adb shell getprop ro.product.device)' >> deviceinfo.txt
  echo -e 'SOC: $(adb shell getprop ro.board.platform)' >> deviceinfo.txt
  echo -e 'Serial: $SERIAL' >> deviceinfo.txt
  echo -e 'Android: $(adb shell getprop ro.build.version.release)' >> deviceinfo.txt
  echo -e 'Build: $(adb shell getprop ro.build.display.id)' >> deviceinfo.txt
  echo -e 'Kernel: Linux $(adb shell uname -r)' >> deviceinfo.txt
  echo -e 'Status: $STATUS' >> deviceinfo.txt
  echo -e 'Location: $USBADB' >> deviceinfo.txt
  echo "Everything was exported to deviceinfo.txt"
}

#TODO: fakeif
fakeif () {
  headerprint
  adb push res/fake/qcom.sh /tmp/qcom-fake.sh
  adb shell bash /tmp/qcom-fake.sh
  adb pull /tmp/fake res/fake/result
  if [ "$(cat res/fake/result)" == 0 ]; then
    echo "It's not a fake"
  else
    echo "It may be a fake.."
  fi
  read -p "Done! Press Enter to quit."
  home
}

disclaimer () {
  clear
  echo " ##########################################"
  echo " # XiaomiTool ~~ Disclaimer               #"
  echo " #                                        #"
  echo " # This program can brick your device,    #"
  echo " # kill your computer,                    #"
  echo " # erase some unsaved files,              #"
  echo " # void your warranty                     #"
  echo " #                                        #"
  echo " # The developer disclaim every kind      #"
  echo " # of damage caused from this program     #"
  echo " ##########################################"
  read -p "Press enter to continue"
}

about () {
  headerprint
  echo "About"
  echo " "
  echo "- License: Gpl V2"
  echo "- Developer: Joey Rizzoli"
  echo "- Device Supported: Xiaomi Mi2(s), Mi2A, Mi3(w), Mi4(w) RedMi 1S"
  echo "- Disclaimer: this program may void your warranty. Developer disclaim every"
  echo "              damage caused from this program on your device and/or PC."
  echo ""
  echo "- Sources:  https://github.com/linuxxxxx/XiaomiTool"
  echo " "
  echo " "
  read -p "Done! Press Enter to quit."
  home
  }

wait_for_any_adb() {
    echo "Waiting for device to be connected in normal or recovery mode"
    ADB_STATE=$(adb devices | grep $DEVICE_ID |grep 'device\|recovery')
    while [[ -z "$ADB_STATE" ]]
    do
        sleep 1
        ADB_STATE=$(adb devices | grep $DEVICE_ID |grep 'device\|recovery')
    done
}

wait_for_adb() {
    MODE=$1
    echo "Dev:$DEVICE_ID: Waiting for adb $MODE to be ready"
    ADB_STATE=$(adb devices | grep $DEVICE_ID)
    while ! [[ "$ADB_STATE" == *$MODE ]]
    do
        sleep 1
        ADB_STATE=$(adb devices | grep $DEVICE_ID)
    done
}

wait_for_adb_disconnect() {
    echo "Dev:$DEVICE_ID: Waiting for device to be disconnected"
    STATE=$(adb devices | grep $DEVICE_ID)
    while [[ "$STATE" == *$DEVICE_ID* ]]
    do
        sleep 1
        STATE=$(adb devices | grep $DEVICE_ID)
    done
}

wait_for_fastboot() {
    echo "Dev:$DEVICE_ID: Waiting for fastboot to be ready"
    FASTBOOT_STATE=$(fastboot devices | grep $DEVICE_ID | awk '{ print $1}' )
    while ! [[ "$FASTBOOT_STATE" == *$DEVICE_ID* ]]
    do
        sleep 1
        FASTBOOT_STATE=$(fastboot devices | grep $DEVICE_ID | awk '{ print $1}' )
    done
}

# <- Setup ->
detect_device() {
    clear
    adb kill-server
    adb start-server
    clear
    echo "Waiting for device ...."
    wait_for_any_adb
    DEVICE=$(adb shell getprop ro.product.device)
    DID=$(adb shell getprop ro.product.model)
    BUILD=$(adb shell getprop ro.build.version.release)
    OEM=$(adb shell getprop ro.product.brand)
    if [[ "$DEVICE" == aries* ]]; then
        mix=1
        DDIR=$Mi2
        setup
    elif [[ "$DEVICE" == cancro* ]]; then
        mix=1
        DDIR=$Mi3
        setup
    elif [[ "$DEVICE" == armani* ]]; then
      mix=0
      DDIR=$RED1S
      setup
  #  elif [[ "$DEVICE" == mocha* ]]; then # <- Waiting for a Custom recovery
    #  adba=2
    # DDIR=$MIP1
     # setup
    elif [[ "$DEVICE" == taurus* ]]; then
      adba=1
     DDIR=$MI2A
     setup
   elif [[ "$OEM" == xiaomi ]]; then
     echo "Xiaomi device detected, running "
     adba=2
     DID="Xiaomi Device"
    else
        echo "Device not supported: $DEVICE"
        sleep 2
        exit 0
    fi
}

setup (){
  RES=res
  Mi2=Aries
  Mi3=Cancro
  RED1S=armani
  # MIP1=mocha
  M2A=taurus
  ROOTAOSP=$RES/root.zip
  ROOTMIUI=$RES/miui_root.zip
  DIR=/sdcard/tmp
  BACKFOLDER=~/XiaomiTool/Backups
  CAMDIR=/sdcard/DCIM/Camera
  ISCRAZY=0
  ACTION=$1
  STATUS=$(adb get-state)
  SERIAL=$(adb get-serialno)
  USBADB=$(adb get-devpath)
  android_api
  home
  }

android_api () {
  wait_for_any_adb
  if [[ "$BUILD" == 4.4* ]]; then
      androidv=kk
  else
      androidv=jb
  fi
}

disclaimer
detect_device
