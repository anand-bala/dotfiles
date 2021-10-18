local M = {}

local util = require "lspconfig/util"

return {
  root_dir = function(fname)
    return util.root_pattern("build", "compile_commands.json")(fname)
      or util.path.dirname(fname)
  end,
}
