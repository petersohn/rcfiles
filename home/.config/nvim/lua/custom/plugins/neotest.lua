return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'DarkKronicle/neotest-dotnet',
    'thenbe/neotest-playwright',
  },
  config = function()
    local neotest = require 'neotest'
    neotest.setup {
      adapters = {
        require 'neotest-dotnet' {
          dap = {
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            args = { justMyCode = false },
            -- Enter the name of your dap adapter, the default value is netcoredbg
            adapter_name = 'netcoredbg',
          },
          -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
          -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
          custom_attributes = {
            -- xunit = { "MyCustomFactAttribute" },
            -- nunit = { "MyCustomTestAttribute" },
            -- mstest = { "MyCustomTestMethodAttribute" }
          },
          -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
          dotnet_additional_args = {
            '--verbosity detailed --no-restore --no-build',
          },
          -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
          -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
          --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
          discovery_root = 'solution', -- Default
        },
        require('neotest-playwright').adapter {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        },
      },
      benchmark = {
        enabled = true,
      },
      consumers = {
        playwright = require('neotest-playwright.consumers').consumers,
      },
      default_strategy = 'integrated',
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      discovery = {
        concurrent = 0,
        enabled = true,
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      highlights = {
        adapter_name = 'NeotestAdapterName',
        border = 'NeotestBorder',
        dir = 'NeotestDir',
        expand_marker = 'NeotestExpandMarker',
        failed = 'NeotestFailed',
        file = 'NeotestFile',
        focused = 'NeotestFocused',
        indent = 'NeotestIndent',
        marked = 'NeotestMarked',
        namespace = 'NeotestNamespace',
        passed = 'NeotestPassed',
        running = 'NeotestRunning',
        select_win = 'NeotestWinSelect',
        skipped = 'NeotestSkipped',
        target = 'NeotestTarget',
        test = 'NeotestTest',
        unknown = 'NeotestUnknown',
        watching = 'NeotestWatching',
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = '',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = '',
        running = '',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = '',
        unknown = '',
        watching = '',
      },
      jump = {
        enabled = true,
      },
      log_level = 1,
      output = {
        enabled = true,
        open_on_run = 'short',
      },
      output_panel = {
        enabled = true,
        open = 'botright split | resize 15',
      },
      projects = {},
      quickfix = {
        enabled = true,
        open = false,
      },
      run = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      state = {
        enabled = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = 'a',
          clear_marked = 'M',
          clear_target = 'T',
          debug = 'd',
          debug_marked = 'D',
          expand = { '<CR>', '<2-LeftMouse>' },
          expand_all = 'e',
          jumpto = 'i',
          mark = 'm',
          next_failed = 'J',
          output = 'o',
          prev_failed = 'K',
          run = 'r',
          run_marked = 'R',
          short = 'O',
          stop = 'u',
          target = 't',
          watch = 'w',
        },
        open = 'botright vsplit | vertical resize 50',
      },
      watch = {
        enabled = true,
      },
    }
    vim.keymap.set('n', '<localleader>tfr', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = '[T]est ?[fr]?', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>tr', function()
      neotest.run.run()
      neotest.summary.open()
    end, { desc = '[T]est [r]un and open summary', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>ts', function()
      neotest.run.stop()
    end, { desc = '[T]est [s]top', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>to', function()
      neotest.output.open { last_run = true, enter = true }
    end, { desc = '[T]est [o]utput open', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>tt', function()
      neotest.summary.toggle()
    end, { desc = '[T]est [t]oggle summary', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>tn', neotest.jump.next, { desc = '[T]est [n]ext', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>tp', neotest.jump.prev, { desc = '[T]est [p]revious', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<localleader>tl', function()
      neotest.run.run_last { enter = true }
      neotest.output.open { last_run = true, enter = true }
    end, { desc = '[T]est rerun [l]ast', noremap = true, silent = true, nowait = true })
    vim.keymap.set('n', '<leader>ta', function()
      require('neotest').playwright.attachment()
    end, { desc = 'Launch test attachment' })
  end,
}
