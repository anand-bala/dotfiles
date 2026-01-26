include coding-agents-common.inc

# ---------------------------------------------------------------------------------
# Allow read-write access ONLY to OpenCode configuration/cache
whitelist ${HOME}/.config/opencode
whitelist ${HOME}/.local/share/opencode
whitelist ${HOME}/.local/state/opencode
whitelist ${HOME}/.cache/opencode

read-write ${HOME}/.config/opencode
read-write ${HOME}/.local/share/opencode
read-write ${HOME}/.local/state/opencode
read-write ${HOME}/.cache/opencode
# ---------------------------------------------------------------------------------

