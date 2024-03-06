#!/usr/bin/env python

'''
CS352 Assignment 1: Network Time Protocol
You can work with 1 other CS352 student

DO NOT CHANGE ANY OF THE FUNCTION SIGNATURES BELOW
'''
import time
import socket
import struct
from datetime import datetime


def getNTPTimeValue(server="time.apple.com", port=123) -> (bytes, float, float):
    temp_pkt = struct.pack('48s', b'\x1b' + 47 * b'\0')
    T1 = time.time()

    sockt = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sockt.sendto(temp_pkt, (server, port))
    pkt, temp = sockt.recvfrom(1024)
    T4 = time.time()

    return (pkt, T1, T4)


def ntpPktToRTTandOffset(pkt: bytes, T1: float, T4: float) -> (float, float):
    T2_seconds = struct.unpack('!I', pkt[32:36])[0]
    T2_fractions = struct.unpack('!I', pkt[36:40])[0]
    T3_seconds = struct.unpack('!I', pkt[40:44])[0]
    T3_fractions = struct.unpack('!I', pkt[44:48])[0]


    T2 = (T2_seconds + (T2_fractions / 2 ** 32)) - 2208988800
    T3 = (T3_seconds + (T3_fractions / 2 ** 32)) - 2208988800

    rtt = (T4 - T1) - (T3 - T2)
    offset = ((T2 - T1) + (T3 - T4)) / 2

    return (rtt, offset)

def getCurrentTime(server="time.apple.com", port=123, iters=20) -> float:
    offsets = []
    for i in range(iters):
        pkt, T1, T4 = getNTPTimeValue(server, port)
        rtt, offset = ntpPktToRTTandOffset(pkt, T1, T4)
        offsets.append(offset)

    avg_offset = sum(offsets) / len(offsets)
    currentTime = time.time() + avg_offset

    return currentTime

if __name__ == "__main__":
    print(getCurrentTime())