-- core/keymaps.lua

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Clipboard keymaps
vim.keymap.set('n', '<Space>y', '"+y', { desc = '[Y]ank into system clipboard' })
vim.keymap.set('n', '<Space>p', '"+p', { desc = '[P]aste from system clipboard' })

-- Windows
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Obsidian
vim.keymap.set("n", "<leader>ns", "<CMD>ObsidianSearch<CR>", { desc = "[S]earch [N]otes" })
vim.keymap.set("n", "<leader>nt", "<CMD>ObsidianToday<CR>", { desc = "[T]oday's [N]ote" })
vim.keymap.set("n", "<leader>nm", "<CMD>ObsidianTomorrow<CR>", { desc = "To[m]orrow's [N]ote" })
vim.keymap.set("n", "<leader>ny", "<CMD>ObsidianYesterday<CR>", { desc = "[Y]esterday's [N]ote" })

-- Neotest
-- -- Neotest
vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "[T]est [N]earest" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,
  { desc = "[T]est nearest [F]ile" })
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,
  { desc = "[D]ebug nearest [T]est" })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble Symbols" })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Trouble Buffer Diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble Quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble Loclist" })
vim.keymap.set("n", "gR", "<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.3<cr>")

-- Telescope keymaps
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep, { desc = '[/] Live grep' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = '[F]ind files' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sW', require('telescope.builtin').lsp_dynamic_workspace_symbols,
  { desc = '[S]earch [W]orkspace symbols' })

-- Which-key registrations
-- (This would typically be called after the which-key plugin is loaded)
local wk = require("which-key")
wk.register({
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>n'] = { name = '[N]otes', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]est', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
})

-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
wk.register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
}, { mode = 'v' })

return {}
