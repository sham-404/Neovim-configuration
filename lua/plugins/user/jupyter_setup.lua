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
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
  end,

  config = function()
    -- Accurately find the current Jupyter cell boundaries
    local function get_cell()
      local current_window = vim.api.nvim_get_current_win()
      local current_pos = vim.api.nvim_win_get_cursor(current_window)

      -- If on the marker, move down one line to properly identify the block
      if vim.fn.getline(current_pos[1]):match("^# %%") and current_pos[1] < vim.fn.line("$") then
        vim.api.nvim_win_set_cursor(current_window, { current_pos[1] + 1, 0 })
      end

      -- Search backward for the marker
      local start_line = vim.fn.search("^# %%", "bnW")
      if start_line == 0 then
        start_line = 1
      else
        start_line = start_line + 1
      end

      -- Search forward for the next marker
      local end_line = vim.fn.search("^# %%", "nW")
      if end_line == 0 then
        end_line = vim.fn.line("$")
      else
        end_line = end_line - 1
      end

      -- Restore cursor
      vim.api.nvim_win_set_cursor(current_window, current_pos)

      -- Handle empty cells
      if start_line > end_line then
        start_line = end_line
      end

      return start_line, end_line
    end

    -- Execute keys synchronously to avoid visual mode sticking
    local function execute_sync(keys)
      local term_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
      vim.api.nvim_feedkeys(term_keys, "x", false)
    end

    -- ==========================================
    -- Keymaps
    -- ==========================================

    -- 1. Initialize & Manage Molten
    vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Init Molten" })
    vim.keymap.set("n", "<leader>md", ":MoltenDeinit<CR>", { silent = true, desc = "Deinit Molten" })
    vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { silent = true, desc = "Show Output" })
    vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide Output" })
    vim.keymap.set("n", "<leader>mx", ":MoltenDelete<CR>", { silent = true, desc = "Delete Cell Output" })

    -- 2. Run Current Cell
    vim.keymap.set("n", "<leader>rc", function()
      local current_pos = vim.api.nvim_win_get_cursor(0)
      local start_line, end_line = get_cell()

      -- Added <C-u> to clear the '<,'> range automatically inserted by visual mode
      local keys = string.format("%dG0V%dG:<C-u>MoltenEvaluateVisual<CR>", start_line, end_line)
      execute_sync(keys)

      vim.api.nvim_win_set_cursor(0, current_pos)
    end, { silent = true, desc = "Run Cell" })

    -- 3. Run and Move to Next Cell (Shift + Enter)
    vim.keymap.set("n", "<S-CR>", function()
      local current_pos = vim.api.nvim_win_get_cursor(0)
      local start_line, end_line = get_cell()

      -- Added <C-u> to clear the '<,'> range automatically inserted by visual mode
      local keys = string.format("%dG0V%dG:<C-u>MoltenEvaluateVisual<CR>", start_line, end_line)
      execute_sync(keys)

      -- Advance cursor to the next cell marker
      local next_cell_line = vim.fn.search("^# %%", "W")
      if next_cell_line ~= 0 then
        local target = math.min(next_cell_line + 1, vim.fn.line("$"))
        vim.api.nvim_win_set_cursor(0, { target, 0 })
      else
        vim.api.nvim_win_set_cursor(0, current_pos)
      end
    end, { silent = true, desc = "Run & Next Cell" })

    -- 4. Run All Cells
    vim.keymap.set("n", "<leader>ra", function()
      local current_pos = vim.api.nvim_win_get_cursor(0)
      local keys = string.format("1G0V%dG:<C-u>MoltenEvaluateVisual<CR>", vim.fn.line("$"))
      execute_sync(keys)
      vim.api.nvim_win_set_cursor(0, current_pos)
    end, { silent = true, desc = "Run All Cells" })

    -- 5. Execute Visual Selection
    vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>", { silent = true, desc = "Run Visual Selection" })

    -- 6. Navigation
    vim.keymap.set("n", "]j", function()
      local next_cell_line = vim.fn.search("^# %%", "W")
      if next_cell_line ~= 0 then
        vim.api.nvim_win_set_cursor(0, { math.min(next_cell_line + 1, vim.fn.line("$")), 0 })
      end
    end, { silent = true, desc = "Next Cell" })

    vim.keymap.set("n", "[j", function()
      local current_line = vim.fn.line(".")
      if
        vim.fn.getline(current_line):match("^# %%")
        or (current_line > 1 and vim.fn.getline(current_line - 1):match("^# %%"))
      then
        vim.api.nvim_win_set_cursor(0, { math.max(1, current_line - 2), 0 })
      end

      local prev_cell_line = vim.fn.search("^# %%", "bW")
      if prev_cell_line ~= 0 then
        vim.api.nvim_win_set_cursor(0, { math.min(prev_cell_line + 1, vim.fn.line("$")), 0 })
      else
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
      end
    end, { silent = true, desc = "Previous Cell" })

    -- ==========================================
    -- Custom Jupyter Cell UI
    -- ==========================================
    local function highlight_cells()
      local buf = vim.api.nvim_get_current_buf()
      local ns = vim.api.nvim_create_namespace("jupyter_cells")

      -- Clear previous highlights to avoid stacking them
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:match("^# %%") then
          -- 1. Create a full-width colored background block
          vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
            line_hl_group = "CursorLine", -- TokyoNight's subtle highlight color

            -- 2. Draw a physical horizontal divider line above the cell
            virt_lines = { { { string.rep("_", 100), "Comment" } } },
            virt_lines_above = true,
          })

          -- 3. Make the actual '# %%' text pop with bright blue and bold
          vim.api.nvim_buf_add_highlight(buf, ns, "Special", i - 1, 0, -1)
        end
      end
    end

    -- Hook the function to automatically run when you edit or open a Python file
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
      pattern = "*.py",
      callback = highlight_cells,
    })
  end,
}

