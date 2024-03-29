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
set history size 100000

source ~/gdb/colors.py

# Dashboard
source ~/gdb/gdb-dashboard/.gdbinit
dashboard -layout !assembly expressions !history memory !registers source !stack !threads
dashboard stack -style limit 5
dashboard source -style context 10
dashboard stack -style compact True

python
import sys
import os
sys.path.insert(0, os.path.join(os.environ['HOME'], 'workspace/libcxx-pretty-printers/src'))
from libcxx.v1.printers import register_libcxx_printers
register_libcxx_printers(None)
end
