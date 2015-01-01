#!/bin/bash

Version="1.8.11"
wget http://www.makemkv.com/download/makemkv-{oss,bin}-$Version.tar.gz
tar xfvz makemkv-bin-$Version.tar.gz
tar xfvz makemkv-oss-$Version.tar.gz

cd makemkv-oss-$Version/
./configure
make
sudo make install
cd ..
cd makemkv-bin-$Version/
make
sudo make install
