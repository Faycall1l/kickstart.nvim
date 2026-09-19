-- Jupyter notebook workflow: edit .ipynb as text + run cells in a kernel.
--
-- Two complementary plugins:
--   1. goerz/jupytext.nvim — transparently converts .ipynb <-> .py (percent)
--      so notebooks are plain-text & git-friendly, with LSP working.
--   2. benlubas/molten-nvim — run cells in a live Jupyter kernel and watch
--      plots/outputs.
--
-- Prerequisites (see README): python3 with `jupyter` + `ipykernel`
-- (and the `jupytext` CLI for jupytext.nvim).

-- [[ jupytext.nvim ]]
vim.pack.add { 'https://github.com/goerz/jupytext.nvim' }
require('jupytext').setup {
  style = 'percent', -- py:percent, round-trips cleanly with Jupyter
}

-- [[ molten-nvim ]] (requires nvim >= 0.9.4, jupyter + ipykernel)
vim.pack.add { 'https://github.com/benlubas/molten-nvim' }

vim.g.molten_output_win_max_height = 20
vim.g.molten_output_win_max_width = 78
vim.g.molten_output_win_hidden_on_clean = false
vim.g.molten_auto_open_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_image_provider = 'none'

vim.keymap.set('n', '<leader>mi', '<Cmd>MoltenInit<CR>', { desc = '[M]: [i]nit kernel' })
vim.keymap.set('n', '<leader>mc', '<Cmd>MoltenReevaluateCell<CR>', { desc = '[M]: re-run [c]ell' })
vim.keymap.set('n', '<leader>ml', '<Cmd>MoltenEvaluateLine<CR>', { desc = '[M]: evaluate [l]ine' })
vim.keymap.set('n', '<leader>me', '<Cmd>MoltenEvaluateOperator<CR>', { desc = '[M]: evaluate operator' })
vim.keymap.set('x', '<leader>me', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = '[M]: evaluate visual selection' })
vim.keymap.set('n', '<leader>ms', '<Cmd>MoltenShowOutput<CR>', { desc = '[M]: [s]how output' })
vim.keymap.set('n', '<leader>mh', '<Cmd>MoltenHideOutput<CR>', { desc = '[M]: [h]ide output' })
vim.keymap.set('n', '<leader>md', '<Cmd>MoltenDelete<CR>', { desc = '[M]: [d]elete cell' })
vim.keymap.set('n', '<leader>mr', '<Cmd>MoltenRestart<CR>', { desc = '[M]: [r]estart kernel' })

-- Jump between cells
vim.keymap.set('n', ']n', '<Cmd>MoltenNext<CR>', { desc = '[M]: next cell' })
vim.keymap.set('n', '[n', '<Cmd>MoltenPrev<CR>', { desc = '[M]: prev cell' })