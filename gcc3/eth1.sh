#!/bin/sh
case "$1" in
  up)
	/sbin/ifconfig eth1 192.168.129.3 netmask 255.255.255.0 up
        ;;
  down)
	/sbin/ifconfig eth1 down
        ;;
  *)
	/sbin/ifconfig eth1
        echo $"Usage: $0 {up|down}"
esac
