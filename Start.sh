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
setup (){
  RES=res
  Mi2=Aries
  Mi3=Cancro
  RED1S=armani
  # MIPAD=mocha
  ROOTQCOM=$RES/root.zip # < don't ask the meaning of ROOTQCOM, it's a word like HOME :P
  ROOTMIUI=$RES/miui_root.zip
  ACTION=$1
  DIR=/sdcard/tmp
  BACKUPDIR=~/XiaomiTool/Backups
  CAMDIR=/sdcard/DCIM/Camera
  ISCRAZY=0 # < Do not set this to 1 xD
  a=0 # < the $a, use it if u want to write 0
  detect_device
  }

becrazy () {
  # The best thing you will find here
  # First, let's f* up user
  trap "" 2 20
  # C ya ctrl-c & ctrl-z :P
  #
  # And now a command that will make the user crazy, he/she will shoot at his/her pc :D
  # This prevents damages to devices
  while :; do echo 'YOU ARE CRAZY !!!'; sleep 1; done
  }

headerprint () {
    if  [ "$ISCRAZY" = "1" ]
      then
        echo "Crazy Mode is on!!"
        echo "User is crazy, to prevent damage..."
        clear
        sleep 2
        while :; do becrazy ; sleep 1; done
        break
  else
  clear
  echo "################################"
  echo " Xiaomi Tool"
  echo " $DID"
  echo "################################"
  echo " "
  fi
  }

home () {
  headerprint
  echo "1- Manage backups"
  echo "2- Push and Pull"
  echo "3- Shell"
  echo "4- Install an apk"
    if [ "$adba" = 1 ]; then
        echo "5 - Install CWM recovery"
        echo "6- Install a ROM"
        echo "7- Flash a zip"
        echo "8- Root"
    elif [ "$adba" = 2 ]; then
        echo "5- Install TWRP recovery"
        echo "7- Flash a zip"
        echo "8- Root"
    fi
    if [ "$androidv" = "kk" ]
      then
       echo "9- Switch to Dalvik"
        echo "10- Switch to Art"
        echo "11 - Record Screen"
    fi
    echo " "
    echo "0- Exit         00-About"
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
      recovery1
    elif  [ "$Choice" == 6 ]; then
      rom
    elif  [ "$Choice" == 7 ]; then
      zip
    elif [ "$Choice" == 8 ]; then
      root
    elif [ "$Choice" == 9 ]; then
        bdedalvik
    elif [ "$Choice" == 10 ]; then
      beart
    elif [ "$Choice" == 11 ]; then
      recorder
    elif  [ "$Choice" == 0 ]; then
      close
    elif  [ "$Choice" == 00 ]; then
      about
    elif  [ "$Choice" = "make me a sandwich" ]
      then
        read -p "Do it yourself: " Choice
        if [ "$Choice" = "sudo make me a sandwich" ]
          then
            echo "Setting crazy mode on.."
            ISCRAZY=1
            sleep 3
            home
            break
        else
        echo "Wrong input"
        home
        fi
        break
    else
      echo "Wrong input"
      home
      fi
  }

apk () {
  headerprint
  echo "Apk Installer"
  echo " "
  read -p "Drag your apk here and press ENTER: " APK
  adb install $APK
  sleep 2
  home
  }

recovery1 () {
    if  [ "$DEVICE" = "aries" ]
      then
        recovery2
        break
    elif  [ "$DEVICE" = "cancro" ]
      then
        recovery3
        break
    elif  [ "$DEVICE" = "armani" ]
        then
          recovery4
          break
  else
  echo "Unsupported device.."
  sleep 3
  home
  fi
  }

recovery2 () {
  # aries-device recovery
  headerprint
  echo "Recovery installer"
  adb reboot bootloader
  fastboot devices
  fastboot flash $Mi2/recovery/recovery.img
  fastboot reboot
  echo "Done!"
  sleep 3
  }

recovery3 () {
  # cancro-devices recovery
  headerprint
  echo "Recovery installer"
  adb reboot bootloader
  fastboot devices
  fastboot flash $Mi3/recovery/recovery.img
  fastboot reboot
  echo "Done!"
  sleep 3
  }

