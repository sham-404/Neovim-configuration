return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      python = { "black" },
      c = { "clang-format" },
    },
  },
}
