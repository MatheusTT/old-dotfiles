return {
   ["goolord/alpha-nvim"] = {
      config = function()
         require "plugins.configs.alpha"
      end,
   },
   ["karb94/neoscroll.nvim"] {
     config = function()
        require("neoscroll").setup()
     end,

     -- lazy loading
     setup = function()
       require("core.utils").packer_lazy_load "neoscroll.nvim"
     end,
   },
}