recovery4 () {
  # RedMi 1S recovery
    headerprint
    echo "Recovery installer"
    adb reboot bootloader
    fastboot devices
    fastboot flash $RED1S/recovery/recovery.img
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
  adb shell "echo -e '--sideload' > /cache/recovery/command" # Dunno if CWM can execute more than one command but let's try, at least it won't wipe data, an echo will be show waring user about this
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
  # Flash files using adb sideload + aosp recovery commands
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
  # Sideload a Root-flashable package to root the device
  # It needs a custom recovery
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

back1 () {
  headerprint
  echo "Backup Manager"
  echo " "
  echo "1- Backup    2-Restore"
  echo " "
  echo "0- Go Back"
  read -p "?" Choice
    if [ "$Choice" = "1" ]
      then
        backup
        break
    elif [ "$Choice" = "2" ]
      then
        restore
        break
    elif [ "$Choice" = "0" ]
      then
        home
        break
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

pnp () {
  headerprint
  echo "Push and Pull"
  echo " "
  echo "1- Push a file "
  echo "2- Import Camera Photos"
  echo " "
  echo "0- Go Back"
  read -p "?" Choice
    if [ "$Choice" = "1" ]
      then
        push
        break
    elif [ "$Choice" = "2" ]
      then
        camera
        break
    elif [ "$Choice" = "0" ]
      then
        home
        break
    else
    echo "Wrong input"
    sleep 2
    pnp
    fi
  }

push () {
  # Push files
  headerprint
  echo "Push a file"
  echo " "
  read -p "Drag your file here (one): " FILE
  adb push $FILE /sdcard
  read -p "Press ENTER"
  home
  }

camera () {
  # Pull files from DCIM to Camera dir
  headerprint
  echo "Import Camera Photos"
  read -p "Press enter to start"
  adb pull $CAMDIR Camera
  read -p "Press ENTER"
  home
  }

close () {
  sleep 1
  echo -n "Quitting."
  sleep 1
  adb kill-server
  echo -n ...
  sleep 2
  killall fastboot
  clear
  exit 1
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

detect_device() {
    # This will read device prop from build.prop
    # Then it will detect if it's a Mi* device
    clear
    adb kill-server
    adb start-server
    clear
    echo "Waiting for device $DEVICE_ID ...."
    DID=$(adb shell getprop ro.product.model)
    DEVICE=$(adb shell getprop ro.product.device)
    if [[ "$DEVICE" == aries* ]]; then
        # MIx = Mi-series device
        mix=1
        DEVICE_ID=$Mi2
        detect_android
    elif [[ "$DEVICE" == cancro* ]]; then
        mix=1
        DEVICE_ID=$Mi3
        detect_android
    elif [[ "$DEVICE" == armani* ]]; then
      mix=0
      DEVICE_ID=$RED1S
      detect_android
  #  elif [[ "$DEVICE" == mocha* ]]; then # <- Waiting for a Custom recovery
    #  adba=2
     # detect_android
    else
        echo "Device not supported: $DEVICE"
        sleep 2
        exit 0
    fi
}

detect_android() {
    # Check if device is running KK to enable some features
    clear
    BUILD=$(adb shell getprop ro.build.version.release)
    if [[ "$BUILD" == 4.4* ]]; then
        androidv=kk
        home
    else
        androidv=jb
        home
    fi
}

beart () {
  headerprint
  echo "ART RunTime"
  adb reboot recovery
  # Wipe dalvik cache
  adb shell rm -rf /data/dalvik-cache
  # Switch ro libart
  adb shell 'echo -n libart.so > /data/property/persist.sys.dalvik.vm.lib'
  adb reboot
  echo "Done!"
  home
}

bedalvik () {
  headerprint
  echo "Dalvik RunTime"
  adb reboot recovery
  # Wipe dalvik cache
  adb shell rm -rf /data/dalvik-cache
  # Switch to libdalvik
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

#
# Init the Tool
#
setup
