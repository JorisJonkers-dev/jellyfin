#!/usr/bin/env bash
# Starts both images restricted (uid 1000, a read-only root, every capability dropped), with only
# the paths the Project mounts writable, and waits until each serves.
# Usage: scripts/smoke-test.sh <jellyfin-image> <jellyseerr-image>
set -euo pipefail
apps=("jellyfin $1 8096 /health" "jellyseerr $2 5055 /api/v1/settings/public")
owned='uid=1000,gid=1000'

cleanup() { docker rm -f smoke-jellyfin smoke-jellyseerr >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup

docker run -d --name smoke-jellyfin --read-only --cap-drop ALL \
  --tmpfs "/tmp:$owned,mode=1777" --tmpfs "/config:$owned" --tmpfs "/cache:$owned" \
  --tmpfs "/media/Series:$owned" --tmpfs "/media/Films:$owned" "$1" >/dev/null
docker run -d --name smoke-jellyseerr --read-only --cap-drop ALL \
  --tmpfs "/tmp:$owned,mode=1777" --tmpfs "/app/config:$owned" "$2" >/dev/null

# jellyfin carries curl, seerr's Alpine base only busybox wget.
status() {
  docker exec "smoke-$1" sh -c "if command -v curl >/dev/null; then curl -s -o /dev/null -w '%{http_code}' 'http://127.0.0.1:$2$3'; else wget -q -O /dev/null 'http://127.0.0.1:$2$3' && echo 200; fi" 2>/dev/null || true
}

for spec in "${apps[@]}"; do
  read -r name _ port path <<<"$spec"
  code=""
  for _ in $(seq 1 60); do
    code=$(status "$name" "$port" "$path")
    [ "$code" = 200 ] && break
    if [ "$(docker inspect -f '{{.State.Running}}' "smoke-$name")" != true ]; then
      docker logs "smoke-$name" 2>&1 | tail -30
      echo "$name exited before it served" >&2
      exit 1
    fi
    sleep 3
  done
  [ "$code" = 200 ] || { docker logs "smoke-$name" 2>&1 | tail -30; echo "$name never served $path" >&2; exit 1; }
  others=$(docker top "smoke-$name" -eo pid,uid | tail -n +2 | awk '$2 != 1000')
  [ -z "$others" ] || { echo "$name runs a process as another uid: $others" >&2; exit 1; }
  echo "$name serves $path as uid 1000"
done
echo "smoke test passed"
