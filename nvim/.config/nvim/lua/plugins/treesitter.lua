-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
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
        "yaml",
        "json",
        "toml",
        "tsx",
        "c",
        "go",
        "gomod",
    },

    highlight = { enable = true },
    indent = { enable = true },
})
