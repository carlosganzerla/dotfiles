-- Diagnostic keymaps
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP formatters
local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        python = { "black" },
        css = { "prettier" },
        flow = { "prettier" },
        graphql = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        javascriptreact = { "prettier" },
        javascript = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        scss = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" }
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
})

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    local xmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('x', keys, func, { buffer = bufnr, desc = desc })
    end

    local builtin = require('telescope.builtin')
    nmap('<F2>', vim.lsp.buf.rename, 'Rename')
    nmap('<leader>ac', vim.lsp.buf.code_action, 'Code action')
    xmap('<leader>ac', vim.lsp.buf.code_action, 'Code action')
    nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
    nmap('gr', builtin.lsp_references, 'Goto References')
    nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
    nmap('gy', vim.lsp.buf.type_definition, 'Type Definition')
    nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>s', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('gh', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('gs', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        conform.format({ bufnr = bufnr })
    end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'ts_ls', 'lua_ls', 'pyright' }

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
    ensure_installed = servers,
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Turn on lsp status information
require('fidget').setup({})

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sh',
    callback = function()
        vim.lsp.start({
            name = 'bash-language-server',
            cmd = { 'bash-language-server', 'start' },
        })
    end,
})
