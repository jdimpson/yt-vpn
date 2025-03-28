FROM jdimpson/openvpn-client
ENV PIPX_BIN_DIR=/usr/local/bin
RUN apk add python3 pipx ffmpeg jq \
&& adduser -D yt-dlp \
&& mkdir /youtube
RUN pipx -v install "yt-dlp[default,cffi]"
COPY exec-ytdlp.sh /exec-ytdlp.sh
RUN chmod a+x /exec-ytdlp.sh
ENTRYPOINT ["/entrypoint-ovpn.sh"]
