-- Formatting & linting for the AI Engineering stack.
--
-- Full `conform.nvim` override (supersedes the upstream setup in init.lua
-- SECTION 7 because the custom layer loads afterwards) and `nvim-lint` for
-- ruff (Python) and markdownlint (Markdown).

-- [[ conform.nvim ]]
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {
      python = true,
      lua = true,
      javascript = true,
      typescript = true,
      typescriptreact = true,
      javascriptreact = true,
      json = true,
      jsonc = true,
      yaml = true,
      toml = true,
      sh = true,
      zsh = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    -- Python: ruff is imported/installed via Mason
    python = { 'ruff_format' },
    -- Lua (kept in sync with the stylua LSP server upstream enables)
    lua = { 'stylua' },
    -- JS/TS/JSON/YAML: fast prettier daemon first, prettier as fallback
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    -- TOML
    toml = { 'taplo' },
    -- Shell
    sh = { 'shfmt' },
    zsh = { 'shfmt' },
  },
}

-- [[ nvim-lint ]]
vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  python = { 'ruff' },
  markdown = { 'markdownlint' },
}

local lint_augroup = vim.api.nvim_create_augroup('aie-lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
