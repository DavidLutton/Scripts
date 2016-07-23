#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import struct

import sys
from optparse import OptionParser


def wake_on_lan(macaddress):
    """ Switches on remote computers using WOL. """

    data = ('FFFFFFFFFFFF' + (macaddress * 20) + 'ABCD').encode()
    send_data = b''
    for i in range(0, len(data), 2):
        send_data += struct.pack(b'B', int(data[i: i + 2], 16))

        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        sock.sendto(send_data, ('255.255.255.255', 7))

        print("Sent WOL to " + macaddress)


def if_sep_remove(len_without, len_with, first_sep, data):
    if len(data) == len_without:
        pass
    elif len(data) == len_without + len_with:
        data = data.replace(data[first_sep], '')
    else:
        raise ValueError('Incorrect data format')
    return(data)


def main():
    # python3 wol.py 001122334455 00:44:33:22:11:66 55-44-33-22-11-00
    parser = OptionParser()
    (options, args) = parser.parse_args()
    for arg in args:
        wake_on_lan(if_sep_remove(12, 5, 2, arg))


if __name__ == "__main__":
    main()
