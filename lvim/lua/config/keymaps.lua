-- General ---------------------------------------------------------------
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

vim.keymap.set("n", ";", ":", { desc = "Enter command mode" }) -- note: shadows ; as f/t repeat
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "U", "~h", { desc = "Uppercase first letter of word" })
vim.keymap.set("n", "<leader>u", "g~w", { desc = "Toggle case of word" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "'", "<cmd>Telescope projects<cr>", { desc = "Project switcher" })

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

    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>ce", function()
      vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
    end, "Next error")

    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
      map("i", "<C-space>", vim.lsp.completion.get, "Trigger completion")
    end

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      map("n", "<leader>th", function()
        local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
      end, "Toggle inlay hints")
    end
  end,
})
