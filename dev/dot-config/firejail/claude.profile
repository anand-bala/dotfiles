include coding-agents-common.inc

# ---------------------------------------------------------------------------------
# Allow read-write access ONLY to Claude's own configuration files and directories
whitelist ${HOME}/.claude.json
whitelist ${HOME}/.claude.json.*
whitelist ${HOME}/.claude/
whitelist ${HOME}/.claude/
whitelist ${HOME}/.local/share/claude

read-write ${HOME}/.claude.json
read-write ${HOME}/.claude.json.*
read-write ${HOME}/.claude/
read-write ${HOME}/.claude/
read-write ${HOME}/.local/share/claude
# ---------------------------------------------------------------------------------
