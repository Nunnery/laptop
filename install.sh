set -e

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
tput=$(which tput)
if [ -n "$tput" ]; then
    ncolors=$($tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability). Note
# that this will be ignored under Cygwin by default, as Windows ACLs take
# precedence over umasks except for filesystems mounted with option "noacl".
umask g-w,o-w

printf "${BLUE}Cloning laptop...${NORMAL}\n"
hash git >/dev/null 2>&1 || {
  echo "Error: git is not installed"
  exit 1
}
env git clone --depth=1 https://github.com/Nunnery/laptop.git $HOME/laptop || {
  printf "Error: git clone of laptop repo failed\n"
  exit 1
}

printf "${BLUE}Installing laptop for you.${NORMAL}\n"
(cd $HOME/laptop && sh mac 2>&1 | tee ~/laptop.log)
