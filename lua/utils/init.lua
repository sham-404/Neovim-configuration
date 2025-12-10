local M = {}

function M.info(msg)
	vim.notify(msg, vim.log.levels.INFO)
end

return M
