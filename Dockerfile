# TraffMonetizer CLI runner — deployable on Caasify, Render, Fly.io, Railway, Koyeb...
#
# Why this wrapper exists:
#   * The official traffmonetizer/cli_v2 image is built FROM scratch:
#     a single binary, no shell, no HOME, no writable /tmp.
#     The CLI needs HOME to persist its device id, otherwise it exits.
#   * Some platforms (e.g. Render free web services) require the service to
#     listen on an HTTP port; the raw CLI never opens one.
#
# This image adds busybox (shell + httpd) and a start script that:
#   * exports HOME=/tmp so the CLI can persist its device id
#   * serves a tiny status page on $PORT (health-check friendly)
#   * restarts the CLI automatically if it ever exits
#
# Required environment variables:
#   TM_TOKEN        - your TraffMonetizer app token (REQUIRED)
#   TM_DEVICE_NAME  - device name shown on the TM dashboard (default: render2)
#   PORT            - HTTP status page port (default: 8080)

FROM busybox:stable AS busybox
FROM scratch
COPY --from=traffmonetizer/cli_v2:latest /usr/local/bin/cli /usr/local/bin/cli
COPY --from=busybox /bin/busybox /bin/busybox
COPY start.sh /start.sh
COPY www /www
ENV HOME=/tmp \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PORT=8080 \
    TM_DEVICE_NAME=render2
EXPOSE 8080
ENTRYPOINT ["/bin/busybox", "sh", "/start.sh"]
