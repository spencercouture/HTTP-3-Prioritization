#!/bin/bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
chromium_path="$SCRIPT_DIR/chromium/src/out/Default"

docker run --shm-size=4g --rm -it -d  --network=none --entrypoint "/bin/bash" -v "$chromium_path:/opt/comsyschrome"  -v "/tmp/browsertime-$1":/browsertime --dns 10.0.1.4 --cap-add=SYS_NICE --name $1-browsertime scouture/browsertime
DPID=$(docker inspect -f '{{.State.Pid}}' $1-browsertime)
mkdir -p /var/run/netns
ln -s /proc/$DPID/ns/net /var/run/netns/$1-browsertime
