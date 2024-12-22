#!/usr/bin/env bash

dotfiles::sudo_keepalive() {
  ! command -v sudo &> /dev/null && return 0

  sudo -v

  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2> /dev/null &
}

wireguard::disconnect_vpns() {
  local -a conns
  conns=$(scutil --nc list | grep com.wireguard.macos | grep Connected | cut -d'"' -f 2) || true

  [[ -z ${conns}   ]] && return 0

  echo "${conns}"
  for c in ${conns}; do
    scutil --nc stop "${c}"
  done
  unset c
}
