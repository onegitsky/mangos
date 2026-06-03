return {
    "xiyaowong/transparent.nvim",
    config = function()
        require("transparent").setup({
            groups = { "NormalFloat", "NvimTreeNormal", "TabLine", "TabLineSel", "BufferCurrent" },
        })
    end,
}
