# Aliases and functions

#
# Generally-useful aliases
#
alias axfr='dig AXFR' # Zone transfer
alias clip='xclip -selection clipboard' # Put input to x primary clipboard
alias clr='clear'
alias digs='dig +short' # reduce dig output
alias duhso='du -h | sort -Vr | head' # Human-readable disk usage top offenders in curr dir
alias duso='du | sort -Vr | head' # Disk usage top offenders in curr dir
alias egrep='grep  --exclude-dir=".svn"--exclude-dir=".git" -E'
alias fgrep='grep --exclude-dir=".svn" --exclude-dir=".git" -F'
alias grep='grep  --exclude-dir=".svn"--exclude-dir=".git"'
alias grepi='grep --exclude-dir=".svn"--exclude-dir=".git" -i' # case-insensitive grep
alias ll='ls -l'
alias lla='ls -la'
alias llz='ls -lZ'
alias nodeactivate='PATH=$(npm bin):$PATH; '
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'" # For REALLY improtant security things
alias sortip='sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4' # Sort ip addresses
alias sudo='sudo ' # to allow sudoing with aliases

#
# Packaging
#
alias apts='apt-cache search'
alias aptshow='apt-cache show'
alias aptinst='apt-get install'
alias aptupd='apt-get update'
alias aptupg='apt-get upgrade'
alias aptrm='apt-get remove'

#
# Aliases rather particular to my use-case
#
alias locksleep='sudo echo && sudo -u csp i3lock -I 10 && sudo pm-suspend'
alias sizerate='$HOME/.bin/sizerate'

#
# Functions
#
# Misc
g() {
  # Google some input directly from cli
  # via Avinash Raj on AskUbuntu https://askubuntu.com/a/486021
  search=""
  echo "Googling: $@"
  for term in $@; do
      search="$search%20$term"
  done
  xdg-open "https://www.google.com/search?q=$search"
}

# hr print horizontal rule, default with '-' but char can be provided
# based on: https://www.reddit.com/r/commandline/comments/7zvmze/show_hr_a_cli_program_that_outputs_a_horizontal/durci2h/
hr() {
  outchar='-'
  if [ ! -z "$1" ]; then
    if [ "${#1}" -eq 1 ]; then
      outchar=$1
    fi
  fi
  printf "%0.s${outchar}" $(seq 1 $(tput cols))
}

# md5sum comparison
md5comp() {
  md5sum=$(md5sum "$1" | tr -s ' ' | cut -d ' ' -f 1)
  for filename in "$@"; do
    newsum=$(md5sum "$filename" | tr -s ' ' | cut -d ' ' -f 1)
    if [ "$newsum" != "$md5sum" ]; then
      echo "No match"
      return 1
    fi
  done

  echo "Match"
  return 0
}

# Mosh
moshs() {
  # Open mosh to host $1 with a screen session as same user
  mosh_screen $1
}

moshr() {
  # Open mosh to host $1 with a screen session as root
  mosh_screen $1 '' 'sudo'
}

mosh_screen() {
  # Connect to mosh with a screen session.
  #
  # Params:
  #  $1: Hostname
  #  $2: Screen session name. If not given defaults to username
  #  $3: sudo? Sudos if nonempty

  if [ ! -z "$2" ]; then
    screenname=$2
  else
    screenname=$(whoami)
  fi
  if [ ! -z "$3" ]; then
    sudocmd='sudo '
  else
    sudocmd=' '
  fi
  hostnameshellcmd='$(hostname)'
  mosh "${1}" -- bash -c "echo \"Logging into host ${1}  identifying as ${hostnameshellcmd}\"; ${sudocmd} screen -DR -S ${screenname}"
}

# Ssh
dossh() {
  # Keep trying to connect over ssh
        ssh "$1"
        until [ $? -eq 0 ]; do
                sleep 1; ssh "$1"
        done
}

sshs() {
  # Open ssh to host $1 with a screen session as same user
  ssh_screen $1
}

sshr() {
  # Open ssh to host $1 with a screen session as root
  ssh_screen $1 '' 'sudo'
}


ssh_screen() {
  # Connect to ssh with a screen session.
  #
  # Params:
  #  $1: Hostname
  #  $2: Screen session name. If not given defaults to username
  #  $3: sudo? Sudos if nonempty

  if [ ! -z "$2" ]; then
    screenname=$2
  else
    screenname=$(whoami)
  fi
  if [ ! -z "$3" ]; then
    sudocmd='sudo '
  else
    sudocmd=' '
  fi
  hostnameshellcmd='$(hostname)'
  ssh -t ${1} "clear; echo \"Logging into host ${1}  identifying as ${hostnameshellcmd}\"; ${sudocmd} screen -DR -S ${screenname}"
}
