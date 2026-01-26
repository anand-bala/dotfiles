# Git
whitelist-ro ${HOME}/.config/git
whitelist-ro ${HOME}/.gitconfig
whitelist-ro ${HOME}/.git-credentials

# Node
whitelist-ro ${HOME}/.npm
whitelist-ro ${HOME}/.npmrc
whitelist-ro ${HOME}/.yarn
whitelist-ro ${HOME}/.yarnrc
whitelist-ro ${HOME}/.local/share/bun

# Python
whitelist-ro ${HOME}/.local/lib/python3*
whitelist-ro ${HOME}/.local/share/uv

# Rust
whitelist-ro ${HOME}/.cargo
whitelist-ro ${HOME}/.rustup

# Pixi (Conda)
whitelist-ro ${HOME}/.local/share/pixi
whitelist ${HOME}/.cache/rattler

# Common bin dirs
whitelist-ro ${HOME}/.local/bin
whitelist-ro ${HOME}/.local/bin

# Fish shell
whitelist-ro ${HOME}/.config/fish

# neovim
whitelist-ro ${HOME}/.config/nvim
whitelist-ro ${HOME}/.local/share/nvim
whitelist ${HOME}/.local/state/nvim
read-write ${HOME}/.local/state/nvim

# direnv
whitelist-ro ${HOME}/.config/direnv
whitelist-ro ${HOME}/.local/share/direnv


