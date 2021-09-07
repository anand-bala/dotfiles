local util = require "lspconfig/util"

local M = {}

local server_version = "13.0.0"
local server_file = string.format("ltex-ls-%s-linux-x64.tar.gz", server_version)
local download_url = string.format(
  "https://github.com/valentjn/ltex-ls/releases/download/%s/%s",
  server_version,
  server_file
)

local custom_config = {
  default_config = {
    cmd = { string.format("./ltex-ls-%s/bin/ltex-ls", server_version) },
    filetypes = { "tex", "bib", "markdown" },
    root_dir = function(filename)
      return util.path.dirname(filename)
    end,
    settings = {
      ltex = {
        checkFrequency = "edit",
        enabled = { "latex", "markdown", "bib" },
      },
    },
  },
  docs = {
    package_json = "https://raw.githubusercontent.com/valentjn/vscode-ltex/develop/package.json",
    description = [[
https://github.com/valentjn/ltex-ls

LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with
support for LaTeX 🎓, Markdown 📝, and others

To install, download the latest
[release](https://github.com/valentjn/ltex-ls/releases) and ensure `ltex-ls` is on
your path.
    ]],

    default_config = {
      root_dir = "vim's starting directory",
    },
  },
  install_script = string.format(
    [[
if test -f ./ltex-ls-%s/bin/ltex-ls; then
  echo "ltex-ls exists."
else 
  curl -SL %s | tar xvz
fi
  ]],
    server_version,
    download_url
  ),
}

function M.register_custom()
  require("lspinstall/servers").ltex = custom_config
end

function M.setup()
  return {
    settings = {
      ltex = {
        enabled = { "latex", "tex", "bib", "markdown" },
        language = "en-US",
        diagnosticSeverity = "information",
        setenceCacheSize = 2000,
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en",
        },
        trace = { server = "verbose" },
        dictionary = { ["en-US"] = {} },
        disabledRules = { ["en-US"] = { "WHITESPACE_RULE" } },
        hiddenFalsePositives = {},
      },
    },
  }
end

return M
