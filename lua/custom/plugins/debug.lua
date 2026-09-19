-- Python debugging: nvim-dap + nvim-dap-ui + nvim-dap-python (debugpy).
--
-- Separate from the upstream kickstart debug.lua (Go-focused, opt-in);
-- this enables a full debugger for the Python/ML stack out of the box.

vim.pack.add {
  { 'https://github.com/mfussenegger/nvim-dap', version = vim.version.range '0.10.*' },
  { 'https://github.com/rcarriga/nvim-dap-ui', version = vim.version.range '4.*' },
  { 'https://github.com/nvim-neotest/nvim-nio', version = vim.version.range '1.*' },
  { 'https://github.com/jay-babu/mason-nvim-dap.nvim', version = vim.version.range '2.*' },
  { 'https://github.com/mfussenegger/nvim-dap-python' },
}

local dap = require 'dap'
local dapui = require 'dapui'

-- Basic debugging keymaps (F-keys mirror the upstream Go debug config so
-- muscle memory is shared across languages)
vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: Toggle DAP UI' })

-- Leader-based alternatives
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = '[D]ebug: toggle [b]reakpoint' })
vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = '[D]ebug: conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = '[D]ebug: [c]ontinue/start' })
vim.keymap.set('n', '<leader>ds', function() dapui.toggle() end, { desc = '[D]ebug: toggle UI' })
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = '[D]ebug: [t]erminate' })
vim.keymap.set('n', '<leader>dp', function() dap.repl.open() end, { desc = '[D]ebug: [p]ython REPL' })

-- DAP UI
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = { 'debugpy' },
}

vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  vim.fn.sign_define('Dap' .. type, { text = icon, texthl = 'DapBreak', numhl = 'DapBreak' })
end
vim.fn.sign_define('DapStopped', { text = breakpoint_icons.Stopped, texthl = 'DapStop', numhl = 'DapStop' })

---@diagnostic disable-next-line: missing-fields
dapui.setup {}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Python adapter using the *active venv* if present, else `python`.
-- debugpy (installed via mason-nvim-dap `ensure_installed`) is resolved from PATH.
local default_python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python'
require('nvim-dap-python').setup(default_python, {
  test_runner = 'pytest',
})
