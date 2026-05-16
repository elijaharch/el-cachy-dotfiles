return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      'm',
      mode = { 'n', 'x', 'o' },
      function() require('flash').jump() end,
      desc = 'Flash',
    },
    {
      'M',
      mode = { 'n', 'x', 'o' },
      function() require('flash').treesitter() end,
      desc = 'Flash Treesitter',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function() require('flash').toggle() end,
      desc = 'Toggle Flash Search',
    },
  },
  config = function(_, opts)
    require('flash').setup(opts)

    local function set_flash_hl()
      vim.api.nvim_set_hl(0, 'FlashLabel', { fg = '#080808', bg = '#ff5189', bold = true })
      vim.api.nvim_set_hl(0, 'FlashMatch', { fg = '#080808', bg = '#fab73d', bold = true })
      vim.api.nvim_set_hl(0, 'FlashCurrent', { fg = '#080808', bg = '#74b2ff', bold = true })
      vim.api.nvim_set_hl(0, 'FlashBackdrop', { fg = '#5a5a5a' })
      vim.api.nvim_set_hl(0, 'FlashPrompt', { fg = '#e3e3e3', bg = '#323437' })
      vim.api.nvim_set_hl(0, 'FlashPromptIcon', { fg = '#ff5189', bg = '#323437', bold = true })
    end

    set_flash_hl()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('FlashContrast', { clear = true }),
      callback = set_flash_hl,
    })
  end,
}
