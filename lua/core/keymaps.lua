vim.g.mapleader = " "

local map = vim.keymap.set

-- File operations
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Editing
map("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlight" })

-- File explorer (Oil)
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
