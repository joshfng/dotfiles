#!/usr/bin/env bash

# shellcheck disable=SC1091

# Short-circuit if init.sh has already been sourced
[[ $(type -t dotfiles::init::loaded) == function ]] && return 0

DOTFILES_PATH=${DOTFILES_PATH:-"$(dirname "$(realpath "${BASH_SOURCE[0]}/../../")")"}
export DOTFILES_PATH

# probably no better than just exporting
# [[ ! "${DOTFILES_PATH@a}" = *x* ]] && export DOTFILES_PATH

. "${DOTFILES_PATH}/bin/lib/util.sh"
. "${DOTFILES_PATH}/bin/lib/logger.sh"

# Marker function to indicate init.sh has been fully sourced
dotfiles::init::loaded() {
  return 0
}
