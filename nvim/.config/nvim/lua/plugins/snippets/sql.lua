local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local copy = require("plugins.snippets.snip_functions").copy

ls.add_snippets("sql", {
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
