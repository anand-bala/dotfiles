return {
  init_options = { clangdFileStatus = true },
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
}
