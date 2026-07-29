return {
  name = "Run current file",
  builder = function()
    return {
      cmd = { "bun", vim.fn.expand "%:p" },
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
}
