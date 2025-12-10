return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          position = "left",
        })
      end,
      desc = "Toggle Neo-tree Explorer",
    },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,

    filesystem = {
      follow_current_file = true,
      use_libuv_file_watcher = true,

      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },

    window = {
      width = 35,
      mappings = {
        ["<space>"] = false,
        ["l"] = "open",
        ["h"] = "close_node",
        ["<cr>"] = "open",
        ["o"] = "open",
      },
    },

    default_component_configs = {
      indent = {
        padding = 1,
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
