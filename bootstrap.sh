#!/usr/bin/env bash

[[ -n ${TRACE} ]] && set -x && export TRACE=${TRACE}

bin_dir="$(realpath "${BASH_SOURCE[0]}")"
DOTFILES_PATH=$(dirname "${bin_dir}")
cd "${DOTFILES_PATH}" || exit

if command -v sudo &>/dev/null; then
  sudo -v

  while true; do
    sudo -n true
    sleep 300
    kill -0 "$$" || exit
  done 2>/dev/null &
fi

# link required files to home directory
. "${DOTFILES_PATH}/bin/sync_dotfiles"

. "${HOME}/.bashrc"
. "${HOME}/.bash_profile"

[[ "${PLATFORM-}" == "mac" ]] && . "${DOTFILES_PATH}/.init/macos.sh"

[[ "${PLATFORM-}" == "linux" ]] &&. "${DOTFILES_PATH}/.init/linux.sh"

. "${DOTFILES_PATH}/.init/install_homebrew"

# use homebrew bash on macos
if [[ "${PLATFORM-}" == "mac" ]]; then
  hb_bash="${HOMEBREW_PREFIX}/opt/bin/bash" || "$(command -v bash)"

  if ! grep "${hb_bash}" /etc/shells &>/dev/null; then
    echo
    echo "Setting \$SHELL to ${hb_bash}"
    echo

    echo "${hb_bash}" | sudo tee -a /etc/shells &>/dev/null
    sudo chsh -s "${hb_bash}" "${USER}" &>/dev/null

    # verify
    grep "^${USER}" /etc/passwd &>/dev/null || exit 127

    echo "done"
    echo
  fi
fi

# shellcheck source=../bin/update_system
. "${HOME}/bin/update_system"


echo "bootsrapping asdf"
echo

# shellcheck disable=SC1091
if ! command -v asdf &>/dev/null; then
  git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch v0.14.1

  . "${HOME}/.asdf/asdf.sh"
  . "${HOME}/.asdf/completions/asdf.bash"
fi

if command -v asdf &>/dev/null; then
  plugins=$(awk '{print $1}' < "${HOME}/.tool-versions" | tr '\n' ' ')

  for plugin in ${plugins}; do
    asdf plugin add "${plugin}"
  done

  asdf install
fi

echo "done!"
echo
