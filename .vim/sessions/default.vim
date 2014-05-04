" ~/.vim/sessions/default.vim:
" Vim session script.
" Created by session.vim 2.4.9 on 18 April 2014 at 16:04:03.
" Open this file in Vim and run :source % to restore your session.

set guioptions=aegimrLtT
silent! set guifont=
if exists('g:syntax_on') != 1 | syntax on | endif
if exists('g:did_load_filetypes') != 1 | filetype on | endif
if exists('g:did_load_ftplugin') != 1 | filetype plugin on | endif
if exists('g:did_indent_on') != 1 | filetype indent on | endif
if &background != 'dark'
	set background=dark
endif
if !exists('g:colors_name') || g:colors_name != 'solarized' | colorscheme solarized | endif
call setqflist([])
let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/observability/cudb_obs_be
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +77 Persister/include/observ/SqlPersistStrategyForMeasurement.hpp
badd +29 Persister/include/observ/SqlPersistStrategyForMeasurementUnit.hpp
badd +151 Persister/test/unitTest/SqlPersistStrategyForMeasurementUnitTest.cpp
badd +1 Aggregator/include/observ/AlarmAggregator.hpp
badd +1 Aggregator/src/observ/AlarmAggregator.cpp
badd +144 Persister/src/observ/SqlPersistStrategyForMeasurementUnit.cpp
badd +69 Engine/include/observ/DataFlow.hpp
badd +1 Persister/lib/Tupfile
badd +4 Util/include/observ/programmerAssertion.hpp
badd +317 Persister/test/unitTest/SqlPersistStrategyForMeasurementTest.cpp
badd +382 Persister/test/integrationTest/SqlPersistStrategyForMeasurementTesting.cpp
badd +688 Parser/test/unitTest/netconfTopologyParserTest/NetconfTopologyParserTest.cpp
badd +8 Parser/test/unitTest/netconfTopologyParserTest/Tupfile
badd +10 Persister/test/integrationTest/AlarmSqlPersisterTest/Tupfile
badd +12 Persister/test/integrationTest/AlarmSqlPersisterTest/AlarmSqlPersisterTest.cpp
badd +31 Persister/test/integrationTest/PersistStrategyFixture.hpp
badd +43 Engine/src/observ/ActionTaker.cpp
badd +1 schemas/cudbobs_schema.postgres.sql
badd +6 Persister/test/integrationTest/testMain.cpp
badd +28 cpp_utility/include/testutil/TestLogSink.hpp
badd +22 DataModel/include/observ/measurement/AlarmEntity.hpp
badd +17 DataModel/include/observ/measurement/AlarmData.hpp
badd +31 test/include/observ/test/DatabaseIntegrationTestFixture.hpp
badd +1 DataModel/include/observ/TimestampIO.hpp
badd +23 PsqlBinding/include/psql/Result.hpp
badd +11 Aggregator/test/unitTest/AlarmAggregatorTest.cpp
badd +1 Aggregator/test/unitTest/MultiValueTpsAggregatorLogicTest.cpp
badd +6 Aggregator/test/unitTest/TopologyMergeAggregatorTest.cpp
badd +24 test/include/observ/createAlarmEntity.hpp
badd +16 test/include/observ/test/SampleTopology.hpp
badd +436 Persister/test/unitTest/MeasurementSqlPersistStrategyTest.cpp
badd +110 Persister/include/observ/MeasurementSqlPersistStrategy.hpp
badd +0 DataModel/include/observ/topology/System.hpp
badd +141 Persister/test/integrationTest/MeasurementSqlPersistStrategyTesting.cpp
badd +0 Engine/src/observ/DataFlowFactory.cpp
silent! argdel *
edit Persister/test/integrationTest/AlarmSqlPersisterTest/AlarmSqlPersisterTest.cpp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe '3resize ' . ((&lines * 24 + 26) / 52)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
exe '4resize ' . ((&lines * 24 + 26) / 52)
exe 'vert 4resize ' . ((&columns * 87 + 103) / 207)
" argglobal
enew
" file NERD_tree_1
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
" argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 730 - ((29 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
730
normal! 046|
wincmd w
" argglobal
edit Persister/include/observ/MeasurementSqlPersistStrategy.hpp
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 32 - ((14 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
32
normal! 040|
wincmd w
" argglobal
edit Persister/test/integrationTest/PersistStrategyFixture.hpp
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 54 - ((12 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
54
normal! 030|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe '3resize ' . ((&lines * 24 + 26) / 52)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
exe '4resize ' . ((&lines * 24 + 26) / 52)
exe 'vert 4resize ' . ((&columns * 87 + 103) / 207)
tabedit Aggregator/include/observ/AlarmAggregator.hpp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
" argglobal
enew
" file NERD_tree_2
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
" argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 6 - ((5 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 029|
wincmd w
" argglobal
edit Aggregator/src/observ/AlarmAggregator.cpp
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 34 - ((33 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
34
normal! 013|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
tabedit Engine/src/observ/DataFlowFactory.cpp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
" argglobal
enew
" file NERD_tree_3
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
" argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 217 - ((24 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
217
normal! 032|
wincmd w
" argglobal
edit DataModel/include/observ/topology/System.hpp
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 26 - ((25 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
26
normal! 05|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 207)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 207)
tabedit schemas/cudbobs_schema.postgres.sql
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 175 + 103) / 207)
" argglobal
enew
" file NERD_tree_4
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
" argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 219 - ((2 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
219
normal! 02|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 103) / 207)
exe 'vert 2resize ' . ((&columns * 175 + 103) / 207)
tabnext 1
if exists('s:wipebuf')
"   silent exe 'bwipe ' . s:wipebuf
endif
" unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save

" Support for special windows like quick-fix and plug-in windows.
" Everything down here is generated by vim-session (not supported
" by :mksession out of the box).

tabnext 1
1wincmd w
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
NERDTree ~/observability/cudb_obs_be
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
1resize 49|vert 1resize 31|2resize 49|vert 2resize 87|3resize 24|vert 3resize 87|4resize 24|vert 4resize 87|
tabnext 2
1wincmd w
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
NERDTree ~/observability/cudb_obs_be
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
1resize 49|vert 1resize 31|2resize 49|vert 2resize 87|3resize 49|vert 3resize 87|
tabnext 3
1wincmd w
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
NERDTree ~/observability/cudb_obs_be
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
1resize 49|vert 1resize 31|2resize 49|vert 2resize 87|3resize 49|vert 3resize 87|
tabnext 4
1wincmd w
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
NERDTree ~/observability/cudb_obs_be
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
1resize 49|vert 1resize 31|2resize 49|vert 2resize 175|
tabnext 1
2wincmd w
if exists('s:wipebuf')
  if empty(bufname(s:wipebuf))
if !getbufvar(s:wipebuf, '&modified')
  let s:wipebuflines = getbufline(s:wipebuf, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:wipebuf
  endif
endif
  endif
endif
doautoall SessionLoadPost
unlet SessionLoad
" vim: ft=vim ro nowrap smc=128
