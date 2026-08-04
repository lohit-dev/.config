local M = {}

-- Shared with the zsh side (theme-set / theme.zsh in the .zsh dotfiles repo):
-- one file, one source of truth for "current theme" across shell and editor.
-- Neovim only reads this at startup -- picking a theme here or via `theme-set`
-- in the shell applies to the *next* launch of the other one, not live.
local state_file = (vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")) .. "/current-theme"

-- zsh syntax-theme slug <-> Neovim :colorscheme name. Catppuccin registers a
-- separate colorscheme per flavour (catppuccin-mocha, catppuccin-macchiato,
-- ...) so no flavour-switching-at-runtime gymnastics needed here.
local SLUG_TO_COLORSCHEME = {
  ["catppuccin-mocha"] = "catppuccin-mocha",
  ["catppuccin-macchiato"] = "catppuccin-macchiato",
  dracula = "dracula",
  gruvbox = "gruvbox",
  tokyo_night = "tokyonight",
  cyberpunk = "cyberpunk",
  nord = "nord",
}
local COLORSCHEME_TO_SLUG = {}
for slug, colorscheme in pairs(SLUG_TO_COLORSCHEME) do
  COLORSCHEME_TO_SLUG[colorscheme] = slug
end

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

require("kanagawa").setup {
  transparent = true,
}

require("nightfox").setup {
  options = {
    transparent = true,
  },
}

require("gruvbox").setup {
  transparent_mode = true,
}

require("tokyonight").setup {
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
}

require("cyberpunk").setup {
  transparent = true,
}

require("nord").setup {
  transparent = true,
}

-- gruvbox-material and everforest (sainnhe) are vim-script plugins, configured
-- via g: variables rather than a Lua setup() call. These must be set before
-- the `:colorscheme` command runs for that scheme -- setting them once here
-- at startup covers every future switch too, since they persist for the
-- whole session regardless of which scheme is currently active.
vim.g.gruvbox_material_transparent_background = 1
vim.g.everforest_transparent_background = 1

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
      -- Known zsh slug (e.g. "tokyo_night") -> mapped colorscheme name.
      -- Otherwise assume it's already a raw :colorscheme name (e.g. picked
      -- via <leader>ft from a scheme with no zsh-side equivalent, like
      -- kanagawa or nightfox) and try it as-is.
      return SLUG_TO_COLORSCHEME[saved] or saved
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
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    -- Persist the zsh slug when this colorscheme has one, so the shell side
    -- can match it on next `source theme.zsh`. Otherwise persist the raw
    -- colorscheme name -- zsh's theme.zsh falls back to catppuccin-mocha for
    -- anything it doesn't recognize rather than erroring.
    vim.fn.writefile({ COLORSCHEME_TO_SLUG[theme] or theme }, state_file)
  end
  return true
end

local initial_theme = read_saved_theme()
local applied = M.apply(initial_theme, false)
if not applied and initial_theme ~= "dracula" then
  applied = M.apply("dracula", false)
end

if applied then
  local source = vim.fn.filereadable(state_file) == 1 and state_file or "default (no state file found)"
  -- vim.notify("colorscheme: " .. vim.g.colors_name .. " (from " .. source .. ")", vim.log.levels.INFO)
end

return M
