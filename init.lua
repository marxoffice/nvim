-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.whichwrap:append("<,>,[,]")

-- 项目级配置 (Neovim 内置功能)
-- 启用后，打开文件时会自动加载项目目录下的 .nvim.lua
-- 例如: /path/to/project/.nvim.lua
--
-- 使用方法:
--   1. 在项目根目录创建 .nvim.lua 文件
--   2. 在文件中写入项目特定的配置，如:
--        -- 覆盖 LSP 设置
--        vim.lsp.config.pylsp = {
--          settings = { pylsp = { plugins = { pycodestyle = { ignore = {'E501'} } } } }
--        }
--        -- 项目快捷键
--        vim.keymap.set('n', '<leader>r', ':AsyncRun python %<CR>')
--   3. 首次打开该项目会提示是否信任，选择信任后生效
--
-- 注意: .nvim.lua 会覆盖全局配置，谨慎处理敏感项目
vim.opt.exrc = true

-- use nvim tree
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local os_name = vim.loop.os_uname().sysname
local is_mac = os_name == "Darwin"
local is_linux = os_name == "Linux"
local is_windows = os_name == "Windows_NT"

-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --

-- Space as leader key
vim.g.mapleader = ' '

-- edit config
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>u', ':e $MYVIMRC<cr>', { desc = 'Edit Nvim Config' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>U', ':source $MYVIMRC<cr>', { desc = 'Source Nvim Config' })

-- Shortcuts
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^', { desc = 'Goto Current Line Left' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_', { desc = 'Goto Current Line Right' })
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', { desc = 'Select All' }) -- By default, Ctrl + a is increment number under Ctrl + x is decrement
vim.keymap.set('n', '<leader>yp', ":let @+=expand('%:p:h')<cr>", { desc = 'Copy the path of CurrentFile' })

-- Basic clipboard interaction
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to System' })    -- copy
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste from System' }) -- paste

-- Delete text
vim.keymap.set({ 'n', 'x' }, 'x', '"_d', { desc = 'Delete Char' }) -- delete

-- Search and replace
vim.keymap.set('n', '<leader>r', ':%s/a/b/gc', { desc = 'Replace a With b and Asked' });
vim.keymap.set('n', '<leader>ch', '<cmd>noh<cr>', { desc = 'Close Search Highlight' });

-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Write File' })
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>', { desc = 'Goto Last Buffer' })
vim.keymap.set('n', '<leader><space>', '<cmd>buffers<cr>:buffer<Space>', { desc = 'Goto Buffer:' })

-- marks
vim.api.nvim_create_user_command('GotoMark', "execute \"normal! '\"..<f-args>", { nargs = 1, })
vim.keymap.set('n', '<leader>m', '<cmd>marks<cr>:GotoMark<Space>', { desc = 'Goto Mark:' })
-- vim.keymap.set('n', '<leader>e', '<cmd>Lexplore %:p:h<cr>') -- use nvim tree
-- vim.keymap.set('n', '<leader>E', '<cmd>Lexplore<cr>') -- use nvim-tree

-- sessions
vim.keymap.set('n', '<leader>ss', '<cmd>mksession! marx.vim<cr>', { desc = 'Save Default Session' })
vim.keymap.set('n', '<leader>sl',
  function()
    local proj_vim_path = vim.fn.getcwd() .. "/marx.vim"
    if (vim.fn.filereadable(proj_vim_path) == 1)
    then
      vim.cmd("source marx.vim")
    else
      print("No session file in this directory")
    end
  end
  , { desc = 'Load Default Session (if have)' })

-- 下面这两条快捷键可以 需要手动输入文件名再回车 一般用不到吧 毕竟一个文件夹多个session有点奇怪
vim.keymap.set('n', '<leader>sS', ':mksession! ', { desc = 'Save Session with name' })
vim.keymap.set('n', '<leader>sL', ':source ', { desc = 'Load Session with name' })

vim.keymap.set('n', '<leader>sw', '<cmd>wshada! scret.shada<cr>', { desc = 'Save Shada (regs marks history)' })
vim.keymap.set('n', '<leader>sr', '<cmd>rshada! scret.shada<cr>', { desc = 'Load Shada (regs marks history)' })

--[[
local function netrw_mapping()
  local bufmap = function(lhs, rhs)
    local opts = {buffer = true, remap = true}
    vim.keymap.set('n', lhs, rhs, opts)
  end

  -- close window
  bufmap('<leader>e', ':Lexplore<cr>')
  bufmap('<leader>E', ':Lexplore<cr>')

  -- Go back in history
  bufmap('H', 'u')

  -- Go up a directory
  bufmap('h', '-^')

  -- Open file/directory
  bufmap('l', '<cr>')

  -- Open file/directory then close explorer
  bufmap('L', '<cr>:Lexplore<CR>')

  -- Toggle dotfiles
  bufmap('.', 'gh')
end
--]]

-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local group = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man' },
  group = group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

--[[
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  group = group,
  desc = 'Keybindings for netrw',
  callback = netrw_mapping
})
--]]

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim')
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  -- file explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
    },
    config = function()
      require('nvim-tree').setup({
        hijack_cursor = false,
        on_attach = function(bufnr)
          local bufmap = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
          end

          -- :help nvim-tree.api
          local api = require('nvim-tree.api')

          bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
          bufmap('o', api.node.open.edit, 'Expand folder or go to file')
          bufmap('A', api.tree.expand_all, 'Expand all')
          bufmap('H', api.node.navigate.parent_close, 'Hidden subtree, Close parent folder')
          bufmap('C', api.tree.change_root_to_node, 'Change root to node')
          bufmap('y', api.fs.copy.node, 'Copy')
          bufmap('d', api.fs.cut, 'Cut')
          bufmap('D', api.fs.remove, 'Delete')
          bufmap('p', api.fs.paste, 'Paste')
          bufmap('r', api.fs.rename, 'Rename')
          bufmap('<Tab>', api.node.open.preview, 'Open Preview')
          bufmap('.', api.node.run.cmd, 'Run Command')
          bufmap('O', api.node.run.system, 'Run in System')
        end
      })
    end
  },
  { "nvim-tree/nvim-web-devicons" },

  -- fuzz finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    cmd = "Telescope",
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'GustavoKatel/telescope-asynctasks.nvim' },

  -- terminal
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    cmd = "ToggleTerm",
    config = function()
      require('toggleterm').setup({
        open_mapping = '<C-g>',
        direction = 'float',
        shade_terminals = true
      })
    end
  },

  -- surround
  { 'kylechui/nvim-surround' },

  -- Git
  { 'lewis6991/gitsigns.nvim' },
  { 'tpope/vim-fugitive' },

  -- Comment
  { 'numToStr/Comment.nvim' },

  -- buffer close
  { 'moll/vim-bbye' },

  -- which key advice
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  -- theme
  { "folke/tokyonight.nvim",               priority = 1000 },
  { "ellisonleao/gruvbox.nvim",            priority = 1000 },

  -- dashboard: alpha
  { "goolord/alpha-nvim" },

  -- indent blank visual
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl' },

  -- below status line
  { 'nvim-lualine/lualine.nvim' },

  -- top status line
  { 'akinsho/bufferline.nvim' },

  -- LSP support
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  -- DAP (Debug Adapter Protocol)
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui',                dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
  { 'jay-babu/mason-nvim-dap.nvim',        dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' } },

  -- Autocomplete (blink.cmp - batteries included)
  -- 快捷键 (preset = 'default'):
  --   C-n/C-p 或 ↑/↓  - 选择下一个/上一个补全项
  --   C-y              - 确认选中项
  --   C-e              - 关闭补全菜单
  --   C-Space          - 打开补全菜单或切换文档显示
  --   C-k              - 切换签名帮助 (需启用 signature.enabled)
  --   C-u/C-d          - 滚动文档窗口（blink 内置支持）
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },

  -- Snippet engine (required by blink.cmp)
  { 'L3MON4D3/LuaSnip' },

  -- asynctasks
  { 'skywind3000/asynctasks.vim' },
  { 'skywind3000/asyncrun.vim' },

  -- treesitter (使用 master 分支，兼容 Neovim 0.11+)
  { 'nvim-treesitter/nvim-treesitter',            branch = 'master', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },

  -- hlchunk
  -- {
  --     "shellRaining/hlchunk.nvim",
  --     lazy = true,
  --     event = { "UIEnter" },
  --     config = function()
  --       require("hlchunk").setup({})
  --     end
  -- },

  {
    'voldikss/vim-translator',
    lazy = true,
    cmd = { 'Translate', 'TranslateR', 'TranslateW' },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {

    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  -- markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { ' ', ' ', ' ', ' ', ' ', ' ' },
        signs = { '󰫎 ' },
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = true,
        border_prefix = true,
        above = '▄',
        below = '▀',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_icon = true,
        language_name = true,
        border = 'hide',
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
        },
      },
      quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = true,
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        preset = 'none',
        style = 'full',
        cell = 'padded',
        border = {
          '┌', '┬', '┐',
          '├', '┼', '┤',
          '└', '┴', '┘',
          '│', '─',
        },
        alignment_indicator = '─',
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
      },
      link = {
        enabled = true,
        image = '󰥶 ',
        email = '󰀓 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        wiki = { icon = '󱗖 ', highlight = 'RenderMarkdownWikiLink' },
        custom = {
          web = { pattern = '^http[s]?://', icon = '󰖟 ', highlight = 'RenderMarkdownLink' },
        },
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅹 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
      },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

})
vim.keymap.set('n', '<leader>pr', '<cmd>Lazy restore<cr>', { desc = 'Restore Plugin from lock-file' })
vim.keymap.set('n', '<leader>pu', '<cmd>Lazy update<cr>', { desc = 'Update Plugin' })
vim.keymap.set('n', '<leader>ps', '<cmd>Lazy sync<cr>', { desc = 'Sync: Clean and Update plugin' })

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --


