return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        notify = true,
        mini = { enabled = true },
        lsp_trouble = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
