#!/bin/bash

set -ex

. ./functions.sh

export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-.*-rootfs.tar.gz"
export DOCKERFILE="Dockerfile.rootfs"

export_variables

 mkdir -p ./tmp/ ./build/
#./docker-download.sh || exit 1
jenkins_artifacts_url="http://3.213.181.230/job/MFW%20pipeline/job/master/lastSuccessfulBuild/artifact/tmp/artifacts"
tarball_name=$(curl -s ${jenkins_artifacts_url}/ | perl -ne 'print $1 if m/(mfw-us[^"]+tar\.gz)/')
curl -s -f -o ./tmp/mfw.img.gz ${jenkins_artifacts_url}/$tarball_name
tar -C ./build/ -xaf ./tmp/mfw.img.gz

# Changes related to BST:
# Override /lib/preinit/ with our own configs for now
# Update 00_preinit.conf
## remove failsafe mode

cp -r ./rootfs/* ./build

#rm -rf ./tmp/

./docker-build.sh || exit 1
