return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    config = function()
      local luasnip = require("luasnip")

      -- Load VS Code style snippets (HTML, JSX, React, etc.)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Optional: keep snippet history
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
    end,
  },
}
