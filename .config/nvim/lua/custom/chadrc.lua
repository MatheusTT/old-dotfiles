local M = {}

--- OPTIONS ---
M.options = {
  tabstop = 2,
  shiftwidth = 2,
  transparency = true,
}

--- UI ---

M.ui = {
   theme = "tokyonight",
   theme_toggle = { "tokyonight", "chadracula" },
}

--- PLUGINS ---

M.plugins = {
  user = {
    ["goolord/alpha-nvim"] = {
      disable = false
    },
    ["nvim-telescope/telescope.nvim"] = {
      disable = false
    },
  },
  override = {
    ["nvim-treesitter/nvim-treesitter"] = {
      ensure_installed = {
        "bash",
        "python",
      }
    },
    ["lukas-reineke/indent-blankline.nvim"] = {
      user_default_options = {
       RRGGBBAA = true, -- #RRGGBBAA hex codes
       rgb_fn = true, -- CSS rgb() and rgba() functions
      }
    }
  }
}



return M
