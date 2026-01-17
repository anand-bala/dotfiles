# Firejail profile for Claude Code
# This profile is designed to be highly restrictive for running AI agents safely.
# Specifically, the goal is to have whitelist only

# Persistent global definitions
include globals.local

# -- lock shit down
noroot
# private-home
private-dev
private-tmp

include allow-common-devel.inc
include disable-common.inc
include disable-programs.inc
include disable-xdg.inc

ipc-namespace
machine-id
nonewprivs
novideo
nosound
# tracelog

dbus-user none
dbus-system none

noexec /tmp

include whitelist-common-devel.inc
keep-shell-rc

# ---------------------------------------------------------------------------------
# Allow read-write access ONLY to Claude's own configuration files and directories
whitelist ${HOME}/.claude.json
whitelist ${HOME}/.claude.json.*
whitelist ${HOME}/.claude/
whitelist ${HOME}/.claude/

# ---------------------------------------------------------------------------------

# Networking
netfilter
protocol unix,inet,inet6

# Hardening
caps.drop all
seccomp
