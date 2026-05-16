local logo = [[
         ╱|、
        (˚ˎ 。7
         |、˜〵
        じしˍ,)ノ

     ┌──────────────────┐
     │   nerfthisdev    │
     │   nvim ~ moonfly │
     └──────────────────┘
]]

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    dashboard = {
      enabled = true,
      preset = {
        header = logo,
        keys = {
          { icon = "\u{f07c} ",  key = 'f', desc = 'Find File',       action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "\u{f15b} ",  key = 'n', desc = 'New File',        action = ':ene | startinsert' },
          { icon = "\u{f002} ",  key = 'g', desc = 'Find Text',       action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "\u{f1da} ",  key = 'r', desc = 'Recent Files',    action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "\u{f013} ",  key = 'c', desc = 'Config',          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "\u{f2f1} ",  key = 's', desc = 'Restore Session', action = ':lua MiniSessions.select()' },
          { icon = "\u{f0eb2} ", key = 'L', desc = 'Lazy',            action = ':Lazy' },
          { icon = "\u{f08b} ",  key = 'q', desc = 'Quit',            action = ':qa' },
        },
      },

      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
      enabled = true,
      -- follow symlinks so stow-managed configs (e.g. ~/.config/nvim) expand
      sources = {
        files = { follow = true },
        grep = { follow = true },
      },
    },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
