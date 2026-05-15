# Configure-file-of-system

Personal Linux desktop and editor configuration files, organized by tool.

## Layout

- `vim/` contains the active Neovim setup. `init.lua` is the entrypoint and the current configuration is split into `lua/core/` and `lua/plugins/`.
- `i3/`, `polybar/`, `alacritty/`, `ranger/`, and `zsh/` keep window manager, bar, terminal, file manager, and shell settings.

## Neovim

The repository now tracks the current modular Neovim configuration used on this machine:

- `vim/lua/core/options.lua` for editor defaults
- `vim/lua/core/keymaps.lua` for shared mappings
- `vim/lua/plugins/*.lua` for plugin registration and setup

Main plugins include `packer.nvim`, `coc.nvim`, `fzf-lua`, `hop.nvim`, `neoscroll.nvim`, `gruvbox.nvim`, `alpha-nvim`, and `nvim-treesitter`.

## Notes

- `vim/init.vim` is kept as the older Vimscript configuration.
- Validate shell helpers with `bash -n` and Neovim Lua files with `luac -p`.
