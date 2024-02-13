-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set linelength to 80 with colorcolumn
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"
vim.cmd("highlight ColorColumn ctermbg=lightgrey guibg=lightgrey")
