" Read the rosmsg syntax to start with
runtime! syntax/rosmsg.vim
unlet b:current_syntax

syn match rossrvSeparator   "^---$"

hi def link rossrvSeparator Special

let b:current_syntax = "rossrv"