-- return {
--   "Vigemus/iron.nvim",
--   config = function()
--     local iron = require("iron.core")
--     local view = require("iron.view")
--     local py_utils = require("utils.python_path")
--
--     -- ==========================================
--     -- Iron Core Setup
--     -- ==========================================
--     iron.setup({
--       config = {
--         scratch_repl = true,
--         -- Inside your iron.nvim setup:
--         repl_definition = {
--           python = {
--             command = function(meta)
--               local py_info = py_utils.get_python_path()
--
--               -- If we find the venv, use its IPython. Otherwise, fallback.
--               -- We add flags to remove the welcome banner, use simple prompts, and remove colors from the prompt to keep it clean.
--               if py_info.path:match(".venv") then
--                 local ipython_path = py_info.path:gsub("bin/python", "bin/ipython")
--                 if vim.fn.filereadable(ipython_path) == 1 then
--                   return { ipython_path, "--no-banner", "--quiet", "--colors=NoColor" }
--                 end
--               end
--
--               return { py_info.path } -- Fallback to standard python if no ipython is installed
--             end,
--             format = require("iron.fts.common").bracketed_paste_python,
--           },
--         },
--         repl_open_cmd = view.split.vertical.botright(40),
--       },
--       highlight = {
--         italic = true,
--       },
--       ignore_blank_lines = true,
--     })
--
--     -- ==========================================
--     -- Cell Parsing Logic
--     -- ==========================================
--     local function get_cell()
--       local current_window = vim.api.nvim_get_current_win()
--       local current_pos = vim.api.nvim_win_get_cursor(current_window)
--
--       if vim.fn.getline(current_pos[1]):match("^# %%") and current_pos[1] < vim.fn.line("$") then
--         vim.api.nvim_win_set_cursor(current_window, { current_pos[1] + 1, 0 })
--       end
--
--       local start_line = vim.fn.search("^# %%", "bnW")
--       if start_line == 0 then
--         start_line = 1
--       else
--         start_line = start_line + 1
--       end
--
--       local end_line = vim.fn.search("^# %%", "nW")
--       if end_line == 0 then
--         end_line = vim.fn.line("$")
--       else
--         end_line = end_line - 1
--       end
--
--       vim.api.nvim_win_set_cursor(current_window, current_pos)
--
--       if start_line > end_line then
--         start_line = end_line
--       end
--
--       return start_line, end_line
--     end
--
--     -- Helper to send exact lines to Iron without visual mode jumping
--     local function send_cell(start_line, end_line)
--       local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
--       iron.send(nil, lines)
--     end
--
--     -- ==========================================
--     -- Keymaps
--     -- ==========================================
--
--     -- 1. Initialize & Manage Iron
--     vim.keymap.set("n", "<leader>mi", "<cmd>IronRepl<CR>", { silent = true, desc = "Init REPL" })
--     vim.keymap.set("n", "<leader>md", "<cmd>IronRestart<CR>", { silent = true, desc = "Restart REPL" })
--     vim.keymap.set("n", "<leader>mo", "<cmd>IronFocus<CR>", { silent = true, desc = "Focus REPL" })
--     vim.keymap.set("n", "<leader>mh", "<cmd>IronHide<CR>", { silent = true, desc = "Hide REPL" })
--
--     -- 2. Run Current Cell
--     vim.keymap.set("n", "<leader>rc", function()
--       local current_pos = vim.api.nvim_win_get_cursor(0)
--       local start_line, end_line = get_cell()
--
--       send_cell(start_line, end_line)
--       vim.api.nvim_win_set_cursor(0, current_pos)
--     end, { silent = true, desc = "Run Cell" })
--
--     -- 3. Run and Move to Next Cell (Shift + Enter)
--     vim.keymap.set("n", "<S-CR>", function()
--       local current_pos = vim.api.nvim_win_get_cursor(0)
--       local start_line, end_line = get_cell()
--
--       send_cell(start_line, end_line)
--
--       local next_cell_line = vim.fn.search("^# %%", "W")
--       if next_cell_line ~= 0 then
--         local target = math.min(next_cell_line + 1, vim.fn.line("$"))
--         vim.api.nvim_win_set_cursor(0, { target, 0 })
--       else
--         vim.api.nvim_win_set_cursor(0, current_pos)
--       end
--     end, { silent = true, desc = "Run & Next Cell" })
--
--     -- 4. Run All Cells
--     vim.keymap.set("n", "<leader>ra", function()
--       local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--       iron.send(nil, lines)
--     end, { silent = true, desc = "Run All Cells" })
--
--     -- 5. Execute Visual Selection
--     vim.keymap.set("v", "<leader>r", function()
--       iron.visual_send()
--     end, { silent = true, desc = "Run Visual Selection" })
--
--     -- 6. Navigation
--     vim.keymap.set("n", "]j", function()
--       local next_cell_line = vim.fn.search("^# %%", "W")
--       if next_cell_line ~= 0 then
--         vim.api.nvim_win_set_cursor(0, { math.min(next_cell_line + 1, vim.fn.line("$")), 0 })
--       end
--     end, { silent = true, desc = "Next Cell" })
--
--     vim.keymap.set("n", "[j", function()
--       local current_line = vim.fn.line(".")
--       if
--         vim.fn.getline(current_line):match("^# %%")
--         or (current_line > 1 and vim.fn.getline(current_line - 1):match("^# %%"))
--       then
--         vim.api.nvim_win_set_cursor(0, { math.max(1, current_line - 2), 0 })
--       end
--
--       local prev_cell_line = vim.fn.search("^# %%", "bW")
--       if prev_cell_line ~= 0 then
--         vim.api.nvim_win_set_cursor(0, { math.min(prev_cell_line + 1, vim.fn.line("$")), 0 })
--       else
--         vim.api.nvim_win_set_cursor(0, { 1, 0 })
--       end
--     end, { silent = true, desc = "Previous Cell" })
--
--     -- ==========================================
--     -- Custom Jupyter Cell UI
--     -- ==========================================
--     local function highlight_cells()
--       local buf = vim.api.nvim_get_current_buf()
--       local ns = vim.api.nvim_create_namespace("jupyter_cells")
--
--       vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
--
--       local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--       for i, line in ipairs(lines) do
--         if line:match("^# %%") then
--           vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
--             line_hl_group = "CursorLine",
--             virt_lines = { { { string.rep("─", 100), "Comment" } } },
--             virt_lines_above = true,
--           })
--           vim.api.nvim_buf_add_highlight(buf, ns, "Special", i - 1, 0, -1)
--         end
--       end
--     end
--
--     vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
--       pattern = "*.py",
--       callback = highlight_cells,
--     })
--   end,
-- }
