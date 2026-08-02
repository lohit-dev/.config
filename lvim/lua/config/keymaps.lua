-- General ---------------------------------------------------------------
local settings = require "config.settings"

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Navigate right" })
vim.keymap.set("n", "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Navigate previous" })

vim.keymap.set("n", ";", ":", { desc = "Enter command mode" }) -- note: shadows ; as f/t repeat
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "U", "~h", { desc = "Uppercase first letter of word" })
vim.keymap.set("n", "<leader>u", "g~w", { desc = "Toggle case of word" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>tn", function()
  local enabled = not settings.get "line_numbers"
  settings.set("line_numbers", enabled)
  vim.opt.number = enabled
  vim.opt.relativenumber = enabled
end, { desc = "Toggle line numbers" })
vim.keymap.set("n", "'", "<cmd>Telescope projects<cr>", { desc = "Project switcher" })
vim.keymap.set("n", "<leader>e", function()
  require("oil").open()
end, { desc = "Open file tree" })

local function open_netrw_file(vertical)
  local file = vim.fn.expand "<cfile>"
  if file == "" then
    return
  end
  vim.cmd((vertical and "vsplit " or "split ") .. vim.fn.fnameescape(file))
end

local function configure_file_tree(args)
  local is_netrw = vim.bo[args.buf].filetype == "netrw"
  local is_directory = vim.fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) == 1
  if not is_netrw and not is_directory then
    return
  end

  vim.keymap.set("n", "<C-v>", function()
    open_netrw_file(true)
  end, { buffer = args.buf, desc = "Open file in vertical split" })
  vim.keymap.set("n", "<C-h>", function()
    open_netrw_file(false)
  end, { buffer = args.buf, desc = "Open file in horizontal split" })
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  pattern = "*",
  callback = function(args)
    configure_file_tree(args)
  end,
})

-- Buffers -----------------------------------------------------------------
local function close_buffers(direction)
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local keep = direction == "left" and buf >= current or buf <= current
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and not keep then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end

vim.keymap.set("n", "<leader>bl", function()
  close_buffers "left"
end, { desc = "Close buffers to the left" })
vim.keymap.set("n", "<leader>br", function()
  close_buffers "right"
end, { desc = "Close buffers to the right" })

-- LSP ---------------------------------------------------------------------
local lsp_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Goto definition")
    map("n", "gr", vim.lsp.buf.references, "Goto references")
    map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>sh", vim.lsp.buf.signature_help, "Signature help")

    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cq", function()
      vim.lsp.buf.code_action { apply = true }
    end, "Quick-fix (apply first action)")
    map("n", "<leader>cf", function()
      vim.lsp.buf.format { async = true }
    end, "Format buffer")

    map("n", "<leader>dn", function()
      vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
    end, "Next error")

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(settings.get "inlay_hints", { bufnr = buf })
      map("n", "<leader>th", function()
        local enabled = not settings.get "inlay_hints"
        settings.set("inlay_hints", enabled)
        for _, target_buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(target_buf) and #vim.lsp.get_clients { bufnr = target_buf } > 0 then
            vim.lsp.inlay_hint.enable(enabled, { bufnr = target_buf })
          end
        end
      end, "Toggle inlay hints")
    end
  end,
})
