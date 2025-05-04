# /etc/profile.d/25-prefs/05-aliases.sh

# Aliases I personally like
alias lsblk="lsblk -o NAME,PARTUUID,LABEL,TYPE,SIZE,MOUNTPOINTS"
alias nv="nvim"
alias ip="ip -c=always"
alias grep="grep --color"
alias ansistrip="sed 's,\x1b\[[0-9;]*m,,g'"

# Make sudo and doas interchangeable, and make su use the sudo prompt
if command -v sudo &>/dev/null; then
    alias su="sudo su"
    alias doas="sudo"
elif command -v doas &>/dev/null; then
    alias su="doas su"
    alias sudo="doas"
fi
