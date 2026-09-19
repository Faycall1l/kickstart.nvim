-- Quality-of-life plugins: oil.nvim, undotree, flash.nvim.

-- [[ oil.nvim ]] -- file explorer as a normal buffer
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup {
  default_file_explorer = true, -- Use oil in netrw's place (opens on `-`)
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 100,
    max_height = 0,
  },
}

-- Open parent directory in oil with `-` in normal mode.
-- NOTE: kickstart upstream already maps `-` to open panes? No — upstream netrw is disabled by default
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory (oil)' })

-- [[ undotree ]] -- visual undo history
vim.pack.add { 'https://github.com/mbbill/undotree' }
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndotree toggle' })

-- [[ flash.nvim ]] -- label-based search/jump
vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('flash').setup {}

vim.keymap.set('n', 's', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter jump' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })