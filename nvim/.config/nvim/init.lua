-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
    { "mason-org/mason.nvim", opts = {} },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "saghen/blink.cmp", opts = {}, version = "1.4.1" },
    { "folke/trouble.nvim", opts = {} },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "S",
          mode = { "n", "x", "o" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "typescript", "css", "html" },
          highlight = {
            enable = true,
          },
        })
      end,
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "folke/snacks.nvim",
      opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      },
    },
    {
      "stevearc/conform.nvim",
      opts = {},
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            typescript = { "prettier" },
            javascript = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
          },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      opts = {},
      config = function()
        vim.lsp.enable("ts_ls")
        vim.lsp.enable("cssls")
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      opts = {},
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require("luasnip").filetype_extend("typescript", { "javascript" })
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
      keys = {
        {
          "<C-L>",
          function()
            require("luasnip").expand_or_jump()
          end,
          mode = "i",
        },
      },
    },
    {
      "nvim-tree/nvim-tree.lua",
      opts = {},
      config = function()
        require("nvim-tree").setup()
        vim.keymap.set("n", "<leader>e", ":NvimTreeFindFile<cr>")
      end,
    },
  },
  checker = { enabled = true },
})

-- Opt
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files({ hidden = true })
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("v", "<leader>f", 'y:Telescope grep_string search=<C-R>"<CR>', { desc = "Telescope live grep selected" })

-- Mapping
vim.keymap.set("i", "<esc>", "")
vim.keymap.set("i", "<A-i>", "<esc>")
vim.keymap.set("i", "<D-i>", "<esc>")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<leader>l", ":Lazy<cr>")
vim.keymap.set("n", "<leader>m", ":Mason<cr>")
vim.keymap.set("n", "<leader><leader>", function()
  require("conform").format()
end)
vim.keymap.set("n", "gd", function()
  vim.lsp.buf.implementation()
end)
vim.keymap.set("n", "gt", function()
  vim.lsp.buf.type_definition()
end)
vim.keymap.set("n", "gh", function()
  vim.lsp.buf.hover()
end)

vim.diagnostic.config({ underline = true, virtual_text = true, signs = false, severity_sort = true })

vim.cmd([[colorscheme tokyonight-night]])
