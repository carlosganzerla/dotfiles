function ShowSlimvArglist()
	local col = vim.fn.col(".")
	local line = vim.fn.line(".")
	vim.cmd("call SlimvArglist(" .. line .. ", " .. (col + 1) .. ")")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lisp",
	callback = function()
		vim.o.complete = ".,w,b,kspell"
		vim.bo.omnifunc = "SlimvOmniComplete"
		vim.keymap.set("n", "gh", ":call SlimvDescribeSymbol()<CR>", { silent = true, buffer = true })
		vim.keymap.set("n", "gd", ":call SlimvFindDefinitions()<CR>", { silent = true, buffer = true })
		vim.keymap.set("n", "gi", ":lua ShowSlimvArglist()<CR>", { silent = true, buffer = true })
		vim.keymap.set("n", "<C-C>", ":call SlimvInterrupt()<CR>", { silent = true, buffer = true })
	end,
})

vim.g.slimv_swank_cmd =
	"! kitty --single-instance sbcl --load ~/.config/autoload/plugged/slimv/slime/start-swank.lisp &"
-- " SWANK server startup command
vim.g.slimv_swank_cmd =
	"! kitty --single-instance sbcl --load ~/.config/autoload/plugged/slimv/slime/start-swank.lisp &"
-- Set vertical split for SLIMV REPL
vim.g.slimv_repl_split = 4
-- Disable Syntax Highlight on REPL
vim.g.slimv_repl_syntax = 0
vim.g.lisp_rainbow = 1
vim.g.slimv_repl_split_size = 60
-- " SWANK with Scheme

vim.g.scheme_builtin_swank = 1
vim.g.slimv_swank_scheme =
	"! kitty --single-instance mit-scheme --load ~/.config/autoload/plugged/slimv/slime/contrib/swank-mit-scheme.scm &"
