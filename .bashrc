#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2312,SC1090

for import_file in "${HOME}/.bash_"{functions,exports,prompt,aliases,extras,secrets}; do
  [[ -f "${import_file}" ]] && . "${import_file}"
done
unset import_file

# bash-completion
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ -f "${HOMEBREW_PREFIX:-}/opt/asdf/libexec/asdf.sh" ]] && . "${HOMEBREW_PREFIX:-}/opt/asdf/libexec/asdf.sh"
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
unset completion_dirs

# disable flow control if we have a TTY
[[ -s 0 ]] && stty -ixon
