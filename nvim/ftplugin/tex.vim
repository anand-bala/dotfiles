setlocal spell
setlocal textwidth=80

function InputFilesFrom(dir, pattern)
  let l:files = split(globpath(a:dir, a:pattern), '\n')
  for f in l:files
    let l:file = substitute(f,"\\","/", "g") 
    let l:out = printf("\\input{%s}\n", l:file)
    execute "normal! i".(l:out)
  endfor
endfunction

