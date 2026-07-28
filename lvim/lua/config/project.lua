require("project_nvim").setup {
  detection_methods = { "lsp", "pattern", "git" },
  patterns = {
    ".git",
    "Makefile",
    "package.json",
    "pyproject.toml",
    "stylua.toml",
  },
  exclude_dirs = { "node_modules", ".git" },
  show_hidden = true,
  silent_chdir = true,
  scope_chdir = "global",
}
