-- Shared settings for the AI Engineering layer.
--
-- Must be loaded first by `custom.plugins`:
--   1. Prepend the Mason `bin` directory to PATH so CLI tools
--      (ruff, prettierd, debugpy, ...) are available outside of LSP.
--   2. Re-assert `mason-tool-installer` ensure_installed with the full
--      AI/engineering toolchain (runs after the upstream setup in init.lua).
--   3. Extend which-key with the AI Engineering leader groups.

-- 1. PATH: Mason installs binaries under `stdpath('data')/mason/bin`.
local mason_bin = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin')
if not vim.env.PATH:find(mason_bin, 1, true) then vim.env.PATH = mason_bin .. ':' .. vim.env.PATH end

-- 2. Full toolchain to auto-install via Mason.
--   Keeps the upstream defaults (`lua-language-server`, `stylua`) and adds the
--   AI Engineering stack. Names are Mason package names.
local ensure_installed = {
  'lua-language-server', -- Lua LSP (upstream default)
  'stylua', -- Lua formatter (upstream default)

  -- Python / ML stack
  'basedpyright', -- Python LSP (pyright fork with Pylance features)
  'ruff', -- Python linter/formatter (ruff + ruff_format + ruff_check)
  'debugpy', -- Python debug adapter (used by nvim-dap)

  -- TypeScript / JavaScript
  'typescript-language-server', -- ts_ls LSP
  'prettierd', -- Fast prettier daemon formatter

  -- Rust
  'rust-analyzer', -- Rust LSP

  -- C/C++
  'clangd', -- C/C++ LSP

  -- Data & config files
  'yaml-language-server', -- YAML LSP
  'taplo', -- TOML LSP

  -- Shell (used by conform for .sh / .zsh)
  'shfmt',

  -- Markdown linting (used by nvim-lint)
  'markdownlint-cli',
}

---@diagnostic disable-next-line: missing-fields
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- 3. which-key leader groups for the AI Engineering layer.
--   Re-registers the upstream spec (s/t/h/gr) so a later `setup` call in this
--   file doesn't clobber them, then adds the new groups.
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Re-declare upstream groups (additive, idempotent)
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },

    -- AI Engineering groups
    { '<leader>a', group = '[A]I Assistant' },
    { '<leader>m', group = '[M]olten' },
    { '<leader>o', group = '[O]il' },
    { '<leader>d', group = '[D]ebug' },
  },
}
