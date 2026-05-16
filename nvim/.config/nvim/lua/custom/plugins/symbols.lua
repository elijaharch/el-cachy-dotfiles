return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  opts = {
    bar = {
      enable = function(buf, win, _)
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ''
          or vim.wo[win].diff
          or vim.api.nvim_win_get_config(win).zindex
          or vim.api.nvim_buf_get_name(buf) == ''
        then
          return false
        end

        local bt = vim.bo[buf].buftype
        if bt == 'terminal' or bt == 'nofile' or bt == 'prompt' or bt == 'quickfix' or bt == 'help' then
          return false
        end

        local skip_ft = {
          ['neo-tree'] = true,
          ['NvimTree'] = true,
          ['toggleterm'] = true,
          ['TelescopePrompt'] = true,
          ['lazy'] = true,
          ['mason'] = true,
          ['help'] = true,
          ['alpha'] = true,
          ['dashboard'] = true,
          ['snacks_dashboard'] = true,
          ['snacks_terminal'] = true,
          ['trouble'] = true,
        }
        if skip_ft[vim.bo[buf].filetype] then
          return false
        end

        return vim.bo[buf].buflisted
      end,
    },
  },
  config = function(_, opts)
    require('dropbar').setup(opts)
    local dropbar_api = require 'dropbar.api'
    vim.keymap.set('n', '<Leader>sc', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
  end,
}
