#!/usr/bin/env python3
# -*- coding: latin-1 -*-

import socket
import struct

def if_sep_remove(len_without,len_with,first_sep,data):
 if len(data) == len_without:
  return(data)
 elif len(data) == len_without + len_with:
  data = data.replace(data[2],'')
 else:
  raise ValueError('Incorrect data format')
 return(data)

#macaddress=if_sep_remove(12,5,2,"00118566A6E0")
#macaddress=if_sep_remove(12,5,2,"00-11-85-66-A6-E0")
#print(macaddress)

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

wake_on_lan("001122334455")

