if vim.loader and vim.fn.filewritable(vim.fn.stdpath("cache")) == 2 then
    vim.loader.enable()
end

require("core.options")
require("core.keymaps")
require("plugins")
