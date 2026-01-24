return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  
  opts = {
    defaults = {
      -- These patterns are ALWAYS ignored, even if 'hidden' is enabled
      file_ignore_patterns = {
        "%.git/",          -- Hides the massive .git folder
        "node_modules/",   -- Hides JS dependencies
        "bin/",
        "venv/",           -- Hides standard python env
        "%.venv/",         -- Hides dot-prefixed python env
        "__pycache__/",    -- Hides python cache
        "%.DS_Store",      -- Hides mac metadata
        "%.lock",          -- Optional: Hides lockfiles if you find them annoying
      },
    },
    pickers = {
      find_files = {
        hidden = true,     -- REQUIRED: This lets .gitignore and .env be seen
      },
    },
  },

  config = function(_, opts)
    require("telescope").setup(opts)
  end,
}
