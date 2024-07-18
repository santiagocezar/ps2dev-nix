#!/usr/bin/env -S nix shell nixpkgs#nix-prefetch-github nixpkgs#jq -c bash

prefetch() {
    name=$1
    repo=$2
    rev=$3

    >&2 echo -e "\e[0;34mfetching \e[1;33m$name \e[0;34mrepo...\e[0m"

    nix-prefetch-github ps2dev "$repo" --rev "$rev" | jq --arg name "$name" '{$name:.}'
}

prefetch_all() {
    {
        # https://github.com/ps2dev/ps2toolchain-dvp/blob/main/config/ps2toolchain-dvp-config.sh
        prefetch dvp-binutils        binutils-gdb     dvp-v2.31.1

        # https://github.com/ps2dev/ps2toolchain-ee/blob/main/config/ps2toolchain-ee-config.sh
        prefetch ee-binutils         binutils-gdb     ee-v2.41.0
        prefetch ee-gcc              gcc              ee-v14.1.0
        prefetch ee-newlib           newlib           ee-v4.4.0
        prefetch ee-pthread-embedded pthread-embedded platform_agnostic

        prefetch iop-binutils        binutils-gdb     iop-v2.35.2
        prefetch iop-gcc             gcc              iop-v13.2.0

        prefetch ps2sdk              ps2sdk           master
        prefetch ps2sdk-ports        ps2sdk-ports     master

        prefetch ps2-packer          ps2-packer       master
        prefetch ps2client           ps2client        master
    } | jq -s add > sources.json
}

prefetch "$@"
