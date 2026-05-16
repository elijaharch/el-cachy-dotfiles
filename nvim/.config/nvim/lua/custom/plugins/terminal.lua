return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec', 'ToggleTermToggleAll' },
  keys = {
    { '<C-\\>',      '<cmd>ToggleTerm<cr>',                                     mode = { 'n', 't' }, desc = 'Toggle terminal' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>',                      desc = 'Terminal: float' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>',           desc = 'Terminal: vertical' },
    { '<leader>ts', '<cmd>ToggleTerm direction=horizontal size=15<cr>',         desc = 'Terminal: split' },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = 'vertical',
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    shade_terminals = false,
    shading_factor = 0,
    auto_scroll = true,
    float_opts = {
      border = 'rounded',
      winblend = 0,
      title_pos = 'center',
    },
    winbar = {
      enabled = false,
    },
    highlights = {
      FloatBorder = { link = 'WinSeparator' },
    },
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = term.bufnr, desc = 'Exit terminal mode' })
      vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { buffer = term.bufnr })
      vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { buffer = term.bufnr })
      vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { buffer = term.bufnr })
      vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { buffer = term.bufnr })
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = term.bufnr, desc = 'Close terminal' })
    end,
  },
}
