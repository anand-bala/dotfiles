local function abolish(args)
  if vim.fn.exists ":Abolish" == 2 then
    vim.cmd("Abolish " .. table.concat(args, " "))
  end
end

abolish { "desparat{e,es,ed,ing,ely,ion,ions,or}", "desperat{}" }
abolish { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" }
abolish { "recieve", "receive" }
abolish { "beleive", "believe" }
