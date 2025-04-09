local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local copy = require("plugins.snippets.snip_functions").copy

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
