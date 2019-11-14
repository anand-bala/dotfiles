if !exists('g:zig_std_path')
  let g:zig_std_path = $HOME."/src/zig/std"
endif

command! -bang -nargs=* ZigDoc
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>). ' '.shellescape(g:zig_std_path), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
