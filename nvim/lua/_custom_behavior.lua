--- Register some custom behavior via autocmds
local utils = require('_utils')

local augroup = utils.create_augroup

-- Spell check on for the following
augroup("spellceck_ft_specific", {
    [[FileType markdown   setlocal spell]],
    [[FileType gitcommit  setlocal spell]],
    [[FileType tex,latex  setlocal spell]]
})

-- Custom filetype mappings
augroup("ft_mappings", {[[BufRead,BufNewFile *.tex,*.latex  set filetype=tex]]})

-- Make the cursor vertically centered
augroup("vertical_center_cursor", {
    [[BufEnter,WinEnter,WinNew,VimResized *,*.* let &scrolloff=winheight(win_getid())/2]]
})

-- Terminal
augroup("terminal_settings", {[[TermOpen * setlocal nonumber norelativenumber]]})
