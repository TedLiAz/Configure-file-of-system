local M = {}

function M.setup_neoscroll()
    local neoscroll = require("neoscroll")
    local keymaps = {
        ["<M-u>"] = function()
            neoscroll.ctrl_u({ duration = 250 })
        end,
        ["<M-d>"] = function()
            neoscroll.ctrl_d({ duration = 250 })
        end,
        ["<M-y>"] = function()
            neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
        end,
        ["<M-e>"] = function()
            neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
        end,
        ["zt"] = function()
            neoscroll.zt({ half_win_duration = 250 })
        end,
        ["zz"] = function()
            neoscroll.zz({ half_win_duration = 250 })
        end,
        ["zb"] = function()
            neoscroll.zb({ half_win_duration = 250 })
        end,
    }

    for key, callback in pairs(keymaps) do
        vim.keymap.set({ "n", "v", "x" }, key, callback)
    end
end

function M.setup_hop()
    vim.keymap.set("n", "f", "<cmd>HopChar1<CR>", { noremap = true })
    require("hop").setup({
        HopChar1 = {
            keys = "etovxqpdygfblzhckisuran",
        },
    })
end

return M
