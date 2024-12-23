#!/usr/bin/env bash

# LINUX

if [[ "${PLATFORM-}" == "linux" ]]; then
  alias dgpu="sudo prime-select nvidia"
  alias igpu="sudo prime-select on-demand"

  alias freemem="free -mh && sync && echo \"echo 1 > /proc/sys/vm/drop_caches\" | sudo sh && free -mh"

  alias pbcopy="xclip -selection clipboard </dev/stdin"
  alias pbpaste="xclip -selection clipboard -o"

  colorflag="--color"
  export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# MACOS

if [[ "${PLATFORM-}" == "darwin" ]]; then
  alias freemem="sudo purge"

  colorflag="-G"
  export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'

  # Google Chrome
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  alias google-chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

  # Clean up LaunchServices to remove duplicates in the “Open With” menu
  alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

  # macOS has no `md5sum`, so use `md5` as a fallback
  command -v md5sum >/dev/null || alias md5sum="md5"

  # macOS has no `sha1sum`, so use `shasum` as a fallback
  command -v sha1sum >/dev/null || alias sha1sum="shasum"

  # Trim new lines and copy to clipboard
  alias tcopy="tr -d '\n' | pbcopy"

  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

  # Hide/show all desktop icons (useful when presenting)
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

  # Disable Spotlight
  alias spotoff="sudo mdutil -a -i off"
  # Enable Spotlight
  alias spoton="sudo mdutil -a -i on"

  # alias chromekill="ps ux | grep '[C]hrome Helper' | grep 'type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
  alias chromekill='killall "Google Chrome Helper (Renderer)"'

  # Lock the screen (when going AFK)
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

  # Recursively delete `.DS_Store` files
  alias dscleanup="find . -type f -name '*.DS_Store' -ls -delete"

  alias audit="sudo praudit -l /dev/auditpipe"

  alias systemlogs="/usr/bin/log stream"

  # bluetooth
  alias bt='blueutil'
  alias btOn='blueutil -p 1'
  alias btOff='blueutil -p 0'

  alias extensions='systemextensionsctl list'
  alias sysinfo='systemstats'

  alias screenshotlocation='defaults write com.apple.screencapture location ~/Pictures/Screenshots'
fi

# COMMON

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Easier navigation
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

alias h='cd $HOME'
alias cc='cd $HOME/code'
alias dl='cd $HOME/Downloads'

alias dotfiles='cd $HOME/code/dotfiles'

alias e="edit"

# clamav virus scan in docker
alias vscan="docker run -it --rm -v /:/scan:ro clamav/clamav:latest clamscan --verbose --stdout --recursive --suppress-ok-results /scan"

# list aliases
alias meta="compgen -a"

alias dr="docker run --rm -it"
alias yt="yt-dlp"
alias ytl="yt-dlp -o \"./%(title)s.%(ext)s\""
alias ydl-audio='cd ~/Downloads && yt-dlp -x --embed-thumbnail'

# List all files colorized in long format
alias l='ls -lF ${colorflag}'

# List all files colorized in long format, excluding . and ..
alias la='ls -lAF ${colorflag}'

# List only directories
alias lsd='ls -lF ${colorflag} | grep --color=never '^d''

# Always use color output for `ls`
alias ls='command ls ${colorflag}'

alias ssha="git rev-parse --short=7 HEAD"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Get week number
alias week='date +%V'

alias kr='killall ruby'
alias skr='sudo killall ruby'

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

alias fit="find . -iname "

# Reload the shell (i.e. invoke as a login shell)
alias reload='exec ${SHELL} -l'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ll="ls -alh"
# alias snow='for((I=0;J=--I;))do clear;for((D=LINES;S=++J**3%COLUMNS,--D;))do printf %*s.\\n $S;done;sleep .1;done'
alias snow='while sleep 0.1; do printf "%-$(( ( RANDOM % `tput cols` ) - 1))s\e[0;$(( 30 + ($RANDOM % 8) ))m*\n" ; done'

alias cdoc="set -x; docker system prune --all --force --volumes; docker volume prune --all --force; set +x"

alias cg='$HOME/bin/cleanup_git'
alias ug='$HOME/bin/update_git'
alias us='$HOME/bin/update_system'

alias tsup="sudo tailscale up --accept-routes=true --exit-node=unraid --shields-up=true"
alias tsdown="sudo tailscale down"

# IP addresses
alias ipaddy="curl https://icanhazip.com"
alias localip=myip

# Show active network interfaces
alias ifactive="ifconfig | pcre2grep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

alias openports="lsof -i tcp"
alias portscan="sudo nmap -sT -O "
alias brutalportscan="sudo nmap -p- -Pn -A -vv "
alias localnetwork="sudo nmap -sn 10.0.0.0/16"
alias localarp="arp -a -l"
alias arptable="arp -a -l"
alias arpclean="sudo arp -a -n -d"

if [[ "${PLATFORM-}" == "linux" ]]; then
  alias dumpbrew="brew bundle dump --force --global --all --no-lock --no-restart"
elif [[ "${PLATFORM-}" == "darwin" ]]; then
  alias dumpbrew="brew bundle dump --force --global --all --no-lock --no-restart"
fi

alias burnin="stress --cpu \$(proc_count) --io 10 --vm 20 --vm-bytes 128M --hdd 4 --hdd-bytes 1G --timeout 24h"

alias netcontent="sudo netstat -atln"

alias network_files="sudo lsof -Pni"

alias monitor_dns='sudo tshark -Y "dns.flags.response == 1" -Tfields \
  -e frame.time_delta \
  -e dns.qry.name \
  -e dns.a \
  -Eseparator=,'

alias monitor_http='sudo tshark -Y "http.request or http.response" -Tfields \
  -e ip.dst \
  -e http.request.full_uri \
  -e http.request.method \
  -e http.response.code \
  -e http.response.phrase \
  -Eseparator=/s'

alias monitor_https='sudo tshark -Y "ssl.handshake.certificate" -Tfields \
  -e ip.src \
  -e x509sat.uTF8String \
  -e x509sat.printableString \
  -e x509sat.universalString \
  -e x509sat.IA5String \
  -e x509sat.teletexString \
  -Eseparator=/s -Equote=d'

# misc
alias duh='du -h -d 1'
alias rmdir='rm -r'
alias neofetch='neofetch --config ~/.neofetch'

alias cs='gh cs create --location EastUs --machine standardLinux32gb'

alias k='kubectl'

alias prod='kubectl env prod'
alias stg='kubectl env stg'
alias dev='kubectl env dev'
alias dba='kubectl env dba'

alias kvpn=kill_vpns

alias k=kubectl
complete -o default -F __start_kubectl k

alias g=git
complete -o default -o nospace -F __git_wrap__git_main g

alias rubyconf='ruby -r rbconfig -e "pp RbConfig::CONFIG"'
alias prunesymlinks='find ! -name . -prune -type l | xargs rm'
