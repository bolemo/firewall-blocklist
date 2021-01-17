#!/bin/sh
_TAIL=100; _LSCI="$(/usr/bin/cut -d. -f1 /proc/uptime)"
eval "$(aegis _env)"
_LSC=/tmp/aegis_lsc; echo "$_LSCI">$_LSC; trap "/bin/rm -f $_LSC >/dev/null 2>&1; exit" INT TERM
  _BT=$(( $(/bin/date +%s) - _UPT ))
  _RSIZE=$(wc -l <$LOG_FILE)
while /usr/bin/awk -F: '
function namefromip(ip){
cmd="/usr/bin/awk '"'"'$1==\""ip"\"{print $3;exit}'"'"' /tmp/netscan/attach_device";cmd|getline nm;close(cmd);
if (!nm) {cmd="/usr/bin/awk '"'"'$1==\""ip"\"{print NF;exit}'"'"' /tmp/dhcpd_hostlist /tmp/hosts";cmd|getline nm;close(cmd)}
if (nm) {nm=nm"("ip")"} else {nm=ip}
return nm}
function protoname(proto){return (proto~/^[0-9]+$/)?"[protocol "proto"]":proto}
function getval(n){i=index(l[c]," "n"=");if(i==0)return;str=substr(l[c],i+length(n)+2);i=index(str," ");str=substr(str,0,i-1);return str}
function floored(a){return (a<0)?0:a}
function pline(iface){
if (IN==iface){REM=SRC;RPT=SPT;LPT=DPT;DIR="\033[1;35mincoming\033[0m";DIR1="from";DIR2="to";
if (OUT=="") {LOC=DST; LNM=(DST=="255.255.255.255")?"broadcast":"router"}
else {LOC=namefromip(DST); LNM="LAN"}
} else if (OUT==iface){REM=DST;RPT=DPT;LPT=SPT;DIR="\033[1;33moutgoing\033[0m";DIR1="to";DIR2="from";
if (IN=="") {LOC=SRC; LNM="router"}
else {LOC=namefromip(SRC); LNM="LAN"}
} else return 0;
return 1;}

$1$2>'$(cat $_LSC)'{ts[++b]=$1;l[b]=$0} END

{c=floored(b-'$_TAIL');while (c++<b){
  PT=strftime("%F %T", ('$_BT'+ts[c]));
  IN=getval("IN"); OUT=getval("OUT"); SRC=getval("SRC"); DST=getval("DST"); PROTO=protoname(getval("PROTO")); SPT=getval("SPT"); DPT=getval("DPT");
  if (pline("brwan")) {IFACE="WAN"} else if (pline("")) {IFACE="VPN"}
  if (RPT) {RPT=":"RPT}; if (LPT) {LPT=":"LPT}
  printf("%s: Blocked %s %s packet %s %s:\033[1;35m%s%s\033[0m %s %s:\033[1;33m%s%s\033[0m\n",PT,DIR,PROTO,DIR1,IFACE,REM,RPT,DIR2,LNM,LOC,LPT)
} print $1$2 >"'$_LSC'"}'; do
sleep 1
done </var/log/log-aegis
