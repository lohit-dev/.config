require("mason").setup() -- also prepends mason's install dir to $PATH

require("mason-lspconfig").setup {
  -- rust_analyzer still gets its binary installed here, but rustaceanvim
  -- starts the client itself, so it's excluded from automatic_enable below.
  ensure_installed = {
    "lua_ls",
    "dockerls",
    "yamlls",
    "jsonls",
    "taplo",
    "gopls",
    "rust_analyzer",
  },
  automatic_enable = {
    exclude = { "rust_analyzer" },
  },
}

-- Non-LSP tools: prettier backs the JS/TS formatter in config.format.
-- Since mason.setup() puts its bin dir on $PATH, once this installs,
-- vim.fn.executable("prettier") in format.lua picks it up automatically.
local mason_registry = require "mason-registry"
mason_registry.refresh(function()
  for _, tool in ipairs { "prettier" } do
    local ok, pkg = pcall(mason_registry.get_package, tool)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end)
