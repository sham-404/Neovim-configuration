return {
    "benlubas/molten-nvim",
    version = "^1.0.0",

    dependencies = {
        "3rd/image.nvim",
    },

    build = ":UpdateRemotePlugins",

    init = function()
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 20
        vim.g.molten_auto_open_output = true
        vim.g.molten_wrap_output = true
        vim.g.molten_virt_text_output = true
    end,

    config = function()
        -- Helper function to find cell boundaries dynamically
        local function get_cell_boundaries()
            local start_line = vim.fn.search("^# %%", "bnW")
            if start_line == 0 then 
                start_line = 1 
            else 
                start_line = start_line + 1 -- Skip the actual '# %%' comment line
            end

            local end_line = vim.fn.search("^# %%", "nW")
            if end_line == 0 then 
                end_line = vim.fn.line("$") 
            else
                end_line = end_line - 1 -- Stop right before the next cell marker
            end
            
            -- Fallback in case of empty cells
            if start_line > end_line then
                start_line = end_line
            end
            
            return start_line, end_line
        end

        -- Helper function to execute a specific range of lines via visual mode
        local function execute_lines(start_line, end_line)
            vim.api.nvim_win_set_cursor(0, { start_line, 0 })
            vim.cmd("normal! V")
            vim.api.nvim_win_set_cursor(0, { end_line, 0 })
            vim.cmd("MoltenEvaluateVisual")
            vim.cmd("execute 'normal! \\<Esc>'") -- Ensure we exit visual mode afterward
        end

        -- 1. Kernel Management
        vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Init Molten" })

        -- 2. Run Current Cell (Maintains cursor position)
        vim.keymap.set("n", "<leader>rc", function()
            local current_pos = vim.api.nvim_win_get_cursor(0) -- Save cursor
            local start_line, end_line = get_cell_boundaries()
            execute_lines(start_line, end_line)
            vim.api.nvim_win_set_cursor(0, current_pos) -- Restore cursor
        end, { silent = true, desc = "Run Current Cell" })

        -- 3. Run and Move to Next Cell (Shift + Enter)
        vim.keymap.set("n", "<S-CR>", function()
            local start_line, end_line = get_cell_boundaries()
            execute_lines(start_line, end_line)
            
            -- Advance cursor to the start of the next cell
            local next_cell = vim.fn.search("^# %%", "W")
            if next_cell ~= 0 then
                vim.api.nvim_win_set_cursor(0, { next_cell, 0 })
            end
        end, { silent = true, desc = "Run and Next Cell" })

        -- 4. Run All Cells in File
        vim.keymap.set("n", "<leader>ra", function()
            local current_pos = vim.api.nvim_win_get_cursor(0)
            execute_lines(1, vim.fn.line("$"))
            vim.api.nvim_win_set_cursor(0, current_pos)
        end, { silent = true, desc = "Run All Cells" })

        -- 5. Execute Visual Selection
        vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Run Visual Selection" })

        -- 6. Navigation: Next / Previous Cell (using standard search so it populates the jumplist)
        vim.keymap.set("n", "]c", "/^# %%<CR>", { silent = true, desc = "Next Cell" })
        vim.keymap.set("n", "[c", "?^# %%<CR>", { silent = true, desc = "Previous Cell" })
    end,
}
