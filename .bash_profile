#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2312,SC1090

[[ -f "${HOME}/.exports" ]] && . "${HOME}/.exports"

[[ -f "${HOME}/.secrets" ]] && . "${HOME}/.secrets"

for file in "${HOME}/."{functions,bash_prompt,aliases,extra}; do
  # shellcheck source=/dev/null
  [[ -f "${file}" ]] && . "${file}"
done
unset file

# Use bash-completion, if available
[[ -n "${PS1}" && -n "${HOMEBREW_PREFIX}" && -f "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
[[ -n "${PS1}" && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

if [[ -d /usr/local/etc/bash_completion.d ]]; then
  for bcfile in /usr/local/etc/bash_completion.d/*; do
    # shellcheck source=/dev/null
    . "${bcfile}"
  done
fi
unset bcfile

if [[ -d "${HOME}/.bash_completion.d" ]]; then
  for bcfile in "${HOME}/.bash_completion.d/"*; do
    # shellcheck source=/dev/null
    . "${bcfile}"
  done
fi
unset bcfile

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

complete -F __start_kubectl k

for prog in gh kind helm kubectl gh minikube; do
  if command -v "${prog}" 2&>/dev/null; then
    . <(${prog} completion bash)
  fi
done

complete -o default -F __start_kubectl k

[[ "$(umask)" == '0000' ]] && umask 0022

[[ -r "${HOME}/.asdf/asdf.sh" ]] && . "${HOME}/.asdf/asdf.sh"
[[ -r "${HOME}/.asdf/completions/asdf.bash" ]] && . "${HOME}/.asdf/completions/asdf.bash"
