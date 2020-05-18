#!/dev/sh
WAN_IP="$(nvram get wan_gateway)"
WAN_IF="$(ip route | sed -n "s/.*via $WAN_IP dev \([[:alnum:]]*\).*/\1/p")"
if ifconfig|grep -qF ‘wg0’; then
    TUN_IF=‘wg0’
elif ps -w|grep -vE ‘grep|server_tap|server_tun’|grep -qF -- ‘/usr/sbin/openvpn --dev’; then
    TUN_IF="$(ps -w|grep -F -- ‘/usr/sbin/openvpn --dev’|grep -vE ‘grep|server_tap|server_tun’|sed -n -- 's/.*openvpn --dev \([[:alnum:]]*\).*/\1/p')"
else
    TUN_IF=‘’
fi
echo "WAN Interface name: $WAN_IF"
[ "$TUN_IF" ] && echo "VPN Interface name: $TUN_IF" || echo 'No VPN or Wireguard (client) detected'
echo 'Thank you for testing :-)'
