#!/system/bin/bash

  busybox touch /tmp/outfake.txt
  if [ -f /dev/block/mmcblk0 ]
    then
    echo -e 'Not fake' > /tmp/outfake.txt
    break
  else
    then
    echo -e 'It is a fake!' > /tmp/outfake.txt
    break
  fi
  
