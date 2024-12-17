#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2312,SC1090

if [[ $- != *i* ]]; then return; fi # [[ -z "$PS1" ]] && return

for file in "${HOME}/."{functions,exports,bash_prompt,aliases,extra,secrets}; do
  [[ -f "${file}" ]] && . "${file}"
done
unset file

# bash-completion
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ -f "${HOMEBREW_PREFIX:-}/etc/profile.d/bash_completion.sh" ]] && . "${HOMEBREW_PREFIX:-}/etc/profile.d/bash_completion.sh"

declare -a completion_dirs=(
  /usr/local/etc/bash_completion.d
  "${HOMEBREW_PREFIX:-}/etc/bash_completion.d"
)

for completion_dir in "${completion_dirs[@]}"; do
  if [[ -d "${completion_dir}" ]]; then
    for bcfile in "${completion_dir}"/*; do
      . "${bcfile}"
    done
    unset bcfile
  fi
done
unset completion_dir

[[ -f "${HOME}/.asdf/asdf.sh" ]] && . "${HOME}/.asdf/asdf.sh"
[[ -f "${HOME}/.asdf/completions/asdf.bash" ]] && . "${HOME}/.asdf/completions/asdf.bash"

# disable flow control if we have a TTY
[[ -s 0 ]] && stty -ixon
