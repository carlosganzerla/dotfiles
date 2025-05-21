-- Diagnostic keymaps
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

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
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    local xmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("x", keys, func, { buffer = bufnr, desc = desc })
    end

    local builtin = require("telescope.builtin")
    nmap("<F2>", vim.lsp.buf.rename, "Rename")
    nmap("<leader>ac", vim.lsp.buf.code_action, "Code action")
    xmap("<leader>ac", vim.lsp.buf.code_action, "Code action")
    nmap("gd", vim.lsp.buf.definition, "Goto Definition")
    nmap("gr", builtin.lsp_references, "Goto References")
    nmap("gR", vim.lsp.buf.references, "Goto References LSP")
    nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
    nmap("gy", vim.lsp.buf.type_definition, "Type Definition")
    nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>s", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    nmap("gh", vim.lsp.buf.hover, "Hover Documentation")
    nmap("gs", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format({ bufnr = bufnr })
    end, { desc = "Format current buffer with LSP" })
end

-- Setup mason so it can manage external tooling
require("mason").setup()

local servers = {
    "ts_ls",
    "postgres_lsp",
    "lua_ls",
    "pyright",
    "clangd",
    "bashls",
    "jsonls",
    "eslint",
    "marksman",
    "cssls",
}

-- Ensure the language servers and tools above installed
require("mason-tool-installer").setup({
    ensure_installed = {
        unpack(servers),
        "isort",
        "black",
        "prettierd",
        "stylua",
        "codespell",
        "markdownlint",
    },

    integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = true,
    },
})

local null_ls = require("null-ls")

function table.copy(t)
    local u = {}
    for k, v in pairs(t) do
        u[k] = v
    end
    return setmetatable(u, getmetatable(t))
end

-- Remove range formatting from black cuz it won't allow gqq's on comments
local black = table.copy(null_ls.builtins.formatting.black)
local prettierd = table.copy(null_ls.builtins.formatting.prettierd)
local methods = require("null-ls.methods")
local FORMATTING = methods.internal.FORMATTING
black.method = { FORMATTING }
prettierd.method = { FORMATTING }

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        prettierd,
        null_ls.builtins.formatting.isort,
        black,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.markdownlint,
    },
})

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lspconfig = require("lspconfig")

-- Generic configs
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

-- Turn on lsp status information. This is for debug only.
-- require("fidget").setup({})

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
})

-- Postgres confgis
lspconfig.postgres_lsp.setup({
    enabled = false,
    cmd = { "postgrestools", "lsp-proxy" },
    filetypes = { "sql", "psql" },
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern("postgrestools.jsonc"),
})
