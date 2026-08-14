return {
	"aserowy/tmux.nvim",
	keys = {
		{
			"<leader>ts",
			function()
				local sessionizer = vim.fn.exepath("tmux-sessionizer")
				if sessionizer == "" then
					sessionizer = vim.fn.expand("~/.local/bin/tmux-sessionizer")
				end

				if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
					vim.fn.system({
						"tmux",
						"display-popup",
						"-E",
						"-w",
						"85%",
						"-h",
						"80%",
						sessionizer,
					})
				else
					vim.cmd("botright 15split")
					vim.cmd("terminal " .. vim.fn.shellescape(sessionizer))
					vim.cmd("startinsert")
				end
			end,
			desc = "Tmux Sessionizer",
		},
	},
	config = function()
		return require("tmux").setup()
	end,
}
