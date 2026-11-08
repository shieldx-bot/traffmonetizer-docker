#!/bin/busybox sh
# TraffMonetizer CLI supervisor
export HOME=/tmp
mkdir -p /tmp /www

cat > /www/index.html <<'HTML'
<!doctype html>
<html><head><meta charset="utf-8"><title>TraffMonetizer node</title></head>
<body style="font-family:sans-serif">
<h1>TraffMonetizer node</h1>
<p id="st">CLI starting...</p>
</body></html>
HTML

if [ -z "$TM_TOKEN" ]; then
  echo "[start.sh] ERROR: TM_TOKEN is not set"
  echo "<html><body><h1>TM_TOKEN is not set</h1><p>Set TM_TOKEN in the platform environment variables.</p></body></html>" > /www/index.html
  sleep 300
  exit 1
fi

# Tiny HTTP status page — keeps platforms that require an open port happy
/bin/busybox httpd -f -p "${PORT:-8080}" -h /www &

echo "[start.sh] starting TraffMonetizer CLI (device: ${TM_DEVICE_NAME:-render2})"
while true; do
  /usr/local/bin/cli start accept --token "$TM_TOKEN" --device-name "${TM_DEVICE_NAME:-render2}"
  code=$?
  echo "[start.sh] cli exited with code $code - restarting in 10s"
  echo "<html><body><h1>TraffMonetizer node</h1><p>CLI restarting (last exit code: $code)</p></body></html>" > /www/index.html
  sleep 10
done
