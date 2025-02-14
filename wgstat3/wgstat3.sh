#!/bin/ksh

( cat /etc/hostname.wg0 ; ifconfig wg0 ) | awk -f wgstat3.awk
