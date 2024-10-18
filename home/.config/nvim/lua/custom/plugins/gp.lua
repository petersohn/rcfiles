return {
  'robitx/gp.nvim',
  config = function()
    require('gp').setup {
      providers = {
        openai = {},
        azure = {},
        copilot = {},
        googleai = {},
        ollama = {
          endpoint = 'http://localhost:11434/v1/chat/completions',
        },
      },
      default_command_agent = 'DeepSeekCoderV2',
      agents = {
        {
          name = 'DeepSeekCoderV2',
          chat = false,
          command = true,
          provider = 'ollama',
          model = {
            model = 'deepseek-coder-v2',
            temperature = 1.0,
            top_p = 1,
            num_ctx = 8192,
          },
          system_prompt = require('gp.defaults').chat_system_prompt,
        },
      },
    }

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
