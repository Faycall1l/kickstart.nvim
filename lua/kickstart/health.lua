--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.12') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

-- AI Engineering toolchain checks (see README for what each tool powers)
local check_aie_toolchain = function()
  local checks = {
    { exe = 'python3', warn = 'Python LSP/debugger fall back to system python; notebooks (molten) need python3 with jupyter + ipykernel' },
    { exe = 'node', warn = 'TypeScript/JS support and prettierd need node on PATH' },
    { exe = 'rust-analyzer', warn = 'Rust LSP not found on PATH; it will be installed via Mason on launch' },
    { exe = 'jupyter', warn = 'Molten notebook cells need jupyter + ipykernel (pip install jupyter ipykernel)' },
    { exe = 'jupytext', warn = 'Editing .ipynb as text needs the jupytext CLI (pip install jupytext)' },
    { exe = 'opencode', warn = 'The [A]I Assistant (opencode.nvim) needs the opencode CLI on PATH (see opencode.ai)' },
  }

  for i, check in ipairs(checks) do
    if vim.fn.executable(check.exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", check.exe))
    elseif check.warn then
      vim.health.warn(string.format("Could not find executable: '%s' — %s", check.exe, check.warn))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", check.exe))
    end
  end

  -- Active virtualenv hint for Python debugging / notebook workflow
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= '' then
    vim.health.ok(string.format("Active virtualenv detected: '%s' (python/debug/notebooks will use it)", venv))
  else
    vim.health.info "No VIRTUAL_ENV active — system python will be used for notebook/debug tooling"
  end
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
    check_aie_toolchain()
  end,
}