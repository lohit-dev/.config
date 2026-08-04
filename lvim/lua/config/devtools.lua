require("Comment").setup {}

require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "-" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "+" },
  },
  on_attach = function(bufnr)
    local gs = require "gitsigns"
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "]h", gs.next_hunk, "Next hunk")
    map("n", "[h", gs.prev_hunk, "Previous hunk")
    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gb", function()
      gs.blame_line { full = true }
    end, "Blame line")
  end,
}

require("trouble").setup {}
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics list" })
vim.keymap.set("n", "<leader>dq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })

vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })
