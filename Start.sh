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

# <-Home ->

headerprint () {
    if  [ "$ISCRAZY" = "1" ]; then
      forkbomb
  fi
  clear
  echo "|-----------------------------------------------|"
  echo "| XiaomiTool"
  echo "| Running on $OS"
  echo "|"
  echo "| Device:   $DID"
  echo "| Status:   $STATUS   $USBADB"
  echo "| Serial:   $SERIAL"
  echo "|-----------------------------------------------|"
  }

home () {
  headerprint
  tput bel
  echo "|                                               |"
  echo "| $(tput setaf 4)10- Manage backups      11- Sync$(tput sgr 0)              |"
  echo "| $(tput setaf 4)12- Shell               13- Install an app$(tput sgr 0)    |"
    if [ "$mix" = 1 ]; then
        echo "| $(tput setaf 4)20- Install a recovery  21- Install a Rom$(tput sgr 0)     |"
        echo "| $(tput setaf 4)22- Flash a zip         23- Root$(tput sgr 0)              |"
        echo "| $(tput setaf 4)24- Boot                25- Unbrick$(tput sgr 0)           |"
    fi
    if [ "$androidv" = "kk" ]; then
        echo "| $(tput setaf 4)30- Wipe menu           31- Record screen$(tput sgr 0)     |"
        echo "| $(tput setaf 4)32- Switch to Dalvik    33- Switch to ART$(tput sgr 0)     |"
    fi
    echo "| $(tput setaf 4)99- Device Info         999- Manage$(tput sgr 0)           |"
    echo "|-----------------------------------------------|"
    echo "|                                               |"
    echo "| $(tput setaf 4)0- Exit         00-About$(tput sgr 0)                      |"
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
        echo -e "$(tput setaf 1)This features is not stable, to prevent damages you cannot use it.$(tput sgr 0)"
        echo -e "$(tput setaf 1)Check for updates to see if it has been fixed$(tput sgr 0)"
        read -p "Press Enter to go back"
        #firefighters
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
      elif [ "$CHOICE" == 999 ]; then
          settings
      elif  [ "$CHOICE" == 0 ]; then
        quit
      elif  [ "$CHOICE" == 00 ]; then
        about
      elif  [ "$CHOICE" = "make me a sandwich" ]; then
          read -p "Do it yourself: " CHOICE
          if [ "$CHOICE" = "sudo make me a sandwich" ]; then
              echo -e "{orange}Advanced mode enabled!$(tput sgr 0)"
              ISCRAZY=1
              sleep 3
              home
          else
          echo -e "$(tput setaf 1)Wrong input!$(tput sgr 0)"
          sleep 2
          home
        fi
      else
        echo -e "$(tput setaf 1)Wrong input$(tput sgr 0)"
        sleep 2
        home
    fi
  }

# <- Install ->

