local M = {}

function M.setup_coc()
    vim.opt.backup = false
    vim.opt.writebackup = false
    vim.opt.updatetime = 300
    vim.opt.signcolumn = "number"

    local keyset = vim.keymap.set
    local opts = { silent = true, expr = true, replace_keycodes = false }

    _G.check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
    keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
    keyset("n", "gd", "<Plug>(coc-definition)", { silent = true, nowait = true })
    keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true, nowait = true })
    keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true, nowait = true })
    keyset("n", "gr", "<Plug>(coc-references)", { silent = true, nowait = true })

    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
    })

    keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
end

return M
