#!/bin/ksh

## Create my_ keys

mkdir -p /etc/wireguard
chmod 700 /etc/wireguard
cd /etc/wireguard

openssl rand -base64 32 > my_secret.key
chmod 600 my_secret.key

ifconfig wg0 create wgport 51820 wgkey `cat /etc/wireguard/my_secret.key`
ifconfig wg0 | grep 'wgpubkey' | cut -d ' ' -f 2 > my_public.key
echo COPY TO PEERs:
cat my_public.key


## Enable routing

cat <<EOF >> /etc/sysctl.conf

net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1

EOF

echo !!! Check your /etc/sysctl.conf file!


## Create wg0 config

cd /etc

cat <<EOF >> /etc/hostname.wg0
wgkey $(cat /etc/wireguard/my_secret.key)
inet 10.0.0.1 255.255.255.0 NONE
wgport 51820
up

EOF

echo !!! Check your /etc/hostname.wg0 file!

# Start wg0

sh ./netstart wg0
ifconfig wg0


## Add pf rules

cat <<EOF >> /etc/pf.conf

pass in on wg0
pass in inet proto udp from any to any port 51820
pass out on egress inet from (wg0:network) nat-to (vio0:0)

EOF

echo !!! Check your /etc/pf.conf file!

pfctl -f /etc/pf.conf


## Monitor network connections

netstat -ln
