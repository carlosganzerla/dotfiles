local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

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
