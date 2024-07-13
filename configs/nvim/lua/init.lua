-- init.lua

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load core configurations
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- Load plugin configurations
require('plugins.lsp')
require('plugins.completion')
require('plugins.treesitter')
require('plugins.telescope')
require('plugins.git')
require('plugins.ui')
require('plugins.extras')
require('plugins.linters')

-- Load project-specific configuration
require('core.project_config').load_project_config()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
