-- gopher.nvim is not an LSP, gopls still does that. This adds Go-specific
-- tooling on top: :GoTagAdd/:GoTagRm (struct tags), :GoIfErr, :GoImpl,
-- :GoTestAdd/:GoTestsAll/:GoTestsExp (gotests), :GoGet/:GoMod/:GoWork, :GoJson.
--
-- One-time setup after first install: run :GoInstallDeps to fetch its
-- underlying binaries (gomodifytags, impl, gotests, iferr, json2go).
require("gopher").setup {}
