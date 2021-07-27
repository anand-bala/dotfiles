return {
  settings = {
    python = { workspaceSymbols = { enabled = true } },
    pyls = { configurationSources = { "flake8" }, plugins = { pydocstyle = { enable = false } } },
  },
}
