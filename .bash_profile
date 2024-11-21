#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2312,SC1090

[[ -f "${HOME}/.exports" ]] && . "${HOME}/.exports"

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
  PLATFORM_LINUX=1
elif [[ "${OS}" == "Darwin" ]]; then
  PLATFORM_MACOS=1
fi

export PLATFORM_LINUX
export PLATFORM_MACOS

# shellcheck disable=SC2154
if [[ "${COLORTERM}" = gnome-* && "${TERM}" = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# Load Homebrew as early as possible
if [[ -n "${PLATFORM_MACOS-}" ]]; then
  if [[ -f /opt/homebrew/bin/brew ]]; then
    # Apple M series chip install location
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    # Apple Intel chip install location
    eval "$(/usr/local/bin/brew shellenv)"
  fi
elif [[ -n "${PLATFORM_LINUX-}" ]]; then
  if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

SHELL="$(command -v bash)"
export SHELL

# shellcheck disable=SC1091
[[ -f "${HOME}/.secrets" ]] && . "${HOME}/.secrets"

# BASH Options
for option in checkwinsize autocd globstar cdspell histappend nocaseglob; do
	shopt -s "${option}" 2> /dev/null
done

# Load the shell dotfiles, and then some:
for file in "${HOME}/."{functions,bash_prompt,aliases,extra,secrets}; do
  # shellcheck source=/dev/null
  [[ -f "${file}" ]] && . "${file}"
done
unset file

# Use bash-completion, if available
[[ -n "${PS1}" && -f "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
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
