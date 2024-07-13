-- plugins/ui.lua

-- Catppuccin theme configuration
require('catppuccin').setup({
  integrations = {
    cmp = true,
    gitsigns = true,
    telescope = true,
    notify = true,
    mini = { enabled = true },
    dap = true,
    treesitter = true,
    lsp_trouble = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    octo = true,
    which_key = true
  }
})

-- Set the colorscheme
vim.cmd('colorscheme catppuccin')

-- Statusline configuration (using mini.statusline)
require('mini.statusline').setup()

-- Indentscope configuration
require('mini.indentscope').setup()

-- Configure Barbecue
require('barbecue').setup {
  theme = 'catppuccin',
}

return {}
