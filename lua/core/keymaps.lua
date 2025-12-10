-- lua/config/keymaps.lua

local map = vim.keymap.set

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable Space bar behavior (so it doesn't move cursor)
map("n", "<Space>", "<Nop>", { silent = true })

-----------------------------------------------------------
-- ✨ NEW: GENERAL QoL IMPROVEMENTS
-----------------------------------------------------------
-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent out" })
map("v", ">", ">gv", { desc = "Indent in" })

-- Move Lines Up/Down (Bubble text) like VSCode Alt+Up/Down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search with <Esc>
map({ "i", "n" }, "<Esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Lazy.nvim Shortcut
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-----------------------------------------------------------
-- FILE OPERATIONS
-----------------------------------------------------------
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" }) -- Changed to qa to close everything

-----------------------------------------------------------
-- TELESCOPE
-----------------------------------------------------------
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help docs" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Grep word under cursor" }) -- ✨ NEW

-----------------------------------------------------------
-- LSP
-----------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-----------------------------------------------------------
-- DIAGNOSTICS
-----------------------------------------------------------
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Send diagnostics to loclist" })

-----------------------------------------------------------
-- WINDOWS & SPLITS
-----------------------------------------------------------
-- Split Management
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Navigation (Integrates with Tmux if you use vim-tmux-navigator)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize with Arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-----------------------------------------------------------
-- BUFFERS (H/L Style)
-----------------------------------------------------------
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to last buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
-- Iterate buffers with H and L (Standard LazyVim)
map("n", "H", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

-----------------------------------------------------------
-- UI TOGGLES
-----------------------------------------------------------
map("n", "<leader>un", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })
map("n", "<leader>ur", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })
map("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spellcheck" })
map("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle wrap" }) -- ✨ NEW

-- Custom Diagnostic Toggle
map("n", "<leader>ud", function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
end, { desc = "Toggle diagnostics" })

-- Notifications (Noice)
map("n", "<leader>sn", "<cmd>NoiceHistory<CR>", { desc = "Notification history" })

-- Custom Escape
map("i", "fd", "<Esc>", { desc = "Escape" })
