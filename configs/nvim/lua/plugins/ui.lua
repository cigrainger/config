-- plugins/ui.lua

-- Catppuccin theme configuration
require('catppuccin').setup({
  integrations = {
    cmp = true,
    dap = true,
    flash = true,
    gitsigns = true,
    indent_blankline = { enabled = true },
    lsp_trouble = true,
    markdown = true,
    mini = { enabled = true },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
        neotest = true,
    neotree = true,
    notify = true,
    octo = true,
    semantic_tokens = true,
    telescope = true,
    treesitter = true,
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

-- Spectre
require('spectre').setup()

return {}
