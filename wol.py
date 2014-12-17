#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import struct

import sys
from optparse import OptionParser


def if_sep_remove(len_without,len_with,first_sep,data):
 if len(data) == len_without:
  pass
 elif len(data) == len_without + len_with:
  data = data.replace(data[first_sep],'')
 else:
  raise ValueError('Incorrect data format')
 return(data)
#macaddress=if_sep_remove(12,5,2,"001122334455")
#macaddress=if_sep_remove(12,5,2,"00-11-22-33-44-55")

def wake_on_lan(macaddress):
 """ Switches on remote computers using WOL. """
 macaddress=if_sep_remove(12,5,2,macaddress)
 # Pad the synchronization stream
 data = b'FFFFFFFFFFFF' + (macaddress * 20).encode()
 send_data = b''
  
 # Split up the hex values in pack
 for i in range(0, len(data), 2):
  send_data += struct.pack(b'B', int(data[i: i + 2], 16))
 # Broadcast it to the LAN
 sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
 sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
 sock.sendto(send_data, ('255.255.255.255',7))
 print("Sent WOL to "+macaddress)

def main():

 parser = OptionParser()
# parser.add_option("-m", "--mac", dest="mac", help="write mac WOL packet", metavar="WOL")

 (options, args) = parser.parse_args()
 #print(options)
# print(args)
 for arg in args:
#  print(arg)
  wake_on_lan(arg)
  

if __name__ == "__main__":
 main()
