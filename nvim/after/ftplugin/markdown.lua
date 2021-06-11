vim.opt.formatoptions:append({t = true})

vim.cmd [[command -nargs=0 Preview FloatermNew --wintype=vsplit --width=0.5 --autoclose=1 --autoinsert=0 --disposable pandoc % | w3m -T text/html]]
