return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    require('easy-dotnet').setup {
      get_sdk_path = function()
        return '/usr/local/share/dotnet/sdk/8.0.402'
      end,
      test_runner = {
        viewmode = 'float',
      },
    }
  end,
}
