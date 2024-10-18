return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      ['<C-s>'] = { 'actions.select', opts = { vertical = false, horizontal = true }, desc = 'Open the entry in a horizontal split' },
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<leader>r'] = 'actions.refresh',
    },
    columns = { 'icon', 'size', 'mtime' },
    view_options = {
      show_hidden = true,
    },
  },
  -- Optional dependencies
  dependencies = {
    {
      'echasnovski/mini.icons',
      opts = {
        style = vim.g.have_nerd_font and 'glyph' or 'ascii',
      },
    },
  },
  init = function()
    vim.keymap.set('n', '<leader>f', '<Cmd>Oil --float<Cr>', { desc = '[F]ile manager' })
    vim.keymap.set('n', '<leader>.', '<Cmd>Oil --float .<Cr>', { desc = '[F]ile manager' })
  end,
}
