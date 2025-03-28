#!/bin/sh

OVPNID=1; # relies on /entrypoint-ytdlp.sh doing an exec to become openvpn
YT=/usr/local/bin/yt-dlp;
MGTPORT=7505;

cd /youtube || exit 1;
RC=1;
if test -z $ATT; then
	ATT=10;
fi
while test $ATT -gt 0; do

	# check status, per https://github.com/OpenVPN/openvpn/blob/30a66f72a98d7a583c524f826a94c4d3e5081688/doc/management-notes.txt#L427
	STATE="UNKNOWN";
	while test "$STATE" != "CONNECTED"; do
		S=$(echo state | nc localhost $MGTPORT | grep -Ev '(END|>INFO)');
		STATE=$(echo "$S" | awk -F, '{print $2}'); 
		SRVIP=$(echo "$S" | awk -F, '{print $5}'); 
		sleep 3;
	done
	echo "Conneected to ovpn server $SRVIP";

	# try to download
	$YT $*;
	RC=$?;
	if test $RC -gt 0; then
		echo failed. connecting to different vpn and trying again;
		kill -HUP $OVPNID
		# echo signal SIGHUP | nc localhost $MGTPORT;
		ATT=$(expr $ATT - 1);
		sleep 3;
	else
		break;
	fi
done
exit $RC;

# example
#   1740894141,CONNECTED,SUCCESS,10.10.0.6,198.44.128.98,1196,,
# The output format consists of up to 9 comma-separated parameters:
#  (a) the integer unix date/time,
#  (b) the state name,
#  (c) optional descriptive string (used mostly on RECONNECTING
#      and EXITING to show the reason for the disconnect),
#  (d) optional TUN/TAP local IPv4 address
#  (e) optional address of remote server,
#  (f) optional port of remote server,
#  (g) optional local address,
#  (h) optional local port, and
#  (i) optional TUN/TAP local IPv6 address.
