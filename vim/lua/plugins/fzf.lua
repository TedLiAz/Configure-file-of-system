local M = {}

function M.setup()
    local actions = require("fzf-lua.actions")

    require("fzf-lua").setup({
        winopts = {
            height = 0.85,
            width = 0.8,
            row = 0.35,
            col = 0.5,
            git_icons = true,
            file_icons = true,
            color_icons = true,
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            preview = {
                border = "border",
                wrap = "nowrap",
                hidden = "nohidden",
                vertical = "up:65%",
                horizontal = "right:60%",
                layout = "vertical",
                flip_columns = 120,
                title = true,
                title_pos = "center",
                scrollbar = "float",
                scrolloff = "-2",
                scrollchars = { "█", "" },
                delay = 0,
                winopts = {
                    number = true,
                    relativenumber = false,
                    cursorline = true,
                    cursorlineopt = "both",
                    cursorcolumn = false,
                    signcolumn = "no",
                    list = false,
                    foldenable = false,
                    foldmethod = "manual",
                },
            },
        },
        keymap = {
            builtin = {
                ["<M-d>"] = "preview-page-down",
                ["<M-u>"] = "preview-page-up",
            },
            fzf = {
                ["alt-j"] = "down",
                ["alt-k"] = "up",
            },
        },
        action = {
            files = {
                ["default"] = actions.file_edit_or_qf,
                ["ctrl-s"] = actions.file_split,
                ["ctrl-v"] = actions.file_vsplit,
                ["ctrl-t"] = actions.file_tabedit,
            },
            buffers = {
                ["default"] = actions.buf_edit,
                ["ctrl-s"] = actions.buf_split,
                ["ctrl-v"] = actions.buf_vsplit,
                ["ctrl-t"] = actions.buf_tabedit,
            },
        },
        files = {
            prompt = "Files> ",
        },
        grep_cword = {
            glob_flag = "--iglob",
            multiprocess = true,
            rg_opts = "--sort none -U --mmap --hidden -j9 --column --line-number --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
        },
        grep_visual = {
            multiprocess = true,
            rg_opts = "--sort none -U --mmap --hidden -j9 --column --line-number --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
        },
        tags_grep_cword = {
            prompt = "Tags❯ ",
            ctags_file = "tags",
            multiprocess = true,
            rg_opts = "--no-heading --color=auto --smart-case",
            grep_opts = "--color=auto --perl-regexp",
            no_header = false,
            no_header_i = false,
        },
        btags = {
            prompt = "BTags❯ ",
            ctags_file = "tags",
            rg_opts = "--sort none -U --mmap -j9 --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
            grep_opts = "--color=auto --perl-regexp",
            multiprocess = true,
            fzf_opts = { ["--info"] = "default", ["--tiebreak"] = "begin" },
        },
        buffers = {
            prompt = "Buffers❯ ",
            sort_lastused = true,
        },
        previewers = {
            bat = {
                cmd = "bat",
                args = "--style=numbers,changes --color auto --line-range :500 {}",
                theme = "Coldark-Dark",
                config = nil,
            },
        },
    })

    vim.keymap.set("n", "<M-f>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
    vim.keymap.set("n", "<M-g>", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true })
    vim.keymap.set("v", "<M-g>", "<cmd>lua require('fzf-lua').grep_visual()<CR>", { silent = true })
    vim.keymap.set("n", "<M-]>", "<cmd>:lua require('fzf-lua').tags_grep_cword()<CR>", { silent = true })
    vim.keymap.set("n", "<F2>", "<cmd>:lua require('fzf-lua').btags()<CR>", { silent = true })
    vim.keymap.set("n", "<M-b>", "<cmd>:lua require('fzf-lua').buffers()<CR>", { silent = true })
end

return M
