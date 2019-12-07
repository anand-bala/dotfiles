" A plugin to write the same line multiple times with some pattern


function Repeatn(fmt_str, ...)
  for arg in a:000
    " NOTE: The function currently supports only one argument in the format
    " string. This is stupid.
    " TODO: Function should be able to handle multiple args in format string.
    let l:out = printf(a:fmt_str, arg)
    execute "normal! i".(l:out)
  endfor
endf

