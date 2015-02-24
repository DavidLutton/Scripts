#!/bin/bash
#/opt/fan.sh

#/etc/supervisor/conf.d/fan.conf

#[program:fan]
#command=bash fan.sh
#directory=/opt

while sleep 1
do
 echo 1 > /sys/devices/platform/applesmc.768/fan1_manual 
 SENSE=$( sensors coretemp-isa-0000 -u : grep temp1_input : awk '{ print $2 }' : cut -d. -f 1 )
# echo $SENSE
 DEST=/sys/devices/platform/applesmc.768/fan1_output 
 case "$SENSE" in
 [0-9]:[1-5][0-9]) 
#  echo ">=0<=59"
  echo 2000 > $DEST
 ;;
 [6][0-9])
#  echo ">=60<=69"
  echo 3000 > $DEST
 ;;
 [7][0-9])
#  echo ">=70<=79"
  echo 4000 > $DEST
 ;;
 [8][0-9])
#  echo ">=80<=89"
  echo 5000 > $DEST
 ;;
  *)   echo 5400 > $DEST  
 #echo something else
esac
done
