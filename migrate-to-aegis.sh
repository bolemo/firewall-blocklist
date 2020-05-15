#!/bin/sh
/opt/bolemo/script/firewall-blocklist clean
rm -f /opt/bolemo/script/firewall-blocklist
[ -e /opt/bolemo/etc/firewall-blocklist.sources ] && mv /opt/bolemo/etc/firewall-blocklist.sources /opt/bolemo/etc/aegis.sources
[ -e /opt/bolemo/etc/firewall-blocklist.custom-bl.netset ] && mv /opt/bolemo/etc/firewall-blocklist.custom-bl.netset /opt/bolemo/etc/aegis.custom-blacklist.netset
[ -e /opt/bolemo/etc/firewall-blocklist.custom-wl.netset ] && mv /opt/bolemo/etc/firewall-blocklist.custom-wl.netset /opt/bolemo/etc/aegis.custom-whitelist.netset
[ -e /opt/bolemo/etc/firewall-blocklist-bl.netset ] && rm -f /opt/bolemo/etc/firewall-blocklist-bl.netset
[ -e /opt/bolemo/etc/firewall-blocklist-wl.netset ] && rm -f /opt/bolemo/etc/firewall-blocklist-wl.netset