---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')


---
-- nvim-tree (File explorer)
---
-- See :help nvim-tree-setup

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Open/Close NvimTree' })


---
-- Telescope
---
-- See :help telescope.builtin
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>', { desc = 'Find History Files' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Find Grep' })
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Find in Current Buffer' })
vim.keymap.set('n', '<leader>ft', '<cmd>Telescope asynctasks all<cr>', { desc = 'Find AsyncTasks' })
-- require('telescope').extensions.asynctasks.all() -- open at nvim start
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open
-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = open_with_trouble },
      n = { ["<c-t>"] = open_with_trouble },
    },
  },
})


---
-- toggleterm
---
-- See :help toggleterm-roadmap
vim.keymap.set('n', '<C-g>', '<cmd>ToggleTerm<cr>', { desc = 'Toggler Terminal' })


---
-- nvim-surround
---
-- See :help nvim-surround
require('nvim-surround').setup({})

require("nvim-surround").buffer_setup({
  delimiters = {
    pairs = {
      ["c"] = { "/*", "*/" },
      ["f"] = function()
        return {
          vim.fn.input({
            prompt = "Enter the function name: "
          }) .. "(",
          ")",
        }
      end,
    },
  }
})


---
-- Gitsigns
---
-- See :help gitsigns-usage
require('gitsigns').setup({
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '➤' },
    topdelete = { text = '➤' },
    changedelete = { text = '▎' },
  }
})


---
-- Comment.nvim
---
require('Comment').setup({})


---
-- vim-bbye
---
vim.keymap.set('n', '<leader>bc', '<cmd>Bdelete<CR>', { desc = 'Close buffer' })

---
-- which-key.nvim
---
require("which-key").setup({})

