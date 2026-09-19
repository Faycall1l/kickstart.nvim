-- AI assistant integration with opencode.nvim (OpenCode TUI/API).
--
-- Leverages OpenCode's existing server & TUI: no new interaction model, just
-- context injection, prompts, and diffpatch-based edit review from Neovim.
--
-- Prerequisite: the `opencode` CLI on $PATH (see README). The plugin starts an
-- integrated `opencode --port` server if none is already running.

vim.pack.add {
  {
    src = 'https://github.com/nickjvandyke/opencode.nvim',
    version = vim.version.range '*',
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    -- Default: start an integrated server via `opencode --port`.
    -- Connect to an existing server instead:
    -- url = 'http://localhost:4077',
  },
}

-- [A]I Assistant keymaps
vim.keymap.set({ 'n', 'x' }, '<leader>aa', function() require('opencode').ask() end, { desc = '[A]: [a]sk OpenCode' })
vim.keymap.set({ 'n', 'x' }, '<leader>as', function() require('opencode').select() end, { desc = '[A]: [s]elect prompt/command' })
vim.keymap.set({ 'n', 'x' }, '<leader>ae', function() require('opencode').prompt('explain @this') end, { desc = '[A]: [e]xplain' })
vim.keymap.set({ 'n', 'x' }, '<leader>ar', function() require('opencode').prompt('review @this') end, { desc = '[A]: [r]eview' })
vim.keymap.set({ 'n', 'x' }, '<leader>af', function() require('opencode').prompt('fix @diagnostics') end, { desc = '[A]: [f]ix diagnostics' })
vim.keymap.set({ 'n', 'x' }, '<leader>at', function() require('opencode').prompt('test @this') end, { desc = '[A]: add [t]ests' })
vim.keymap.set({ 'n', 'x' }, '<leader>ad', function() require('opencode').prompt('document @this') end, { desc = '[A]: [d]ocument' })

-- Session management
vim.keymap.set('n', '<leader>an', function() require('opencode').command 'session.new' end, { desc = '[A]: [n]ew session' })
vim.keymap.set('n', '<leader>ac', function() require('opencode').command 'session.compact' end, { desc = '[A]: [c]ompact session' })
vim.keymap.set('n', '<leader>am', function() require('opencode').command 'session.select' end, { desc = '[A]: session select' })