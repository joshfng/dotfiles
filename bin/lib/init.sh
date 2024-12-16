#!/usr/bin/env bash

# Short-circuit if init.sh has already been sourced
[[ $(type -t dotfiles::init::loaded) == function ]] && return 0

DOTFILES_PATH=${DOTFILES_PATH:-$(dirname "$(realpath "$0/../..")")}

# shellcheck source=util.sh
source "${DOTFILES_PATH}/bin/lib/util.sh"
# shellcheck source=logger.sh
source "${DOTFILES_PATH}/bin/lib/logger.sh"

# Marker function to indicate init.sh has been fully sourced
dotfiles::init::loaded() {
  return 0
}
