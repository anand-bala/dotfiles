local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function abolish(args)
  -- if vim.fn.exists ":Abolish" == 2 then
  vim.cmd("Abolish " .. table.concat(args, " "))
  -- end
end

autocmd({ "InsertEnter" }, {
  group = augroup("MyAbolishConf", {}),
  pattern = "*",
  callback = function()
    abolish { "desparat{e,es,ed,ing,ely,ion,ions,or}", "desperat{}" }
    abolish { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" }
    abolish { "reciev{e,es,ed,ing}", "receiv{}" }
    abolish { "beleiv{e,es,ed,ing}", "believ{}" }
    abolish { "cal{a,e}nder{,s}", "cal{e}ndar{}" }
    abolish { "{,non}existan{ce,t}", "{}existen{}" }
    abolish { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" }
    abolish { "reproducable", "reproducible" }
    abolish { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" }
    abolish { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" }
  end,
  once = true,
})
