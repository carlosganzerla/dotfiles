local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', 'n', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'u', api.fs.rename, opts('Rename'))
end

-- pass to setup along with your other options
require("nvim-tree").setup({
    on_attach = my_on_attach,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        group_empty = true,
    },
})

vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
