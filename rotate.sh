#!/bin/bash
IFS=$'\n'
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
n="$(basename "${0}")"

display_help() {
    echo -e "\nvblr help"
    echo -e "\n  args"
    echo "    -h/--help    display help"
    echo "    -d/--debug   just print don't do"
    echo "    -[0-9]+      to indicate how many old zip logs to keep, default is 0 and keeps all"
    echo -e "\n  usage"
    echo "    ${n} /var/log"
    echo "    ${n} /var/log -5"
    echo -e "    ${n} /var/log -9 -d\n"
    exit
}

pargs=()
debug="false"
nokeep=0
for val in "${@}"; do
    if [[ "${val}" =~ ^-+(h|help)$ ]]; then
        display_help
    fi
    if [[ "${val}" =~ ^-+(d|debug)$ ]]; then
        debug="true"
    fi
    if [[ "${val}" =~ ^-+[0-9]+$ ]]; then
        nokeep="$(echo "${val}" | grep -Po "[0-9]+$")"
    fi
    if [[ ! "${val}" =~ ^- ]]; then
        pargs+=("${val}")
    fi
done

ts() {
    date +%Y%m%d-%H%M%S
}

rcmd() {
    cmd=${@}
    echo -e "\033[0;93m${cmd}\033[0m"
    if [[ "${debug}" == "false" ]]; then
        eval ${cmd}
    fi
}

ff() {
    find "${workdir}" -mindepth 1 -maxdepth 1 -type f | grep -E "${1}" | sort
}

# main
workdir="${scriptdir}"
if (("${#pargs}" > 0)); then
    workdir="${pargs[0]}"
fi

for fil in $(ff ".*\.log$"); do
    shortname="$(echo "${fil}" | grep -Po ".*(?=\.)")"
    newname="${shortname}_.log"
    ziparchive="${shortname}_$(ts).zip"
    echo -e "\nzip log file ${fil}"
    rcmd cp "${fil}" "${newname}" &&
        rcmd truncate -s 0 "${fil}" &&
        rcmd zip -j -9 "${ziparchive}" "${newname}" &&
        rcmd rm "${newname}"

    if ((${nokeep} > 0)); then
        oldfil=($(
            ff "${shortname}_[0-9]{8}-[0-9]{6}.zip$" | head -n -${nokeep}
        ))
        if ((${#oldfil} > 0)); then
            echo "remove old zipped logs"
            for fil in "${oldfil[@]}"; do
                rcmd rm "${fil}"
            done
        fi
    fi
done