---
-- alpha-nvim
---
local function random_elem(tb)
  local keys = {}
  for k in pairs(tb) do table.insert(keys, k) end
  return tb[keys[math.random(#keys)]]
end

local images = {
  KaBiShou = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣿⣶⣦⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣤⣶⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⢀⡀⣄⠀⠀⠀⠀⠀⠀⠀⣿⣿⠟⠉⠀⢀⣀⠀⠀⠈⠉⠀⠀⣀⣀⠀⠀⠙⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⣀⣶⣿⣿⣿⣾⣇⠀⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⣼⡏⠀⠀⠀⣀⣀⣉⠉⠩⠭⠭⠭⠥⠤⢀⣀⣀⠀⠀⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⣿⠷⠒⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠒⠼⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠈⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢹⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀]],
    [[⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣶⣤⣄⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀]],
    [[⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀]],
    [[⠀⠀⣀⠀⢸⡿⠿⣿⡿⠋⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠻⠿⠟⠉⢙⣿⣿⣿⣿⣿⣿⡇]],
    [[⠀⠀⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⠿⢿⡿⣿⠳⠀]],
    [[⠀⠀⡞⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣇⡀⠀⠀]],
    [[⢀⣸⣀⡀⠀⠀⠀⠀⣠⣴⣾⣿⣷⣆⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣰⣿⣿⣿⣿⣷⣦⠀⠀⠀⠀⢿⣿⠿⠃⠀]],
    [[⠘⢿⡿⠃⠀⠀⠀⣸⣿⣿⣿⣿⣿⡿⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⢻⣿⣿⣿⣿⣿⣿⠂⠀⠀⠀⡸⠁⠀⠀⠀]],
    [[⠀⠀⠳⣄⠀⠀⠀⠹⣿⣿⣿⡿⠛⣠⠾⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠳⣄⠙⠛⠿⠿⠛⠉⠀⠀⣀⠜⠁⠀⠀⠀⠀]],
    [[⠀⠀⠀⠈⠑⠢⠤⠤⠬⠭⠥⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠢⠤⠤⠤⠒⠊⠁⠀⠀⠀⠀⠀⠀]],
  },

  MengHuan = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠄⣀⡀⡀⠤⠐⣢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠠⢤⠔⠈⠀⠀⠀⠀⠀⠀⠀⠁⠀⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠏⠀⣀⣀⡀⠀⠀⠀⠀⢀⠀⡔⢻⣦⠀⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠸⠀⠰⠛⣇⣹⡜⡄⠀⠀⠸⢠⣿⣿⣀⠇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⢀⠔⡉⠤⠐⠒⠒⠒⠂⠠⠬⣁⠒⠠⢄⡀⠀⢠⠀⠐⠠⠿⢿⡇⠀⠀⠀⠀⠈⠛⠉⠀⡀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⡐⡡⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠐⠂⠄⡁⠒⠱⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠄⠒⣒⣀⣴]],
    [[⠰⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠐⠢⠌⣉⣶⣶⣦⣄⣀⣠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠂⢁⣠⣴⣾⣿⣿⡟⠁]],
    [[⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠀⠉⠛⠿⠿⠛⠆⠤⠄⠀⣀⣀⣀⣀⣀⡀⠔⢁⣤⣾⣿⣿⣿⡿⠟⠁⠀⠀]],
    [[⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⢀⠀⠀⠄⠀⡀⠀⠁⠐⠒⠂⠠⠤⢤⣤⣤⣶⣾⣿⠿⠿⠛⠋⠁⠀⠀⠀⠀⠀]],
    [[⢇⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠈⡄⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠘⡈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠁⠀⠀⠉⢂⠀⢱⡀⡰⢠⡃⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠐⢄⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⢸⠀⠀⠈⠀⠀⠉⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠑⢄⡁⠂⠤⢀⣀⠀⠀⠀⠀⣀⣀⣼⣿⠀⠀⠀⠀⣮⣤⣶⣶⣦⠋⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠈⠑⠂⠤⠄⠀⠀⠠⠾⠿⠿⢻⣿⠀⠀⢀⣴⣿⣿⣿⡿⠁⡀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⡿⢃⠤⠐⠁⠀⢰⣾⠟⡀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠆⠀⠀⠀⠀⢸⡟⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⢰⠀⠀⠀⠀⠀⠀⣇⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠸⠀⠀⠀⠀⠀⠀⢹⠀⠀⢁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡇⠀⡀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡇⠀⡇⠀⠀⠀⠀⠀⠀⢸⣿⡀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡿⠁⣆⠁⠀⠀⠀⠀⠀⠀⠀⣿⣷⢠⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  YiBu = {
    [[⢰⣶⣶⠶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⡶⣶⣶⣶⣶⡆]],
    [[⢸⣿⣿⡆⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣇⠀⠀⢀⡀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⢠⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⡄⠀⠘⣿⣶⣤⣀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⢀⣠⣴⣾⠃⠀⢀⣾⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⡄⠀⠘⢿⣿⣿⣷⣦⣀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⢀⣤⣾⣿⣿⣿⠃⠀⢀⣾⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣄⠀⠈⠻⣿⣿⣿⣿⣷⣤⡀⠈⢿⣿⣿⣿⡿⠟⠛⣿⠿⠛⡿⠿⣿⣿⣿⣿⣿⣿⠟⠀⣀⣴⣿⣿⣿⣿⡿⠃⠀⢠⣾⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣷⡀⠀⠈⠻⣿⣿⣿⣿⣿⣦⡀⢻⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠉⢻⡿⠁⢀⣾⣿⣿⣿⣿⣿⠟⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠈⠛⢿⣿⣿⣿⡿⠆⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠴⣿⣿⣿⣿⣿⠟⠁⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⡀⠉⠻⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢹⠟⠋⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⡤⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⣴⣶⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣼⠋⠙⡆⠀⠀⠀⠀⠀⠀⠀⣰⠋⠙⣆⠀⠀⣿⣿⣿⣿⡇⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣿⣦⣴⡧⠀⠀⠀⠀⠀⠀⠀⣿⣦⣴⣿⠀⢰⣿⣿⣿⠏⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢿⣿⣿⠇⠀⠀⠀⣀⠀⠀⠀⢹⣿⣿⡟⠀⠸⠿⠛⠁⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠈⠛⠋⠀⠀⠀⠈⠛⠁⠀⠀⠀⠙⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠈⠑⠒⠋⠉⠑⠒⠋⠀⠀⠀⠀⠀⢀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢃⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡻⢿⣧⣴⡆⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢉⣴⣿⣿⢋⣶⣤⣄⣀⣀⣀⠀⢀⣀⣀⣤⣶⣷⣌⢿⣿⣷⠭⠛⣿⣴⣧⠀⣠⣆⠀⠀⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡖⣠⣾⣿⠇⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡎⣿⣿⣷⡘⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢰⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣿⣿⣿⣷⢸⣿⣿⣿⣿⣿⡿⢰⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⡀⠸⠻⣿⡇⠏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠀⣿⣿⣿⢿⢸⣿⣿⣿⣿⣿⠇⣼⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣴⡀⠻⣿⡀⠻⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡿⠀⢠⣿⠛⠇⣶⣾⣿⣿⣿⣿⡟⢠⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠈⠙⠂⠸⠋⢿⣿⣿⣿⣿⣿⣿⡿⠁⠁⢀⡾⠁⣾⣾⣿⣿⣿⣿⣿⠟⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⢻⡿⠁⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⡿⢋⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠈⡿⠃⠀⠀⠀⠀⠀⠀⠀⠿⠿⠟⠛⢋⣡⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣷⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⡀⠀⠀⠀⠀⡀⠀⠀⠀⠀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇]],
    [[⠸⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠶⠤⠤⠾⠿⠷⠶⠶⠾⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇]],
  },

  GengGui = {
    [[⠀⠀⠀⠀⠀⠀⠀⢢⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣶⣶⡟⠁⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣷⣶⣦⣤⣀⡀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⣶⣶⣶⣶⣦⣤⣀⡀⢀⣀⣠⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⠁⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠸⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠐⢶⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣾⠟⠁⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠠⣶⡆⠈⠻⣿⣿⣿⣿⣿⠋⠠⣶⡆⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣤⣤⣿⣿⣿⣿⣿⣦⣤⣤⣶⣶⣶⣾⡿⢿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢀⣾⣿⣿⣿⣿⣯⣤⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠶⣶⣶⣾⣿⣿⣿⣿⣧⠀⠛⠁⠀⠈⠿⠋⠉⠉⠉⠉⠻⠋⠀⠀⠈⠁⢠⣾⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⢠⣤⣤⣤⣀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⠟⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣷⣦⡀⠀⠙⠿⣿⣿⣿⣿⣿⣦⣀⣠⣀⣴⡀⣠⡀⣠⡀⣴⣄⣠⣾⣿⣿⣿⣿⣿⣿⡿⠋⠀⣼⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣋⣀⣠⣾⣿⣿⣿⣿⣿⣿⣷⣶⣶⣤⣄⠀]],
    [[⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷]],
    [[⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠻⣿⣿⣿⡿⠟⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠿⠿⠿⠛⠁⣿⣿⠃⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⠁⠀⠀⠀⠀⠀⠹⡇⠀⠀⠀⠈⠙⠛⠋⠁⣸⡿⠃]],
    [[⠸⣿⣿⡟⠉⠉⠉⠉⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠛⠁⠀⠀⠀⠀⠙⣧⠙⣿⣿⣿⣿⣿⣿⣿⣿⠘⡏⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠁⠀]],
    [[⠀⢻⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⠈⠻⣿⡿⢿⣿⣿⣿⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⠈⢻⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  PiKaQiu = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣷⣶⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⣶⣾⣿⡟]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⠉⠉⠛⠳⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠶⠚⠋⠉⠁⢸⣿⣿⣿⠏⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⡆⠀⠀⠀⠀⠈⠙⠷⣄⡀⠀⣀⣠⡤⠶⠖⠛⠛⠛⠛⠛⠓⠶⠦⣤⣀⠀⢀⣴⠞⠋⠀⠀⠀⠀⠀⠀⣼⣿⠟⠁⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠋⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡶⠋⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⢻⡟⠛⠶⠶⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⢀⠀⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠘⣇⠀⠀⠀⠀⠀⠉⠉⠛⠛⠲⠶⢤⣤⣀⣀⠀⠀⠀⠀⠀⣼⠃⠀⢰⣿⣿⣤⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣧⣤⣧⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠶⠶⣤⡟⠀⠀⠈⠻⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⠿⠟⠃⠀⠀⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⢀⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣿⣿⣿⣿⡄⠀⠀⠀⣄⣀⣀⣤⣤⣀⡀⣀⠄⠀⠀⠀⢠⣾⣿⣿⣦⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠻⠶⠶⠦⢤⣤⣤⣤⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⢀⣿⡄⠻⣿⣿⠟⠁⠀⠀⠀⠀⠈⢏⠉⠉⢹⠃⠀⠀⠀⠀⠀⠸⣿⣿⣿⡿⢀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣹⠇⠀⠀⠀⠀⢠⡟⠉⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⠴⠃⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⢀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⠀⠀⣠⡟⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠀⠀⠀⠀⣰⠏⠀⠀⠀⣰⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⣰⠏⠀⠀⠀⢰⠏⠀⠀⠀⠀⠀⠀⠠⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⠀⠻⢦⣄⣀⢠⡟⠀⣄⠀⠀⠀⠀⠀⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⢀⣶⠀⠀⠀⠀⠀⠀⣠⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠰⣯⣀⡀⠀⠀⠀⠀⠀⠀⠀⠉⣿⠁⠀⠹⣆⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⢀⡿⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠶⢦⣤⣀⡀⠀⢰⡇⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠈⢷⡄⠀⠀⠀⠀⠀⣾⠀⠀⠀⠀⠀⢀⡾⠁⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠃⢀⣼⠁⠀⠀⠀⠀⠈⠻⣦⠀⠀⠀⣀⣨⣿⡄⠀⠀⠀⢠⡟⠀⠀⠀⠀⢠⡟⠁⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⢦⣄⣈⣿⠀⠀⠀⠀⠀⠀⠀⠘⢷⣼⡷⡿⠛⠋⠁⠀⠀⠀⠿⣿⣤⣦⣴⣦⡟⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠉⠈⠉⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  Rayquaza = {
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⡿⠁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡎⢻⣿⣿⣿⣿⡟⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢈⣿⡿⠿⡝⣠⠊⠃⠈⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⠇⡹⢳⠟⣻⣿⣿⣿⣿⣿⣿⣿⣿⢋⢿⣦⠞⠰⠋⠉⠉⠓⢶⣄⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⡠⠁⣦⣼⣿⣿⣿⣿⣿⣿⣿⡿⣝⣧⣿⠇⢀⠀⠀⠲⠶⣧⠄⠈⢷⡀⠈⡿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⣁⣤⣶⣻⢀⣯⣔⡢⣬⣉⠒⢤⣿⠊⠀⠉⡆⠞⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⡏⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣤⣾⡟⡏⢠⢷⣿⣽⡿⠟⢯⠈⡏⢫⠞⠳⡀⢈⠀⠀⡗⠚⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣡⣧⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣗⣿⣿⡯⢅⢀⣴⠞⢧⣧⣇⣎⠙⢆⡄⠀⢀⡇⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣽⠟⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢱⣴⡿⠋⣼⣾⡾⣯⠤⢒⠎⠀⢠⡟⠓⣄⣣⣀⣿⡀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣧⣹⠶⣮⢿⣿⣿⣿⠋⠃⠀⣁⢀⡴⣫⣤⣀⡶⠯⢿⣿⣿⣅⠀⢀⡿⠀⢠⠏⣷⢿⣼⣿⣶⡄⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣶⣾⠁⢙⠟⣷⣿⣿⣟⠋⡟⢈⡏⢈⣯⢠⣴⣿⡿⠁⠈⡳⣿⣁⣠⣿⢿⣟⣿⢽⣿⣿⣿⡀⠤⠐⠠⢄⣈⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣷⣈⠳⡾⡿⣉⣉⣉⣙⣷⣷⠟⠘⢉⣵⣿⣿⠋⠀⢠⢾⠏⢠⣾⣿⣿⣶⣿⣿⣿⣿⡿⠿⡆⠀⠰⢫⡇⠈⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⠀⠀⠀⠀⢀⣘⣦⣶⣿⣿⣿⠁⠀⠰⡕⠁⣰⣿⣿⣿⣿⣿⣿⣿⣿⡽⠀⡠⠀⢰⣧⡿⠁⠰⢿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣣⣍⠁⠀⣀⣝⣿⣿⣿⣿⣿⡟⢀⣴⠗⠳⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⡤⠖⠁⣠⣿⠟⠁⢠⠃⡼⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠸⢧⠀⢀⠿⢻⣿⣿⣯⣿⣿⡿⠿⠛⠙⠢⡼⠟⠁⠀⡰⢃⣰⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠁⠛⢝⢅⠀⣨⣛⡩⡉⠁⠀⠀⠀⠀⠀⢹⠀⢀⣜⣡⣿⣾⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣊⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⡀⠀⠉⢊⠏⠀⠈⠽⠀⣀⣀⠀⢤⣴⣽⣶⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⣙⠳⠛⠉⢉⣡⣼⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣾⣿⡿⠀⠀⣀⣤⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
  },

  RayquazaInv = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⡄⠀⠀⠀⠀⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡷⠀⢀⣀⢢⠟⣵⣼⣷⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⣸⢆⡌⣠⠄⠀⠀⠀⠀⠀⠀⠀⠀⡴⡀⠙⣡⣏⣴⣶⣶⣬⡉⠻⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢟⣾⠙⠃⠀⠀⠀⠀⠀⠀⠀⢀⠢⠘⠀⣸⡿⣿⣿⣍⣉⠘⣻⣷⡈⢿⣷⢀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⠾⠛⠉⠄⡿⠐⠫⢝⠓⠶⣭⡛⠀⣵⣿⣶⢹⣡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⢰⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠛⠁⢠⢰⡟⡈⠀⠂⢀⣠⡐⣷⢰⡔⣡⣌⢿⡷⣿⣿⢨⣥⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠞⠘⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠨⠀⠀⢐⡺⡿⠋⣡⡘⠘⠸⠱⣦⡹⢻⣿⡿⢸⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠂⣠⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡎⠋⢀⣴⠃⠁⢁⠐⣛⡭⣱⣿⡟⢠⣬⠻⠜⠿⠀⢿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠘⠆⣉⠑⡀⠀⠀⠀⣴⣼⣿⠾⡿⢋⠔⠛⠿⢉⣐⡀⠀⠀⠺⣿⡿⢀⣿⡟⣰⠈⡀⠃⠀⠉⢻⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠉⠁⣾⡦⣠⠈⠀⠀⠠⣴⢠⡷⢰⡷⠐⡟⠋⠀⢀⣾⣷⢌⠀⠾⠟⠀⡀⠠⠀⡂⠀⠀⠀⢿⣛⣯⣟⡻⠷⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠈⠷⣌⢁⢀⠶⠶⠶⠦⠈⠈⣠⣧⡶⠊⠀⠀⣴⣿⡟⡁⣰⡟⠁⠀⠀⠉⠀⠀⠀⠀⢀⣀⢹⣿⣏⡔⢸⣷⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⡿⠧⠙⠉⠀⠀⠀⣾⣿⣏⢪⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⢂⣿⢟⣿⡏⠘⢀⣾⣏⡀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠜⠲⣾⣿⠿⠢⠀⠀⠀⠀⠀⢠⡿⠋⣨⣌⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⢛⣩⣾⠟⠀⣠⣾⡟⣼⢃⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣇⡘⣿⡿⣀⡄⠀⠀⠐⠀⠀⢀⣀⣤⣦⣝⢃⣠⣾⣿⢏⡼⠏⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣾⣤⡢⡺⣿⠗⠤⢖⢶⣾⣿⣿⣿⣿⣿⡆⣿⡿⠣⠞⠀⠁⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠵⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⢿⣿⣶⡵⣰⣿⣷⣂⣿⠿⠿⣿⡛⠋⠂⠉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⠦⣌⣤⣶⡶⠞⠃⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠁⠀⢀⣿⣿⠿⠛⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  LieKongZuo = {
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠛⠛⠋⠉⠭⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢛⣩⣤⠀⣤⣼⣿⣧⣀⠈⢓⣀⣄⡛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠰⠊⡴⢶⢌⡈⢿⣿⣿⣿⣿⠀⢉⣙⠻⣿⣿⣶⣍⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠎⣉⣥⣥⣶⣶⡖⠀⠸⠯⠭⠝⠃⠀⠀⠡⠈⢭⡙⠛⣉⣤⠙⠋⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢡⠆⢀⣾⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣤⣶⣿⣿⣶⣦⣄⠃⢸⣿⣿⣷⣄⠳⡄⠈⢿⣿⣿⣿⣿⣿⣿]],
    [[⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢀⡏⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠈⣿⣿⣿⣿⣧⡙⠆⠈⣿⣿⣿⣿⣿⣿]],
    [[⣇⠀⣌⠻⣿⣿⣿⣿⣿⣿⣧⡄⠈⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠸⡝⢿⣿⣿⣿⣿⠀⠀⠘⣿⣿⣿⣿⣿]],
    [[⣿⣧⠹⣷⡌⢻⣿⣿⣿⣿⣿⡇⣰⣧⣼⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠈⣠⡔⠀⢀⣤⣶⣄⠀⠘⣿⣿⣿⣿]],
    [[⣿⣿⣧⠙⣿⣦⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠆⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⣼⠟⡀⠀⢍⢻⣿⣿⣧⡘⣿⣿⣿⣿]],
    [[⣿⣿⣿⣷⡘⣿⣷⣄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⢀⣀⣤⣅⡀⠊⢍⠛⢿⡿⢋⣴⣿⠏⣼⣿⣤⡀⠘⣿⣿⣿⣇⢹⣿⣿⣿]],
    [[⣿⣿⣿⣿⣷⡜⢿⣿⣧⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⣤⣶⣿⣿⡿⠟⣛⡀⠈⠁⠄⣠⣿⣿⠃⢸⣿⣿⣿⡇⠠⠘⣿⣿⣿⡄⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣷⡌⢿⣿⣷⠈⣿⣿⣿⣿⣿⣿⣿⠟⡀⠸⣿⠿⠟⢋⡴⢋⣥⣶⠀⢠⣾⣿⣿⠃⡀⠈⣿⣿⣿⣿⠀⢀⣈⡉⠉⠁⢿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⡌⢿⣿⠈⣿⣿⣿⣿⣿⣿⠋⣴⢘⣶⠖⢚⣉⣉⣴⣿⡿⢃⣴⣿⣿⡿⠃⣴⡄⠀⠹⡟⠋⠉⣰⣿⣿⣷⣴⠀⢸⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⡎⢻⣧⠹⣿⣿⣿⣿⠃⠼⢃⡾⢡⣾⣿⣿⣿⣿⠋⣠⣾⡿⠟⢋⣤⣾⣿⡷⠀⠀⠃⢰⣀⣿⣿⣿⣿⣿⠀⠀⠙⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⠟⠂⢻⣧⠙⠿⠟⠩⢒⣠⣍⡓⢦⡙⣿⣿⠟⣡⣾⠟⠩⠄⢀⣈⠛⠃⣶⡄⠃⠀⠀⡼⢹⣿⣿⣿⣿⡟⠀⠀⠀⣿]],
    [[⣿⣿⣿⣿⣿⣿⡿⢃⣤⠙⣆⢻⡗⢀⡌⣰⣿⣿⣿⡷⢸⡇⠿⢃⣴⠟⣡⣄⢲⡀⢻⣿⣷⣦⢻⡷⠀⣎⠀⠃⣿⠿⠿⠿⠁⠀⠀⠀⢠⣿]],
    [[⣿⣿⣿⣿⣿⡿⠣⠛⢡⠀⣤⠄⣴⠸⣇⠹⣿⣿⠿⢃⠜⣁⣴⣿⢃⣾⣿⣿⣆⢳⡀⢻⣿⣿⣆⠰⣶⣬⣑⡀⠰⠞⢃⣤⣶⣶⣄⠀⢸⣿]],
    [[⣿⣿⣿⣿⣿⡇⠰⣦⠌⢈⠃⢸⣿⢀⠻⢷⣶⣶⡾⠏⢰⣿⣿⡏⠸⣿⣿⣿⣿⣦⣅⠀⠙⠋⠁⡄⠈⠛⠛⢉⣴⣶⡌⢻⡿⠿⠿⠀⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⡘⣿⡘⣿⣶⣶⣶⣶⢀⣿⡟⢠⣿⠀⠻⣿⣿⣿⣿⣿⣄⠻⣿⡇⠃⣼⣿⣿⣦⡈⣿⣿⣦⡁⢸⣷⠠⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠹⣿⣿⣿⣿⣿⠇⣼⡟⠀⣿⠟⢀⣦⡙⣿⣿⣿⣿⣿⣷⣌⡛⠦⠹⣿⡟⣡⣦⣌⣙⡛⠻⠘⠃⠾⢎⢻]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⢿⣿⣿⣿⡿⢰⠏⠰⠰⠋⣴⣌⠻⣷⡈⢿⣿⣿⣿⣿⣿⣿⣶⣦⣬⣥⣬⣭⣭⣭⣤⣔⠲⠾⠿⠈⣸]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠡⢂⡀⢼⣿⣿⣿⣁⣯⣴⠾⠃⣼⣿⣿⣷⣌⠻⣄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⠏⢀⣴⣿⣿⡄⠻⣿⣿⠟⣉⡄⠀⢰⣿⣿⣿⣿⣿⣷⣌⠢⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⡃⣠⣿⣿⣿⣿⣷⠁⢬⣴⣆⣹⠇⢀⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡧⣄⣈⣁⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
  },
  LieKongZuoInv = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣤⣴⣶⣒⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡤⠖⠛⣿⠛⠃⠀⠘⠿⣷⡬⠿⠻⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣏⣵⢋⡉⡳⢷⡀⠀⠀⠀⠀⣿⡶⠦⣄⠀⠀⠉⠲⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣱⠶⠚⠚⠉⠉⢩⣿⣇⣐⣒⣢⣼⣿⣿⣞⣷⡒⢦⣤⠶⠛⣦⣴⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⣹⡿⠁⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠛⠉⠀⠀⠉⠙⠻⣼⡇⠀⠀⠈⠻⣌⢻⣷⡀⠀⠀⠀⠀⠀⠀]],
    [[⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⢰⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣷⠀⠀⠀⠀⠘⢦⣹⣷⠀⠀⠀⠀⠀⠀]],
    [[⠸⣿⠳⣄⠀⠀⠀⠀⠀⠀⠘⢻⣷⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣇⢢⡀⠀⠀⠀⠀⣿⣿⣧⠀⠀⠀⠀⠀]],
    [[⠀⠘⣆⠈⢳⡄⠀⠀⠀⠀⠀⢸⠏⠘⠃⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⠟⢫⣿⡿⠛⠉⠻⣿⣧⠀⠀⠀⠀]],
    [[⠀⠀⠘⣦⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣹⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠃⣠⢿⣿⡲⡄⠀⠀⠘⢧⠀⠀⠀⠀]],
    [[⠀⠀⠀⠈⢧⠀⠈⠻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⡿⠿⠛⠺⢿⣵⡲⣤⡀⢀⡴⠋⠀⣰⠃⠀⠛⢿⣧⠀⠀⠀⠸⡆⠀⠀⠀]],
    [[⠀⠀⠀⠀⠈⢣⡀⠀⠘⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠛⠉⠀⠀⢀⣠⠤⢿⣷⣾⣻⠟⠀⠀⣼⡇⠀⠀⠀⢸⣟⣧⠀⠀⠀⢻⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠈⢳⡀⠀⠈⣷⠀⠀⠀⠀⠀⠀⠀⣠⢿⣇⠀⣀⣠⡴⢋⡴⠚⠉⣿⡟⠁⠀⠀⣼⢿⣷⠀⠀⠀⠀⣿⡿⠷⢶⣶⣾⡀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢳⡀⠀⣷⠀⠀⠀⠀⠀⠀⣴⠋⡧⠉⣩⡥⠶⠶⠋⠀⢀⡼⠋⠀⠀⢀⣼⠋⢻⣿⣆⢠⣴⣶⠏⠀⠀⠈⠋⣿⡇⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⢱⡄⠘⣆⠀⠀⠀⠀⣼⣃⡼⢁⡞⠁⠀⠀⠀⠀⣴⠟⠁⢀⣠⡴⠛⠁⠀⢈⣿⣿⣼⡏⠿⠀⠀⠀⠀⠀⣿⣿⣦⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⣠⣽⡄⠘⣦⣀⣠⣖⡭⠟⠲⢬⡙⢦⠀⠀⣠⠞⠁⣠⣖⣻⡿⠷⣤⣼⠉⢻⣼⣿⣿⢃⡆⠀⠀⠀⠀⢠⣿⣿⣿⠀]],
    [[⠀⠀⠀⠀⠀⠀⢀⡼⠛⣦⠹⡄⢨⡿⢳⠏⠀⠀⠀⢈⡇⢸⣀⡼⠋⣠⠞⠻⡍⢿⡄⠀⠈⠙⡄⢈⣿⠱⣿⣼⠀⣀⣀⣀⣾⣿⣿⣿⡟⠀]],
    [[⠀⠀⠀⠀⠀⢀⣜⣤⡞⣿⠛⣻⠋⣇⠸⣆⠀⠀⣀⡼⣣⠾⠋⠀⡼⠁⠀⠀⠹⡌⢿⡄⠀⠀⠹⣏⠉⠓⠮⢿⣏⣡⡼⠛⠉⠉⠻⣿⡇⠀]],
    [[⠀⠀⠀⠀⠀⢸⣏⠙⣳⡷⣼⡇⠀⡿⣄⡈⠉⠉⢁⣰⡏⠀⠀⢰⣇⠀⠀⠀⠀⠙⠺⣿⣦⣴⣾⢻⣷⣤⣤⡶⠋⠉⢳⡄⢀⣀⣀⣿⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⢧⠀⢧⠀⠉⠉⠉⠉⡿⠀⢠⡟⠀⣿⣄⠀⠀⠀⠀⠀⠻⣄⠀⢸⣼⠃⠀⠀⠙⢷⠀⠀⠙⢾⡇⠈⣟⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣆⠀⠀⠀⠀⠀⣸⠃⢠⣿⠀⣠⡿⠙⢦⠀⠀⠀⠀⠀⠈⠳⢤⣙⣆⠀⢠⠞⠙⠳⠦⢤⣄⣧⣼⣁⡱⡄]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⡀⠀⠀⠀⢀⡏⣰⣏⣏⣴⠋⠳⣄⠈⢷⡀⠀⠀⠀⠀⠀⠀⠉⠙⠓⠚⠓⠒⠒⠒⠛⠫⣍⣁⣀⣷⠇]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣞⡽⢿⡃⠀⠀⠀⠾⠐⠋⣁⣼⠃⠀⠀⠈⠳⣄⠻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠋⠀⠀⢻⣄⠀⠀⣠⠶⢻⣿⡏⠀⠀⠀⠀⠀⠈⠳⣝⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢼⠟⠀⠀⠀⠀⠈⣾⡓⠋⠹⠆⣸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⠻⠷⠾⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  LieKongZuoBig = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣀⣴⣶⣶⢶⣶⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡤⠤⣶⡿⠿⠉⢉⢻⣮⣿⡛⢛⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⡛⣻⣥⣀⢰⡏⠀⠀⠀⠀⠀⠉⢻⣿⠟⠉⠉⠙⠓⠲⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡯⣴⣿⠡⢤⣌⣻⣷⣄⠀⠀⠀⠀⠀⢸⣟⡿⠷⢦⣀⠀⠀⠀⠉⠻⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⢡⣴⠶⠟⠚⠛⠉⠉⢩⣿⣿⠒⠒⠒⠠⣤⣿⣿⣿⣦⢿⣖⠲⢤⣀⣤⡶⠿⢷⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠛⠻⠿⠿⠿⠋⠉⠉⠛⠛⢿⣷⡎⣿⠉⠀⠀⠈⠻⣯⠙⢿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠇⣴⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⠀⠀⠀⠀⠀⠘⢷⣄⠻⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠏⣸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⡇⠀⠀⠀⠀⠀⠀⠙⣧⣽⣿⡆⠀⠀⠀⠀⠀⠀⠀]],
    [[⠸⣿⡿⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⣿⣷⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⡀⢂⡀⠀⠀⠀⠀⠀⠈⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀]],
    [[⠀⠘⣧⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠟⠻⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣄⣱⡶⢲⣶⣲⣶⠾⠿⢿⣿⣷⡀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠘⣷⡀⠈⠻⣄⡀⠀⠀⠀⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡶⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⡿⠋⣠⣿⣿⣋⡀⠀⠀⠀⠹⣿⠿⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠈⢷⡀⠀⠈⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⣿⣿⣳⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠋⠀⢠⠟⢿⣯⣉⢷⠀⠀⠀⠀⠙⣧⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠈⢷⡀⠀⠀⠹⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣻⣿⠿⠿⠿⠿⢿⣯⣟⠶⣤⡀⠀⢀⣴⠟⠁⠀⣰⠏⠀⠈⠻⢿⢸⡄⠀⠀⠀⠀⢻⡆⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠋⠁⠀⠀⠀⠀⢀⣹⣿⣧⣸⣿⣶⡞⠁⠀⠀⣼⡏⠀⠀⠀⠀⢸⣿⢿⡄⠀⠀⠀⠀⣷⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡏⠀⠀⠀⠀⠀⣀⡴⠟⣋⣡⢿⣿⣿⡿⠋⠀⠀⠀⣼⣿⣇⠀⠀⠀⠀⠘⣿⡆⣿⣀⣀⣀⢀⣹⡄⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⢹⣄⠀⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠹⣧⣀⣀⣤⡴⠾⢋⣴⠞⠋⠀⢀⣿⠟⠀⠀⠀⠀⣴⣟⣿⣿⡄⠀⠀⠀⠀⣻⣷⠟⠛⠛⣿⣿⣿⡇⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⢙⡧⠈⣉⣩⡤⠶⠶⠟⠁⠀⠀⣠⡿⠁⠀⠀⠀⠀⣼⠏⠙⣿⣿⣇⠀⣤⣴⣶⡟⠁⠀⠀⠀⠘⠹⣿⡇⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠸⣧⠀⠀⠀⠀⠀⠀⢰⡏⢀⡾⠁⣼⠏⠁⠀⠀⠀⠀⠀⢀⡾⠋⠀⠀⠀⣀⣤⠾⠃⠀⠀⢹⣿⣿⡄⣿⡟⢿⠀⠀⠀⠀⠀⠀⠀⣿⣿⣦⡀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣇⠀⠹⣆⠀⠀⠀⠀⣠⡿⠶⠛⠁⠸⣧⣄⠀⠀⠀⠀⢀⣴⠟⠁⢀⣠⣶⣾⣯⡁⠀⢠⡶⢄⣼⢻⣿⣿⣿⠇⡈⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⡇⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡶⠻⣧⠀⠙⢧⣤⣴⢿⣷⠞⠛⠉⠙⢷⡄⠹⣇⠀⠀⣴⡟⠁⢀⣴⣿⣯⣾⡿⠛⠻⢶⣾⡀⠈⣿⣿⡿⣿⣿⢠⡇⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⡇⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠋⠙⣧⠹⣦⠀⣸⣿⠛⡿⠁⠀⠀⠀⠀⢀⡇⠀⣿⢠⡾⠋⢀⣴⠟⠙⣧⠉⣿⡆⠀⠀⠀⠘⣧⠀⢸⣿⠁⣿⣿⣾⠀⠀⢀⣀⢀⣼⣿⣿⣿⣿⣿⠃⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢀⡼⢃⣠⠶⣿⠶⠿⣿⠏⡇⠀⣧⠀⠀⠀⠀⢀⣼⢇⣠⡿⠟⠁⢠⡟⠁⠀⠀⠘⣦⠘⣿⣄⠀⠀⠀⠹⣿⠛⠙⠷⢬⣻⣿⡿⠛⢉⣽⠿⠛⠉⠙⢿⣿⣿⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⣿⡿⠿⣿⣠⡟⢠⣾⠋⠀⣿⡄⠙⠷⣦⣤⡶⠋⢁⣾⠋⠀⠀⢀⣿⠀⠀⠀⠀⠀⠙⢷⣼⣿⡄⠀⠀⢀⣽⣷⡄⠀⠀⠉⣩⣿⠞⢿⣇⠀⠀⠀⠀⠈⢿⠋⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢻⣧⣂⡬⠽⠛⡿⣿⠀⠀⡏⠳⢤⣀⣀⣀⣀⣤⣾⠇⠀⠀⡀⢸⢿⡄⠀⠀⠀⠀⠀⠀⠘⢿⠿⠿⠿⠿⡏⣾⣿⠿⠿⠿⣏⡀⠀⠀⠹⣦⡀⣤⠶⢶⣼⡇⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡆⠀⢷⠀⠀⠈⠉⠁⠀⢠⡿⠀⠀⣼⠇⠀⢸⣷⡀⠀⠀⠀⠀⠀⠀⠘⣷⡀⠀⠀⣧⣿⠁⠀⠀⠀⠉⢷⡄⠀⠀⠈⠻⣿⠀⠀⣿⡀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⣼⡟⠀⠀⣿⠏⠻⣆⠀⠀⠀⠀⠀⠀⠈⠻⢦⣀⠈⢿⡆⠀⠀⣠⡶⠛⠷⣤⣄⣀⡀⢸⡀⣼⠏⠙⣦⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣿⣿⣧⠀⠀⠀⠀⠀⠀⣸⠏⢀⡾⣿⡇⢠⡾⢿⡀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠾⢿⣦⣤⣿⣤⣀⣀⣀⣤⣼⣟⠛⠛⠛⠓⢲⣸⡇]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⡄⠀⠀⠀⠀⠀⡿⢀⣾⣷⠿⣴⡟⠀⠀⠹⣦⡀⠘⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠉⠉⠁⠀⠀⠉⠓⠶⣤⣠⣾⠟⠁]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣥⠟⢿⡇⠀⠀⠀⠀⠸⠃⠙⠁⣀⣶⣿⠀⠀⠀⠀⠈⠻⣦⡈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠟⠁⠀⠈⢻⣄⠀⠀⠀⢀⣠⡶⢻⣿⣿⠁⠀⠀⠀⠀⠀⠀⠈⠻⣦⡻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡿⠁⠀⠀⠀⠀⠘⣯⣷⣤⡴⢿⣡⠀⢸⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠀⠀⠀⠀⠀⠀⠀⠹⣷⣉⡀⠀⣉⣤⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣙⠻⠿⠿⠿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },

  GoKuSmall = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⠾⠿⠿⠿⠿⠿⠿⠷⣶⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡾⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⣠⣾⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠉⠻⣷⣄⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣿⠟⢁⣀⣠⣀⡀⠀⠈⠻⣷⣄⠀⠀⠀⠀]],
    [[⠀⠀⠀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠈⢿⣦⠀⠀⠀]],
    [[⠀⠀⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢶⣦⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⠤⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀]],
    [[⠀⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀]],
    [[⢰⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡆]],
    [[⣼⡏⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠙⠻⣿⡿⠿⣿⣿⣿⣿⡿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧]],
    [[⣿⡇⠀⠀⠀⠀⠀⣼⡟⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣷⣶⣿⣿⣥⣄⣠⣶⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
    [[⣿⡇⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣭⣿⣟⣿⡟⠛⠛⣿⣯⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
    [[⢻⣇⠀⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⢿⣷⣾⡟⢿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟]],
    [[⠸⣿⡀⠀⠀⠀⠀⠘⢧⡀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⡟⠈⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠇]],
    [[⠀⢻⣧⠀⠀⠀⠀⠀⠀⠙⢶⣄⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠀]],
    [[⠀⠀⢻⣧⠀⠀⠀⠀⠀⠀⢼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠀⠀]],
    [[⠀⠀⠀⠻⣧⡀⠀⠀⠀⠀⢸⣿⣿⣿⣏⠙⠛⠋⣿⠿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⢀⣼⠟⠀⠀⠀]],
    [[⠀⠀⠀⠀⠙⢿⣆⡀⠀⠀⠀⠙⢿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⣿⣿⡗⠀⠀⠀⠀⣴⡿⠋⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠙⢿⣦⣄⣰⣶⣿⣿⣧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣠⣿⣿⣶⣄⣴⡿⠋⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },
  GoKuBig = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⢀⣀⣤⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀]],
    [[⠺⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⢿⠏⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠁⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠽⢿⣿⣿⣿⣿⣿⣿⣿⣿⣥⣼⣿⣿⣿⣿⣿⠋⣪⠴⠶⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠃]],
    [[⠀⠀⠀⠀⠀⠀⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠙⢿⣿⣿⡏⢠⢁⣀⣀⣀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀]],
    [[⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠙⠊⢻⣿⠁⠸⠁⠀⠀⢨⣿⠋⣹⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠻⠟⣿⣿⡙⡿⠀⠀⢰⣶⠀⠙⠃⠀⣶⡆⠀⠊⢸⣀⢿⡟⠉⠈⣿⣿⣿⣿⣄⡀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢀⠿⡓⢣⠀⣀⡈⠉⠀⠀⠀⠀⠉⣀⣀⣀⡼⠀⣘⡁⡐⣠⣿⣿⣿⣿⡿⠿⠷⠄⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠼⠦⣉⣧⠀⠛⠒⠉⠁⠰⢿⠀⠀⠈⠉⠉⠉⠉⣰⣉⢽⡞⠛⢯⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠔⡿⠀⠀⡜⢡⣻⡄⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⣠⢣⣹⠀⢣⠀⠈⢯⠑⠦⣀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⣠⠴⠃⠀⠃⠀⠘⠀⢙⠀⠈⠢⣄⠀⠀⠀⠋⠁⠀⠀⢀⣠⠚⠁⠀⢸⡇⠘⠆⠀⠀⠁⠀⠀⠙⠢⡀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⢠⠚⠁⠀⠀⠀⠀⠀⠀⠀⢈⠉⢦⡀⠸⡕⢶⠤⣀⣠⠤⡾⣫⣋⣀⣤⣖⣹⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⣏⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣸⣷⠀⠀⢰⠀⠀⠀⠀⠀⢸⡉⠉⠉⠉⠉⠒⠧⣄⡴⠚⠉⠀⠀⠀⠀⠀⣸⢃⠔⠀⠀⠀⠀⢰⠀⢀⣾⣿⣷⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢀⣿⣿⣷⡄⠈⡆⠀⠀⠀⠀⠘⣷⣄⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⣰⣿⠋⠀⠀⠀⠀⠀⢸⢀⣾⣿⣿⠟⡀⠀⠀⠀]],
    [[⠀⠀⠀⣠⡿⠛⢿⣿⣿⣷⣽⠀⠀⠀⠀⠀⠹⣿⣷⣤⣄⣀⣀⣸⣀⣀⣀⣀⣠⣤⣾⡿⠁⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⠋⠱⣹⠀⠀⠀]],
    [[⠀⠀⣠⠋⠀⠀⠀⠙⠻⠿⣿⡆⠀⠰⡀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⢠⣿⠟⠋⠁⠀⠀⢹⡇⠀⠀]],
    [[⣤⣴⣇⡀⠀⠀⠀⠀⠀⠀⢠⢿⡀⠀⠙⣄⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⢠⠂⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀]],
    [[⣿⣿⣿⣿⠿⠓⠒⠢⢤⣀⡀⡨⢷⡄⠀⢎⢦⡀⠀⠀⠹⢿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⢰⠇⠀⠀⠀⠀⠀⠀⠀⠈⡄⠀]],
    [[⣿⣿⡿⠃⠀⠀⠀⠀⢸⢸⣿⣿⣿⣷⣤⣤⣀⡉⠂⠀⠀⠀⠙⠿⠋⠀⠀⠀⢀⣀⠤⠤⣜⠁⠀⠀⢠⡿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⣿⣿⡁⠀⠀⠀⠀⠀⢸⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣤⣀⣀⠀⠀⢀⡏⣰⠶⣶⡎⢳⠀⣠⠟⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⣰⠀]],
  },
  AyanamiRei = {
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿]],
    [[⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿]],
    [[⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿]],
    [[⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿]],
  }
}
local startify = require('alpha.themes.startify')
local random_image = true -- 设置为true表示每次启动显示不同的图片
startify.section.header.val = images.KaBiShou
if random_image then
  startify.section.header.val = random_elem(images)
