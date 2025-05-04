# /etc/profile.d/00-base/02-i18n.sh

# Set up i18n variables
for i in $(locale); do
    unset "${i%=*}"
done

# Just use C if on a tty
if [[ "$(tty)" =~ /dev/tty ]]; then
    export LANG=C.UTF-8
    exit 0
fi

# Otherwise, use a regular locale
source /etc/locale.conf

for i in $(locale); do
    key="${i%=*}"
    if [[ -v $key ]]; then
        export "${key?}"
    fi
done
