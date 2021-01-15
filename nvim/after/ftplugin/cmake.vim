let g:ale_cmake_cmakelint_executable = "cmake-lint"
let g:ale_cmake_cmakeformat_executable = "cmake-format"

let b:ale_linters = ["cmakelint"]
let b:ale_fixert = []

let &l:equalprg = 'cmake-format -'

