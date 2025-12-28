-- 1. Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Load core settings
require("core")

-- 3. Fix PATH (optional)
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.cargo/bin")

-- 4. Load plugins using Lazy
require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.user" },
})
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1
  vim.g.neovide_opacity = 0.95
  vim.g.neovide_background_color = "#0f1117"
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0

  vim.o.guifont = "Consolas,FiraCode Nerd Font:h9.5"
  vim.g.neovide_disable_ligatures = true
end
