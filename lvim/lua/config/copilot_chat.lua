-- Lazy-loaded (load = false in init.lua's vim.pack.add) -- only needed when
-- actually chatting with the AI, not every session. Copilot's own inline
-- ghost-text suggestions (config.copilot) stay eager since those need to be
-- live continuously as you type.
local loaded = false
local function ensure_loaded()
  if loaded then
    return
  end
  vim.cmd.packadd "CopilotChat.nvim"
  require("CopilotChat").setup {}
  loaded = true
end

local function chat_cmd(cmd)
  return function()
    ensure_loaded()
    vim.cmd(cmd)
  end
end

vim.keymap.set("n", "<leader>aa", chat_cmd "CopilotChatToggle", { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>ae", chat_cmd "CopilotChatExplain", { desc = "Explain with Copilot Chat" })
vim.keymap.set("x", "<leader>ae", chat_cmd "CopilotChatExplain", { desc = "Explain selection with Copilot Chat" })
