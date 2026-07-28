require("catppuccin").setup {
  flavour = "mocha",
  integrations = {
    native_lsp = { enabled = true },
    treesitter = true,
  },
}

require("dracula").setup {
  transparent_bg = true,
}

vim.cmd.colorscheme "dracula"

-- <leader>ct to flip between the two whenever you want a change of scenery
vim.keymap.set("n", "<leader>ct", function()
  vim.cmd.colorscheme(vim.g.colors_name == "dracula" and "catppuccin" or "dracula")
end, { desc = "Toggle Catppuccin / Dracula" })
