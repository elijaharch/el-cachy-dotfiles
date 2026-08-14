local items = {
	{
		repo = "oskarnurm/koda.nvim",
		schemes = { "koda", "koda-dark", "koda-light", "koda-glade", "koda-moss" },
	},
	{
		repo = "andreypopp/vim-colors-plain",
		schemes = { "plain", "plain-cterm" },
	},
	{
		repo = "folke/tokyonight.nvim",
		schemes = {
			"tokyonight",
			"tokyonight-night",
			"tokyonight-storm",
			"tokyonight-day",
			"tokyonight-moon",
		},
	},
	{
		repo = "catppuccin/nvim",
		name = "catppuccin",
		schemes = {
			"catppuccin",
			"catppuccin-latte",
			"catppuccin-frappe",
			"catppuccin-macchiato",
			"catppuccin-mocha",
		},
	},
	{
		repo = "rebelot/kanagawa.nvim",
		schemes = { "kanagawa", "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
	},
	{
		repo = "rose-pine/neovim",
		name = "rose-pine",
		schemes = { "rose-pine", "rose-pine-main", "rose-pine-moon", "rose-pine-dawn" },
	},
	{
		repo = "ellisonleao/gruvbox.nvim",
		schemes = { "gruvbox" },
	},
	{
		repo = "shaunsingh/nord.nvim",
		schemes = { "nord" },
	},
	{
		repo = "navarasu/onedark.nvim",
		schemes = { "onedark" },
	},
	{
		repo = "EdenEast/nightfox.nvim",
		schemes = { "nightfox", "dayfox", "dawnfox", "nordfox", "terafox", "carbonfox" },
	},
	{
		repo = "sainnhe/everforest",
		schemes = { "everforest" },
	},
	{
		repo = "sainnhe/sonokai",
		schemes = { "sonokai" },
	},
	{
		repo = "sainnhe/edge",
		schemes = { "edge" },
	},
	{
		repo = "marko-cerovac/material.nvim",
		schemes = {
			"material",
			"material-darker",
			"material-deep-ocean",
			"material-lighter",
			"material-oceanic",
			"material-palenight",
		},
	},
	{
		repo = "Mofiqul/dracula.nvim",
		schemes = { "dracula", "dracula-soft" },
	},
	{
		repo = "projekt0n/github-nvim-theme",
		schemes = {
			"github_dark",
			"github_dark_default",
			"github_dark_dimmed",
			"github_dark_high_contrast",
			"github_light",
			"github_light_default",
			"github_light_high_contrast",
		},
	},
	{
		repo = "nyoom-engineering/oxocarbon.nvim",
		schemes = { "oxocarbon" },
	},
	{
		repo = "RRethy/base16-nvim",
		schemes = { "base16-default-dark", "base16-default-light" },
	},
}

local function scheme_names()
	local names = { "moonfly" }

	for _, item in ipairs(items) do
		vim.list_extend(names, item.schemes)
	end

	return names
end

local theme_file = vim.fn.stdpath("state") .. "/theme"

local function read_saved_scheme()
	local file = io.open(theme_file, "r")
	if not file then
		return nil
	end

	local name = vim.trim(file:read("*a"))
	file:close()

	if name == "" then
		return nil
	end

	return name
end

local function write_saved_scheme(name)
	local file = io.open(theme_file, "w")
	if not file then
		vim.notify("Unable to save theme: " .. theme_file, vim.log.levels.WARN)
		return
	end

	file:write(name .. "\n")
	file:close()
end

local function setup_koda(name)
	local variant_overrides = {
		dark = {
			bg = "#090909",
			line = "#1a1a1a",
		},
		moss = {
			bg = "#090d0e",
			line = "#151d1e",
		},
	}

	local variant_by_name = {
		["koda-dark"] = "dark",
		["koda-light"] = "light",
		["koda-glade"] = "glade",
		["koda-moss"] = "moss",
	}
	local variant = variant_by_name[name]

	if name == "koda" then
		variant = vim.o.background == "light" and "light" or "dark"
	end

	if variant then
		require("koda").setup({
			colors = variant_overrides[variant] or {},
		})
	end
end

local function apply_scheme(name)
	setup_koda(name)
	vim.cmd.colorscheme(name)
end

local function apply_saved_scheme()
	local name = read_saved_scheme() or "moonfly"
	local ok, err = pcall(apply_scheme, name)

	if not ok then
		vim.notify("Unable to load saved theme " .. name .. ": " .. err, vim.log.levels.WARN)
		apply_scheme("moonfly")
	end
end

local specs = vim.tbl_map(function(item)
	local spec = {
		item.repo,
		lazy = true,
		priority = 1000,
	}

	if item.name then
		spec.name = item.name
	end

	return spec
end, items)

specs[#specs + 1] = {
	"folke/snacks.nvim",
	opts = function(_, opts)
		opts = opts or {}
		opts.picker = opts.picker or {}
		opts.picker.sources = opts.picker.sources or {}
		opts.picker.sources.colorschemes = opts.picker.sources.colorschemes or {}
		return opts
	end,
	init = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("PersistTheme", { clear = true }),
			callback = function()
				if vim.g.colors_name then
					write_saved_scheme(vim.g.colors_name)
				end
			end,
		})

		vim.api.nvim_create_user_command("Theme", function(command_opts)
			local name = command_opts.args

			if name == "" then
				vim.ui.select(scheme_names(), {
					prompt = "Select theme",
					format_item = function(item)
						if item == vim.g.colors_name then
							return item .. " (current)"
						end

						return item
					end,
				}, function(choice)
					if choice then
						apply_scheme(choice)
					end
				end)
				return
			end

			apply_scheme(name)
		end, {
			nargs = "?",
			complete = function(arg_lead)
				return vim.tbl_filter(function(theme)
					return theme:find(arg_lead, 1, true) == 1
				end, scheme_names())
			end,
			desc = "Select or set the active theme",
		})
	end,
}

specs[#specs + 1] = {
	"bluz71/vim-moonfly-colors",
	name = "moonfly",
	lazy = false,
	priority = 1000,
	config = apply_saved_scheme,
}

return specs
