vim.api.nvim_create_user_command("TrimTrailing", "%s/\\s\\+$//e", {})

vim.api.nvim_create_user_command("KillOtherBufers", "%bd|e#", {})
