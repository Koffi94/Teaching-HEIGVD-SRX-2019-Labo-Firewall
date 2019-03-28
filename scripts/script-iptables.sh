#!/bin/bash

###1
#LAN-WAN
iptables -A FORWARD -p udp -s 192.168.100.0/24 -o eth0 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 53 -j ACCEPT

#WAN-LAN
iptables -A FORWARD -p udp -i eth0 --sport 53 -d 192.168.100.0/24 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --sport 53 -d 192.168.100.0/24 -j ACCEPT

###2
#LAN- DMZ
iptables -A FORWARD -p icmp -s 192.168.100.0/24 --icmp-type 8 -d 192.168.200.0/24 -j ACCEPT
iptables -A FORWARD -p icmp -s 192.168.200.0/24 --icmp-type 0 -d 192.168.100.0/24 -j ACCEPT

#LAN-WAN
iptables -A FORWARD -p icmp -s 192.168.100.0/24 -o eth0 --icmp-type 8 -j ACCEPT
iptables -A FORWARD -p icmp -i eth0 --icmp-type 0 -d 192.168.100.0/24 -j ACCEPT

#DMZ-LAN\
iptables -A FORWARD -p icmp -s 192.168.200.0/24 --icmp-type 8 -d 192.168.100.0/24 -j ACCEPT
iptables -A FORWARD -p icmp -s 192.168.100.0/24 --icmp-type 0 -d 192.168.200.0/24 -j ACCEPT

###3-4
#LAN-WAN
iptables -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 443 -j ACCEPT

#WAN-LAN
iptables -A FORWARD -p tcp -i eth0 --sport 80 -d 192.168.100.0/24 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --sport 8080 -d 192.168.100.0/24 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --sport 443 -d 192.168.100.0/24 -j ACCEPT

###5
#WAN-DMZ
iptables -A FORWARD -p tcp -i eth0 -d 192.168.200.3/32 --dport 80 -j ACCEPT

#DMZ-WAN
iptables -A FORWARD -p tcp -s 192.168.200.3/32 -o eth0 --sport 80 -j ACCEPT

#LAN-DMZ
iptables -A FORWARD -p tcp -s 192.168.100.0/24 -d 192.168.200.0/24 --dport 80 -j ACCEPT

#DMZ-LAN
iptables -A FORWARD -p tcp -s 192.168.200.0/24 --sport 80 -d 192.168.100.0/24 -j ACCEPT

###6-7
#Client_in_LAN-DMZ
iptables -A FORWARD -p tcp -s 192.168.100.3/32 -d 192.168.200.0/24 --dport 22 -j ACCEPT

#DMZ-Client_in_LAN
iptables -A FORWARD -p tcp -s 192.168.200.0/24 --sport 22 -d 192.168.100.3/32 -j ACCEPT

#Client_in_Line-eth1
iptables -A INPUT -p tcp -s 192.168.100.3/32 -i eth1 --dport 22 -j ACCEPT

#eth1-Client_in_LAN
iptables -A OUTPUT -p tcp -o eth1 --sport 22 -d 192.168.100.3/32 -j ACCEPT

###8
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP