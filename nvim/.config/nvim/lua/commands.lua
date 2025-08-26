vim.api.nvim_create_user_command("TrimTrailing", "%s/\\s\\+$//e", {})

vim.api.nvim_create_user_command("KillOtherBufers", "%bd|e#", {})

vim.api.nvim_create_user_command("Find", ":NvimTreeFindFile", {})

function psql_query(database, range)
    local text = {}
    if range == 0 then
        text = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    else
        local _, ls, cs = unpack(vim.fn.getpos("'<"))
        local _, le, ce = unpack(vim.fn.getpos("'>"))
        text = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    end

    local scratch_bufno = vim.api.nvim_create_buf(false, true)
    if scratch_bufno == 0 then
        vim.notify("Could not create buffer", vim.log.levels.ERROR)
        return
    end
    vim.api.nvim_buf_set_text(scratch_bufno, 0, 0, 0, 0, text)
    local win = vim.api.nvim_open_win(scratch_bufno, true, {
        height = 10,
        split = "below",
    })
    vim.api.nvim_win_set_buf(win, scratch_bufno)
    vim.cmd("setlocal nowrap")
    vim.cmd(string.format("execute 'buffer %s | %s'", scratch_bufno, string.format("%%!psql -d %s", database)))
end

vim.api.nvim_create_user_command("Psql", function(cmdargs)
    psql_query(cmdargs.args, cmdargs.range)
end, { nargs = 1, range = "%"})

function close_floats()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

vim.api.nvim_create_user_command("FloatClose", function()
    close_floats()
end, { nargs = 0 })
