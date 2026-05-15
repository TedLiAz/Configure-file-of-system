local M = {}

function M.setup()
    vim.cmd("packadd nvim-treesitter")

    require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            local ok = pcall(vim.treesitter.start, args.buf)
            if not ok then
                return
            end

            local win = vim.api.nvim_get_current_win()
            vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[win].foldmethod = "expr"
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
end

return M
