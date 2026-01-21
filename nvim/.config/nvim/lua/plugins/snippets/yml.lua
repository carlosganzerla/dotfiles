local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local copy = require("plugins.snippets.snip_functions").copy

local function get_changeset(args, parent, nodate)
    local name = vim.split(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"), ".", { plain = true })[1]
    if nodate == true then
        return string.sub(name, 12)
    end
    return name
end

ls.add_snippets("yaml", {
    s(
        "deploy",
        fmt([[
                name: Deploy to Amazon ECS

                on:
                  release:
                    types: [published]

                jobs:
                    deploy:
                      uses: alude/actions-lib/.github/workflows/ecs-deploy.yml@v1
                    with:
                      aws-region: 
                      ecr-repository: 
                      ecs-service: 
                      ecs-cluster: 
                      ecs-task-definition: 
                      ecs-task-definition-family: 
                      container-name:
                      dockerfile:
        ]],
            {}
        )
    ),
})
