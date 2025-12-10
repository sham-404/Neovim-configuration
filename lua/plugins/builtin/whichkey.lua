return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- The sidebar look you liked
    preset = "helix",

    -- This 'spec' is where we define the GROUP names and ICONS
    spec = {
      {
        mode = { "n", "v" }, -- Normal and Visual mode
        { "<leader>b", group = "Buffers", icon = "󰈯" },
        { "<leader>c", group = "Code", icon = "" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>s", group = "Split/Window", icon = "" },
        { "<leader>u", group = "UI", icon = "" },
        { "<leader>q", group = "Quit/Session", icon = "󰗼" },
        { "<leader>g", group = "Git", icon = "" },
        { "<leader>l", group = "Lazy", icon = "󰒲" },
      },
    },
  },
}
