vim.api.nvim_create_user_command('W', 'w<bang>', { bang = true })
vim.api.nvim_create_user_command('Wa', 'wa<bang>', { bang = true })
vim.api.nvim_create_user_command('WA', 'wa<bang>', { bang = true })
vim.api.nvim_create_user_command('Q', 'q<bang>', { bang = true })
vim.api.nvim_create_user_command('Qa', 'qa<bang>', { bang = true })
vim.api.nvim_create_user_command('QA', 'qa<bang>', { bang = true })

return {}
