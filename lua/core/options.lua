local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true

opt.timeoutlen = 300
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8

opt.laststatus = 3 -- global statusline

opt.fillchars:append({ eob = " " })

vim.opt.clipboard = "unnamedplus"
