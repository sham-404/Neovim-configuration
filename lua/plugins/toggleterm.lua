return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      -- This is your DEFAULT direction for your main terminal
      direction = "float",
      size = 12,
      open_mapping = [[<c-\>]],
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      function _G.set_terminal_keymaps()
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, desc = "Exit terminal mode" })
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
    keys = {
      -- Normal toggleterm terminals
      {
        "<leader>ft",
        function()
          vim.cmd("cd %:p:h")
          -- This creates a terminal with your DEFAULT (horizontal) settings
          local term = require("toggleterm.terminal").Terminal:new({})
          term:toggle()
        end,
        desc = "Terminal: Toggle in file directory",
      },
      {
        "<leader>fT",
        function()
          vim.cmd("cd ~")
          -- This also creates a terminal with your DEFAULT (horizontal) settings
          local term = require("toggleterm.terminal").Terminal:new({})
          term:toggle()
        end,
        desc = "Terminal: Toggle in HOME directory",
      },

      -- <<< REPLACED <leader>r function >>>
      {
        "<leader>r",
        function()
          local ok, cmd = pcall(require("code_runner.commands").get_filetype_command)
          if not ok or not cmd or cmd == "" then
            vim.notify("No run command for this filetype", vim.log.levels.WARN)
            return
          end

          -- 1. Get the Terminal object
          local Terminal = require("toggleterm.terminal").Terminal

          -- 2. Create a new, *specific* terminal instance
          local runner_term = Terminal:new({
            cmd = cmd, -- Run the command
            direction = "float", -- !! Make it float !!
            close_on_exit = false, -- !! Auto-close when done !!
            hidden = true, -- Don't show in :ToggleTerm list

            -- Optional: Add float options for styling
            float_opts = {
              border = "rounded",
              width = function(term)
                return math.floor(vim.o.columns * 0.8)
              end,
              height = function(term)
                return math.floor(vim.o.lines * 0.8)
              end,
            },
          })

          -- 3. Open the terminal
          runner_term:toggle()
        end,
        desc = "Run code in FLOATING terminal",
      },
    },
  },
}
