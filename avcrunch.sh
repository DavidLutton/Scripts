#!/bin/bash
#unset a i

while IFS= read -r -d $'\0' FILE; do

 PROBE=$(  avprobe "$FILE" 2>&1  | grep Stream | cut -d" " -f 7 | sort -d | uniq  | cut -d":" -f1 | tr "\n" ' ' )

 CONF=""
 case "$PROBE" in

  "Audio Subtitle Video ")
  CONF="$CONF -codec:v h264 -map 0:v"
  CONF="$CONF -codec:a copy -map 0:a:0"
  CONF="$CONF -codec:s copy -map 0:s"
  ;;

  "Audio Video ")
   CONF="$CONF -codec:v h264 -map 0:v"
   CONF="$CONF -codec:a copy -map 0:a:0"
  ;;

  *)
   echo "$PROBE"
   exit
  ;;

 esac


 avconv -i "$FILE" $CONF "$FILE.mkv"

 STATE="$?"
 echo "$STATE"
 if [ "$STATE" = "0" ]
 then
  mv -v "$FILE" "$FILE.orig"
  rm -v "$FILE.orig"
 fi
 read foo


done < <(find . -name "*.mkv" -a ! -name "*.mkv.mkv"  -type f -print0)
