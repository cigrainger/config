-- Locals
local aerial = require("aerial");
local ai = require("mini.ai")
local bracketed = require('mini.bracketed')
local bufferline = require("bufferline")
local catppuccin = require("catppuccin")
local chatgpt = require("chatgpt")
local cmp = require("cmp")
local cmp_git = require("cmp_git")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local comment = require("mini.comment")
local copilot = require("copilot")
local copilot_cmp = require("copilot_cmp")
local crates = require("crates")
local elixir = require("elixir")
local fidget = require("fidget")
local flash = require("flash")
local gitsigns = require("gitsigns")
local gs = package.loaded.gitsigns
local lspconfig = require("lspconfig")
local lspkind = require("lspkind")
local lualine = require("lualine")
local luasnip = require("luasnip")
local neodev = require("neodev")
local neotest = require("neotest")
local null_ls = require("null-ls")
local nvim_tree = require("nvim-tree")
local octo = require("octo")
local rust_tools = require("rust-tools")
local surround = require("nvim-surround")
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local todo_comments = require("todo-comments")
local trouble = require("trouble")
local wilder = require("wilder")
local wk = require("which-key")

-- General settings
vim.o.hlsearch = false                 -- Set highlight on search
vim.wo.number = true                   -- Make line numbers default
vim.o.mouse = 'a'                      -- Enable mouse mode
vim.o.breakindent = true               -- Enable break indent
vim.opt.undofile = true                -- Save undo history
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.termguicolors = true           -- Use termguicolors
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

aerial.setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

bufferline.setup({ options = { diagnostics = "nvim_lsp" } }) -- Bufferline

catppuccin.setup({
  integrations = {
    aerial = true,
    cmp = true,
    flash = true,
    gitsigns = true,
    nvimtree = true,
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

fidget.setup()
flash.setup()

-- Mini
ai.setup()
bracketed.setup()
comment.setup()
chatgpt.setup({
  api_key_cmd = "op read op://Private/OpenAI/api_key --no-newline --account amplifiedai",
  openai_params = {
    model = "gpt-3.5-turbo-1106",
    max_tokens = 1000
  },
  openai_edit_params = {
    model = "gpt-3.5-turbo-1106"
  }
})

surround.setup()

lualine.setup({
  options = { section_separators = '', component_separators = '', theme = 'catppuccin' }
})

elixir.setup {
  nextls = {
    enable = true,
    experimental = {
      completions = {
        enable = false -- control if completions are enabled. defaults to false
      }
    },
    on_attach = function(_, bufnr)
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
          l = { vim.lsp.codelens.run, "Run the codelens under the cursor" },
        },
      }
      wk.register(lsp_leader_keymaps, { prefix = "<leader>", buffer = bufnr })
      wk.register({ K = { vim.lsp.buf.hover, "Hover" } })

      vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format { async = false } ]] -- format on save
    end
  },
  credo = { enable = false },
  elixirls = { enable = false, }
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',       -- show only symbol annotations
      maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
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
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'git' },
    { name = 'luasnip' },
    { name = 'path' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}

vim.defer_fn(function()
  copilot.setup()
end, 100)

vim.defer_fn(function()
  copilot_cmp.setup()
end, 200)

cmp_git.setup()

crates.setup {}

gitsigns.setup { current_line_blame = true }


neodev.setup({
  override = function(root_dir, library)
    if require("neodev.util").has_file(root_dir, "~/code/config/configs/nvim") then
      library.enabled = true
      library.plugins = true
    end
  end,
})

neotest.setup({
  adapters = {
    require("neotest-elixir"),
    require("neotest-rust"),
  },
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.diagnostics.deadnix,
    null_ls.builtins.diagnostics.dotenv_linter,
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
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<c-t>"] = trouble.open_with_trouble
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble
      }
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
local servers = { 'rnix', 'terraformls', 'dockerls', 'bashls', 'taplo', 'yamlls', 'tailwindcss' }
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
  on_attach = on_attach,
  capabilities = capabilities
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
  ["/"] = { function() telescope_builtin.live_grep(require('telescope.themes').get_ivy({})) end, "Search project" },
  e = { vim.diagnostic.open_float, "Open diagnostic" },
  ["<space>"] = { function() telescope_builtin.find_files(require('telescope.themes').get_ivy({})) end, "Search buffers" },
  z = {
    name = "ChatGPT",
    c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
    e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
    g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
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
    n = { neotest.run.run, "Test nearest" },
    f = { function() neotest.run.run(vim.fn.expand("%")) end, "Test file" },
  },
  q = {
    name = "Quit",
    q = { "<cmd>wqa<CR>", "Write and quit" },
    Q = { "<cmd>qa!<CR>", "Quit without saving" },
  },
  o = {
    name = "Open",
    a = { "<cmd>AerialToggle!<CR>", "Aerial" },
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

wk.register({
  s = { function() flash.jump() end, "Flash" },
  S = { function() flash.treesitter() end, "Flash Treesitter" }
}, { mode = { "n", "x", "o" } })

wk.register({ r = { function() flash.remote() end, "Remote Flash" } }, { mode = "o" })
wk.register({ R = { function() flash.treesitter_search() end, "Treesitter Search" } }, { mode = { "o", "x" } })
wk.register({ ["<c-s>"] = { function() flash.toggle() end, "Toggle Flash Search" } }, { mode = "c" })
