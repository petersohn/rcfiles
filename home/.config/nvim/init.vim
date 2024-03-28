set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua dofile(os.getenv("HOME") .. "/.config/nvim/luainit.lua")
