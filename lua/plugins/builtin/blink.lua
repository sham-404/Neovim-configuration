return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v0.*",
  opts = {
    keymap = {
      preset = "default",
    },

    completion = {
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" -- don't auto-popup in cmdline
        end,
      },
    },

    -- 🔥 enable cmdline completions
    -- (this is the key part you're missing)
    cmdline = {
      enabled = true,
      keymap = {
        -- LazyVim style
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
}
