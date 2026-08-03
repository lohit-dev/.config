local M = {}

local state_dir = vim.fn.stdpath "state"
local state_file = state_dir .. "/lvim-colorscheme"

require("catppuccin").setup {
  flavour = "mocha",

  transparent_background = true,

  integrations = {
    native_lsp = { enabled = true },
    treesitter = true,
  },
}

require("dracula").setup {
  transparent_bg = true,
}

local function apply_completion_highlights()
  -- Keep the completion menu flat and unobtrusive instead of a dark card.
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = normal.fg, bg = normal.bg })
  vim.api.nvim_set_hl(0, "PmenuSel", {
    fg = normal.fg,
    bg = normal.bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "PmenuSbar", { fg = normal.fg, bg = normal.bg })
  vim.api.nvim_set_hl(0, "PmenuThumb", { fg = normal.fg, bg = normal.bg })
end

local function read_saved_theme()
  if vim.fn.filereadable(state_file) == 1 then
    local saved = vim.fn.readfile(state_file)[1]
    if saved and saved ~= "" then
      return saved
    end
  end
  return "dracula"
end

function M.apply(theme, persist)
  if type(theme) ~= "string" or theme == "" then
    return false
  end

  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify("Unable to load colorscheme '" .. theme .. "': " .. err, vim.log.levels.WARN)
    return false
  end

  apply_completion_highlights()
  if persist then
    vim.fn.mkdir(state_dir, "p")
    vim.fn.writefile({ theme }, state_file)
  end
  return true
end

local initial_theme = read_saved_theme()
if not M.apply(initial_theme, false) and initial_theme ~= "dracula" then
  M.apply("dracula", false)
end

-- <leader>ct to flip between the two whenever you want a change of scenery
vim.keymap.set("n", "<leader>ct", function()
  M.apply(vim.g.colors_name == "dracula" and "catppuccin" or "dracula", true)
end, { desc = "Toggle Catppuccin / Dracula" })

return M
