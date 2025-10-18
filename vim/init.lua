-- enable line number
vim.o.number = true
-- set tab to 4 space
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.ignorecase = true
vim.o.cursorline = true
vim.o.colorcolumn = "150"
-- vim.cmd("highlight ColorColumn ctermbg=238")
vim.o.textwidth = 150
vim.g.mapleader = " "
-- vim.o.mouse = "a"
-- Don't hightlight search results
vim.o.hlsearch = false
vim.api.nvim_set_keymap('n' , '<M-o>' , '<C-o>' , {noremap = true})


--------------- neoscroll setup begin -----------------------------------
neoscroll = require('neoscroll')
local keymap = {
    ["<M-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end;
    ["<M-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end;
    ["<M-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 100 }) end;
    ["<M-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 100 }) end;
    ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end;
    ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
    ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end;
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func)
end
--------------- neoscroll setup end -----------------------------------

--------------- fzf-lua setup begin -----------------------------------
local actions = require "fzf-lua.actions"
require'fzf-lua'.setup
{
    winopts = {
        height      = 0.85,
        width       = 0.80,
        row         = 0.35,
        col         = 0.50,
        git_icons   = true,
        file_icons  = true,
        color_icons = true,
        border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        preview = {
            -- default     = 'bat',           -- override the default previewer?
            -- default uses the 'builtin' previewer
            border         = 'border',        -- border|noborder, applies only to
            -- native fzf previewers (bat/cat/git/etc)
            wrap           = 'nowrap',        -- wrap|nowrap
            hidden         = 'nohidden',      -- hidden|nohidden
            vertical       = 'up:65%',        -- up|down:size
            horizontal     = 'right:60%',     -- right|left:size
            layout         = 'vertical',          -- horizontal|vertical|flex
            flip_columns   = 120,             -- #cols to switch to horizontal on flex
            -- Only used with the builtin previewer:
            title          = true,            -- preview border title (file/buf)?
            title_pos      = "center",        -- left|center|right, title alignment
            scrollbar      = 'float',         -- `false` or string:'float|border'
            -- float:  in-window floating border
            -- border: in-border chars (see below)
            scrolloff      = '-2',            -- float scrollbar offset from right
            -- applies only when scrollbar = 'float'
            scrollchars    = {'█', '' },      -- scrollbar chars ({ <full>, <empty> }
            -- applies only when scrollbar = 'border'
            delay          = 0,             -- delay(ms) displaying the preview
            -- prevents lag on fast scrolling
            winopts = {                       -- builtin previewer window options
                number            = true,
                relativenumber    = false,
                cursorline        = true,
                cursorlineopt     = 'both',
                cursorcolumn      = false,
                signcolumn        = 'no',
                list              = false,
                foldenable        = false,
                foldmethod        = 'manual',
            },
        } ,
    },
    keymap = {
        builtin = {
            -- neovim `:tmap` mapping for the fzf win
            ["<M-d>"] = "preview-page-down",
            ["<M-u>"] = "preview-page-up",
        },
        fzf = {
            -- fzf '--bind=' options
            ["alt-j"] = "down",
            ["alt-k"] = "up",
        }
    },
    action = {
        -- These override the default tables completely
        -- no need to set to `false` to disable an action
        -- delete or modify is sufficient
        files = {
            -- providers that inherit these actions:
            --   files, git_files, git_status, grep, lsp
            --   oldfiles, quickfix, loclist, tags, btags
            --   args
            -- default action opens a single selection
            -- or sends multiple selection to quickfix
            -- replace the default action with the below
            -- to open all files whether single or multiple
            -- ["default"]     = actions.file_edit,
            ["default"]     = actions.file_edit_or_qf,
            ["ctrl-s"]      = actions.file_split,
            ["ctrl-v"]      = actions.file_vsplit,
            ["ctrl-t"]      = actions.file_tabedit,
        },
        buffers = {
            -- providers that inherit these actions:
            --   buffers, tabs, lines, blines
            ["default"]     = actions.buf_edit,
            ["ctrl-s"]      = actions.buf_split,
            ["ctrl-v"]      = actions.buf_vsplit,
            ["ctrl-t"]      = actions.buf_tabedit,
        },
    },
    files = {
        vim.api.nvim_set_keymap('n', '<M-f>', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true }),
        prompt = 'Files> ',
    },
    grep_cword = {
        vim.api.nvim_set_keymap('n', '<M-g>', "<cmd>lua require('fzf-lua').grep_cword()<CR>", { noremap = true, silent = true }),
        glob_flag    = "--iglob",
        multiprocess = true,
        rg_opts      = "--sort none -U --mmap --hidden -j9 --column --line-number --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
    },
    grep_visual = {
        vim.api.nvim_set_keymap('v', '<M-g>', "<cmd>lua require('fzf-lua').grep_visual()<CR>", { noremap = true, silent = true }),
        multiprocess = true,
        rg_opts      = "--sort none -U --mmap --hidden -j9 --column --line-number --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
    },
    tags_grep_cword = {
        vim.api.nvim_set_keymap('n', '<M-]>', "<cmd>:lua require('fzf-lua').tags_grep_cword()<CR>", { noremap = true, silent = true }),
        prompt       = 'Tags❯ ',
        ctags_file   = "tags",
        multiprocess = true,
        -- 'tags_live_grep' options, `rg` prioritizes over `grep`
        rg_opts      = "--no-heading --color=auto --smart-case",
        grep_opts    = "--color=auto --perl-regexp",
        no_header    = false,    -- hide grep|cwd header?
        no_header_i  = false,    -- hide interactive header?
    },
    btags = {
        vim.api.nvim_set_keymap('n', '<F2>', "<cmd>:lua require('fzf-lua').btags()<CR>", { noremap = true, silent = true }),
        prompt       = 'BTags❯ ',
        ctags_file   = "tags",
        rg_opts      = "--sort none -U --mmap -j9 --no-heading --color=auto --smart-case  -g '!{.git,node_modules}/*'",
        grep_opts    = "--color=auto --perl-regexp",
        multiprocess = true,
        fzf_opts     = { ["--info"] = "default", ["--tiebreak"] = "begin" },
    } ,
    buffers = {
        vim.api.nvim_set_keymap('n', '<M-b>', "<cmd>:lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true }),
        prompt        = 'Buffers❯ ',
        sort_lastused = true,         -- sort buffers() by last used
    },
    previewers = {
        bat = {
            cmd    = "bat",
            args   = "--style=numbers,changes --color auto --line-range :500 {}",
            theme  = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
            config = nil,            -- nil uses $BAT_CONFIG_PATH
        },
    },
}
--------------- fzf-lua setup end -----------------------------------

--------------- themes setup begin --------------------------------
require("gruvbox").setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})
vim.o.background = "dark" -- or "light" for light mode
vim.cmd("colorscheme gruvbox")
--------------- themes setup end --------------------------------

--------------- vim-autoformat begin -----------------------------
vim.api.nvim_set_keymap('n' , '<F5>' , ':Autoformat<CR>' , {noremap = true})
vim.api.nvim_set_keymap('v' , '<F5>' , ':Autoformat<CR>' , {})
vim.g.formatters_python = {'yapf'}
vim.g.formatter_yapf_style ='facebook'
vim.g.autoformat_verbosemode = 1
--------------- vim-autoformat end -----------------------------

--------------- tabular setup begin -----------------------------
vim.api.nvim_set_keymap('n' , '<F4>' , ':Tabularize /'   , {noremap = true})
vim.api.nvim_set_keymap('v' , '<F4>' , ':Tabularize /'   , {})
--------------- tabular setup end -----------------------------

--------------- vim-interestingwords setup begin -----------------------------
vim.api.nvim_set_keymap('n' , 'K'    , ':call InterestingWords("n")<CR>' , {noremap = true , silent = true})
vim.api.nvim_set_keymap('v' , 'K'    , ':call InterestingWords("v")<CR>' , {silent = true})
vim.api.nvim_set_keymap('n' , 'n'    , ':call WordNavigation(1)<CR> '    , {noremap = true , silent = true})
vim.api.nvim_set_keymap('n' , 'N'    , ':call WordNavigation(0)<CR> '    , {noremap = true , silent = true})
vim.api.nvim_set_keymap('n' , '<F3>' , ':call UncolorAllWords()<CR> '    , {noremap = true , silent = true})
vim.g.interestingWordsRandomiseColors = 1
--------------- vim-interestingwords setup end -----------------------------

--------------- vim-visual-multi setup begin -----------------------------
vim.api.nvim_exec([[
let g:VM_maps = {}                            "取消默认按键映射。
let g:VM_maps['Find Under']         = '<M-n>' "进入多光标模式并选中光标下字符串。
let g:VM_maps['Find Subword Under'] = '<M-n>' "选中下一个字符串。
let g:VM_maps['Find Next']          = 'n'     "往下查找并增加光标。
let g:VM_maps['Find Prev']          = 'N'     "往上查找并增加光标。
let g:VM_maps['Skip Region']        = 'q'     "跳过当前光标到下一个。
let g:VM_maps['Remove Region']      = 'Q'     "取消当前光标。
let g:VM_maps['Select All']         = '\vA'   "进入多光标模式并选中所有同光标下的字符串。
let g:VM_maps['Undo']               = 'u'     "Undo.
let g:VM_maps['Redo']               = '<M-r>' "Redo.
]],false)
--------------- vim-visual-multi setup end -----------------------------

--------------- hop setup begin -----------------------------
require('hop').setup {
    HopChar1 = {
        vim.api.nvim_set_keymap('n', 'f', "<cmd>HopChar1<CR>",{noremap = true}),
        keys = 'etovxqpdygfblzhckisuran'
    },
}
--------------- hop setup end -----------------------------


--------------- coc.nvim setup begin ----------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "number"
-- vim.opt.signcolumn = "yes"
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- Use <c-j> to trigger snippets
-- keyset("i", "<M-j>", "<Plug>(coc-snippets-expand-jump)")
-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})
-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
--------------- coc.nvim setup end ----------------

--------------- alpha-nvim setup begin ----------------
require'alpha'.setup(require'alpha.themes.startify'.config)
--------------- alpha-nvim setup end ----------------

--------------- windline.nvim setup begin ----------------
require('wlsample.bubble')
--------------- windline.nvim setup end ----------------

-------------- rainbow-delimiters begin ------------------------
require('rainbow-delimiters.setup').setup {}
-------------- rainbow-delimiters end ------------------------

-------------- indent-blankline begin ------------------------
local highlight = {
    "RainbowRed"    ,
    "RainbowYellow" ,
    "RainbowBlue"   ,
    "RainbowOrange" ,
    "RainbowGreen"  ,
    "RainbowViolet" ,
    "RainbowCyan"   ,
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
end)
vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup {
    scope = {
        enabled    = true,
        show_start = false,
        show_end   = false,
        priority   = 500,
        highlight  = highlight
    }
}
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
-------------- indent-blankline end ------------------------

-------------- nvim-treesitter begin --------------------------
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "cpp","python","make","c", "lua", "vim", "vimdoc", "query" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },
    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {"c", "rust","lua","cpp"},
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
            scope_incremental = '<TAB>'
        },
    },
}


---------------- nvim-treesitter end --------------------------
return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim'      }
    use { 'karb94/neoscroll.nvim'       }
    use { 'roxma/vim-tmux-clipboard'    }

    -- Themes Begin
    use { 'daltonmenezes/aura-theme' }
    use { "ellisonleao/gruvbox.nvim"    }
    use { 'windwp/windline.nvim'        }
    -- Themes End

    use { 'lukas-reineke/indent-blankline.nvim' }
    use { 'HiPhish/rainbow-delimiters.nvim'}
    use { 'Chiel92/vim-autoformat'      }
    use { 'godlygeek/tabular'           }
    use { 'lfv89/vim-interestingwords'  }
    use { 'mg979/vim-visual-multi'      }
    use { 'phaazon/hop.nvim'            }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'ibhagwan/fzf-lua'   , requires = { 'kyazdani42/nvim-web-devicons' }}
    use { 'neoclide/coc.nvim'  , branch   = 'release'}
    use { 'goolord/alpha-nvim' , requires = { 'nvim-tree/nvim-web-devicons' , 'nvim-lua/plenary.nvim' }}
end)


