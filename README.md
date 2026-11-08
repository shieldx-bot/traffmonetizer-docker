# traffmonetizer-docker

Run the [TraffMonetizer](https://traffmonetizer.com) CLI on any container
platform (Caasify, Render, Fly.io, Railway, Koyeb...).

The official [`traffmonetizer/cli_v2`](https://hub.docker.com/r/traffmonetizer/cli_v2)
image is built `FROM scratch` (single binary, no shell, no `HOME`), which makes
the CLI exit immediately on many PaaS platforms. This project wraps it with
busybox and a supervisor script:

- sets `HOME=/tmp` so the CLI can persist its device id
- serves a small HTTP status page on `$PORT` (platform health checks)
- auto-restarts the CLI if it exits

## Environment variables

| Variable         | Required | Default    | Description                              |
|------------------|----------|------------|------------------------------------------|
| `TM_TOKEN`       | yes      | —          | Your TraffMonetizer app token            |
| `TM_DEVICE_NAME` | no       | `render2`  | Device name shown on the TM dashboard    |
| `PORT`           | no       | `8080`     | Port for the HTTP status page            |

## Deploy on Caasify (https://my.caasify.com/launch)

1. Source: **Public Git Repository** → `https://github.com/shieldx-bot/traffmonetizer-docker`
2. Branch: `main`
3. Add environment variables: `TM_TOKEN` (+ optionally `TM_DEVICE_NAME`)
4. Deploy — Caasify builds the Dockerfile and runs the container.

## Deploy on Render (https://dashboard.render.com)

1. New → Web Service → **Public Git Repository** → paste this repo URL
2. Runtime: Docker, instance type: Free
3. Environment variables: `TM_TOKEN` (+ optionally `TM_DEVICE_NAME`)
4. Deploy. The status page answers on the platform-assigned port.

## Run locally

```bash
docker run -d --restart always \
  -e TM_TOKEN=your_app_token \
  -e TM_DEVICE_NAME=my-laptop \
  -p 8080:8080 \
  ghcr.io/shieldx-bot/traffmonetizer-docker:latest
```

Check status: `docker logs -f <container>`
