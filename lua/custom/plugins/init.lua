-- Ordered loader for the AI Engineering plugin layer.
--
-- Replaces the upstream auto-loader (`vim.fs.dir()`, order unspecified) with an
-- explicit, dependency-aware order. Each module below carries its own
-- `vim.pack.add()` + `setup()` calls, so this copies the upstream pattern of
-- keeping plugins self-contained per file.
--
-- If a module is missing (e.g. work-in-progress on a feature branch), it is
-- skipped with an error notification instead of breaking the whole config.

local modules = {
  -- Shared settings, PATH, toolchain, which-key groups (must load first)
  'config',
  -- Language servers for the AI/engineering stack
  'lsp',
  -- Additional treesitter parsers
  'treesitter',
  -- Formatting & linting (conform.nvim override + nvim-lint)
  'format',
  -- Jupyter notebook workflow (molten-nvim + jupytext.nvim)
  'notebooks',
  -- Data files (csvview.nvim)
  'data',
  -- Markdown & docs (render-markdown.nvim)
  'markdown',
  -- Python debugging (nvim-dap + nvim-dap-python)
  'debug',
  -- Quality-of-life (oil.nvim, undotree, flash.nvim)
  'qol',
  -- AI assistant (opencode.nvim)
  'ai',
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, 'custom.plugins.' .. module)
  if not ok then
    vim.notify(('custom.plugins: failed to load %q: %s'):format(module, err), vim.log.levels.ERROR)
  end
end