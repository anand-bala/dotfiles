local luadev = require("neodev").setup {
  lspconfig = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            "vim",
            -- AwesomeWM globals
            "awesome",
            "client",
            "screen",
            "root",
            "terminal",
          },
        },
      },
    },
  },
}

-- Setup for AwesomeWM
luadev.settings.Lua.workspace.library["/usr/share/awesome/lib"] = true

return luadev
