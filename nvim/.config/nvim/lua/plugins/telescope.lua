local builtin = require('telescope.builtin')

require('telescope').setup {
    defaults = {
        layout_strategy = "horizontal",
        file_ignore_patterns = { ".git/" },
        layout_config = {
            preview_width = 0.4,
            horizontal = {
                preview_cutoff = 0,
                size = {
                    width = "95%",
                    height = "95%",
                },
            },
        },
        file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
        pickers = {
            find_files = {
                theme = "dropdown",
            }
        },
        mappings = {
            i = {
                ['<C-u>'] = false,
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
                ["<esc>"] = require('telescope.actions').close,
            },
        },
    },
}


vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({ hidden = true })
end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>rg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>bl', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>bd', builtin.git_bcommits, { desc = 'Telescope git commits' })

require('telescope').load_extension("ui-select")
