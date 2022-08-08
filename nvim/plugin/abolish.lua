local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function abolish(args)
  -- if vim.fn.exists ":Abolish" == 2 then
  vim.cmd("Abolish " .. table.concat(args, " "))
  -- end
end

do
  local abolish_abbrevs = augroup("abolish_abbrevs", {})
  autocmd("VimEnter", {
    group = abolish_abbrevs,
    pattern = "*",
    callback = function()
      abolish { "desparat{e,es,ed,ing,ely,ion,ions,or}", "desperat{}" }
      abolish { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" }
      abolish { "recieve", "receive" }
      abolish { "beleive", "believe" }
    end,
  })
end
