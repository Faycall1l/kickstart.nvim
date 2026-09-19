-- Data files: comfortable CSV/TSV editing with csvview.nvim.
--
-- Auto-detects delimiters and headers, adds Excel-like navigation and text
-- objects, plus sticky headers/columns. Requires Neovim >= 0.10.

vim.pack.add { 'https://github.com/hat0uma/csvview.nvim', version = vim.version.range '1.*' }

require('csvview').setup {
  parser = {
    comments = { '#', '//' },
  },
  keymaps = {
    -- Text objects for selecting fields
    textobject_field_inner = { 'if', mode = { 'o', 'x' } },
    textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    -- Excel-like navigation
    jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
    jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
    jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
    jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
  },
}

vim.keymap.set('n', '<leader>xv', '<Cmd>CsvViewToggle<CR>', { desc = '[x]: toggle Csv[V]iew' })
vim.keymap.set('n', '<leader>xi', '<Cmd>CsvViewInfo<CR>', { desc = '[x]: CsvView [i]nfo' })

-- Enable csvview automatically whenever a CSV/TSV file is opened.
local csv_augroup = vim.api.nvim_create_augroup('aie-csvview', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost' }, {
  group = csv_augroup,
  pattern = { '*.csv', '*.tsv' },
  callback = function(ev) require('csvview').enable(ev.buf) end,
})
