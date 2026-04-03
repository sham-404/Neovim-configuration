return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  init = function()
    -- 1. Manual folding mode
    vim.o.foldmethod = "manual"

    -- 3. Required UFO settings
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    -- 4. Keep workflow manual
    provider_selector = function()
      return ""
    end,

    -- 5. Clean, simple UI handler: appends " ... (X lines)"
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" ... (%d lines)"):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          break
        end
        curWidth = curWidth + chunkWidth
      end

      -- Uses a subtle standard highlight for the suffix
      table.insert(newVirtText, { suffix, "NonText" })
      return newVirtText
    end,
  },
}
