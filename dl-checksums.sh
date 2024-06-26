#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/notaryproject/notation/releases/download

# https://github.com/notaryproject/notation/releases/download/v1.1.1/notation_1.1.1_checksums.txt
# https://github.com/notaryproject/notation/releases/download/v1.1.1/notation_1.1.1_darwin_arm64.tar.gz

dl()
{
    local ver=$1
    local lhashes=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-"tar.gz"}
    local platform="${os}_${arch}"
    local file="notation_${ver}_${platform}.${archive_type}"
    local url="${MIRROR}/v${ver}/${file}"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(egrep -e "${file}\$" $lhashes | awk '{ print $1 }')
}

dl_ver() {
    local ver=$1

    local file="notation_${ver}_checksums.txt"
    local lhashes="${DIR}/${file}"

    # https://github.com/notaryproject/notation/releases/download/v1.1.1/notation_1.1.1_checksums.txt
    local url="${MIRROR}/v${ver}/${file}"

    if [ ! -e "${lhashes}" ];
    then
        curl -sSLf -o $lhashes $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl $ver $lhashes darwin amd64
    dl $ver $lhashes darwin arm64
    dl $ver $lhashes linux amd64
    dl $ver $lhashes linux arm64
    dl $ver $lhashes windows amd64 zip
}

dl_ver ${1:-1.1.1}