end

startify.section.header.opts.position = 'center' -- 让图标显示在中间 对于某些大图标很有用 默认显示左边
-- startify.section.mru.val = { { type = "padding", val = 0 } }                         -- 这一行可以让近期文件不显示
-- startify.section.mru_cwd.val = { { type = "padding", val = 0 } }                     -- 这一行可以不显示当前文件夹的文件
startify.section.top_buttons.val = {
  startify.button("e", "Edit New File", "<cmd>ene <CR>", { desc = "Edit New File" }),                 -- 快捷键配置 四个参数分别是 按键 名称 具体值 配置信息 一旦离开初始页面 配置就失效了
  startify.button("SPC f f", "Find Files", '<cmd>Telescope find_files<cr>', { desc = 'Find Files' }), -- 如果不写具体值和配置信息 (3-4参数) 只会显示 不会真的设置新的快捷键 这也意味着把光标设置到这里 并且按下回车会出现问题
  startify.button("SPC f g", "Grep Files (Find Contents)", '<cmd>Telescope live_grep<cr>', { desc = 'Find Grep' }),
  startify.button("SPC f h", "Find History Files", '<cmd>Telescope oldfiles<cr>', { desc = 'Find History Files' }),
  startify.button("SPC f t", "Find AsyncTasks", '<cmd>Telescope asynctasks all<cr>', { desc = 'Find AsyncTasks' }),
}

