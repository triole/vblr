#!/bin/bash
IFS=$'\n'
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pargs=()
debug="false"
for val in "$@"; do
    if [[ "${val}" =~ ^-+(d|debug)$ ]]; then
        debug="true"
    fi
    if [[ ! "${val}" =~ ^- ]]; then
        pargs+=("${val}")
    fi
done

ts() {
    date +%Y%m%d_%H%M%S
}

rcmd() {
    cmd=${@}
    echo -e "\033[0;93m${cmd}\033[0m"
    if [[ "${debug}" == "false" ]]; then
        eval ${cmd}
    fi
}

findfiles() {
    find "${workdir}" -regex ".*\.${1}$"
}

# main
workdir="${scriptdir}"
if (("${#pargs}" > 0)); then
    workdir="${pargs[0]}"
fi

for fil in $(findfiles "log"); do
    shortname="$(echo "${fil}" | grep -Po ".*(?=\.)")"
    newname="${shortname}_.log"
    ziparchive="${shortname}_$(ts).zip"
    echo -e "\nzip log file ${fil}"
    rcmd cp "${fil}" "${newname}" &&
        rcmd truncate -s 0 "${fil}" &&
        rcmd zip -j -9 "${ziparchive}" "${newname}" &&
        rcmd rm "${newname}"
done
