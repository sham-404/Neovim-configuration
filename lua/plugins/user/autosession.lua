-- return {
--   {
--     "nvim-telescope/telescope.nvim",
--     dependencies = {
--       --"rmagatti/session-lens",
--       "rmagatti/auto-session",
--     },
--     config = function()
--       local telescope = require("telescope")
--       telescope.setup({})
--       --telescope.load_extension("session-lens")
--       require("auto-session").setup({
--         log_level = "error",
--         auto_restore_enabled = false,
--         auto_session_enable_last_session = false,
--         session_lens = {
--           load_on_setup = false,
--         },
--         pre_save_cmds = { "Neotree close" },
--         post_restore_cmds = { "Neotree show" },
--       })
--       -- Remove [No Name] buffers after session restore
--       vim.api.nvim_create_autocmd("User", {
--         pattern = "AutoSessionRestorePost",
--         callback = function()
--           for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--             if vim.api.nvim_buf_get_name(buf) == "" then
--               vim.api.nvim_buf_delete(buf, { force = true })
--             end
--           end
--         end,
--       })
--     end,
--   },
-- }

return {
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      log_level = "error",

      -- ❌ never auto-restore anything
      auto_restore_enabled = false,
      auto_session_enable_last_session = false,

      -- 🚫 do NOT auto-create sessions
      auto_session_create_enabled = false,

      -- ✅ auto-save ONLY if a session exists
      auto_save_enabled = true,

      -- 🧹 ignore junk dirs
      auto_session_suppress_dirs = {
        "~/",
        "~/Downloads",
        "/",
      },
    },
  },
}