apk () {
  headerprint
  echo "$(tput setaf 3)Apk Installer$(tput sgr 0)"
  echo " "
  read -p "Drag your apk here and press ENTER: " APK
  adb install $APK
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

recovery () {
  headerprint
  echo "$(tput setaf 3)Recovery installer$(tput sgr 0)"
  adb reboot bootloader
  echo "Flashing recovery on your $DID"
  wait_for_fastboot
  fastboot flash $DDIR/recovery/recovery.img
  fastboot reboot
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  sleep 3
  }

rom () {
  headerprint
  echo "$(tput setaf 3)Rom installer$(tput sgr 0)"
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
  echo "Warning: if your device bootloops, boot into recovery and wipe data!$(tput sgr 0)"
  read -p "If your phone screen is blank with recovery background, press enter or wait (it may reboot automatically, depends on the rom you flashed)"
  adb reboot
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

zip () {
  headerprint
  echo "$(tput setaf 3)Zip flasher$(tput sgr 0)"
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
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

root () {
  headerprint
  echo "$(tput setaf 3)Root Enabler$(tput sgr 0)"
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
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

# <- Advanced ->

shelll () {
  headerprint
  echo "$(tput setaf 3)Shell$(tput sgr 0)"
  echo " "
  echo "Type exit when you want to quit"
  echo " "
  adb shell
  read -p "Press Enter to quit$(tput sgr 0)"
  home
  }

fbboot () {
  headerprint
  echo "$(tput setaf 3)Fastboot Booter$(tput sgr 0)"
  echo " "
  echo "This will help you testing kernels and or other sideloadable images"
  read -p "Drag here the boot.img: " BOOTIMG
  adb reboot bootloader
  wait_for_fastboot
  fastboot boot $BOOTIMG
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  }

# <- Backup ->

back1 () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| $(tput setaf 3)1-Backup                   2-Restore$(tput sgr 0)          |"
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
    echo "$(tput setaf 1)Wrong input$(tput sgr 0)"
    back1
    fi
  }

backup () {
  headerprint
  echo "$(tput setaf 3)Backup$(tput sgr 0)"
  echo " "
  read -p "Type backup name (NO SPACES): " BACKUPID
  echo " "
  echo "Android 4.4.x KitKat have a bug with adb backup, if you're running it backup will fail!$(tput sgr 0)"
  echo "Enter password on your phone and let it work"
  adb backup -nosystem -noshared -apk -f $BACKFOLDER/$BACKUPID.ab
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

restore () {
  headerprint
  echo "$(tput setaf 3)Restore$(tput sgr 0)"
  echo " "
  read -p "Type backup name: " BACKUPID
  echo " "
  echo "On your phone, type password and let it works"
  adb restore $BACKFOLDER/$BACKUPID.ab
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

# <- Sync ->

pnp () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| $(tput setaf 3)1-Push a file            2- Import Camera$(tput sgr 0)     |"
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
    echo "$(tput setaf 1)Wrong input$(tput sgr 0)"
    sleep 2
    pnp
    fi
  }

push () {
  headerprint
  echo "$(tput setaf 3)Push a file$(tput sgr 0)"
  echo " "
  read -p "Drag your file here (one): " FILE
  adb push $FILE /sdcard
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

camera () {
  headerprint
  echo "$(tput setaf 3)Import Camera Photos$(tput sgr 0)"
  echo " "
  read -p "Press enter to start"
  adb pull $CAMDIR Camera
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

# <- 4.4 Features ->

beart () {
  headerprint
  echo "$(tput setaf 3)Android RunTime$(tput sgr 0)"
  echo " "
  adb reboot recovery
  adb shell rm -rf /data/dalvik-cache
  adb shell 'echo -n libart.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

bedalvik () {
  headerprint
  echo "$(tput setaf 3)Dalvik RunTime$(tput sgr 0)"
  echo " "
  adb reboot recovery
  adb shell rm -rf /data/dalvik-cache
  adb shell 'echo -n libdalvik.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

# < 4.4+ Features ->

recorder () {
  headerprint
  echo "$(tput setaf 3)Screen Recorder$(tput sgr 0)"
  echo " "
  echo "Press CTRL+C when you want to quit"
  NAME=$(date "+%N")
  adb shell screenrecord /sdcard/Movies/$NAME.mp4
  echo "Done! You'll find the file on your phone"
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

# < 5+ Features ->

bhistorian () {
  headerprint
  echo "$(tput setaf 3)Battery Historian dumper$(tput sgr 0)"
  echo " "
  read -p "Press enter to dump the battery stats"
  adb shell dumpsys batterystats 2>&1 | tee res/bhistorian/$NOW &> /dev/null
  python res/bhistorian/historian.py res/bhistorian/$NOW &> /dev/null
  echo "Done, you will find the oputput inside the bhistorian folder$(tput sgr 0)"
}

# < - Recover it! ->

firefighters () {
  headerprint
  echo "$(tput setaf 3)Firefighter Mode!$(tput sgr 0)"
  echo " "
  echo "$(tput setaf 5)To recover your phone you need to get into fastboot mode"
  echo "Boot your phone with Vol- and Power Key"
  echo "Once you see the bootloader Logo, attach the phone here.$(tput sgr 0)"
  read -p "Press Enter to continue."
  clear
  headerprint
  echo "$(tput setaf 3)Firefighter Mode!$(tput sgr 0)"
  echo " "
  read -p "Drag here the .tar file that contains the fastboot files" FBPACK
  rm -rf $DDIR/fbpack && mkdir $DDIR/fbpack &> /dev/null
  cp $FBPACK $DDIR/fbpack/pack.tar &> /dev/null
  tar -xf $DDIR/fbpack/pack.tar  &> /dev/null
  echo "$(tput sgr5)Firefigher is recoverying your phone...$(tput sgr 0)"
  wait_for_fastboot
  sh $DDIR/fbpack/flash_all_wipe.sh
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

# <- Wipes ->

wipec () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| $(tput setaf 3)1- Wipe Cache + Dalvik   2-Wipe Data$(tput sgr 0)                |"
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
    echo "$(tput setaf 1)Wrong input, retry!$(tput sgr 0)"
    sleep 2
    wipec
  fi
}

wipecache () {
  headerprint
  echo "$(tput setaf 3)Wipe Cache$(tput sgr 0)"
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb sideload "res/cache.zip"
  echo "Wait until it works..."
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

wipedata () {
  headerprint
  echo "$(tput setaf 3)Wipe Data$(tput sgr 0)"
  adb reboot recovery
  wait_for_adb recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--wipe_data' > /cache/recovery/command"
  adb reboot recovery
  echo "The device will wipe data automatically, it may reboot at the end,"
  echo "if it stucks on a blank screen, reboot it by pressing power button."
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

# <- Tools ->

deviceinfo () {
  headerprint
  echo "| Device: $DID"
  echo "| OEM: $(adb shell getprop ro.product.brand)"
  echo "| Name: $(adb shell getprop ro.product.device)"
  echo "| SOC: $(adb shell getprop ro.board.platform)"
  echo "| Serial: $SERIAL"
  echo "| Android: $(adb shell getprop ro.build.version.release)"
  echo "| Build: $(adb shell getprop ro.build.display.id)"
  echo "| Kernel: Linux $(adb shell uname -r)"
  echo "| Status: $STATUS"
  echo "| Location: $USBADB"
  echo "|-----------------------------------------------|"
  echo "| $(tput setaf 3)1- Export as Text        2-Check if fake$(tput sgr 0)            |"
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
    echo "$(tput setaf 1)Wrong input, retry!$(tput sgr 0)"
    sleep 2
    wipec
  fi
}

exportinfo () {
  touch deviceinfo.txt
  OEM=$(adb shell getprop ro.product.brand)
  CODENAME= $(adb shell getprop ro.product.device)
  SOC= $(adb shell getprop ro.board.platform)
  ROM=$(adb shell getprop ro.build.display.id)
  DEVICE_KERNEL=$(adb shell uname -r)
  echo -e 'Device: $DID' > deviceinfo.txt
  echo -e 'OEM: $OEM' >> deviceinfo.txt
  echo -e 'Name: $CODENAME' >> deviceinfo.txt
  echo -e 'SOC: $SOC' >> deviceinfo.txt
  echo -e 'Serial: $SERIAL' >> deviceinfo.txt
  echo -e 'Android: $androidv' >> deviceinfo.txt
  echo -e 'Build: $ROM' >> deviceinfo.txt
  echo -e 'Kernel: Linux $DEVICE_KERNEL' >> deviceinfo.txt
  echo -e 'Status: $STATUS' >> deviceinfo.txt
  echo -e 'Location: $USBADB' >> deviceinfo.txt
  echo "$(tput setaf 2)Everything have been exported to deviceinfo.txt"
  read -p "Done! Press Enter to quit.$(tput sgr 0)"
  home
}

fakeif () {
  headerprint
  adb push res/fake/qcom.sh /tmp/qcom-fake.sh
  adb shell bash /tmp/qcom-fake.sh
  adb pull /tmp/fake res/fake/result
  if [ "$(cat res/fake/result)" == 0 ]; then
    echo "$(tput setaf 2)It's not a fake.$(tput sgr 0)"
  else
    echo "$(tput setaf 3)It may be a fake.."
  fi
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
}

wait_for_any_adb() {
  if [[ $DISTRO == "ubuntu" ]]; then
    echo "$(tput setaf 3)Waiting for adb device$(tput sgr 0)"
    ADB_STATE=$(adb devices | grep $DEVICE_ID |grep 'device\|recovery')
    while [[ -z "$ADB_STATE" ]]
    do
        sleep 1
        ADB_STATE=$(adb devices | grep $DEVICE_ID |grep 'device\|recovery')
    done
  else
    echo "$(tput setaf 3)Waiting for device to be connected in normal or recovery mode$(tput sgr 0)"
    adb wait-for-device
  fi
}

wait_for_adb() {
  MODE=$1
  if [[ $DISTRO == "other" ]]; then
    echo "$(tput setaf 3)Waiting for adb $MODE to be ready$(tput sgr 0)"
    adb wait-for-device
  else
    echo "$(tput setaf 3)Waiting for adb $MODE to be ready$(tput sgr 0)"
    ADB_STATE=$(adb devices | grep $DEVICE_ID)
    while ! [[ "$ADB_STATE" == *$MODE ]]
    do
        sleep 1
        ADB_STATE=$(adb devices | grep $DEVICE_ID)
    done
  fi
}

wait_for_adb_disconnect() {
  if [[ $DISTRO == "other" ]]; then
    sleep 5
  else
    echo "$(tput setaf 3)Waiting for device to be disconnected$(tput sgr 0)"
    STATE=$(adb devices | grep $DEVICE_ID)
    while [[ "$STATE" == *$DEVICE_ID* ]]
    do
        sleep 1
        STATE=$(adb devices | grep $DEVICE_ID)
    done
  fi
}

wait_for_fastboot() {
    echo "$(tput setaf 3) Waiting for fastboot device$(tput sgr 0)"
    FASTBOOT_STATE=$(fastboot devices | grep $DEVICE_ID | awk '{ print $1}' )
    while ! [[ "$FASTBOOT_STATE" == *$DEVICE_ID* ]]
    do
        sleep 1
        FASTBOOT_STATE=$(fastboot devices | grep $DEVICE_ID | awk '{ print $1}' )
    done
}

detect_device() {
    clear
    adb kill-server &> /dev/null
    adb start-server &> /dev/null
    clear
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
     echo "Xiaomi device detected! "
     adba=2
     DID="Xiaomi Device"
    else
        echo "Device not supported: $DEVICE"
        sleep 2
        exit 0
    fi
}

setup (){
  if [ "$(uname) &> /dev/null" == "Darwin" ]; then
    OS="Os X"
    DISTRO="other"
  elif [ "$(expr substr $(uname -s) 1 5) &> /dev/null" == "Linux" ]; then
    OS="Linux"
    python -mplatform | grep buntu && DISTRO="ubuntu" || DISTRO="other"
  elif [ "$(expr substr $(uname -s) 1 10) &> /dev/null" == "MINGW32_NT" ]; then
    OS="Windows/CYGWIN"
    DISTRO="other"
  fi
  RES=res
  Mi2=Aries
  Mi3=Cancro
  RED1S=armani
  # MIP1=mocha
  M2A=taurus
  ROOTAOSP=$RES/root.zip
  ROOTMIUI=$RES/miui_root.zip
  DIR=/sdcard/tmp
  BACKFOLDER=Backups
  CAMDIR=/sdcard/DCIM/Camera
  ISCRAZY=0
  ACTION=$1
  NOW=$(date +"%F-%I-%H-%N")
  STATUS=$(adb get-state)
  SERIAL=$(adb get-serialno)
  USBADB=$(adb get-devpath)
  TOOLPATH=$(realpath .)
  # We love colours !
  #tput setaf
  #red=1
  #blue=4
  #green=2
  #magenta=5
  #yellow=3
  #NC=sgr 0
  # We don't love colours anymore :(
  }

android_api () {
  wait_for_any_adb
  if [[ "$BUILD" == 4.4* ]]; then
      androidv=kk
  else
      androidv=jb
  fi
}

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

# <- Tool Resources ->

settings () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| $(tput setaf 3)1- Setup drivers         2-Update from ota$(tput sgr 0)    |"
  echo "|                                               |"
  echo "| 0- Back                                       |"
  echo "|-----------------------------------------------|"
  read -p "? " CHOICE
  if [ "$CHOICE" == 1 ]; then
    drivers
  elif [ "$CHOICE" == 2 ]; then
    ota
  elif [ "$CHOICE" == 0 ]; then
    home
  else
    echo "$(tput setaf 1)Wrong input, retry!$(tput sgr 0)"
    sleep 2
    settings
  fi
}

drivers () {
  headerprint
  if [[ $DISTRO == "ubuntu" ]]; then
    echo "XiaomiTool needs root access to install drivers, you can check for code to see what it does to be sure it won't damage your system."
    sudo apt-get install android-tools-adb android-tools-fastboot &> /dev/null
    touch /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666"' > /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0e79", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0502", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="413c", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0489", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="091e", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="24e3", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="2116", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0482", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="17ef", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1004", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="22b8", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0409", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="2080", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="2257", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="10a9", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1d4d", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0471", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="04da", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f53", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="04e8", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="04dd", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0fce", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0930", MODE="0666"' >> /tmp/android.rules
    echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="19d2", MODE="0666"' >> /tmp/android.rules
    sudo cp /tmp/android.rules /etc/udev/rules.d/51-android.rules
    sudo chmod 644 /etc/udev/rules.d/51-android.rules
    sudo chown root. /etc/udev/rules.d/51-android.rules
    mkdir ~/android &> /dev/null && touch ~/android/adb_usb.ini &> /dev/null
    echo -e '0x2717' >> ~/android/adb_usb.ini
    sudo service udev restart
    sudo killall adb
    echo "Done!"
  else
    echo "Only Ubuntu-based systems have auto drivers setup (up to now)"
  fi
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
}

ota () {
  headerprint
  echo "Downloading lastest XiaomiTool release from Git, it may take up to 30 mins..."
  wget https://github.com/linuxxxxx/XiaomiTool/archive/unix.zip  &> /dev/null
  rm -rf ota && mkdir ota
  filename=$NOW
  mv unix.zip ota/$filename.zip
  unzip ota/$filename.zip
  TOPDIR=.
  mv XiaomiTool-unix ../XiaomiTool-ota
  NEWTOOL=$(realpath ../XiaomiTool-ota)
  cp $BACKFOLDER ../XiaomiTool-ota/Backups &> /dev/null
  cp Camera ../XiaomiTool-ota/Camera &> /dev/null
  mv $TOOLPATH ../XiaomiTool-old
  mv $NEWTOOL $TOOLPATH
  read -p "$(tput setaf 2)Done! XiaomiTool will be relaunched.$(tput sgr 0)"
  ./$TOOLPATH/Start.sh
  quit
}

disclaimer () {
  clear
  echo "$(tput setaf 1) ##########################################"
  echo " # XiaomiTool ~~ Disclaimer               #"
  echo " #                                        #"
  echo " # This program can brick your device,    #"
  echo " # kill your computer,                    #"
  echo " # erase some unsaved files,              #"
  echo " # void your warranty                     #"
  echo " #                                        #"
  echo " # The developer disclaim every kind      #"
  echo " # of damage caused from this program     #"
  echo " ##########################################$(tput sgr 0)"
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
  read -p "$(tput setaf 2)Done! Press Enter to quit.$(tput sgr 0)"
  home
  }

quit () {
  adb kill-server  &> /dev/null
  killall -9 adb &> /dev/null
  killall -9 fastboot &> /dev/null
  exit
  }


# <- Start ->

if [[ $1 == "--emergency" ]]; then
  setup
  if [[ $OS == "Linux" ]]; then
    wait-for-fastboot
  fi
  DEVICE="Emergency Mode"
  adba=1
elif [[ $1 == "--debug" ]]; then
  adb kill-server  &> /dev/null
  adb start-server &> /dev/null
  DID="-> DEBUG MODE <-"
  DEVICE="$DID"
  mix=1
  androidv==kk
  setup
  home
else
  disclaimer
  detect_device
  android_api
  home
fi
