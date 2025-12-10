return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Load the plugin when entering Insert mode for performance
  config = function()
    require("nvim-autopairs").setup({
      -- Options can go here. The defaults are generally good.
      -- Example: check_ts=true enables Treesitter-based smarter pairing
      -- check_ts = true,
    })

    -- **Crucial for integrating with completion (like Blink/LSP snippets):**
    -- If you are using a completion engine like Blink (or nvim-cmp),
    -- you need to tell autopairs to work with it on completion confirm.
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if cmp_status_ok then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