startify.section.bottom_buttons.val = {
  { type = "padding", val = 0 }
} -- 设置不显示底部按钮

startify.section.footer.val = { {
  type = "text",
  val = "   Have Fun with neovim"
      .. " v"
      .. vim.version().major
      .. "."
      .. vim.version().minor
      .. "."
      .. vim.version().patch
      .. "\n  Help poor children in Uganda!"
}
}

startify.config.layout = {
  { type = "padding", val = 1 },
  startify.section.header,
  { type = "padding", val = 2 },
  startify.section.top_buttons,
  startify.section.mru_cwd,
  startify.section.mru,
  startify.section.bottom_buttons,
  startify.section.footer,
}

-- local dashboard = require("alpha.themes.dashboard") -- 这个配置模板不会显示历史文件和当前文件 但是会提示几种快捷键
-- dashboard.section.header.val = KaBiShou
require("alpha").setup(startify.config)

if is_linux then
  ---
  -- Indent-blankline
  ---
  -- See :help ibl.setup()
  require('ibl').setup({
    enabled = true,
    scope = {
      enabled = true,
    },
    indent = {
      char = '▏',
    },
  })
end

if is_windows then
  ---
  -- Indent-blankline
  ---
  -- See :help ibl.setup()
  require('ibl').setup({
    enabled = true,
    scope = {
      enabled = false,
    },
    indent = {
      char = '▏',
    },
  })
