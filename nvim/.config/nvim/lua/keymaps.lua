-- Show buffers on F5
vim.keymap.set("n", "<F5>", ":buffers<CR>:buffer<Space>")

-- Reload .vimrc with F6
vim.keymap.set("n", "<F6>", ":source ~/.config/nvim/init.vim<CR>")

-- When in normal mode, stop highlighting search results
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Open/close Fern drawer
-- vim.keymap.set("n", "<C-b>", ":Fern . -drawer -toggle<CR>", { silent = true })
-- vim.command("command! Find execute ':Fern . -drawer -reveal=%'")

-- Kill all buffers except the current one
function KillOtherBuffers()
    vim.cmd("%bd|e#")
end

-- vim.command("command! -nargs=0 KillOtherBuffers call KillOtherBuffers()")

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
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.vim<CR>", { silent = true })

-- Clear trailing whitespace
-- vim.command("command! TrimTrailing execute ':%s/\s\+$//e'")

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })

-- Redraw on Ctrl F5
vim.keymap.set("n", "<C-F5>", ":redraw!<CR>", { silent = true })
