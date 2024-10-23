#!/usr/bin/env bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

##############################
# here I define a bunch of variables that these functions use:

# uncomment and set this variable if you want new .save files generated
GEN_NEW_PROTOBUF_FILES="TRUE"

# list of websites to run the job for
# <URL> <shortname>
# (I keep shortname at 6 characters max, i forget why)
websites=(
    # "han www.hannaford.com"
    #"gen genius.com"
    # "nyt www.nytimes.com"
    # "wmart www.walmart.com"
    # "bbc www.bbc.com"
    # "apple www.apple.com"
    # "msoft www.microsoft.com"
    # "bbuy www.bestbuy.com"
    # "target www.target.com"
    # "hdepot www.homedepot.com"
    "ytube www.youtube.com"
)
# "wiki www.wikipedia.org"
# "spotfy open.spotify.com"

bwdown=4000000
rtt=1
bdp=1
loss=0.0
cc="cubic"
priomode="firefoxext"
sites="$SCRIPT_DIR/mitmproxy/sites"

##############################

##############################
# now I define the functions to operate the testbed

# delete old protobuf files for a given site
delete_protobuf_files() {
    site_dir="$sites/$1"

    # create an empty site_dir
    if [ -d "$site_dir" ]; then
        echo "$1 exists, deleting .save files..."
        rm -rf $site_dir/protobuf_files/*.save
    fi
}

# creates a config file for a given website
# create_config_file <website>
create_config_file() {
    # config line 1
    website="$1"
    workdir="$sites/$1"
    config_line1='{"general":{"repeat": 1,"dir":"'"$workdir"'"}}'
    config_line2='{"bwdown": '"$bwdown"', "rtt": '"$rtt"', "bdp": '"$bdp"', "loss": '"$loss"', "cc": "'"$cc"'", "priomode": "'"$priomode"'", "website": "'"$website"'", "workdir": "'"$workdir"'", "priofile": ""}'
    echo $config_line1 >$workdir/evalconfig.json
    echo $config_line2 >>$workdir/evalconfig.json
    run_script="sudo python3 main.py --eval $workdir/evalconfig.json --quiche wiki"
}

# run the testbed for a given website
run_testbed() {
    shortname=$1
    site=$2
    workdir="$sites/$2"
    echo "#/usr/bin/env bash" >$workdir/run_testbed.sh
    echo "sudo python3 main.py --eval $workdir/evalconfig.json --quiche $1" >$workdir/run_testbed.sh
    chmod +x $workdir/run_testbed.sh
    $workdir/run_testbed.sh
}

# for each row in websites...
for row in "${websites[@]}"; do
    # split the row into arguments
    IFS=' ' read -r -a site_arr <<<"$row"
    shortname="${site_arr[0]}"
    site="${site_arr[1]}"

    if [ -n "$GEN_NEW_PROTOBUF_FILES" ]; then
        delete_protobuf_files $site
        $SCRIPT_DIR/mitmproxy/capture-site.sh $site
    fi
    create_config_file $site
    run_testbed $shortname $site
done
