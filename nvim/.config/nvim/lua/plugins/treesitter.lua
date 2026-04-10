-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
local ts = require("nvim-treesitter")
-- Add languages to be installed here that you want installed for treesitter
local languages = {
	"lua",
	"python",
	"typescript",
	"regex",
	"bash",
	"markdown",
	"markdown_inline",
	"sql",
	"html",
	"css",
	"javascript",
	"ledger",
	"yaml",
	"json",
	"toml",
	"tsx",
	"c",
	"go",
	"gomod",
	"terraform",
}
ts.install(languages)
ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	highlight = { enable = true },
	indent = { enable = true },
})
for _, lang in ipairs(languages) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { lang },
        callback = function()
            vim.treesitter.start()
        end,
    })
end
