local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local function copy(args)
    return args[1]
end

ls.setup({
    keep_roots = true,
    link_roots = true,
    link_children = true,

    -- Update more often, :h events for more info.
    update_events = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    delete_check_events = "TextChanged",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "choiceNode", "Comment" } },
            },
        },
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = false,
    -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
    -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
    store_selection_keys = "<Tab>",
    -- luasnip uses this function to get the currently active filetype. This
    -- is the (rather uninteresting) default, but it's possible to use
    -- eg. treesitter for getting the current filetype by setting ft_func to
    -- require("luasnip.extras.filetype_functions").from_cursor (requires
    -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
    -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
    ft_func = require("luasnip.extras.filetype_functions").from_cursor,
})

ls.add_snippets("markdown", {
    s("tabledoc", {
        t("# `"),
        i(1, "table"),
        t("` table"),
        t({ "", "", "## Fields", "", "## SQL", "", "```sql", "" }),
        t("CREATE TABLE "),
        f(copy, 1),
        t({ " (", ");", "```" }),
    }),
    s("enumdoc", {
        t("# `"),
        i(1, "type"),
        t("` enum"),
        t({ "", "", "An enumeration...", "", "The following values apply:", "", "## SQL", "", "```sql", "" }),
        t("CREATE TYPE "),
        f(copy, 1),
        t({ " AS ENUM (", ");", "```" }),
    }),
    s("funcdoc", {
        t("# `"),
        i(1, "function"),
        t("` function"),
        t({ "", "", "This function...", "", "", "## Inputs", "", "", "## Output", "", "", "```sql", "", "```" }),
    }),
})

ls.add_snippets("typescript", {
    s("eslint max lines", t("/* eslint max-lines-per-function: 0 */")),
    s(
        "jest test",
        fmt(
            [[
            describe('{}', () => {{
                beforeEach(() => {{
                }});

                it('{}', {}() => {{
                    {}
                }});
            }});
        ]],
            {
                i(1, "Feature"),
                i(2, "does something"),
                c(3, { t(""), t("async ") }),
                i(0),
            }
        )
    ),
})

ls.add_snippets("typescriptreact", {
    s(
        "story",
        fmt(
            [[
            import React from 'react';
            import {{ StoryFn, Meta }} from '@storybook/react';
            import {{ {}, {}Props }} from './{}';

            export default {{
                title: '{}{}',
                component: {},
                args: {{
                    {}
                }},
            }} as Meta;

            const Template: StoryFn<{}Props> = args => <{} {{...args}} />;

            export const Default = Template.bind({{}});
        ]],
            {
                i(1),
                f(copy, 1),
                f(copy, 1),
                i(2),
                f(copy, 1),
                f(copy, 1),
                i(0),
                f(copy, 1),
                f(copy, 1),
            }
        )
    ),
    s(
        "visual component",
        fmt(
            [[
            import React from 'react';

            export type {}Props = {{
            }};

            export const {} = ({{ }}: {}Props): JSX.Element => {{
                return (
                    <{}>{}</{}>
                );
            }};
        ]],
            {
                i(1),
                f(copy, 1),
                f(copy, 1),
                i(2),
                i(0),
                f(copy, 2),
            }
        )
    ),
})

ls.add_snippets("python", {
    s(
        "python test",
        fmt(
            [[
            import pytest
            {}
            {}
            {}
            {}
            def test_{}():
                pass
        ]],
            {
                c(1, { t({ "from unittest.mock import Mock, AsyncMock", "" }), t("") }),
                c(2, {
                    fmt(
                        [[
            class Dependencies:
                def __init__(self) -> None:
                    pass
            ]],
                        {}
                    ),
                    t(""),
                }),
                c(3, {
                    fmt(
                        [[
                    @pytest.fixture
                    def fixture():
                ]],
                        {}
                    ),
                    t(""),
                }),
                c(4, {
                    fmt(
                        [[
                @pytest.fixture
                def dependencies():
                    return Dependencies()
                ]],
                        {}
                    ),
                    t(""),
                }),
                i(5),
            }
        )
    ),
})

local function get_changeset(args, parent, nodate)
    local name = vim.split(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"), ".", { plain = true })[1]
    if nodate == true then
        return string.sub(name, 12)
    end
    return name
end

ls.add_snippets("xml", {
    s(
        "dbchangelogfile",
        fmt(
            [[
        <?xml version="1.1" encoding="UTF-8" standalone="no"?>
        <databaseChangeLog
            xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
            xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"
            xmlns:pro="http://www.liquibase.org/xml/ns/pro"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="
                http://www.liquibase.org/xml/ns/dbchangelog-ext
                http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd
                http://www.liquibase.org/xml/ns/pro
                http://www.liquibase.org/xml/ns/pro/liquibase-pro-4.1.xsd
                http://www.liquibase.org/xml/ns/dbchangelog
                http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.1.xsd"
        >
            <changeSet dbms="postgresql" author="carlo" id="{}">
                <sqlFile
                    splitStatements="false"
                    path="{}.sql"
                />
                <rollback>
                    <sqlFile
                        splitStatements="false"
                        path="{}.rollback.sql"
                    />
                </rollback>
            </changeSet>
        </databaseChangeLog>
        ]],
            {
                f(get_changeset, {}, { user_args = { true } }),
                f(get_changeset, {}, {}),
                f(get_changeset, {}, {}),
            }
        )
    ),
    s(
        "dbchangelogsql",
        fmt(
            [[
        <?xml version="1.1" encoding="UTF-8" standalone="no"?>
        <databaseChangeLog
            xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
            xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"
            xmlns:pro="http://www.liquibase.org/xml/ns/pro"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="
                http://www.liquibase.org/xml/ns/dbchangelog-ext
                http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd
                http://www.liquibase.org/xml/ns/pro
                http://www.liquibase.org/xml/ns/pro/liquibase-pro-4.1.xsd
                http://www.liquibase.org/xml/ns/dbchangelog
                http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.1.xsd"
        >
            <changeSet dbms="postgresql" author="carlo" id="{}">
            <sql>
                {}
            </sql>
            <rollback>
                <sql>
                </sql>
            </rollback>
        </changeSet>
        </databaseChangeLog>
        ]],
            {
                f(get_changeset, {}, { user_args = { true } }),
                i(0),
            }
        )
    ),
    s(
        "dbchangesetpermissions",
        fmt(
            [[
            <changeSet
                context="production"
                dbms="postgresql"
                author="carlo"
                id="{}-permissions">
                <sql>
                    {}
                </sql>
                <rollback>
                    <sql>
                    </sql>
                </rollback>
            </changeSet>
        ]],
            {
                f(get_changeset, {}, { user_args = { true } }),
                i(0)
            }
        )
    ),
})

vim.keymap.set("n", "<leader><leader>s", "<cmd>luafile ~/.config/nvim/lua/plugins/snippets.lua<CR>")
