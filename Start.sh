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


#      */*****   var    *****\*

X=~/XiaomiTool
Mi2=~/XiaomiTool/aries
Mi3=~/XiaomiTool/cancro
ROOTURL=http://download.chainfire.eu/372/SuperSU/UPDATE-SuperSU-v1.86.zip?retrieve_file=1
ROOTZIP=~/XiaomiTool/res/root.zip
DEVICE=
ACTION=$1
Choice=
APK=
ZIP=
ROM=
DIR=/sdcard/tmp
BACKUPID=
BACKUPDIR=~/XiaomiTool/Backups
FILE=
CAMDIR=/sdcard/DCIM/Camera
ISCRAZY=0
a=0
trap "" 2 20

#      */*****   HOME    *****\*

becrazy () {
while :; do echo 'YOU ARE CRAZY !!!'; sleep 1; done
}


headerprint () {
  if  [ "$ISCRAZY" = "1" ]
    then
      echo "Crazy Mode is on!!"
      echo "User is crazy, to prevent damage..."
      sleep 2
      while :; do becrazy ; sleep 1; done
      break
else
clear
echo "################################"
echo "# LG L Manager                 #"
echo "# $DEVICE                         #"
echo "################################"
echo " "
fi
}

home () {
headerprint
echo "1- Install         3- Push and Pull"
echo "2- Backup       4- Shell"
echo " "
echo "0- Exit            00-About"
read -p "?" Choice
if  [ "$Choice" = "1" ]
  then
    install
    break
elif  [ "$Choice" = "2" ]
  then
    back1
    break
elif  [ "$Choice" = "3" ]
  then
    pnp
    break
elif  [ "$Choice" = "4" ]
  then
    shelll
    break
elif  [ "$Choice" = "0" ]
  then
    close
    break
elif  [ "$Choice" = "00" ]
  then
    about
    break
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
    fi
    break
else
  echo "Wrong input"
  home
  fi
}

#      */*****   Install    *****\*

install () {
headerprint
echo "Installer"
echo " "
echo "1- Apk       4- Root "
echo "2- Rom     5- Recovery "
echo "3- Mod/Gapps
echo " "
echo "0- Go Back"
read -p "?" Choice
  if  [ "$Choice" = "1" ]
    then
      apk
      break
  elif  [ "$Choice" = "2" ]
    then
      rom
      break
  elif  [ "$Choice" = "3" ]
    then
      zip
      break
  elif  [ "$Choice" = "4" ]
    then
      rootit
      break
  elif  [ "$Choice" = "5" ]
    then
      recovery1
      break
  elif  [ "$Choice" = "0" ]
    then
      home
      break
else
echo "Wrong input"
install
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
  elif  [ "$DEVICE" = "aries" ]
    then
      recovery2
      break
  elif  [ "$DEVICE" = "cancro" ]
    then
      recovery3
      break
else
echo "Unsupported device.."
sleep 3
home
fi
}

recovery2 () {
recovery3 () {
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
headerprint
echo "Recovery installer"
adb reboot bootloader
fastboot devices
fastboot flash $Mi3/recovery/recovery.img
fastboot reboot
echo "Done!"
sleep 3
}

rom () {
headerprint
echo "Rom installer"
adb reboot recovery
echo "Wipe /data now!"
read -p "When you've wiped /data press ENTER"
adb shell  rm -rf /cache/recovery
adb shell mkdir /cache/recovery
adb shell "echo -e '--sideload' > /cache/recovery/command'
adb reboot recovery
adb wait-for-device
read -p "Drag your zip here and press ENTER: " ROM
adb sideload $ROM
echo "Now wait until your phone install rom, about 3 mins"
sleep 360
read -p "If your phone screen is blank with recovery background, press enter or wait"
adb reboot
echo "Done!"
home
}

zip () {
headerprint
echo "Mod installer"
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



# */*** Other ***\*


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
adb pull $CAMDIR $L/Camera
read -p "Press ENTER"
home
}


close () {

sleep 1
echo -n "Quitting."
sleep 1
echo -n ...
sleep 1
echo -n ...
sleep 1
echo -n ...
sleep 2
clear
exit
}

about () {
headerprint
echo "About"
echo " "
echo "- License: Gpl V2"
echo "- Developer: Joey Rizzoli"
echo "- Device Supported: Xiaomi Mi2(s), Mi3(w)"
echo "- Disclaimer: this program may void your warranty. Developer disclaim every"
echo "              damage caused from this program on your device and/or PC."
echo "- Thanks: me (for program) and Michael, Raimondo (for recoveries)"
echo ""
echo "- Sources:  https://github.com/ionolinuxnoparty/XiaomiTool"
echo " "
echo " "
sleep 20
read -p "Press enter to go back"
home
}

detect_device() {
clear
echo "####################"
echo "Connect device..."
sleep 1
echo "Connected device is"
sleep 1
echo "$(adb shell getprop ro.product.device)"
echo "#####################"
sleep 1
echo " "
echo "Select the number based on the code you see above"
echo " "
echo "1- Mi2(s) [aries]"
echo "2- Mi3 [cancro]"
echo " "
read -p "? " Choice
  if [ "$Choice" = "1" ]
    then
      DEVICE=aries
      home
      break
  elif [ "$Choice" = "2" ]
    then
      DEVICE=cancro
      home
      break
  echo "Wrong input, retry"
  sleep 2
  detect_device
  fi
}

if [ "$ACTION" = 0 ] 
    then
      detect_device
elif [ "$ACTION" = 1 ]
    then
      DEVICE=aries
      home
elif [ "$ACTION" = 2 ]
    then
      DEVICE=cancro
      home
elif [ "$ACTION" = 3 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 4 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 5 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 6 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 7 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 8 ]
    then
      ISCRAZY=1
      detect_device
elif [ "$ACTION" = 9 ]
    then
      ISCRAZY=1
      detect_device
fi
