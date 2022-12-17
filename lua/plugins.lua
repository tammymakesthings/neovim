local M = {}

function M.setup()
	local packer_bootstrap = false
	local conf = {
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				"git", "clone", "--depth", "1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
	end

	local function plugins(use)
    use { "lewis6991/impatient.nvim" }
		use { "wbthomason/packer.nvim" }

		-- Color Theme
		use { 
			'Mofiqul/dracula.nvim',
			config = function()
				vim.cmd "colorscheme dracula"
			end,
		}

		-- Startup
		use {
			"goolord/alpha-nvim",
			config = function()
				require("config.alpha").setup()
			end,
		}

		-- Git
		use {
			"TimUntersberger/neogit",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("config.neogit")
			end,
		}

    -- Development
    use { "tpope/vim-fugitive", event = "BufRead" }
    use { "tpope/vim-surround", event = "BufRead" }
    use { "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } }
    use {
      "numToStr/Comment.nvim",
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("config.comment").setup()
      end,
    }
    use { "tpope/vim-rhubarb" }
    use { "tpope/vim-unimpaired" }
    use { "tpope/vim-vinegar" }
    use { "tpope/vim-sleuth" }
    use { "wellle/targets.vim", event = "BufWinEnter" }
    use { "easymotion/vim-easymotion", event = "BufRead" }
    use {
      "lewis6991/gitsigns.nvim",
      -- event = "BufReadPre",
      -- wants = "plenary.nvim",
      -- requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup()
      end,
    }

    use { "rhysd/git-messenger.vim" }
     use {
      "sindrets/diffview.nvim",
      cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
      },
    }
    use { "unblevable/quick-scope", event = "VimEnter" }
    use { "voldikss/vim-floaterm", event = "VimEnter" }
    use {
      "folke/which-key.nvim",
      config = function()
        require("config.whichkey").setup()
      end,
    }
    use {
      "kyazdani42/nvim-tree.lua",
      event = "BufWinEnter",
      config = function()
        require("nvim-tree").setup {}
      end,
    }
    use { "windwp/nvim-spectre", event = "VimEnter" }
    use {
      "ruifm/gitlinker.nvim",
      event = "VimEnter",
      config = function()
        require("gitlinker").setup()
      end,
    }
    use { "google/vim-searchindex" }
    use {
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session" },
      config = function()
        require("config.auto-session").setup()
        require("session-lens").setup {}
      end,
    }
-- Testing
    use {
      "rcarriga/vim-ultest",
      config = "require('config.test').setup()",
      run = ":UpdateRemotePlugins",
      requires = { "vim-test/vim-test" },
    }

    -- Telescope
    use { "nvim-lua/plenary.nvim" }
    use { "nvim-lua/popup.nvim" }
    use {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      as = "telescope",
      requires = {
        "nvim-telescope/telescope-project.nvim",
        "nvim-telescope/telescope-symbols.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-github.nvim",
        "fhill2/telescope-ultisnips.nvim",
        "cljoly/telescope-repo.nvim",
        "jvgrootveld/telescope-zoxide",
        "dhruvmanila/telescope-bookmarks.nvim",
        -- 'nvim-telescope/telescope-hop.nvim'
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        {
          "nvim-telescope/telescope-arecibo.nvim",
          rocks = { "openssl", "lua-http-parser" },
        },
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = { "tami5/sql.nvim" },
        },
        {
          "nvim-telescope/telescope-vimspector.nvim",
          event = "BufWinEnter",
        },
        { "nvim-telescope/telescope-dap.nvim" },
      },
      config = function()
        require("config.telescope").setup()
      end,
    }

    -- Project settings
    use {
      "ahmedkhalf/project.nvim",
      event = "VimEnter",
      config = function()
        require("config.project").setup()
      end,
    }
    -- use {'airblade/vim-rooter'}

    -- LSP config
    use { "williamboman/nvim-lsp-installer" }
    use { "jose-elias-alvarez/null-ls.nvim" }
    -- use {
    --   "tamago324/nlsp-settings.nvim",
    --   -- event = "BufReadPre",
    --   config = function()
    --     require("config.nlsp-settings").setup()
    --   end,
    -- }
    use {
      "neovim/nvim-lspconfig",
      as = "nvim-lspconfig",
      after = "nvim-treesitter",
      opt = true,
      config = function()
        require("config.lsp").setup()
        require("config.dap").setup()
      end,
    }

    -- Completion - use either one of this
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "quangnguyen30192/cmp-nvim-ultisnips",
        "hrsh7th/cmp-nvim-lua",
        "octaltree/cmp-look",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-calc",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-emoji",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
      },
      config = function()
        require("config.cmp").setup()
      end,
    }
    use {
      "tami5/lspsaga.nvim",
      config = function()
        require("config.lspsaga").setup()
      end,
    }
    use {
      "onsails/lspkind-nvim",
      config = function()
        require("lspkind").init()
      end,
    }
    use { "sbdchd/neoformat", event = "BufWinEnter" }
    use { "szw/vim-maximizer", event = "BufWinEnter" }
    use { "kshenoy/vim-signature", event = "BufWinEnter" }
    use { "kevinhwang91/nvim-bqf", event = "BufWinEnter" }
    use { "andymass/vim-matchup", event = "CursorMoved" }
    use { "ray-x/lsp_signature.nvim" }
    use {
      "folke/trouble.nvim",
      event = "VimEnter",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup { auto_open = false }
      end,
    }
    use {
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      config = function()
        require("todo-comments").setup {}
      end,
    }
    use {
      "nacro90/numb.nvim",
      event = "VimEnter",
      config = function()
        require("numb").setup()
      end,
    }
    use { "junegunn/vim-easy-align", event = "BufReadPost" }
    use { "antoinemadec/FixCursorHold.nvim", event = "BufReadPost" }

    -- Snippets
    use {
      "SirVer/ultisnips",
      requires = { { "honza/vim-snippets", rtp = "." }, "mlaursen/vim-react-snippets" },
      config = function()
        vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
        vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
        vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
        vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
        vim.g.UltiSnipsRemoveSelectModeMappings = 0
      end,
    }
    -- Lua development
    use { "folke/lua-dev.nvim", event = "VimEnter" }
    use {
      "simrat39/symbols-outline.nvim",
      event = "VimEnter",
      config = function()
        require("config.symbols-outline").setup()
      end,
      disable = true, -- TODO: fix
    }

    -- Better syntax
    use {
      "nvim-treesitter/nvim-treesitter",
      as = "nvim-treesitter",
      event = "BufRead",
      opt = true,
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        { "jose-elias-alvarez/nvim-lsp-ts-utils" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "p00f/nvim-ts-rainbow" },
        {
          "nvim-treesitter/playground",
          cmd = "TSHighlightCapturesUnderCursor",
        },
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
        },
        { "RRethy/nvim-treesitter-textsubjects" },
        {
          "windwp/nvim-autopairs",
          run = "make",
          config = function()
            require("nvim-autopairs").setup {}
          end,
        },
        {
          "windwp/nvim-ts-autotag",
          config = function()
            require("nvim-ts-autotag").setup { enable = true }
          end,
        },
        {
          "romgrk/nvim-treesitter-context",
          config = function()
            require("treesitter-context.config").setup { enable = true }
          end,
        },
        {
          "mfussenegger/nvim-ts-hint-textobject",
          config = function()
            vim.cmd [[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]]
            vim.cmd [[vnoremap <silent> m :lua require('tsht').nodes()<CR>]]
          end,
        },
      },
    }
    
    --   "hrsh7th/vim-vsnip",
    --   event = "VimEnter",
    --   requires = {
    --     "rafamadriz/friendly-snippets",
    --     "cstrap/python-snippets",
    --     "ylcnfrht/vscode-python-snippet-pack",
    --     "xabikos/vscode-javascript",
    --     "golang/vscode-go",
    --     "rust-lang/vscode-rust",
    --   },
    -- }
    -- use { "hrsh7th/cmp-vsnip" }
    --
    -- use {
    --   "weilbith/nvim-code-action-menu",
    --   cmd = "CodeActionMenu",
    -- }
    -- use {"haringsrob/nvim_context_vt"}

    -- LIST of plugins
    -- https://gist.github.com/mengwangk/dc703fb091e25dd75b7ef7c7be3bd4c9

		if packer_bootstrap then
			print "Restart required after packer bootstrap!"
			require("packer").sync()
		end
	end

  pcall(require, "impatient")
  pcall(require, "packer_compiled")
  require("packer").init(conf)
  require("packer").startup(plugins)
end

return M

