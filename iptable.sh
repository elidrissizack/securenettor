#!/bin/bash

export IF_RESEAU="wlp1s0"
iptables -F
iptables -X 

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 10000 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 3218 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 9050 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport smtp -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport pop3 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport imap -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 8118 -j ACCEPT
iptables -A INPUT -i $IF_RESEAU -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 445 -j ACCEPT

iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT

##configuration server tor
iptables -t filter -A INPUT  -p tcp --source-port 1024 --destination-port 9050  -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --destination-port 1024 --source-port 9050  -m state --state ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o $IF_RESEAU --match state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i $IF_RESEAU --match state --state ESTABLISHED,RELATED -j ACCEPT

iptables-save > /etc/iptables/iptables.rules
systemctl restart iptables.service
