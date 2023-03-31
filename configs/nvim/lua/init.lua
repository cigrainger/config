-- Locals
local catppuccin = require("catppuccin")
local cmp = require("cmp")
local cmp_git = require("cmp_git")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local comment = require("Comment")
local copilot = require("copilot")
local copilot_cmp = require("copilot_cmp")
local crates = require("crates")
local gitsigns = require("gitsigns")
local gs = package.loaded.gitsigns
local leap = require("leap")
local lspconfig = require("lspconfig")
local lualine = require("lualine")
local luasnip = require("luasnip")
local neodev = require("neodev")
local neotest = require("neotest")
local null_ls = require("null-ls")
local nvim_tree = require("nvim-tree")
local octo = require("octo")
local rust_tools = require("rust-tools")
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local todo_comments = require("todo-comments")
local trouble = require("trouble")
local wilder = require("wilder")
local wk = require("which-key")

local border = {
  { "╭", "FloatBorder" }, { "─", "FloatBorder" }, { "╮", "FloatBorder" },
  { "│", "FloatBorder" }, { "╯", "FloatBorder" }, { "─", "FloatBorder" },
  { "╰", "FloatBorder" }, { "│", "FloatBorder" }
}

-- General settings
vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true -- Make line numbers default
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.termguicolors = true -- Use termguicolors
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup
catppuccin.setup {
  styles = {
    comments = { "italic" },
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
  }
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = "copilot" },
    { name = "git" },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'rg' },
  },
  window = {
    documentation = {
      border = border,
    },
    completion = {
      border = border,
    },
  },
}

vim.defer_fn(function()
  copilot.setup()
end, 100)

vim.defer_fn(function()
  copilot_cmp.setup()
end, 200)

cmp_git.setup()

comment.setup {}

crates.setup {
  null_ls = {
    enabled = true,
    name = "crates.nvim",
  },
}

gitsigns.setup { current_line_blame = true }

leap.add_default_mappings()

lualine.setup {
  options = {
    theme = 'catppuccin',
  }
}

neodev.setup({
  override = function(root_dir, library)
    if require("neodev.util").has_file(root_dir, "/Users/chris/code/config/configs/nvim") then
      library.enabled = true
      library.plugins = true
    end
  end,
})

neotest.setup({
  adapters = {
    -- require("neotest-elixir"),
    -- require("neotest-rust"),
  },
})

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.credo,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.taplo,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.tfsec,
    null_ls.builtins.diagnostics.shellcheck,
  }
})

nvim_tree.setup {
  respect_buf_cwd = true,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  }
}

octo.setup {}

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,['<C-d>'] = false,
        ["<c-t>"] = trouble.open_with_trouble
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble
      }
    }
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_ivy {}
    }
  }
}
telescope.load_extension('fzf')

todo_comments.setup {}

trouble.setup {}

wilder.setup { modes = { ':', '/', '?' } }

-- Treesitter configuration
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false;

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm'
    }
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  indent = { enable = true },
}


-- set colorscheme after options
vim.cmd('colorscheme catppuccin')

-- LSP settings
local on_attach = function(client, bufnr)
  local lsp_leader_keymaps = {
    c = {
      D = { vim.lsp.buf.declaration, "Go to declaration" },
      d = { telescope_builtin.lsp_definitions, "Go to definition" },
      i = { telescope_builtin.lsp_implementations, "Go to implementation" },
      k = { vim.lsp.buf.signature_help, "Signature help" },
      a = { vim.lsp.buf.code_actions, "Code actions" },
      r = { telescope_builtin.lsp_references, "List references" },
      t = { telescope_builtin.lsp_type_definitions, "Jump to type definition" },
      n = { vim.lsp.buf.rename, "Rename symbol" },
      s = { telescope_builtin.lsp_document_symbols, "List document symbols" },
    },
  }
  wk.register(lsp_leader_keymaps, { prefix = "<leader>", buffer = bufnr })
  wk.register({ K = { vim.lsp.buf.hover, "Hover" } })

  vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format { async = false } ]] -- format on save

  vim.api.nvim_create_user_command("Format", vim.lsp.buf.format, {})
  if client.name == "rust_analyzer" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

