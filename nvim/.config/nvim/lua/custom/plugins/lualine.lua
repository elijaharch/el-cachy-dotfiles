return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = function()
			local mode_map = {
				["NORMAL"]  = "N",
				["O-PENDING"] = "N?",
				["INSERT"]  = "I",
				["VISUAL"]  = "V",
				["V-BLOCK"] = "VB",
				["V-LINE"]  = "VL",
				["V-REPLACE"] = "VR",
				["REPLACE"] = "R",
				["COMMAND"] = "!",
				["SHELL"]   = "SH",
				["TERMINAL"] = "T",
				["EX"]      = "X",
				["S-BLOCK"] = "SB",
				["S-LINE"]  = "SL",
				["SELECT"]  = "S",
				["CONFIRM"] = "Y?",
				["MORE"]    = "M",
			}

			return {
				options = {
					icons_enabled = true,
					theme = "auto",
					globalstatus = true,
					component_separators = "",
					section_separators = "",
					disabled_filetypes = {
						statusline = { "snacks_dashboard" },
					},
					always_divide_middle = true,
					always_show_tabline = false,
					refresh = {
						statusline = 1000,
					},
				},

				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s) return mode_map[s] or s end,
							padding = { left = 1, right = 1 },
						},
					},
					lualine_b = {
						{ "branch", icon = "" },
						{
							"diff",
							symbols = { added = "+", modified = "~", removed = "-" },
							colored = true,
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
						},
						{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
					},
					lualine_y = {},
					lualine_z = {
						{ "location", padding = { left = 1, right = 1 } },
					},
				},

				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},

				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = { "neo-tree", "toggleterm", "lazy", "mason" },
			}
		end,
	},
}
