vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Show buffers on F5
vim.keymap.set("n", "<F5>", ":buffers<CR>:buffer<Space>")

-- Reload .vimrc with F6
vim.keymap.set("n", "<F6>", ":luafile ~/.config/nvim/init.lua<CR>")

-- When in normal mode, stop highlighting search results
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "<leader>qa", ":KillOtherBuffers<CR>", { silent = true })

-- Kill buffer without messing windows
vim.keymap.set("n", "<leader>c", ":bp|bd #<CR>", { silent = true })

-- Set 85 length on vertical split
vim.keymap.set("n", "<leader>w", ":vertical resize 85<CR>", { silent = true })

-- Navigation on Buffers
vim.keymap.set("n", "<C-Right>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":bd<CR>", { silent = true })

-- Swap windows with Ctrl + direction
vim.keymap.set("n", "<C-l>", "<C-W>l", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-W>k", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-W>j", { silent = true })
vim.keymap.set("n", "<C-h>", "<C-W>h", { silent = true })

-- Quickfix list navigation
vim.keymap.set("n", "]c", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[c", ":cprev<CR>", { silent = true })

-- Location list navigation
vim.keymap.set("n", "]l", ":lnext<CR>", { silent = true })
vim.keymap.set("n", "[l", ":lprev<CR>", { silent = true })

-- Load .vimrc onto another buffer
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { silent = true })

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })

-- Redraw on Ctrl F5
vim.keymap.set("n", "<C-F5>", ":redraw!<CR>", { silent = true })

-- Disable quit
vim.keymap.set("n", "<C-w><C-q>", "<nop>")

-- Apply macros on visual mode. Source:
-- https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
function ExecuteMacroOverVisualRange()
    -- Get the macro register from the user input
    local macro_register = vim.fn.nr2char(vim.fn.getchar())
    -- Echo the macro register (for debugging purposes)
    print("@" .. macro_register)
    -- Execute the macro over the visual selection
    vim.cmd(":'<,'>normal @" .. macro_register)
end

vim.keymap.set("x", "@", ":<C-u>lua ExecuteMacroOverVisualRange()<CR>", { noremap = true, silent = true })

-- Disable arrows
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

-- Tab navigation
vim.keymap.set("n", "<leader><Right>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<leader><Left>", ":tabprev<CR>", { silent = true })

-- Toggle tree
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { silent = true, noremap = true, nowait = true })

-- Copy file name into + register
vim.keymap.set('n', 'cp', ':let @+ = expand("%")<cr>', { silent= true, noremap = true  })

-- Copilot settings
vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-l>', '<Plug>(copilot-suggest)')
vim.keymap.set('i', '<C-Space>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

vim.keymap.set("n", "<leader><leader>s", "<cmd>luafile ~/.config/nvim/lua/plugins/snippets.lua<CR>")
