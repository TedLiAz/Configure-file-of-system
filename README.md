# Configure-file-of-system

Personal Linux desktop and editor configuration files, organized by tool.

## Layout

- `vim/` contains the active Neovim setup. `init.lua` is the entrypoint and the current configuration is split into `lua/core/` and `lua/plugins/`.
- `i3/`, `polybar/`, `alacritty/`, `ranger/`, and `zsh/` keep window manager, bar, terminal, file manager, and shell settings.
- `skills/` contains custom AI Agent skills (e.g. `refine-prompt`) compatible with CodeBuddy, Antigravity, and Claude/Agents, along with a `sync.sh` deployment script.

## Skills (CodeBuddy / Antigravity / Agents)

Custom workflows and prompt-engineering skills for AI coding agents:

- `skills/refine-prompt`: Converts raw or ambiguous requirements into structured, executable AI prompts with explicit bounds and acceptance criteria.
- `skills/sync.sh`: Idempotent shell script to link all skills in this repo into local agent discovery roots (`~/.codebuddy/skills`, `~/.gemini/config/skills`, and `~/.agents/skills`).

### Deploy to New Machine

```bash
git clone https://github.com/TedLiAz/Configure-file-of-system.git ~/Documents/Configure-file-of-system
cd ~/Documents/Configure-file-of-system

# Auto-detect installed agents and link:
./skills/sync.sh

# Or explicitly sync to CodeBuddy:
./skills/sync.sh --codebuddy
```

## Neovim

The repository now tracks the current modular Neovim configuration used on this machine:

- `vim/lua/core/options.lua` for editor defaults
- `vim/lua/core/keymaps.lua` for shared mappings
- `vim/lua/plugins/*.lua` for plugin registration and setup

Main plugins include `packer.nvim`, `coc.nvim`, `fzf-lua`, `hop.nvim`, `neoscroll.nvim`, `gruvbox.nvim`, `alpha-nvim`, and `nvim-treesitter`.

## Notes

- `vim/init.vim` is kept as the older Vimscript configuration.
- `vim/clang-format` mirrors the `.clang-format` used in `Zero-Jitter-Forge` for C/C++ formatting defaults.
- Validate shell helpers with `bash -n` and Neovim Lua files with `luac -p`.
