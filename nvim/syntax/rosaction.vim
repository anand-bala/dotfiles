" Read the rosmsg syntax to start with
runtime! syntax/rosmsg.vim
unlet b:current_syntax

syn match rosactionSeparator   "^---$"

hi def link rosactionSeparator Special

let b:current_syntax = "rosaction"

