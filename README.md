# kickstart.nvim — AI Engineering Edition

An **AI Engineering** take on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim):
Python/ML notebooks, TypeScript/JavaScript, Rust/C++, data & config files, Markdown docs,
and an AI assistant (OpenCode) — all on a fork that stays **syncable with upstream.**

- Small, single-file core: `init.lua` is the upstream file, near-untouched.
- All AI Engineering features live in `lua/custom/plugins/` (the official
  escape hatch kickstart documents), with an explicit loader.
- PR-your-features or keep your fork in sync with `nvim-lua/kickstart.nvim` by
  fast-forwarding just `master`.

**NOT** a Neovim distribution — a starting point, documented top-to-bottom.

---

## Table of Contents

- [What's inside](#whats-inside)
- [Installation](#installation)
- [AI Engineering Stack](#ai-engineering-stack)
- [Keymaps](#keymaps)
- [How it's structured](#how-its-structured)
- [FAQ](#faq)
- [Install Recipes](#install-recipes)
- [Alternative Neovim installation methods](#alternative-neovim-installation-methods)

---

## What's inside

| Area | What you get | Where |
| :--- | :--- | :--- |
| **Python / ML** | `basedpyright` LSP (Pylance features), `ruff` lint+format, debugpy debugging, type checking | `lsp.lua`, `format.lua`, `debug.lua` |
| **Notebooks** | edit `.ipynb` as plain text (`jupytext.nvim`) + run cells in a live Jupyter kernel (`molten-nvim`) | `notebooks.lua` |
| **TypeScript/JS** | `ts_ls` LSP, inlay hints, `prettierd` formatting | `lsp.lua`, `format.lua` |
| **Rust** | `rust_analyzer` with clippy + inlay hints | `lsp.lua` |
| **C/C++** | `clangd` LSP | `lsp.lua` |
| **Data & config** | `csvview.nvim` (CSV/TSV), `yamlls`, `taplo` | `data.lua`, `lsp.lua` |
| **Markdown & docs** | `render-markdown.nvim` (obsidian preset), `markdownlint` | `markdown.lua`, `format.lua` |
| **AI assistant** | `opencode.nvim` — ask/review/fix/document with OpenCode | `ai.lua` |
| **Quality of life** | `oil.nvim`, `undotree`, `flash.nvim` | `qol.lua` |

Everything installs automatically through **Mason** (`:Mason` to inspect).
Nothing blocks: run `:checkhealth` and fix only the tools you actually want.

---

## Installation

### Install Neovim

Targets the latest [stable](https://github.com/neovim/neovim/releases/tag/stable)
(0.11+) and [nightly](https://github.com/neovim/neovim/releases/tag/nightly).
Check your version with `nvim --version`. If your package manager ships an
outdated Neovim, see [Alternative installation methods](#alternative-neovim-installation-methods).

### Install External Dependencies

- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation) (used by Telescope)
- A [Nerd Font](https://www.nerdfonts.com/) — **enabled by default** in this fork
  (`vim.g.have_nerd_font = true`). If you don't use one, flip it back to `false`.
- Clipboard tool (xclip/xsel/win32yank) depending on your platform.
- Optional, per-language tooling (used by Mason to resolve non-LSP tools):
  - **Python**: a `python3` with `jupyter` + `ipykernel` (for `molten-nvim`), and
    `jupytext` (for `jupytext.nvim`). E.g. `python3 -m pip install jupyter ipykernel jupytext`.
    Activating a virtualenv before opening Neovim makes both molten and the Python
    debugger use it automatically.
  - **TypeScript/JS**: `node` + `npm`.
  - **OpenCode**: the `opencode` CLI on `$PATH`
    (see [opencode.ai](https://opencode.ai)). `opencode.nvim` starts an
    integrated server (`opencode --port`) if none is running.

> [!NOTE]
> See [Install Recipes](#install-recipes) for Windows and Linux specifics.

### Install Kickstart

> [!NOTE]
> [Backup](#faq) your previous configuration (if any exists).

Neovim's configurations are located at (depending on your OS):

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd) | `%localappdata%\nvim\` |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim\` |

<details><summary>Linux / MacOS</summary>

```sh
git clone https://github.com/Faycall1l/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary>Windows (PowerShell)</summary>

```powershell
git clone https://github.com/Faycall1l/kickstart.nvim.git $env:LOCALAPPDATA\nvim
```

</details>

On first launch, `vim.pack` will download all plugins and Mason will install the
toolchain automatically. Then run `:checkhealth` to see what's ready.

---

## AI Engineering Stack

### Python / ML (`<leader>` + LSP defaults)

- `basedpyright` — pyright fork with Pylance-ported features: completions,
  inlay hints, semantic tokens, type checking (`basic`), navigation, refactors.
- `ruff` — linting (nvim-lint) and formatting (`ruff_format`) on save via conform.
- `debugpy` — full debugging via `nvim-dap` (see [Keymaps](#keymaps)).

### Jupyter notebooks

Editing an `.ipynb`:

- `jupytext.nvim` transparently opens notebooks as **`py:percent`** text — so it's
  readable, diffable, and `basedpyright`/`ruff` work inside notebook code.
- `molten-nvim` runs cells against a live Jupyter kernel. Output appears as
  virtual text or in a floating window; plots/images/LateX are supported.
- `]n` / `[n` jump between cells.

The full `keymaps under <leader>m ([M]olten)`:

| Key | Action |
| :--- | :--- |
| `<leader>mi` | Initialize kernel |
| `<leader>mc` | Re-run current cell |
| `<leader>ml` | Evaluate current line |
| `<leader>me` (n/x) | Evaluate operator / visual selection |
| `<leader>ms` / `<leader>mh` | Show / hide output |
| `<leader>md` | Delete cell |
| `<leader>mr` | Restart kernel |

### Data & config files

- `csvview.nvim` auto-enables on `*.csv` / `*.tsv`: Excel-like navigation
  (`<Tab>` / `<Enter>`), text objects (`if` / `af`). Toggle with `<leader>xv`,
  inspect with `<leader>xi`.
- YAML / TOML get `yamlls` / `taplo` LSPs; both are formatted on save.

### Markdown

`render-markdown.nvim` (obsidian preset) turns Markdown buffers into rendered
docs. Toggle with `<leader>tr`. `markdownlint` lints Markdown via nvim-lint.

### AI assistant (OpenCode)

`<leader>a` is the **`[A]I Assistant`** group:

| Key | Action |
| :--- | :--- |
| `<leader>aa` | Ask OpenCode (prompt input) |
| `<leader>as` | Select prompt / command |
| `<leader>ae` | Explain `@this` |
| `<leader>ar` | Review `@this` |
| `<leader>af` | Fix `@diagnostics` |
| `<leader>at` | Add tests for `@this` |
| `<leader>ad` | Document `@this` |
| `<leader>an` / `<leader>ac` | New / compact session |

Context placeholders: `@this`, `@buffer`, `@diagnostics`, `@quickfix`, etc.
When OpenCode proposes an edit, the target file opens in a new tab with
`:diffpatch` — accept whole (`da`), hunk (`dp`), or reject (`dr`).

### Debugging (Python)

| Key | Action |
| :--- | :--- |
| `<F5>` | Start / continue |
| `<F1>` / `<F2>` / `<F3>` | Step into / over / out |
| `<F7>` | Toggle DAP UI |
| `<leader>db` / `<leader>dB` | Toggle / conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>ds` | Toggle UI |
| `<leader>dt` | Terminate |
| `<leader>dp` | DAP REPL |

`debugpy` is auto-installed via Mason; pytest is the default test runner, and the
active virtualenv is used when set.

---

## Keymaps

Upstream keymaps are preserved. Added leader groups:

| Prefix | Group |
| :--- | :--- |
| `<leader>a` | `[A]I Assistant` |
| `<leader>m` | `[M]olten` |
| `<leader>o` | `[O]il` |
| `<leader>d` | `[D]ebug` |

Plus: `<leader>u` undotree, `<leader>xv` / `<leader>xi` csvview,
`<leader>tr` render-markdown, `s`/`S`/`r`/`R` flash jumps, `-` open oil.

Also upstream quality-of-life shortcuts still apply (`<leader>f` format,
`<leader>sh` help search, etc.) — press `<space>` and which-key will show them.

---

## How it's structured

```
init.lua                      <- upstream, near-untouched (Nerd Font flag + loader)
lua/custom/plugins/
  init.lua                    <- explicit, dependency-aware loader
  config.lua                  <- PATH, Mason toolchain, which-key groups
  lsp.lua                     <- basedpyright, ts_ls, rust_analyzer, clangd, yamlls, taplo
  treesitter.lua              <- extra parsers
  format.lua                  <- conform override + nvim-lint
  notebooks.lua               <- jupytext.nvim + molten-nvim
  data.lua                    <- csvview.nvim
  markdown.lua                <- render-markdown.nvim
  debug.lua                   <- nvim-dap + debugpy
  qol.lua                     <- oil.nvim, undotree, flash.nvim
  ai.lua                      <- opencode.nvim
lua/kickstart/                <- upstream modules (health, optional plugins)
```

### Keeping in sync with upstream

`master` tracks `nvim-lua/kickstart.nvim`. All downstream work happens on
`dev/ai-engineering` and `feature/*` branches. To resync:

```sh
git checkout master
git pull upstream master
git checkout dev/ai-engineering
git merge master
```

Because the AI layer lives entirely in `lua/custom/plugins/`, merges stay
conflict-free almost always — that "escape hatch" directory is upstream's promise.

### Updating

Plugins use the built-in `vim.pack`:

```lua
:lua vim.pack.update()                    -- install/update all plugins
:lua vim.pack.update(nil, { offline = true }) -- inspect pending updates
```

---

## FAQ

* What if I want to update or uninstall?
  * Uninstall: remove your config directory and local data directory
    (e.g. `~/.config/nvim` and `~/.local/share/nvim`).
  * Reinstall plugins from scratch: `rm -rf ~/.local/share/nvim/pack` (or the
    matching path for your `NVIM_APPNAME`).
* Do I need to install all the AI tools?
  * No. Mason only installs the toolchain on `:Mason`/first run. Run
    `:checkhealth` and ignore warnings for languages you don't use.
* Notebooks require Jupyter — do I need the full JupyterLab?
  * No. `molten-nvim` needs a kernel, i.e. `jupyter` + `ipykernel`
    (`python3 -m pip install jupyter ipykernel`). `jupytext` is used only when
    opening `.ipynb` files as text.
* Why is `init.lua` still one file? Why are my plugins split?
  * `init.lua` stays upstream to make syncing trivial; the split
    `lua/custom/plugins/` layer is the officially documented integration point
    and keeps each concern in one small file.
* What happened to `lazy.nvim`?
  * Upstream kickstart migrated to Neovim's built-in `vim.pack` manager; this
    fork follows that.

---

## Install Recipes

After installing all dependencies, continue with
[Install Kickstart](#install-kickstart).

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>

Kickstart's default config is make-only for `telescope-fzf-native.nvim`.
If `make` is unavailable, a CMake fallback can be enabled in the `PackChanged`
hook inside `init.lua` (upstream documents both variants inline).

</details>
<details><summary>Windows with gcc/make using chocolatey</summary>

```sh
choco install -y neovim git ripgrep wget fd unzip gzip mingw make tree-sitter
```

</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```sh
wsl --install
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip neovim
```

</details>

#### Linux Install

<details><summary>Ubuntu</summary>

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip neovim
```

</details>
<details><summary>Debian</summary>

```sh
sudo apt update
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip curl
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```

</details>
<details><summary>Fedora</summary>

```sh
sudo dnf install -y gcc make git ripgrep fd-find tree-sitter-cli unzip neovim
```

</details>
<details><summary>Arch</summary>

```sh
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd tree-sitter-cli unzip neovim
```

</details>

---

## Alternative Neovim installation methods

<details><summary>Bob</summary>

[Bob](https://github.com/MordechaiHadad/bob) is a Neovim version manager:

```bash
rustup default stable && rustup update stable
cargo install bob-nvim
bob use stable
```

</details>

<details><summary>Homebrew</summary>

```sh
brew install neovim
```

</details>

<details><summary>Flatpak</summary>

Install [flatpak](https://flathub.org/setup) then
`flatpak install flathub io.neovim.nvim`.

</details>

<details><summary>mise</summary>

```bash
mise plugins install neovim
mise use neovim@stable
```

</details>

---

Enjoy your AI Engineering Neovim! ✨