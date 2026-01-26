# Firejail profile for Claude Code
# This profile is designed to be highly restrictive for running AI agents safely.
# Specifically, the goal is to have whitelist only
quiet

# -- lock shit down
noroot
nonewprivs
# private-home
private-dev
private-tmp


include allow-common-devel.inc
include disable-common.inc
include disable-programs.inc
#include disable-xdg.inc

# ipc-namespace
machine-id
nonewprivs
novideo
nosound
# keep-fd
# tracelog

dbus-user none
dbus-system none

# noexec /tmp

include whitelist-common.inc
include whitelist-common-devel.inc
keep-shell-rc


# Networking
# netfilter
protocol unix,inet,inet6,packet,netlink

# Hardening
caps.drop all
seccomp
