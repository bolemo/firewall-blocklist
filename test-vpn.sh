WAN_IF1="$(nvram get wan_ifname)"
ifconfig ppp0 >/dev/null 2>/dev/null && WAN_IF2='ppp0' || WAN_IF2='brwan'
ip route | grep -qF 'ppp0' && WAN_IF3='ppp0' || WAN_IF3='brwan'
if ifconfig|grep -qF 'wg0'; then
    TUN_IF='wg0'
elif ps -w|grep -vE 'grep|server_tap|server_tun'|grep -qF -- '/usr/sbin/openvpn --dev'; then
    TUN_IF="$(ps -w|grep -F -- '/usr/sbin/openvpn --dev'|grep -vE 'grep|server_tap|server_tun'|sed -n -- 's/.*openvpn --dev \([[:alnum:]]*\).*/\1/p')"
else
    TUN_IF=''
fi
echo "WAN Interface name method 1: $WAN_IF1"
echo "WAN Interface name method 2: $WAN_IF2"
echo "WAN Interface name method 3: $WAN_IF3"
[ "$TUN_IF" ] && echo "VPN Interface name: $TUN_IF" || echo 'No VPN or Wireguard (client) detected'
echo 'Thank you for testing :-)'
