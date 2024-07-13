-- core/project_config.lua

local M = {}

function M.load_project_config()
  local config_path = vim.fn.findfile('.nvim.lua', '.;')
  if config_path ~= '' then
    local config = loadfile(config_path)
    if config then
      local ok, err = pcall(config)
      if not ok then
        vim.notify('Error loading project config: ' .. err, vim.log.levels.ERROR)
      else
        vim.notify('Loaded project config from ' .. config_path, vim.log.levels.INFO)
      end
    end
  end
end

return M
