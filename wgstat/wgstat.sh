#!/bin/ksh

( cat peers.txt ; ifconfig wg0 ) | awk -f wgstat2.awk
