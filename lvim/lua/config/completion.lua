local cmp = require "cmp"

cmp.setup {
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged },
  },
  preselect = cmp.PreselectMode.Item,
  window = {
    completion = {
      border = "none",
      winblend = 0,
      scrollbar = false,
      side_padding = 0,
      winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = "none",
      winblend = 0,
      winhighlight = "Normal:Normal,FloatBorder:Normal,Search:None",
    },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "snippets" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
}
