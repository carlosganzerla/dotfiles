local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
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
                i(0),
            }
        )
    ),
    s(
        "newenumvalue",
        fmt(
            [[

             CREATE TYPE {}_new AS ENUM (
             );

             ALTER TABLE {}
                 ALTER COLUMN {} TYPE {}_new
                 USING {}::text::{}_new;

             DROP TYPE {};

             ALTER TYPE {}_new RENAME TO {};
             {}
             ]],
            {
                i(1),
                i(2),
                i(3),
                f(copy, 1),
                f(copy, 3),
                f(copy, 1),
                f(copy, 1),
                f(copy, 1),
                f(copy, 1),
                i(0),
            }
        )
    ),
})
