require("which-key").setup {}

require("which-key").add {
  { "<leader>f", group = "Find" },
  { "<leader>c", group = "Code" },
  { "<leader>g", group = "Git" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Window" },
}
