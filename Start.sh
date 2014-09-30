#!/bin/bash

#   Copyright 2014 Joey Rizzoli
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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
  echo "| 1- Manage backups        2- Sync              |"
  echo "| 3- Shell                 4- Install an app    |"
    if [ "$mix" = 1 ]; then
        echo "| 5- Install a recovery    6- Install a Rom     |"
        echo "| 7- Flash a zip           8- Root              |"

    fi
    if [ "$androidv" = "kk" ]; then
        echo "| 9- Wipe menu             10- Record screen    |"
        echo "| 11- Switch to Dalvik     12- Switch to ART    |"
    fi
    echo "| 13- Device Info                                   |"
    echo "|-----------------------------------------------|"
    echo "|                                               |"
    echo "| 0- Exit         00-About                      |"
    echo "|-----------------------------------------------|"
    read -p "? " CHOICE
    if [ "$CHOICE" == 1 ]; then
      back1
    elif [ "$CHOICE" == 2 ]; then
      pnp
    elif  [ "$CHOICE" = 3 ]; then
      shelll
    elif  [ "$CHOICE" == 4 ]; then
      apk
    elif  [ "$CHOICE" == 5 ]; then
      recovery
    elif  [ "$CHOICE" == 6 ]; then
      rom
    elif  [ "$CHOICE" == 7 ]; then
      zip
    elif [ "$CHOICE" == 8 ]; then
      root
    elif [ "$CHOICE" == 9 ]; then
      wipec
    elif [ "$CHOICE" == 10 ]; then
        recorder
    elif [ "$CHOICE" == 11 ]; then
        bdedalvik
    elif [ "$CHOICE" == 12 ]; then
      beart
    elif [ "$CHOICE" == 13 ]; then
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
  sleep 2
  home
  }

recovery () {
  headerprint
  echo "Recovery installer"
  adb reboot bootloader
  echo "Flashing recovery on your $DID"
  fastboot flash $DDIR/recovery/recovery.img
  fastboot reboot
  echo " "
  echo "Done!"
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
  isavailable
  read -p "Drag your zip here and press ENTER: " ROM
  sleep 180 # < Wait until it wipes data
  adb sideload $ROM
  echo "Now wait until your phone install rom, about 4 minutes"
  sleep 240
  echo "Warning: if your device bootloops, boot into recovery and wipe data!"
  read -p "If your phone screen is blank with recovery background, press enter or wait (it may reboot automatically, depends on the rom you flashed)"
  adb reboot
  echo "Done!"
  home
  }

zip () {
  headerprint
  echo "Zip flasher"
  echo " "
  adb reboot recovery
  isavaible
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  isavailable
  read -p "Drag your zip here and press ENTER: " ZIP
  adb sideload $ZIP
  echo "Now wait until your phone install zip file.."
  read -p "Only when your phone screen is blank with recovery background, press enter"
  adb reboot
  echo "Done!"
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
  isavailable
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb wait-for-device
  adb sideload $ROOTZIP
  echo "Now wait until your phone install zip file. It will reboot automatically one it's done."
  echo "Done!"
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

# <- Backup ->

back1 () {
  headerprint
  echo "Backup Manager"
  echo " "
  echo "1- Backup    2-Restore"
  echo " "
  echo "0- Go Back"
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
  echo "Enter password on your phone and let it work"
  adb backup -nosystem -noshared -apk -f $BACKFOLDER/$BACKUPID.ab
  read -p "Done! Press Enter"
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
  read -p "Done! Press Enter"
  home
  }

# <- Sync ->

pnp () {
  headerprint
  echo "Push and Pull"
  echo " "
  echo "1- Push a file "
  echo "2- Import Camera Photos"
  echo " "
  echo "0- Go Back"
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
  read -p "Press ENTER"
  home
  }

camera () {
  headerprint
  echo "Import Camera Photos"
  echo " "
  read -p "Press enter to start"
  adb pull $CAMDIR Camera
  read -p "Press ENTER"
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
  echo "Done!"
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
  echo "Done!"
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
  sleep 3
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
  sh $DDIR/fbpack/wipe-all.sh
  echo "Done!"
  read -p "Press Enter to quit."
  home
}

# <- Wipes ->

wipec () {
  headerprint
  echo "|-----------------------------------------------|"
  echo "| 1- Wipe Cache + Dalvik   2-Wipe Data                |"
  echo "|                                               |"
  echo "| 0- Back                                             |"
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
  isavailable
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb sideload "res/cache.zip"
  echo "Done!"
  adb reboot
  sleep 3
  home
}

wipedata () {
  headerprint
  echo "Wipe Cache"
  adb reboot recovery
  isavailable
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--wipe_data' > /cache/recovery/command"
  ab reboot recovery
  echo "Done!"
  echo "The device will wipe data automatically, it may reboot at the end,"
  echo "if it stucks on a blank screen, reboot it by pressing power button."
  sleep 5
  home
}

# <- Other stuffs ->

deviceinfo () {
  headerprint
  echo "| Device: $DID"
  echo "| Android: $(adb shell getprop ro.build.version.release)"
  echo "| OEM: $(adb shell getprop ro.product.brand)"
  echo "| Name: $(adb shell getprop ro.product.device)"
  echo "| SOC: $(adb shell getprop ro.board.platform)"
  echo "| Build: $(adb shell getprop ro.build.display.id)"
  echo "| Serial: $SERIAL"
  echo "| Status: $STATUS"
  echo "| Location: $USBADB"
  read -p "Press Enter to quit"
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
  echo "- Device Supported: Xiaomi Mi2(s), Mi3(w), Mi4(w) RedMi 1S"
  echo "- Disclaimer: this program may void your warranty. Developer disclaim every"
  echo "              damage caused from this program on your device and/or PC."
  echo ""
  echo "- Sources:  https://github.com/linuxxxxx/XiaomiTool"
  echo " "
  echo " "
  read -p "Press enter to go back"
  home
  }

isavailable () {
  adb wait-for-device
}

# <- Setup ->
detect_device() {
    clear
    adb kill-server
    adb start-server
    clear
    echo "Waiting for device ...."
    isavailable
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
  BACKUPDIR=~/XiaomiTool/Backups
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
  if [[ "$BUILD" == 4.4* ]]; then
      androidv=kk
  else
      androidv=jb
  fi
}

disclaimer
detect_device
