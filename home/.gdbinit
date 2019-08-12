# source ~/gdb/stl-views-1.0.3.gdb
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off
set history save on
set python print-stack full
set print static-members no
set auto-load local-gdbinit on
set auto-load safe-path /

source ~/gdb/colors.py

# Dashboard
source ~/gdb/gdb-dashboard/.gdbinit
dashboard -layout !assembly expressions !history memory !registers source stack !threads
dashboard stack -style limit 5
dashboard stack -style compact True
