local myconfigs = {}

local default_capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local default_conf = {
  on_init = function(client)
    client.config.flags = {}
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
  end,
  capabilities = default_capabilities,
}

function myconfigs.__index(table, key)
  -- If key already in table, then return it
  if rawget(table, key) ~= nil then
    return rawget(table, key)
  end

  -- Otherwise, try load the correct submodule
  local ok, conf = pcall(require, "_lsp/configs/" .. key)
  if ok then
    conf = vim.tbl_deep_extend("force", default_conf, conf)
    -- Store the conf in the table so we don't have to pcall again.
    rawset(table, key, conf)
    return conf
  end

  -- Otherwise, store an empty table (as we don't have a specific configuration for this
  -- server)
  table[key] = {}

  return {}
end

return setmetatable({}, myconfigs)
