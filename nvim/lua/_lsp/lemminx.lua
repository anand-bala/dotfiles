local util = require 'lspconfig/util'
local Path = require("plenary").path

local M = {}

local server_version = "0.16.2"
local server_file = string.format("org.eclipse.lemminx-%s-uber.jar", server_version)
local download_url = string.format(
                       "https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx/org.eclipse.lemminx/%s/%s",
                       server_version, server_file)

local custom_config = {
  default_config = {
    cmd = {
      "java", "-noverify", "-cp", string.format("./%s", server_file),
      "org.eclipse.lemminx.XMLServerLauncher"
    },
    filetypes = {"xml", "xsd", "svg"},
    root_dir = function(filename)
      return util.root_pattern(".git")(filename) or util.path.dirname(filename)
    end
  },
  docs = {
    description = [[
https://github.com/eclipse/lemminx

Features:
 - textDocument/codeAction
 - textDocument/completion
 - textDocument/definition (jump between opening and closing tags)
 - textDocument/documentHighlight
 - textDocument/documentLink
 - textDocument/documentSymbol
 - textDocument/foldingRanges
 - textDocument/formatting
 - textDocument/hover
 - textDocument/rangeFormatting
 - textDocument/rename
 - textDocument/typeDefinition (link from an XML element to the definition of the element in the schema file)
]]
  },
  install_script = string.format([[curl -LO %s]], download_url)
}

function M.register_custom() require("lspinstall/servers").lemminx = custom_config end

function M.setup()
  return {
    settings = {
      xml = {
        java = {home = "/usr/lib/jvm/default-java"},
        server = {workDir = tostring(Path:new(vim.fn.stdpath("cache"), "lemminx"))}
      }
    }

  }
end

return M
