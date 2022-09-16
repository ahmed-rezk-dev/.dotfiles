local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins/index.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost index.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use "wbthomason/packer.nvim"

    -- Helpers
    use "nvim-lua/plenary.nvim" -- require for LSP
    use { "ahmedkhalf/project.nvim", config = function() require("plugins._project").setup() end } -- Automagically cd to project directory using nvim lsp
    use 'lewis6991/impatient.nvim' -- Speed up loading Lua modules in Neovim to improve startup time.
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use { "rmagatti/auto-session", config = function() require("plugins._sessions").setup() end } -- sessions manager
    use { "rmagatti/session-lens",  requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" }, config = function() require("session-lens").setup() end } -- telescope sessions manager 
    use { "akinsho/toggleterm.nvim", config = function () require("plugins._toggleterm").setup() end } -- To persist and toggle multiple terminals 
    use { "christianchiarulli/nvim-gps", branch = "text_hl", config = function() require("plugins._gps").setup() end } -- nvim-gps is status line component that shows context of the current cursor position in file
    use {'jbyuki/instant.nvim', config = function() require("plugins._instant").setup() end } -- instant.nvim is a collaborative editing plugin for Neovim written in Lua with no dependencies.


    -- LSP
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "tamago324/nlsp-settings.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", config = function() require("plugins._trouble").setup() end }

    -- Treesitter
    -- parser generator language syntax
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = function() require("plugins._treesitter").setup() end }
    use { "p00f/nvim-ts-rainbow" } -- NOTE: To be fixed
    use { "lukas-reineke/indent-blankline.nvim", config = function() require("plugins._indentline").setup() end }
    use { "numToStr/Comment.nvim", config = function() require("plugins._comment").setup() end }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use { "windwp/nvim-autopairs", config = function() require("plugins._autopairs").setup() end } -- To supports multiple characters auto close & open tags
    use { "norcalli/nvim-colorizer.lua", config = function() require("plugins._colorizer").setup() end } -- A high-performance color highlighter
    use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim", config = function() require('plugins._todo-higlight').setup() end } -- highlight your todo comments in different styles

    -- cmp plugins
    use { "hrsh7th/nvim-cmp", config = function() require("plugins._cmp").setup() end }
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-nvim-lsp"
    use { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" }
    use { "onsails/lspkind.nvim" }
    use { "hrsh7th/cmp-nvim-lsp-signature-help" }

    -- snippets
    use { "L3MON4D3/LuaSnip" }
    use "rafamadriz/friendly-snippets"

    -- Debug Adapter Protocol
    use {"mfussenegger/nvim-dap", config = function () require("lsp.dap.init").setup() end }
    use "rcarriga/nvim-dap-ui"
    use { "nvim-telescope/telescope-dap.nvim" }
    use { "Pocco81/DAPInstall.nvim", commit = "24923c3819a450a772bb8f675926d530e829665f" }
    use "theHamsta/nvim-dap-virtual-text"

    -- Lua interface plugins
    use { "kyazdani42/nvim-tree.lua", config = function() require("plugins._nvim-tree").setup() end } -- Files exploer
    use { "folke/which-key.nvim", config = function() require("plugins._whichkey").setup() end } -- shortcuts manager
    use { "akinsho/bufferline.nvim", config = function() require("plugins._bufferline").setup() end } -- Tabs/Buffers mananger
    use { "nvim-lualine/lualine.nvim", config = function() require("plugins._lualine").setup() end } -- Stauts button bar
    use { "nvim-telescope/telescope.nvim", config = function () require("plugins._telescope").setup() end } -- finder/ Searchings
    use { "goolord/alpha-nvim", config =function () require("plugins._alpha").setup() end } -- Dashboard window
    use { "anuvyklack/hydra.nvim", config = function() require("plugins._hydra").setup() end } -- This is the Neovim implementation of the famous Emacs Hydra package.
    use "kyazdani42/nvim-web-devicons" -- This plugin provides the same icons as well as colors for each icon
    use { "tami5/lspsaga.nvim", config = function() require("plugins._lspsaga").setup() end } -- A light-weight lsp plugin based on neovim's built-in lsp with a highly performant UI.
    use { "chentoast/marks.nvim", config = function() require("plugins._marker").setup() end } -- A better user experience for interacting with and manipulating Vim marks.
    use { "phaazon/hop.nvim", as = "hop", config = function() require("plugins._hop").setup() end } -- Hop is an EasyMotion-like plugin allowing you to jump anywhere in a document.
    -- Themes/Colorsches
    use { "olimorris/onedarkpro.nvim", config = function() require("themes.onedarkPro").setup() end }

    -- Git
    use { "lewis6991/gitsigns.nvim", config = function() require("plugins._git").gitsignsSetup() end }
    use { "sindrets/diffview.nvim", config = function() require("plugins._git").diffviewSetup() end }
    use { "TimUntersberger/neogit", requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" }, config = function() require("plugins._git").neogitSetup() end }
    use {'pwntester/octo.nvim', requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons', }, config = function () require"plugins._octo".setup() end } -- Edit and review GitHub issues and pull requests from the comfort of your favorite editor.

    -- Note taking
    use { "nvim-neorg/neorg", ft = "norg", after = "nvim-treesitter", config = function() require("plugins._norg").setup() end }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
