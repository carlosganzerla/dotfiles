function KillOtherBuffers()
    vim.cmd("%bd|e#")
end

function ExecuteMacroOverVisualRange()
    -- Get the macro register from the user input
    local macro_register = vim.fn.nr2char(vim.fn.getchar())
    -- Echo the macro register (for debugging purposes)
    print('@' .. macro_register)
    -- Execute the macro over the visual selection
    vim.cmd(":'<,'>normal @" .. macro_register)
end

vim.api.nvim_create_user_command("TrimTrailing", "%s/\\s\\+$//e", {})

vim.api.nvim_create_user_command("KillOtherBufers", "call KillOtherBuffers()", {})