end

---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false

-- See :help lualine.txt
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'NvimTree' }
    }
  },
  sections = {
    lualine_x = {
      {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
      }, "encoding", "fileformat", "filetype"
    },
  }
})


--[[
---
-- bufferline
---
-- See :help bufferline-settings
require('bufferline').setup({
  options = {
    mode = 'buffers',
    offsets = {
      {filetype = 'NvimTree'}
    },
  },
  -- :help bufferline-highlights
  highlights = {
    buffer_selected = {
      italic = false
    },
    indicator_selected = {
      fg = {attribute = 'fg', highlight = 'Function'},
      italic = false
    }
  }
})
--]]



---
-- Luasnip (snippet engine)
---
-- See :help luasnip-loaders
local snippet_path = vim.fn.stdpath("config") .. "/my-snippets/"
if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
  vim.opt.rtp:append(snippet_path)
end
require('luasnip.loaders.from_vscode').lazy_load() -- 导入vscode的代码片段作为提示


---
-- LuaSnip 跳转快捷键
---
-- 在代码片段中跳转到下一个/上一个占位符
-- 例如: for ($1; $2; $3) { $0 }
--   按 C-f 跳到下一个占位符 ($1 → $2 → $3 → $0)
--   按 C-b 跳回上一个占位符
vim.keymap.set({ 'i', 's' }, '<C-f>', function()
  local ls = require('luasnip')
  if ls.jumpable(1) then ls.jump(1) end
end, { desc = 'LuaSnip: Jump forward' })

