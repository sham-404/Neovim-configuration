local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 80 })
  end,
})
