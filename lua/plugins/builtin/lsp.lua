return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls", -- updated!
        "pyright",
      },
    })

    -- Modern Neovim LSP config
    local lsp = vim.lsp
    local configs = require("lspconfig.configs")
    local util = require("lspconfig.util")

    -- LUA LS
    lsp.config["lua_ls"] = lsp.config["lua_ls"] or require("lspconfig.server_configurations.lua_ls")
    vim.lsp.start({
      name = "lua_ls",
      cmd = { "lua-language-server" },
      root_dir = util.root_pattern(".git", "init.lua"),
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- TS LS (NEW)
    lsp.config["ts_ls"] = lsp.config["ts_ls"] or require("lspconfig.server_configurations.tsserver")
    vim.lsp.start({
      name = "ts_ls",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    })

    -- Pyright
    lsp.config["pyright"] = lsp.config["pyright"] or require("lspconfig.server_configurations.pyright")
    vim.lsp.start({
      name = "pyright",
      cmd = { "pyright-langserver", "--stdio" },
      root_dir = util.root_pattern("requirements.txt", ".git"),
    })
  end,
}
