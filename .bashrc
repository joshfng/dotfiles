#!/usr/bin/env bash

# shellcheck disable=SC2312

[[ -n ${TRACE} ]] && set -x && export TRACE=${TRACE}

[[ -n "${PS1}" ]] && . "${HOME}/.bash_profile";
