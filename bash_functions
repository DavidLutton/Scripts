#!/bin/bash

function venv {
	if [ -z "$1" ]
	then
		venvs
	else
		if [ -e "$HOME/ENV/pyvenv/$1/venv/bin/activate" ]
		then
			source "$HOME"/ENV/pyvenv/"$1"/venv/bin/activate
		else
			echo "$1 activate script not present"
		fi
	fi	
	#python3 "$2" "${@:3}"
	#deactivate
	# [arrays - Remove first element from $@ in bash - Stack Overflow](http://stackoverflow.com/questions/2701400/remove-first-element-from-in-bash)
}
function venvs {
	find "$HOME"/ENV/pyvenv/. -maxdepth 1 -type d | grep "\./" | cut -d'/' -f7
}

function imap {
	imapfilter

	echo offlineimap
	offlineimap

}

function cleanfire {
	# Start a clean instance of Firefox
	## Yes I know that private tabs exist but sometimes
	#		combinations of addons mangle sites
  IDN=$( uuidgen )
  mkdir /tmp/"$IDN" && firefox -no-remote -profile /tmp/"$IDN"
  rm -rfv /tmp/"$IDN"
}

function jekyll-up {
  echo "Domain: $1"
  domain="$1"
  SRC="/home/$USER/Public/dot.$domain/"
  LDEST="/home/$USER/Public/deploy_dot.$domain/"

  if [ -e "$SRC" ]
  then
    jekyll build -s  "$SRC" -d "$LDEST"
    if [ "$?" == 0 ]
    then
     rsync "$LDEST"  -av "$SERVER":"$HPATH/$domain/deploy/" --progress  --delete
    fi
  fi
}

function jekyll-lo {
  echo "Domain: $1"
  domain="$1"
  SRC="/home/$USER/Public/dot.$domain/"
  LDEST="/home/$USER/Public/deploy_dot.$domain/"

  if [ -e "$SRC" ]
  then
    jekyll serve -s  "$SRC" -d "$LDEST"
  fi
}

# simple rsync wrapper to find targets to mirror
# that have a id.yaml in the top of dir
# a name to store the mirrored contents to
## Change to support a better yaml`ish` parser like https://gist.github.com/pkuczynski/8665367 or  https://github.com/0k/shyaml
function rsync-pull {
	#name: USB32
	#uuid: 9945656a-3adf-417c-bd1c-f966a67ae0fc
	# uuidgen > id.yaml


	find /media/"$USER"/ -maxdepth 2 -name id.yaml -exec realpath '{}' \; 2>/dev/null | while read line
	do
	   echo "$line"
	   DEST=$( cat "$line" | grep name | cut -d':' -f2 | tr -d ' ' )
	   DIR=$(  echo "$line" | cut -d/ -f-4 )
	   echo "$DIR"
	   rsync -av --progress "$DIR"/ /mnt/SSD/rsync/"$DEST"/ # "$@"
	done


	# Refs
	# [shell - bash/fish command to print absolute path to a file - Stack Overflow](http://stackoverflow.com/questions/3915040/bash-fish-command-to-print-absolute-path-to-a-file/3915075#3915075)
	# [linux - Looping through the content of a file in Bash? - Stack Overflow](http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash/1521470#1521470)


}

function rsync-push {
	find /media/"$USER"/ -maxdepth 2 -name id.yaml -exec realpath '{}' \; 2>/dev/null | while read line
	do
	   #echo "$line"
	   DEST=$( cat "$line" | grep name | cut -d':' -f2 | tr -d ' ' )
	   DIR=$(  echo "$line" | cut -d/ -f-4 )
	   rsync -av --progress /media/"$USER"/SSD/rsync/"$DEST"/ "$DIR"/ # "$@"
	done

}

function yt-dl {
	youtube-dl --output "%(uploader)s/%(upload_date)s-%(id)s-^-%(uploader)s-^-%(title)s.%(ext)s" --continue --write-description --write-info-json --write-thumbnail --ignore-errors --restrict-filenames "$@"
}
