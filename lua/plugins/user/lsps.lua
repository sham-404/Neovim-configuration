return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp", -- Ensure Blink is listed here or in your main plugins
    -- REMOVED: "hrsh7th/cmp-nvim-lsp" (This was causing the crash)
  },
  config = function()
    -- 1. Setup Mason
    require("mason").setup()

    require("blink.cmp").setup({
      completion = {
        trigger = {
          show_on_insert = true,
          show_on_keyword = true,
        },
      },
      sources = {
        default = {
          "lsp",
          "buffer",
          "snippets",
          "path",
        },
      },
    })

    -- 2. Capabilities (Use BLINK, not cmp_nvim_lsp)
    -- This handles the communication between the LSP and your completion menu
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local lspconfig = require("lspconfig")

    -- 3. Define Servers
    local servers = {
      cssls = {},

      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
              experimental = true,
            },
            check = {
              command = "check",
            },
            cargo = {
              enable = false, -- important
            },
            files = {
              watcher = "server", -- avoids errors without Cargo.toml
            },
            procMacro = {
              enable = false, -- single files don't need macros
            },
          },
        },
      },

      eslint = {
        settings = { run = "onSave" },
      },
      tailwindcss = {
        filetypes = {
          "astro",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "html",
          "css",
        },
      },
      ts_ls = {},
    }

    -- 4. Setup Mason-LSPConfig (The Glue)
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,

      handlers = {
        function(server_name)
          local server_config = servers[server_name] or {}
          -- Pass the Blink capabilities to the server
          server_config.capabilities = capabilities
          require("lspconfig")[server_name].setup(server_config)
        end,
      },
    })
  end,
}