-- nvim-cmp supports additional completion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable the following language servers
local servers = { 'rnix', 'terraformls', 'dockerls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach, capabilities = capabilities }
end

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.elixirls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "/etc/elixir-ls/language_server.sh" }
}

rust_tools.setup({ server = { on_attach = on_attach } })

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Wilder menu
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    pumblend = 20,
    highlights = {
      border = 'Normal', -- highlight to use for the border
    },
    -- 'single', 'double', 'rounded' or 'solid'
    -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
    border = 'rounded',
  })
))

-- Keymaps
wk.register({
  e = { vim.diagnostic.open_float, "Open diagnostic" },
  ["<space>"] = { telescope_builtin.buffers, "Search buffers" },
  z = {
  },
  h = {
    s = { gs.stage_hunk, "Stage hunk" },
    r = { gs.reset_hunk, "Reset hunk" },
    S = { gs.stage_buffer, "Stage buffer" },
    R = { gs.reset_buffer, "Reset buffer" },
    u = { gs.undo_stage_hunk, "Undo stage hunk" },
    p = { gs.preview_hunk, "Preview hunk" },
    b = { function() gs.blame_line { full = true } end, "Line blame" },
    d = { gs.diffthis, "Diff file" },
  },
  s = {
    b = { function() telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy({})) end,
      "Fuzzy find in current buffer" },
    h = { function() telescope_builtin.help_tags(require('telescope.themes').get_ivy({})) end,
      "Find help tags" },
    g = { function() telescope_builtin.live_grep(require('telescope.themes').get_ivy({})) end,
      "Live grep" },
    i = { "<cmd>Octo issue list<CR>", "List issues" },
    p = { "<cmd>Octo pr list<CR>", "List PRs" },
    o = { "<cmd>Octo actions<CR>", "List Octo actions" },
  },
  x = {
    x = { "<cmd>Trouble<CR>", "Toggle trouble" },
    w = { "<cmd>Trouble<CR>", "Toggle trouble workspace diagnostics" },
    d = { "<cmd>Trouble<CR>", "Toggle trouble document diagnostics" },
    l = { "<cmd>Trouble<CR>", "Toggle trouble loclist" },
    q = { "<cmd>Trouble<CR>", "Toggle trouble quickfix" },
    h = { gs.setqflist, "Toggle git hunks in quickfix" },
  },
  t = {
    name = "Test",
    n = { neotest.run.run(), "Test nearest" },
    f = { neotest.run.run(vim.fn.expand("%")), "Test file" },
  },
  q = {
    name = "Quit",
    q = { "<cmd>wqa<CR>", "Write and quit" },
    Q = { "<cmd>qa!<CR>", "Quit without saving" },
  },
  o = {
    name = "Open",
    n = { "<cmd>NvimTreeToggle<CR>", "Tree" }
  },
  f = {
    name = "File",
    f = { function() telescope_builtin.find_files(require('telescope.themes').get_ivy({}), { previewer = false }) end,
      "Find" },
  },
  b = {
    name = "Buffer",
    d = { "<cmd>q<CR>", "Kill" },
    s = { "<cmd>w<CR>", "Save" }
  },
  w = {
    name = "Window",
    s = { "<cmd>split<CR>", "Horizontal split" },
    v = { "<cmd>vsplit<CR>", "Vertical split" },
    h = { "<C-w><C-h>", "Move to left window" },
    j = { "<C-w><C-j>", "Move to downwards window" },
    k = { "<C-w><C-k>", "Move to upwards window" },
    l = { "<C-w><C-l>", "Move to right window" },
    d = { "<C-w>c", "Close window" },
    ["="] = { "<C-w>=", "Make splits equal" },
  },
}, { prefix = "<leader>" })

wk.register({
  ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
  ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
  ["[t"] = { "<Plug>(ultest-prev-fail)", "Previous failing test" },
  ["]t"] = { "<Plug>(ultest-next-fail)", "Next failing test" },
  ["[c"] = { function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
  end, "Previous diagnostic" },
  ["]c"] = { function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
  end, "Next diagnostic" },
})

wk.register({
  ["[c"] = { function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
  end, "Previous diagnostic" },
  ["]c"] = { function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
  end, "Next diagnostic" },
}, { mode = "v" })
