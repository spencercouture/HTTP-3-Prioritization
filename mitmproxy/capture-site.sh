#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "usage: ./capture-site.sh <www.website.com>"
    exit
fi
SITE_URL=$1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SITE_PATH="$SCRIPT_DIR/sites/$SITE_URL"

# check if directory already exists, ask for overwrite confirmation
if [ -d $SITE_PATH ] ; then 
    read -p "\"sites/$SITE_URL\" already exists. would you like to overwrite? (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo rm -rf $SITE_PATH
    else
        echo "quitting..."
        exit -1
    fi
fi
echo "mkdir $SITE_PATH"
mkdir $SITE_PATH

# clear output directory
sudo rm -rf $SCRIPT_DIR/run/output/*

# mounts mitmproxy/run to /run in the container
mitm_container=$(docker run -v "$SCRIPT_DIR"/run/:/run/ --rm -it -p 8080:8080 --detach mahimahi-gen)

echo "sleeping for 3s to ensure mitmproxy is up..."
sleep 3

docker run --add-host=host.docker.internal:host-gateway --rm sitespeedio/browsertime:22.6.0 --video --visualMetrics --proxy.https host.docker.internal:8080 --iterations 1 https://$SITE_URL

docker stop $mitm_container

# copy output to site dir
cp -r $SCRIPT_DIR/run/output/* $SITE_PATH
