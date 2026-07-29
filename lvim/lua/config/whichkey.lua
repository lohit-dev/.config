require("which-key").setup {}

require("which-key").add {
  { "<leader>f", group = "Find" },
  { "<leader>c", group = "Code" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Git hunks" },
  { "<leader>x", group = "Diagnostics" },
  { "<leader>l", group = "LeetCode" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Window" },
}
