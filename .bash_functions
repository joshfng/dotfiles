#!/usr/bin/env bash

# shellcheck disable=SC2155,SC2312

token() {
  head -c 12 /dev/urandom | shasum | cut -d ' ' -f1
}

encrypt() {
    gpg -es -r "$GPGKEY" "$1"
}

decrypt() {
    gpg -o "${1%.*}" -d "$1"
}

proc_count() {
  local concurrency=1

  if command -v nproc &>/dev/null; then
    concurrency=$(nproc)
  elif command -v sysctl &>/dev/null && sysctl hw.ncpu &>/dev/null; then
    concurrency=$(sysctl -n hw.ncpu)
  elif [ -f /proc/cpuinfo ]; then
    concurrency=$(grep -c processor /proc/cpuinfo)
  fi

  echo "$concurrency"
}

prepend_path() {
  local _bin_dir=$1

  # remove existing entry
  case ":$PATH:" in
    *":${_bin_dir}:"*) PATH=${PATH//$_bin_dir:/} ;;
  esac

  # add entry to the front
  case ":$PATH:" in
    *":$_bin_dir:"*) : ;;
    *) PATH="$_bin_dir:$PATH" ;;
  esac

  export PATH

  return
}

sudo_keepalive() {
  if command -v sudo &>/dev/null; then
    sudo -v

    while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done 2>/dev/null &
  fi
}

wipe_disk() {
  local device
  if [[ "$1" == "/dev/"* ]]; then
    device="$1"
  else
    echo "missing device, ie: wipe_disk /dev/diskN"
    return
  fi

  sudo_keepalive

  echo "wiping disk ${device}"
  echo

  if command -v scrub 2 &>/dev/null; then
    sudo scrub --pattern nnsa "${device}"
  elif command -v dd 2 &>/dev/null; then
    for i in {1..3}; do
      echo "pass ${i} of 3 start..."

      # random data for pass 1 & 2, zeros for 3
      local if="/dev/random"
      if [[ ${i} == 3 ]]; then
        if="/dev/zero"
      fi

      sudo dd if="${if}" of="${device}" bs=4m status=progress
      sync

      echo
      echo "pass ${i} of 3 done!"
      echo
    done
  fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
  local tmpFile="${*%/}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

  size=$(
    stat -f"%z" "${tmpFile}" 2>/dev/null # macOS `stat`
    stat -c"%s" "${tmpFile}" 2>/dev/null # GNU `stat`
  )

  local cmd=""
  if ((size < 52428800)) && hash zopfli 2>/dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2>/dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [[ -f "${tmpFile}" ]] && rm "${tmpFile}"

  zippedSize=$(
    stat -f"%z" "${tmpFile}.gz" 2>/dev/null # macOS `stat`
    stat -c"%s" "${tmpFile}.gz" 2>/dev/null # GNU `stat`
  )

  echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
}

# Determine size of a file or total size of a directory
fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "${array[*]}" ]]; then
    du "${arg}" -- "$@"
  else
    du "${arg}" .[^.]* ./*
  fi
}

# Compare original and gzipped file size
gz() {
  local origsize=$(wc -c <"$1")
  local gzipsize=$(gzip -c "$1" | wc -c)
  local ratio=$(echo "${gzipsize} * 100 / ${origsize}" | bc -l)
  printf "orig: %d bytes\n" "${origsize}"
  printf "gzip: %d bytes (%2.2f%%)\n" "${gzipsize}" "${ratio}"
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [[ "${PLATFORM-}" == "linux" ]]; then
  if grep -q Microsoft /proc/version; then
    # Ubuntu on Windows using the Linux subsystem
    alias open='explorer.exe'
  else
    alias open='xdg-open'
  fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
o() {
  if [[ $# -eq 0 ]]; then
    open .
  else
    open "$@"
  fi
}

flushdns() {
  if [[ "${PLATFORM-}" == "darwin" ]]; then
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  elif [[ "${PLATFORM-}" == "linux" ]]; then
    sudo resolvectl flush-caches
  fi
}

myip() {
  ifconfig | awk '/inet / {print $2}' | grep -v 127.0.0.1
}

edit() {
  if [[ $# -gt 0 ]]; then
    code "$@"
  else
    code .
  fi
}

ios2usb() {
  dd if="$1" of="$2" bs=1m status=progress
}

update_boot() {
  sudo update-grub && sudo update-initramfs -u -k all
}

gen_mac() {
  echo "02:$(openssl rand -hex 5 | awk '{print toupper($0)}' | sed 's/\(..\)/\1:/g; s/.$//')"
}
