let b:dispatch = 'latexmk -pdf -pvc'
compiler latexmk

" setlocal formatoptions+=t
setlocal textwidth=88

let g:tex_conceal="abdgm"
let g:tex_flavor = 'latex'
