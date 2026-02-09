local ls = require("luasnip")
local s = ls.snippet
local c = ls.choice_node
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node
local copy = require("plugins.snippets.snip_functions").copy

ls.add_snippets("terraform", {
	s(
		"tfbackend",
		fmt(
			[[
            terraform {{
              required_providers {{
                aws = {{
                  source  = "hashicorp/aws"
                  version = "{}"
                }}
              }}
              required_version = ">= 1.14.0"
            }}
            {}
            ]],
			{
				c(1, { t(">= 6.0"), t("~> 6.28") }),
				i(0),
			}
		)
	),
    s("tfimport", fmt(
        [[
            import {{
                id = "{}"
                to = {}.{}
            }}

            resource "{}" "{}" {{
            }}
        ]],
        {
            i(0),
            i(1),
            i(2, "this"),
            f(copy, 1),
            f(copy, 2),
        }
    )),
})
