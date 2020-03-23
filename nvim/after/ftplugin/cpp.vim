" Setup for C++ files

" map to <Leader>cf in C++ code
nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
vnoremap <buffer><Leader>cf :ClangFormat<CR>

set foldmethod=syntax

