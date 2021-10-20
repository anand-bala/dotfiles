local myconfigs = {}

function myconfigs.__index(table, key)
  -- If key already in table, then return it
  if rawget(table, key) ~= nil then
    return rawget(table, key)
  end

  -- Otherwise, try load the correct submodule
  local ok, conf = pcall(require, "_lsp/configs/" .. key)
  if ok then
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
