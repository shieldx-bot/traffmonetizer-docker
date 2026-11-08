# TraffMonetizer CLI runner — deployable on Caasify, Render, Fly.io, Railway...
#
# The official traffmonetizer/cli_v2 image is FROM scratch (no shell, no HOME):
# the CLI exits on PaaS platforms. This single-stage image fixes that:
#   * busybox provides the shell and a tiny HTTP status page on $PORT
#   * HOME=/tmp lets the CLI persist its device id
#   * start.sh auto-restarts the CLI
#
# Required environment variables:
#   TM_TOKEN        - your TraffMonetizer app token (REQUIRED)
#   TM_DEVICE_NAME  - device name on the TM dashboard (default: render2)
#   PORT            - HTTP status page port (default: 8080)
#
# The bundled bin/cli is the official TraffMonetizer linux/amd64 binary
# extracted from traffmonetizer/cli_v2:latest.

FROM busybox:stable
COPY bin/cli /usr/local/bin/cli
COPY start.sh /start.sh
COPY www /www
ENV HOME=/tmp \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PORT=8080 \
    TM_DEVICE_NAME=render2
EXPOSE 8080
ENTRYPOINT ["/bin/busybox", "sh", "/start.sh"]
