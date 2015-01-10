#!/bin/bash

SITE="http://ipxe.daln.org/"
EMBED="iPXE.ipxe"
GIT="git://git.ipxe.org/ipxe.git"
DIR=$( echo "$GIT"  | cut -d/ -f4 | cut -d. -f1 ) # git://fqdn/REPO.git  - $REPO === $DIR 

if [ -e "$DIR" ]
then
  cd "$DIR"
  git clean -d -x -f #-n
  git remote update
  cd ..
else
  git clone "$GIT"
fi

cat > "$EMBED" << EOF
#!ipxe
:retry_dhcp
dhcp || goto retry_dhcp
chain $SITE
EOF

cd "$DIR"/src

for TARGET in "undionly.kpxe" "ipxe.usb" "ipxe.lkrn"
do
  make bin/"$TARGET" EMBED=../../"$EMBED" && mv -v bin/"$TARGET" ../../"$TARGET"
done

cd - && rm -v "$EMBED"
