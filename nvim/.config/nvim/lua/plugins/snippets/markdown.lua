local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local copy = require("plugins.snippets.snip_functions").copy

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
		t({ "", "", "This function...", "", "", "## Inputs", "", "", "## Output", "", "## SQL", "", "```sql", "", "```" }),
	}),
})
