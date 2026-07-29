return {
  name = "Test current file",
  builder = function()
    return {
      cmd = { "bun", "test", vim.fn.expand "%:p" },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
}
