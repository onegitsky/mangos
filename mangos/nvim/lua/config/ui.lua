vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd [[highlight CursorLine guibg=#151515 ctermbg=290]]
  end
})
