-- Language servers for the AI Engineering stack.
--
-- Upstream (init.lua SECTION 6) already enables `stylua` and `lua_ls` and sets
-- `mason-lspconfig` to `automatic_enable = false`, so servers must be enabled
-- explicitly. This file enables the additional servers installed via Mason and
-- gives them lean, stack-appropriate defaults.

-- Each entry: server name -> vim.lsp.Config overrides for that server.
-- (A `{}` value simply enables the server with nvim-lspconfig defaults.)
---@type table<string, vim.lsp.Config>
local aie_servers = {
  -- Python / ML
  -- basedpyright: community-maintained pyright fork with Pylance-ported
  -- features (inlay hints, semantic tokens, docstring completion payload)
  -- and stricter defaults. Replaces stock pyright (SOTA for Neovim).
  basedpyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },

  -- TypeScript / JavaScript
  ts_ls = {
    settings = {
      javascript = { inlayHints = { includeInlayParameterNameHints = 'literals' } },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'literals',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },

  -- Rust
  rust_analyzer = {
    settings = {
      rust_analyzer = {
        checkOnSave = { command = 'clippy' },
        inlayHints = { bindingModeHints = 'enable', closingBraceHints = 'always', parameterHints = { enable = true } },
      },
    },
  },

  -- C/C++
  clangd = {},

  -- Data & config files
  yamlls = {},
  taplo = {},
}

for name, config in pairs(aie_servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end