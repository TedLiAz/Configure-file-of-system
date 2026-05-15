local M = {}

function M.setup_autoformat()
    vim.keymap.set("n", "<F5>", ":Autoformat<CR>")
    vim.keymap.set("v", "<F5>", ":Autoformat<CR>", {})
    vim.g.formatters_python = { "yapf" }
    vim.g.formatter_yapf_style = "facebook"
    vim.g.autoformat_verbosemode = 1
end

function M.setup_tabular()
    vim.keymap.set("n", "<F4>", ":Tabularize /")
    vim.keymap.set("v", "<F4>", ":Tabularize /", {})
end

function M.setup_interestingwords()
    vim.keymap.set("n", "K", ":call InterestingWords(\"n\")<CR>", { silent = true })
    vim.keymap.set("v", "K", ":call InterestingWords(\"v\")<CR>", { silent = true })
    vim.keymap.set("n", "n", ":call WordNavigation(1)<CR> ", { silent = true })
    vim.keymap.set("n", "N", ":call WordNavigation(0)<CR> ", { silent = true })
    vim.keymap.set("n", "<F3>", ":call UncolorAllWords()<CR> ", { silent = true })
    vim.g.interestingWordsRandomiseColors = 1
end

function M.setup_visual_multi()
    vim.g.VM_maps = {
        ["Find Under"] = "<M-n>",
        ["Find Subword Under"] = "<M-n>",
        ["Find Next"] = "n",
        ["Find Prev"] = "N",
        ["Skip Region"] = "q",
        ["Remove Region"] = "Q",
        ["Select All"] = "\\vA",
        ["Undo"] = "u",
        ["Redo"] = "<M-r>",
    }
end

return M
