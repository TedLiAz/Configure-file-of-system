local M = {}

local function safe_require(module_name)
    local ok, module = pcall(require, module_name)
    if not ok then
        vim.notify(("Failed to load %s: %s"):format(module_name, module), vim.log.levels.ERROR)
        return nil
    end

    return module
end

local function safe_call(label, callback)
    local ok, err = pcall(callback)
    if not ok then
        vim.notify(("Failed to configure %s: %s"):format(label, err), vim.log.levels.ERROR)
    end
end

function M.configure()
    local appearance = safe_require("plugins.appearance")
    local editing = safe_require("plugins.editing")
    local motion = safe_require("plugins.motion")
    local treesitter = safe_require("plugins.treesitter")
    local fzf = safe_require("plugins.fzf")
    local lsp = safe_require("plugins.lsp")

    if appearance then
        safe_call("gruvbox", appearance.setup_gruvbox)
        safe_call("windline", appearance.setup_windline)
        safe_call("indent-blankline", appearance.setup_indent_blankline)
        safe_call("rainbow-delimiters", appearance.setup_rainbow_delimiters)
        safe_call("alpha", appearance.setup_alpha)
    end

    if editing then
        safe_call("autoformat", editing.setup_autoformat)
        safe_call("tabular", editing.setup_tabular)
        safe_call("interestingwords", editing.setup_interestingwords)
        safe_call("visual-multi", editing.setup_visual_multi)
    end

    if motion then
        safe_call("neoscroll", motion.setup_neoscroll)
        safe_call("hop", motion.setup_hop)
    end

    if treesitter then
        safe_call("nvim-treesitter", treesitter.setup)
    end

    if fzf then
        safe_call("fzf-lua", fzf.setup)
    end

    if lsp then
        safe_call("coc", lsp.setup_coc)
    end
end

function M.setup()
    local packer = safe_require("packer")
    if not packer then
        return
    end

    packer.startup(function(use)
        use({ "wbthomason/packer.nvim" })
        use({ "karb94/neoscroll.nvim" })
        use({ "roxma/vim-tmux-clipboard" })

        use({ "daltonmenezes/aura-theme" })
        use({ "ellisonleao/gruvbox.nvim" })
        use({ "windwp/windline.nvim" })

        use({ "lukas-reineke/indent-blankline.nvim" })
        use({ "HiPhish/rainbow-delimiters.nvim" })
        use({ "Chiel92/vim-autoformat" })
        use({ "godlygeek/tabular" })
        use({ "lfv89/vim-interestingwords" })
        use({ "mg979/vim-visual-multi" })
        use({ "phaazon/hop.nvim" })
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
        use({ "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } })
        use({ "neoclide/coc.nvim", branch = "release" })
        use({ "goolord/alpha-nvim", requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" } })
    end)

    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = M.configure,
    })
end

M.setup()

return M
