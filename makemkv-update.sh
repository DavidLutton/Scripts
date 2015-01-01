#!/bin/bash 

sudo apt-get install libav-tools pkg-config checkinstall build-essential libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev
version=$( wget "http://www.makemkv.com/download/" -qO- | grep -m 1 "MakeMKV v" | sed -e "s/.*MakeMKV v//;s/ (.*//" )
# Thanks to [mechevar](http://www.makemkv.com/forum2/memberlist.php?mode=viewprofile&u=5355) for sed`fo [here](http://www.makemkv.com/forum2/viewtopic.php?f=3&t=5266) [#](http://dl.dropbox.com/u/18055299/buildMakeMkv.sh)

for package in "bin" "oss"
do
 di=/dev/shm
 cd ${di}/
 dir=${di}/makemkv-${package}-${version}
 file=makemkv-${package}-${version}.tar.gz
 if [ ! -e ${file} ]
 then
  wget http://www.makemkv.com/download/${file}
 fi
 tar xfvz ${file}
 cd ${dir}
 ./configure
 make
 sudo checkinstall --pkgname makemkv_${package}
 rm -rfv ${dir}
done
