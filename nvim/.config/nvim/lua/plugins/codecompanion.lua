require("codecompanion").setup({
	adapters = {
		copilot = {
			model = "gpt-5.2-codex",
		},
	},
	strategies = {
		chat = {
			adapter = "copilot",
		},
		inline = {
			adapter = "copilot",
		},
	},
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				make_tools = true,
				show_server_tools_in_chat = true,
				add_mcp_prefix_to_tool_names = false,
				show_result_in_chat = true,
				format_tool = nil,
				make_vars = true,
				make_slash_commands = true,
			},
		},
	},
	rules = {
		default = {
			description = "Collection of common files for all projects",
			files = {
				".rules",
			},
			is_preset = true,
		},
		opts = {
			chat = {
				autoload = "default", -- The rule groups to load
				enabled = true,
			},
		},
	},
})
