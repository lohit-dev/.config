local npairs = require "nvim-autopairs"

npairs.setup {
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "vim" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[\%|'"%)%>%]%)%,]], "%s+", ""),
    end_key = "l",
    keys = "qwertyuiopzxcvbnm",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}
