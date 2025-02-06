#!/bin/ksh

## $1 <= peer No = IP last octet

echo "Peer _$1_ PUBLIC key? "
read _pubk

_psk=$(openssl rand -base64 32)

echo $_pubk > /etc/wireguard/peer$1_public.key
echo $_psk > /etc/wireguard/peer$1_shared.key

cat <<EOF >> /etc/hostname.wg0
wgpeer $_pubk wgaip 10.0.0.$1/32 wgpka 10 wgpsk $_psk
EOF

_endp=$(ifconfig vio0 | grep 'inet' | cut -d ' ' -f 2)

echo "=== Your config is : ==="
echo ""
echo "[Interface]"
echo "Address = 10.0.0.$1/24 # peer wgaip"
echo "PrivateKey = my_private_key"
echo "MTU = 1280"
echo "DNS = 10.0.0.1"
echo ""
echo "[Peer]"
echo "PublicKey =" $(cat /etc/wireguard/my_public.key)
echo "PresharedKey =" $_psk " # preshared key"
echo "AllowedIPs = 0.0.0.0/0, ::/0 # nets to route into tunnel"
echo "Endpoint = $_endp:51820"
echo ""
