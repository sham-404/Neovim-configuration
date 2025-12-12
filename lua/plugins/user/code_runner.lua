return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
  },
  {
    "CRAG666/code_runner.nvim",
    lazy = false,
    config = function()
      local python_util = require("utils.python_path")

      require("code_runner").setup({
        filetype = {

          ----------------------------------------------------------------------
          -- PYTHON
          ----------------------------------------------------------------------
          python = function()
            local venv_info = python_util.get_python_path()
            local py_executable = vim.fn.shellescape(venv_info.path)
            local file = vim.fn.shellescape(vim.fn.expand("%:p"))
            return string.format("%s %s$end", py_executable, file)
          end,

          ----------------------------------------------------------------------
          -- C
          ----------------------------------------------------------------------
          c = function()
            local file_dir = vim.fn.expand("%:p:h")
            local file_path = vim.fn.expand("%:p")
            local exe_name = vim.fn.expand("%:t:r")
            local bin_dir = file_dir .. "/bin"
            local exe_path = bin_dir .. "/" .. exe_name

            return string.format(
              "mkdir -p %s && gcc %s -o %s && %s$end",
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(file_path),
              vim.fn.shellescape(exe_path),
              vim.fn.shellescape(exe_path)
            )
          end,

          ----------------------------------------------------------------------
          -- C++
          ----------------------------------------------------------------------
          cpp = function()
            local file_dir = vim.fn.expand("%:p:h")
            local file_path = vim.fn.expand("%:p")
            local exe_name = vim.fn.expand("%:t:r")
            local bin_dir = file_dir .. "/bin"
            local exe_path = bin_dir .. "/" .. exe_name

            return string.format(
              "mkdir -p %s && g++ %s -o %s && %s$end",
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(file_path),
              vim.fn.shellescape(exe_path),
              vim.fn.shellescape(exe_path)
            )
          end,

          ----------------------------------------------------------------------
          -- JAVA
          ----------------------------------------------------------------------
          java = function()
            local file_dir = vim.fn.expand("%:p:h")
            local file_path = vim.fn.expand("%:p")
            local class_name = vim.fn.expand("%:t:r")
            local bin_dir = file_dir .. "/bin"

            return string.format(
              "mkdir -p %s && javac -d %s %s && java -cp %s %s$end",
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(file_path),
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(class_name)
            )
          end,

          ----------------------------------------------------------------------
          -- RUST (ADDED)
          ----------------------------------------------------------------------
          rust = function()
            local file_dir = vim.fn.expand("%:p:h") -- folder path
            local file_path = vim.fn.expand("%:p") -- full rust file path
            local exe_name = vim.fn.expand("%:t:r") -- filename without .rs
            local bin_dir = file_dir .. "/bin" -- bin directory
            local exe_path = bin_dir .. "/" .. exe_name -- output binary path

            -- `rustc` output flag must be `-o`
            return string.format(
              "mkdir -p %s && rustc %s -o %s && %s$end",
              vim.fn.shellescape(bin_dir),
              vim.fn.shellescape(file_path),
              vim.fn.shellescape(exe_path),
              vim.fn.shellescape(exe_path)
            )
          end,

          ----------------------------------------------------------------------
          -- JS / LUA / SH / DART
          ----------------------------------------------------------------------
          javascript = function()
            return string.format("node %s$end", vim.fn.shellescape(vim.fn.expand("%:p")))
          end,

          lua = function()
            return string.format("lua %s$end", vim.fn.shellescape(vim.fn.expand("%:p")))
          end,

          sh = function()
            return string.format("bash %s$end", vim.fn.shellescape(vim.fn.expand("%:p")))
          end,

          dart = function()
            return string.format("dart run %s$end", vim.fn.shellescape(vim.fn.expand("%:p")))
          end,
        },
      })

      vim.keymap.set("n", "<leader>R", ":RunCode<CR>", {
        desc = "Run file dynamically (uses pyright/venv)",
      })
    end,
  },
}