vim.keymap.set({ 'i', 's' }, '<C-b>', function()
  local ls = require('luasnip')
  if ls.jumpable(-1) then ls.jump(-1) end
end, { desc = 'LuaSnip: Jump backward' })


---
-- LSP config (Neovim 0.11+ 使用 vim.lsp.config 内置 API)
---
-- See :help vim.lsp.config

-- 设置默认 capabilities (blink.cmp)
vim.lsp.config['*'] = {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

---
-- Diagnostic customization
-- deprecated
---
---
--[[
local sign = function(opts)
  -- See :help sign_define()
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '✘' }) -- 各种级别的诊断标志 错误 警告 提示 信息
sign({ name = 'DiagnosticSignWarn', text = '▲' })
sign({ name = 'DiagnosticSignHint', text = '⚑' })
sign({ name = 'DiagnosticSignInfo', text = '»' })
--]]
--

-- See :help vim.diagnostic.config()
vim.diagnostic.config({ -- 显示文件的诊断信息 例如当前文件哪里出错了 有什么错
  virtual_text = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.INFO] = '⚑',
      [vim.diagnostic.severity.HINT] = '»',
    },
  },
})

--[[
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})--]]

-- 使用 vim.lsp.handlers.hover 和 signature_help 的配置方式避免 deprecated 警告
vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.hover(err, result, ctx, config)
end

vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.signature_help(err, result, ctx, config)
end

---
-- LSP Keybindings
---
vim.api.nvim_create_autocmd('LspAttach', { -- lsp 启动之后的快捷键
  group = group,
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs, desc)
      local opts = { buffer = true, desc = desc }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- You can search each function in the help page.
    -- For example :help vim.lsp.buf.hover()

    -- Neovim 0.11+ 内置 LSP 快捷键（无需手动配置）：
    -- grn      - vim.lsp.buf.rename()              (原 <F2>)
    -- grr      - vim.lsp.buf.references()          (原 gr)
    -- gri      - vim.lsp.buf.implementation()      (原 gi)
    -- grt      - vim.lsp.buf.type_definition()    (原 go)
    -- gra      - vim.lsp.buf.code_action()         (原 <F4>)
    -- gO       - vim.lsp.buf.document_symbol()
    -- CTRL-S   - vim.lsp.buf.signature_help()      (Insert/Select 模式，原 gs)

    -- 以下为需要手动配置的快捷键（Neovim 未提供默认）
    bufmap('n', 'grh', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Toggle hover doc') -- 网上很多建议将这个功能配置成K快捷键 这里做一个统一的解释 K 是一个vim/nvim的默认按键(不是map配置出来的快捷键) 你可以通过 :help K 查看K是干啥的 我这里一句话解释就是keyword 他会调用keywordprg来查看当前单词是干嘛的 如果你没有配置keywordprg 那么他会调用:help! 查看一下当前单词 这个功能可以直接查看各种文档的 比如C语言printf 上面按K 就会看到文档 Python上面调用则会使用pydoc查看python文档的(因为neovim识别到当前文件是py类型 直接将keywordprg设置成了pydoc看文档功能) 注意: 0.11+的neovim默认lsp配置会在检查用户没配置K快捷键 并且检查到keywordprg为空或者默认值时 自动将K配置为vim.lsp.buf.hover 不过这里的配置也不必删除 因为也许有人是既需要原生的K这种的 又需要Hover的 因此配置一个gr前缀的系列快捷键可以作为保底
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto definition')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Goto declaration')
    bufmap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format buffer') -- 后续可以考虑上 conform.nvim 这玩意是专门的formater 有些lsp是不自带format的
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Display diagnostic')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Goto previous diagnostic')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Goto next diagnostic')
  end
})


---
-- LSP servers
---
-- See :help mason-settings
require('mason').setup({
  ui = { border = 'rounded' }
})

-- See :help mason-lspconfig-settings
require('mason-lspconfig').setup({
  ensure_installed = {
  },
  -- See :help mason-lspconfig.setup_handlers()
  --[[
  handlers = {
    function(server)
      -- See :help lspconfig-setup
      lspconfig[server].setup({})
    end,
    ['tsserver'] = function()
      lspconfig.tsserver.setup({
        settings = {
          completions = {
            completeFunctionCalls = true
          }
        }
      })
    end,
  }
  --]]
})


-- 配置并启用 LSP servers (Neovim 0.11+ 内置 API)
-- See :help vim.lsp.config
-- See :help vim.lsp.enable

