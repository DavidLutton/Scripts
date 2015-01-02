#!/bin/bash

RESULTS=$( find . -name "*.mkv" -a ! -name "*.mkv.mkv" )

for FILE in $RESULTS
do
 CONF="-codec:v h264 -codec:a copy -map 0:v -map 0:a:0"
 CONF_="-codec:s copy -map 0:s"
 nice -n 20 avconv -i $FILE $CONF $CONF_ $FILE.mkv && mv $FILE $FILE.orig && rm  $FILE.orig
 nice -n 20 avconv -i $FILE $CONF  $FILE.mkv && mv $FILE $FILE.orig && rm  $FILE.orig

done
