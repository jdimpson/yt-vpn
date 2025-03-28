Quick and dirty extension of [my openvpn-client container](https://github.com/jdimpson/openvpn-client) that has [yt-dlp](https://github.com/yt-dlp/yt-dlp) installed as well. Run the container just like you would the openvpn-client, then use `docker exec` to either run `yt-dlp` directly, or run `/exec-ytdlp.sh` (recommended).

Run `/exec-ytdlp.sh` (under `docker exec`) with the same arguments you'd pass to `yt-dlp`. It will automatically change to the folder `/youtube` (which you should *bind mount* to where ever you want the downloaded videos to go). If the download fails, `/exec-ytdlp.sh` will send a [hard restart signal](https://openvpn.net/community-resources/controlling-a-running-openvpn-process/) to `openvpn-client` before attempting to repeat the download. (Why you'd want it to do this is your business.) It will restart / retry 10 times before giving up. Set the environment variable `ATT` to some other integer to change how many retries you want.

Example that will fail and retry twice:
``` 
docker exec -it -e ATT=2 yt-openvpn-container /exec-ytdlp.sh https://youtu.be/NOSUXHVIDEOID
``` 
