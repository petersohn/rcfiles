return {
  'nacitar/a.vim',
  init = function()
    vim.g.alternateSearchPath =
      'reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../..'
  end,
}
