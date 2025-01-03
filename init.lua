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
  { "folke/tokyonight.nvim",                      priority = 1000 },
  { "ellisonleao/gruvbox.nvim",                   priority = 1000 },

  -- dashboard: alpha
  { "goolord/alpha-nvim" },

  -- indent blank visual
  { 'lukas-reineke/indent-blankline.nvim',        main = 'ibl' },

  -- below status line
  { 'nvim-lualine/lualine.nvim' },

  -- top status line
  { 'akinsho/bufferline.nvim' },

  -- LSP support
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  -- Autocomplete
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lsp' },

  -- Snippets
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  -- asynctasks
  { 'skywind3000/asynctasks.vim' },
  { 'skywind3000/asyncrun.vim' },

  -- treesitter
  { 'nvim-treesitter/nvim-treesitter' },
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
  }

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
-- nvim-cmp (autocomplete)
---
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

-- See :help cmp-config
cmp.setup({ -- cmp是补全的引擎，它可以介绍多种补全的资源，例如lsp，正则表达式，文件，buffer等等
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'path' },                        -- 允许文件路径作为代码提示 例如你写代码 open("./")这时候就会提示各种文件
    { name = 'nvim_lsp' },                    -- 允许lsp提示
    { name = 'buffer',  keyword_length = 3 }, -- 允许buffer作为提示
    { name = 'luasnip', keyword_length = 2 }, -- 允许代码片段作为提示 比如之前安装的vscode片段
  },
  window = {                                  -- 窗口设置边框
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = { -- 一个设置
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = { -- 这里的是在你按下Tab补全时，用各种标志区分补全来自哪个资源
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  -- See :help cmp-mapping
  mapping = {                                             -- 快捷键设置
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts), -- 用上下选择哪个补全
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts), -- 同上
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),            -- 滑动文档，用idea的时候，可以看到一个函数的
    ['<C-d>'] = cmp.mapping.scroll_docs(4),             -- 文档 这两个快捷键可以滑动那个小窗口

    ['<C-e>'] = cmp.mapping.abort(),                    -- 取消
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- 确认
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- 回车表示 确认 很符合使用习惯

    ['<C-f>'] = cmp.mapping(function(fallback)          -- 在代码段中向后跳转
      if luasnip.jumpable(1) then                       -- 很多代码段是不只一个参数的
        luasnip.jump(1)                                 -- 例如 for($1 i = 0; i < $2; i$3)
      else                                              -- 按这个就可以从$1往后面跳，方便你修改
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-b>'] = cmp.mapping(function(fallback) -- 同上 向前跳转
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),


    ['<Tab>'] = cmp.mapping(function(fallback) -- 补全快捷键
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback) -- 同上
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})


---
-- LSP config
---
-- See :help lspconfig-global-defaults
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

---
-- Diagnostic customization
---
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

-- See :help vim.diagnostic.config()
vim.diagnostic.config({ -- 显示文件的诊断信息 例如当前文件哪里出错了 有什么错
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

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
    -- 下面的各种函数调用已经非常容易懂了 就不解释了

    bufmap('n', 'H', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Toggle hover doc') -- h is left
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto definition')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Goto declaration')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Goto implementation')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>',
      'Goto definition of the type of the symbol under the cursor')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', 'List all the references')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Display signature help')
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol under the cursor')
    bufmap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format buffer')
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Display code action')
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


lspconfig.clangd.setup({})
lspconfig.lua_ls.setup({})

lspconfig.pylsp.setup({
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
})


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

if is_linux then
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
    },
  })
end

if is_windows then
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua',
      'vim',
      'vimdoc',
      'json',
      'c',
      'cpp',
      'python',
    },
  })
end



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
  { "<leader>f", group = "telescope find" },
  { "<leader>p", group = "plugin" },
  { "<leader>s", group = "session" },
  { "<leader>t", group = "translate" },
  { "<leader>x", group = "trouble" }, -- use t for trouble?
  { "<leader>y", group = "copy to system" },
  { "]",         group = "Goto next" },
  { "[",         group = "Goto prev" },
})


---
-- noice
--
-- See :help noice
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
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
