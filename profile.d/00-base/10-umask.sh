# /etc/profile.d/00-base/10-umask.sh

# Sets the umask
if [ "$(id -gn)" = "$(id -un)" ] && [ $EUID -gt 99 ]; then
  umask 002
else
  umask 022
fi
