require("overseer").setup {
  task_list = {
    direction = "bottom",
    min_height = 20,
    max_height = 20,
    default_detail = 1,
  },
}

vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })

-- run_template (what :OverseerRun uses under the hood) is deprecated in favor
-- of run_task as of overseer 2026; same behavior, opts={} still triggers the
-- template picker. After you pick and it starts, force the "open vsplit"
-- action so you always see live output instead of just a pass/fail notify.
vim.keymap.set("n", "<leader>or", function()
  require("overseer").run_task({}, function(task, err)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    elseif task then
      require("overseer").run_action(task, "open vsplit")
    end
  end)
end, { desc = "Run task (vsplit output)" })

vim.keymap.set("n", "<leader>oc", ":OverseerShell ", { desc = "Run custom task command" })
