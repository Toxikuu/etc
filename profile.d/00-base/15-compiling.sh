# /etc/profile.d/00-base/15-compiling.sh

# Find the number of processors, with fallbacks
# 1. nproc
# 2. grep /proc/cpuinfo
# 3. 1
NPROC=$(
    nproc 2>/dev/null ||
    grep -c '^processor' /proc/cpuinfo 2>/dev/null ||
    echo 1
)

# Export some variables useful for compiling software
export MAKEFLAGS="-j$NPROC"
export LDFLAGS="-Wl,--as-needed"
export FFLAGS="-O2 -pipe"
export CFLAGS="-O2 -pipe"
export CXXFLAGS="-O2 -pipe"
