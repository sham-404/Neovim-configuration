return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v0.*",

  opts = {
    keymap = {
      preset = "default",

      ["<CR>"] = { "accept", "fallback" }, -- FIXED
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev" },
    },

    completion = {
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline"
        end,
      },
    },

    cmdline = {
      enabled = true,

      keymap = {
        ["<Tab>"] = { "accept" },
      },

      completion = {
        menu = { auto_show = true },
      },
    },
  },
}
