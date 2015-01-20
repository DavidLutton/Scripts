#!/bin/bash
#unset a i

while IFS= read -r -d $'\0' FILE; do
 PROBE=$( avprobe "$FILE" -loglevel quiet -show_streams -of json | grep codec_type | cut -d'"' -f 4 | sort -d | uniq | tr "\n" " " )
 CONF=""

 case "$PROBE" in

  "audio subtitle video ")
  CONF="$CONF -codec:v h264 -map 0:v"
  CONF="$CONF -codec:a copy -map 0:a:0"
  CONF="$CONF -codec:s copy -map 0:s"
  ;;

  "audio video ")
   CONF="$CONF -codec:v h264 -map 0:v"
   CONF="$CONF -codec:a copy -map 0:a:0"
  ;;

  *)
   echo "$PROBE"
   exit
  ;;

 esac

 avconv -i "$FILE" $CONF "$FILE.mkv"
# STATE="100"
 echo "$CONF"

 STATE="$?"
 echo "$STATE"
 if [ "$STATE" = "0" ]
 then
  mv -v "$FILE" "$FILE.orig"
  rm -v "$FILE.orig"
 fi
 read foo

done < <(find . -name "*.mkv" -a ! -name "*.mkv.mkv"  -type f -print0)
