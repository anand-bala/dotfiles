local settings = {
  ["rust-analyzer"] = {
    checkOnSave = {
      command = "clippy",
    },
    rustfmt = {
      extraArgs = { "+nightly" },
    },
    cargo = {
      autoReload = true,
    },
  },
}

return {
  settings = settings,
}
