# Installation

fresh debian 12 with gnome, installed vim, tmux, git, ninja-linux, docker, cmake, python3-protobuf, cargo

machine needs much more than 8GB of ram. 32 did the trick for me. the -j flag might help with this as well.

clone the `depot_tools` repository: `git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git` and add to PATH.


cd into `browsertime/docker/chromium/` and run `fetch --nohooks --no-history chromium`

cd into src then `gclient sync --with_branch_heads --with_tags` and `git fetch`
(fetch takes *forever*)


checkout version and sync dependencies
`git checkout 128.0.6599.1`
`gclient sync --with_branch_heads --with_tags`

try to apply the patch:
`git apply --reject --whitespace=fix ../../credentials_flag.patch`
then add to the top of `net/url_request/url_request.cc`:
`#include base/command_line.h` 

in `net/url_request/url_request_http_job.cc`, find `DeterminePrivacyMode` and make sure it always returns `PRIVACY_MODE_DISABLED`.

generate ninja files
`gn gen out/Default`

install ninja
```
wget https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip
unzip ninja-linux.zip 
sudo mv ninja /usr/local/bin/
```

build with ninja
```
autoninja -C out/Default chrome
autoninja -C out/Default chromedriver
```

cd back into docker folder and run the build script
```
cd ../..
sudo ./build.sh
```

checkout h2o repo, cmake then make
```
git submodule update --init --recursive
cd h2o/
cmake .
make
sudo make install
```

build fcgi executable for h2o
```
cd go_fastcgi/src/
go mod init fcgi
go mod tidy
```
copy mahimahi files to go src? this is hugely overkill but the only way I got it recognized
```
sudo cp -r MahimahiProtobufs/ /usr/local/go/src/
```
and build 
```
go build
mv src ../fcgi
```

build mitmproxy container for site-capturing
```
cd mitmproxy
./build.sh
```
# Building quiche
install rustup:
```
curl https://sh.rustup.rs -sSf | sh
```

build quiche-server:
```
cd quiche/
git submodule update --init
cargo build
make docker-protobuf-build
```



# Site capture
the following command can be used to capture protobuf/mahimahi files of sites:
```
./mitmproxy/capture_site.sh www.wikipedia.org
```

this populates the directory sites/www.wikipedia.org with the proper .save files and an addition file named `pp_sorted.txt` that displays the request/responses in a readable format.

