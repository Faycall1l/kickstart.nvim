-- Additional treesitter parsers for the AI Engineering stack.
--
-- Upstream (init.lua SECTION 9) installs the core parsers and already
-- auto-installs any available parser on FileType, so this is only a hint to
-- pre-install the stack's languages. (Note: newer nvim-treesitter merged
-- `jsonc` into `json`, so `jsonc` is no longer a separate parser.)

local parsers = {
  -- Python / ML
  'python',
  -- JavaScript / TypeScript
  'javascript',
  'typescript',
  'tsx',
  'jsdoc',
  -- Rust
  'rust',
  -- C/C++
  'c',
  'cpp',
  -- Data & config files
  'json',
  'yaml',
  'toml',
  'sql', -- for SQL cells / queries
}

require('nvim-treesitter').install(parsers)