vim.lsp.config.clangd = {}
vim.lsp.enable('clangd')

vim.lsp.config.lua_ls = {}
vim.lsp.enable('lua_ls')

vim.lsp.config.pylsp = {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  }
}
vim.lsp.enable('pylsp')


---
-- AsyncTasks
---
-- See :help asynctasks
vim.g.asyncrun_open = 6
vim.g.asynctasks_extra_config = { vim.fn.stdpath("config") .. "/.tasks", vim.fn.stdpath("data") .. "/.tasks" }
vim.g.asyncrun_rootmarks = { '.git', '.svn', '.root', '.project', '.hg', '.tasks' }
vim.keymap.set('n', '<leader>cq', '<cmd>cclose<cr>', { desc = 'Close QuickFix/AsyncTask Terminal' })
vim.keymap.set('n', '<leader>ct', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader>cL', '<cmd>lclose<cr>', { desc = 'Close Location List' })
vim.keymap.set('n', '<leader>ca', '<cmd>wqa<cr>', { desc = 'Close Neovim and Save all files' })
vim.keymap.set('n', '<leader>cb', '<cmd>Bdelete<CR>', { desc = 'Close buffer' })

---
-- Treesitter
---
-- See :help nvim-treesitter-modules
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  -- :help nvim-treesitter-textobjects-modules
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
  },
  ensure_installed = {
    'lua',
    'vim',
    'vimdoc',
    'json',
    'c',
    'cpp',
    'python',
    'markdown',
    'markdown_inline',
  },
})


---
-- vim-translator
--
-- See :help translator.txt
vim.keymap.set('n', '<leader>ts', ':TranslateW<cr>', { desc = 'Translate this word' })
vim.keymap.set('x', '<leader>ts', ":TranslateW<cr>", { desc = 'Translate selected Text' })
vim.keymap.set('x', '<leader>tr', ":TranslateR<cr>", { desc = 'Translate and Replace' })

---
-- which-key
--
-- See :help which-key
local wk = require("which-key")
wk.add({
  { "<leader>",  group = "leader" },
  { "<leader>b", group = "buffers" },
  { "<leader>c", group = "close" },
  { "<leader>d", group = "debug (DAP)" },
  { "<leader>f", group = "telescope find" },
  { "<leader>p", group = "plugin" },
  { "<leader>s", group = "session" },
  { "<leader>t", group = "translate" },
  { "<leader>x", group = "trouble" },
  { "<leader>y", group = "copy to system" },
  { "]",         group = "Goto next" },
  { "[",         group = "Goto prev" },
  { "gr",        group = "LSP (n:rename, r:refs, i:impl, t:type, a:action, h:hover)" },
})


---
-- noice
--
-- See :help noice
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **blink.cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})


---
-- todo-comments
--
-- See :help todo-comments
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- set keywords if you want
-- require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})


---
-- DAP (Debug Adapter Protocol)
---
-- See :help dap
-- See :help dapui
-- See :help mason-nvim-dap

local dap = require('dap')
local dapui = require('dapui')

-- DAP UI 配置
dapui.setup({
  icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
  mappings = {
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  layouts = {
    {
      elements = {
        { id = 'scopes',      size = 0.25 },
        { id = 'breakpoints', size = 0.25 },
        { id = 'stacks',      size = 0.25 },
        { id = 'watches',     size = 0.25 },
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        { id = 'repl',    size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      size = 10,
      position = 'bottom',
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = 'single',
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  controls = {
    enabled = true,
    element = 'repl',
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  },
})

-- 自动打开/关闭 DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- Mason-nvim-dap 配置（类似 mason-lspconfig）
require('mason-nvim-dap').setup({
  ensure_installed = {},
  automatic_installation = true,
  handlers = {
    function(config)
      -- 所有 adapter 的默认配置
      require('mason-nvim-dap').default_setup(config)
    end,
  },
})

-- DAP 虚拟文本显示变量值
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })

-- DAP 快捷键
vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'DAP: Continue/Start' })
vim.keymap.set('n', '<F6>', function() dap.pause() end, { desc = 'DAP: Pause' })
vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end, { desc = 'DAP: Toggle Breakpoint' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'DAP: Step Over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'DAP: Step Into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'DAP: Step Out' })
vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'DAP: Toggle REPL' })
vim.keymap.set('n', '<leader>dh', function()
  dap.ui.widgets.hover()
end, { desc = 'DAP: Hover Variable' })
vim.keymap.set('n', '<leader>dp', function()
  dap.ui.widgets.preview()
end, { desc = 'DAP: Preview Variable' })
vim.keymap.set('n', '<leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = 'DAP: Show Frames' })
vim.keymap.set('n', '<leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = 'DAP: Show Scopes' })
vim.keymap.set('n', '<leader>du', function() dapui.toggle() end, { desc = 'DAP: Toggle UI' })
vim.keymap.set('n', '<leader>dq', function()
  dap.close()
  dapui.close()
end, { desc = 'DAP: Quit Debugging' })


-- ========================================================================== --
-- ==                         MERMAID PREVIEW                               == --
-- ========================================================================== --

-- Check if mermaid-ascii is available
-- install: go install github.com/AlexanderGrooff/mermaid-ascii@latest
local function mermaid_ascii_available()
  return vim.fn.executable('mermaid-ascii') == 1
end

if mermaid_ascii_available() then
  -- Extract mermaid code block at cursor position
  local function get_mermaid_block()
    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1 -- Convert to 0-indexed

    -- Find the start of the code block (```mermaid)
    local start_row = nil
    for i = row, 0, -1 do
      local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
      if line:match('^```%s*mermaid%s*$') then
        start_row = i
        break
      end
      -- If we hit another code block, stop searching
      if line:match('^```%s*%w+') and i ~= row then
        break
      end
    end

    if not start_row then
      return nil
    end

    -- Find the end of the code block (```)
    local end_row = nil
    for i = start_row + 1, vim.api.nvim_buf_line_count(buf) - 1 do
      local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
      if line:match('^```%s*$') then
        end_row = i
        break
      end
    end

    if not end_row then
      return nil
    end

    -- Extract the content
    local lines = vim.api.nvim_buf_get_lines(buf, start_row + 1, end_row, false)
    return table.concat(lines, '\n')
  end

  -- Create floating window
  local function show_mermaid_preview(content)
    if not content or content == '' then
      vim.notify('Empty mermaid content', vim.log.levels.WARN)
      return
    end

    -- Run mermaid-ascii
    local result = vim.fn.system({ 'mermaid-ascii', '-f', '-' }, content)

    if vim.v.shell_error ~= 0 then
      vim.notify('mermaid-ascii error: ' .. result, vim.log.levels.ERROR)
      return
    end

    -- Create scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, '\n'))
    vim.bo[buf].filetype = 'mermaid_preview'
    vim.bo[buf].modifiable = false

    -- Calculate window size
    local lines = vim.split(result, '\n')
    local width = 0
    for _, line in ipairs(lines) do
      width = math.max(width, #line)
    end
    width = math.min(width + 2, vim.o.columns - 4)
    local height = math.min(#lines + 2, vim.o.lines - 4)

    -- Create floating window
    local opts = {
      relative = 'editor',
      width = width,
      height = height,
      row = (vim.o.lines - height) / 2,
      col = (vim.o.columns - width) / 2,
      style = 'minimal',
      border = 'rounded',
      title = ' Mermaid Preview ',
      title_pos = 'center',
    }

    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.wo[win].wrap = true
    vim.wo[win].cursorline = true

    -- Press q to close
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf, nowait = true })

    -- Press Esc to close
    vim.keymap.set('n', '<Esc>', function()
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf, nowait = true })
  end

  -- Preview mermaid diagram under cursor
  local function preview_mermaid()
    local content = get_mermaid_block()
    if not content then
      vim.notify('No mermaid code block found at cursor position', vim.log.levels.WARN)
      return
    end
    show_mermaid_preview(content)
  end

  -- Preview all mermaid diagrams in current buffer
  local function preview_all_mermaid()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local content = table.concat(lines, '\n')

    -- Extract all mermaid blocks
    local mermaid_blocks = {}
    for block in content:gmatch('```mermaid%s*\n(.-)```') do
      table.insert(mermaid_blocks, block)
    end

    if #mermaid_blocks == 0 then
      vim.notify('No mermaid code blocks found in buffer', vim.log.levels.WARN)
      return
    end

    -- Combine all blocks with separator
    local combined = table.concat(mermaid_blocks, '\n\n---\n\n')
    show_mermaid_preview(combined)
  end

  -- Set keymaps for markdown files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = group,
    desc = 'Mermaid preview keymaps',
    callback = function()
      vim.keymap.set('n', '<leader>mp', preview_mermaid, { buffer = true, desc = 'Preview Mermaid diagram' })
      vim.keymap.set('n', '<leader>mP', preview_all_mermaid, { buffer = true, desc = 'Preview all Mermaid diagrams' })
    end,
  })

  -- Also add which-key entries
  wk.add({
    { '<leader>m', group = 'mermaid' },
  })
end
