#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# mounts mitmproxy/run to /run in the container
docker run -v "$SCRIPT_DIR"/run/:/run/ --rm -it -p 8080:8080 mahimahi-gen
