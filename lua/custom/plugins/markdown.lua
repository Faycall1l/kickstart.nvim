-- Markdown & docs: beautiful rendered Markdown buffers.

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- Preset tuned for note-taking/docs; 'default' and 'lazy' are alternatives
  preset = 'obsidian',
  render_modes = { 'n', 'v' },
  completions = {
    blink = { enabled = true }, -- Completion in code blocks via blink.cmp
  },
  heading = {
    sign = true,
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    position = 'inline',
    width = 'block',
  },
  code = {
    sign = true,
    width = 'block',
    right_pad = 1,
    min_width = 40,
  },
  checkbox = {
    unchecked = { icon = '󰄱 ' },
    checked = { icon = '󰱒 ' },
  },
}