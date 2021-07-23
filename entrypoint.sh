#!/bin/bash

set -e

set_clash_iptables(){
      iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 1080
      iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 1080
      }

set_clash_iptables

sysctl -w net/ipv4/ip_forward=1

ip addr

exec "$@"
