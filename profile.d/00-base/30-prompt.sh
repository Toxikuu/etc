# /etc/profile.d/00-base/30-prompt.sh

# Define some basic prompts
NORMAL="\[\e[0m\]"
BOLD="\[\e[1m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"

if [[ $EUID == 0 ]]; then
    PS1="${BOLD}${RED} [ ${NORMAL}\w${BOLD}${RED} ]# ${NORMAL}"
else
    PS1="${BOLD}${GREEN} [ ${NORMAL}\w${BOLD}${GREEN} ]\$ ${NORMAL}"
fi

unset RED GREEN BOLD NORMAL
