#!/usr/bin/env -S nix shell nixpkgs#nix-prefetch-git nixpkgs#jq -c bash

prefetch() {
    name=$1
    url=$2
    ref=$3

    >&2 echo -e "\e[0;34mfetching \e[1;33m$name \e[0;34mrepo...\e[0m"
    line=$(git ls-remote "$url" "$ref")

    rev=$(cut -f1 <<<"$line")
    ref=$(cut -f2 <<<"$line")

#     nix-prefetch-git "$url" "refs/heads/$ref" | jq --arg name "$name" '{$name:.}'

    jq -cn '{$name:{url:$url, rev:$rev, ref:$ref}}' \
       --arg url "$url" \
       --arg rev "$rev" \
       --arg ref "$ref" \
       --arg name "$name"
}


{
    prefetch dvp-binutils        https://github.com/ps2dev/binutils-gdb.git     dvp-v2.14

    prefetch ee-binutils         https://github.com/ps2dev/binutils-gdb.git     ee-v2.41.0
    prefetch ee-gcc              https://github.com/ps2dev/gcc.git              ee-v13.2.0        # maybe ee-v11.3.0
    prefetch ee-newlib           https://github.com/ps2dev/newlib.git           ee-v4.4.0         # maybe ee-v4.3.0
    prefetch ee-pthread-embedded https://github.com/ps2dev/pthread-embedded.git platform_agnostic

    prefetch iop-binutils        https://github.com/ps2dev/binutils-gdb.git     iop-v2.35.2
    prefetch iop-gcc             https://github.com/ps2dev/gcc.git              iop-v13.2.0

    prefetch ps2sdk              https://github.com/ps2dev/ps2sdk.git           master
    prefetch ps2sdk-ports        https://github.com/ps2dev/ps2sdk-ports.git     master

    prefetch ps2-packer          https://github.com/ps2dev/ps2-packer.git       master
    prefetch ps2client           https://github.com/ps2dev/ps2client.git        master
} | jq -s add > sources.json

