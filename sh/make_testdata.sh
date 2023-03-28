#!/bin/bash

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
basedir=$(echo "${scriptdir}" | grep -Po ".*(?=\/)")
testfol="${basedir}/tmp"

ts() {
    date +%Y%m%d_%H%M%S
}

mkdir -p "${testfol}"

for i in {0..5}; do
    outf="${testfol}/logfile${i}.log"
    touch "${outf}"
    for i in {000..999}; do
        echo "${i} --- $(ts)" >>"${outf}"
    done
done
