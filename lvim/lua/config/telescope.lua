-- Needs `rg` (ripgrep) on PATH for live_grep: brew install ripgrep
-- `fd` is optional but makes find_files faster: brew install fd

local telescope = require "telescope"
local builtin = require "telescope.builtin"

telescope.setup {}

telescope.load_extension "projects"

-- Only run git-backed pickers when actually inside a git repo
local function git_safe(fn_name)
  return function()
    local result = vim.fn.systemlist("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse --git-dir 2>/dev/null")

    if vim.v.shell_error ~= 0 or #result == 0 then
      vim.notify("Not a git directory", vim.log.levels.WARN, { title = "Telescope" })
      return
    end

    builtin[fn_name]()
  end
end

local map = vim.keymap.set

local function theme_picker()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local colorscheme = require "config.colorscheme"

  builtin.colorscheme {
    enable_preview = true,
    attach_mappings = function(_, map_picker)
      map_picker("i", "<CR>", function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          colorscheme.apply(selection.value, true)
        end
      end)
      map_picker("n", "<CR>", function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          colorscheme.apply(selection.value, true)
        end
      end)
      return true
    end,
  }
end

map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fa", function()
  builtin.find_files { hidden = true, no_ignore = true }
end, { desc = "Find all files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fw", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in buffer" })
map("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Projects" })
map("n", "<leader>ft", theme_picker, { desc = "Pick colorscheme" })

map("n", "<leader>cm", git_safe "git_commits", { desc = "Git commits" })
map("n", "<leader>gt", git_safe "git_status", { desc = "Git status" })
