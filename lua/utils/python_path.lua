-- utils/python_path.lua
local M = {}

-- Search upwards for pyrightconfig.json
local function find_pyright_config(start_dir)
  local dir = start_dir or vim.fn.expand("%:p:h")
  dir = vim.fn.fnamemodify(dir, ":p")
  while dir ~= "/" and dir ~= "." and dir ~= "" do
    -- FIX: Use vim.fs.joinpath for cross-platform safety
    local cfg = vim.fs.joinpath(dir, "pyrightconfig.json")
    if vim.fn.filereadable(cfg) == 1 then
      -- Return the directory path as the project root
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- Resolve relative paths safely
local function resolve_path(path, base_dir)
  if not path or path == "" then
    return nil
  end
  base_dir = vim.fn.fnamemodify(base_dir or vim.fn.getcwd(), ":p")
  if not vim.startswith(path, "/") then
    -- FIX: Use vim.fs.joinpath here as well
    return vim.fn.fnamemodify(vim.fs.joinpath(base_dir, path), ":p")
  end
  return vim.fn.fnamemodify(path, ":p")
end

-- FIX: The function now returns a table: { path = "...", root = "..." }
function M.get_python_path()
  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" then
    buf_dir = vim.fn.getcwd()
  end
  buf_dir = vim.fn.fnamemodify(buf_dir, ":p")

  -- 1️⃣ Check pyright config
  local cfg_dir = find_pyright_config(buf_dir)
  if cfg_dir then
    local cfg_path = vim.fs.joinpath(cfg_dir, "pyrightconfig.json")
    local ok, lines = pcall(vim.fn.readfile, cfg_path)
    if ok and lines then
      -- FIX: Use a pcall with vim.fn.json_decode for better compatibility
      local decoded = nil
      local ok_decode, result = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
      if ok_decode then
        decoded = result
      end -- FIX: Safely check for decoded table before accessing keys
      if decoded then
        if decoded["python.pythonPath"] and decoded["python.pythonPath"] ~= "" then
          local py = resolve_path(decoded["python.pythonPath"], cfg_dir)
          if vim.fn.filereadable(py) == 1 then
            return { path = py, root = cfg_dir }
          end
        end

        if decoded.venv then
          local base = decoded.venvPath and resolve_path(decoded.venvPath, cfg_dir) or cfg_dir
          local venv_python = vim.fs.joinpath(base, decoded.venv, "bin/python")
          if vim.fn.filereadable(venv_python) == 1 then
            return { path = venv_python, root = cfg_dir }
          end
        end
      end
    end
  end

  -- 2️⃣ Search for local venvs (.venv or venv) upward
  local dir = buf_dir
  while dir ~= "/" and dir ~= "." and dir ~= "" do
    for _, name in ipairs({ ".venv", "venv" }) do
      -- FIX: Use vim.fs.joinpath for the candidate path
      local candidate = vim.fs.joinpath(dir, name, "bin/python")
      if vim.fn.filereadable(candidate) == 1 then
        -- We found the venv, so its containing dir is the project root
        return { path = candidate, root = dir }
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end

  -- 3️⃣ Final fallback to system Python (no specific project root found)
  return { path = "python", root = vim.fn.expand("%:p:h") or vim.fn.getcwd() }
end

return M
