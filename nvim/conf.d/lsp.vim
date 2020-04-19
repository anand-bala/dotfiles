" -- nvim-lsp completions-nvim diagnostics-nvim
" {{{
" Load default LSP configuration
luafile ~/.config/nvim/lua/config.lua

" Enable languages
lua require'nvim_lsp'.ccls.setup{on_attach=require'on_attach'.on_attach}
au Filetype c,cpp setl omnifunc=v:lua.vim.lsp.omnifunc
lua require'nvim_lsp'.pyls_ms.setup{on_attach=require'on_attach'.on_attach}
au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
lua require'nvim_lsp'.rust_analyzer.setup{on_attach=require'on_attach'.on_attach}
au Filetype rust setl omnifunc=v:lua.vim.lsp.omnifunc
lua require'nvim_lsp'.texlab.setup{on_attach=require'on_attach'.on_attach}
au Filetype tex,latex setl omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF
require'nvim_lsp'.sumneko_lua.setup{
    on_attach= require'on_attach'.on_attach;
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable";
            };
            runtime = {
                version = "LuaJIT";
            };
        };
    };
}
EOF

au Filetype lua setl omnifunc=v:lua.vim.lsp.omnifunc
lua require'nvim_lsp'.vimls.setup{on_attach=require'on_attach'.on_attach}
au Filetype vim setl omnifunc=v:lua.vim.lsp.omnifunc


let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [
            \       {'complete_items': ['path']}]
            \   },
            \ 'markdown' : {
            \   'default': [
            \       {'mode': 'spel'}],
            \   'comment': [],
            \   },
            \ 'verilog' : {
            \   'default': [
            \       {'complete_items': ['ts']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   }
            \}
" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
" autocmd CursorMoved * lua vim.lsp.util.show_line_diagnostics()

let g:LspDiagnosticsErrorSign = ' '
let g:LspDiagnosticsWarningSign = '⚡'
let g:LspDiagnosticsInformationSign = 'I'
let g:LspDiagnosticsHintSign = 'H'

" diagnostic-nvim
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_virtual_text_prefix = ' '
let g:diagnostic_trimmed_virtual_text = 30
let g:space_before_virtual_text = 5
let g:diagnostic_insert_delay = 1

" completion-nvim
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 1
let g:completion_timer_cycle = 200

" }}}


