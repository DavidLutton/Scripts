#!/bin/bash
date
#set -x

function pdfiscrypt() { 
 qpdf --show-encryption "$@" 2>/dev/null 1> tmp
 if  [ "$( wc -c tmp )" == "22 tmp" ]
 then
  rm tmp
  return 0
 else
  rm tmp
  return 1
 fi
}


function pdfdecrypt() {
 pass=$( pdfcrack "$1" -n 1 -s -c "ABCDEFGHIJKLMNOPQRSTUVWXYZ" | grep pass | cut -d' ' -f3 )
 qpdf --password='' --decrypt "$1" "$2" 2>/dev/null
 minimumsize=1800
 actualsize=$(wc -c "$2" | cut -f 1 -d ' ')

 if [ $actualsize -ge $minimumsize ]; then
#  echo size is over $minimumsize bytes
  return 0
 else
 # echo size is under $minimumsize bytes
  rm "$2" 
  return 1
 fi

}

function pdfprint0(){
 gs -q -dAutoRotatePages=/None -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$2" -c .setpdfwrite -f "$1" # 2>/dev/null
# gs works on all files so far, but there is nothing lost by keeping the others
# echo $?
 if [ ! -e "$2" ]
 then
  return 1
 else
  
  minimumsize=2500
  actualsize=$(wc -c "$2" | cut -f 1 -d ' ')

  if [ $actualsize -ge $minimumsize ]; then
#  echo size is over $minimumsize bytes
   return 0
  else
 # echo size is under $minimumsize bytes
   rm "$2" 
   return 1
  fi
 fi
}

function pdfprint1(){
 pdftops -level3 -origpagesizes -passfonts "$1" "$3"
 ps2pdf -dAutoRotatePages=/None -dPDFX=true "$3" "$2"
 rm "$2" 
 minimumsize=900
 actualsize=$(wc -c "$2" | cut -f 1 -d ' ')

 if [ $actualsize -ge $minimumsize ]; then
#  echo size is over $minimumsize bytes
  return 0
 else
 # echo size is under $minimumsize bytes
  return 1
 fi
}

function pdfprint2(){
 pdf2ps -dLanguageLevel=3 "$1" "$3"
 ps2pdf -dAutoRotatePages=/None -dPDFX=true "$3" "$2"
 rm "$2"
}

find . ! -name "*.??.pdf" -type f -name "*.pdf" -print0 | while read -d $'\0' file; 
do
 fullpath=$file  # pathfinder http://stackoverflow.com/a/1403489/3459491
 filename="${fullpath##*/}"                      # Strip longest match of */ from start
 dir="${fullpath:0:${#fullpath} - ${#filename}}" # Substring from 0 thru pos of filename
 base="${filename%.[^.]*}"                       # Strip shortest match of . plus at least one non-dot char from end
 ext="${filename:${#base} + 1}"                  # Substring from len of base thru end
 if [[ -z "$base" && -n "$ext" ]]; then          # If we have an extension and no base, it's really the base
  base=".$ext"
  ext=""
 fi

 #   echo -e "$fullpath:\n\tdir  = \"$dir\"\n\tbase = \"$base\"\n\text  = \"$ext\""
 echo -en "\n\n:::: $dir$base.$ext ::::\n"
 
 pdfiscrypt "$dir$base.$ext"
 if [ $? != 0 ] # http://stackoverflow.com/questions/5195607/checking-bash-exit-status-of-several-commands-efficiently
 then 
  #if [ ! -e "$dir$base.dc.$ext" ]
  #then
   pdfdecrypt "$dir$base.$ext" "$dir$base.dc.$ext"
 # else
   #echo "done before"
#  fi
  case "$?" in  # http://www.thegeekstuff.com/2010/07/bash-case-statement/
#   0)  echo -n . ;; 
   0)  echo "Okay : removed restrictions"  ;;
#   3)  echo -n .
   3)  echo "Okay : but may have lost 1/more object" ;;
             # Or DynamicPDF made the original
             # DynamicPDF over counts objects by 1 
   *)  echo "File : $dir$base.$ext is not processed going to fallbacks"  
            # branch for the fallback print functions here 
   pdfprint0 "$dir$base.$ext" "$dir$base.gc.$ext"
   pdfprint1 "$dir$base.$ext" "$dir$base.ts.$ext" "$dir$base.ps" 
   #echo "pdfprint0 status : $?"|| \
   #print2 "$dir$base.$ext" "$dir$base.ns.$ext" "$dir$base.ps"
;;
  esac
 else
  echo "No restrictions: skipping"
 fi

done
