return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 1,
      trim_scope = "inner",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = nil,
    })

    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context()
    end, { silent = true, desc = "Go to context" })
  end,
}
