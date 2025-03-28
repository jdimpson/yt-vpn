#!/bin/sh
if test -x /entrypoint-ovpn.sh; then
	/entrypoint-ovpn.sh &
else
	# check for older openvpn-client image
	if test -x /entrypoint.sh; then
		/entrypoint.sh &
	else
		echo "Could not find or execute openvpn client entrypoint" >&2;
		exit 1;
	fi
fi

YT=/usr/local/bin/yt-dlp


