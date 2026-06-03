return {
'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = function()
      vim.api.nvim_set_hl(0, 'RMbH1', { fg = '#101010', bg = '#99845b' })
      vim.api.nvim_set_hl(0, 'RMbH2', { fg = '#101010', bg = '#996253' })
      vim.api.nvim_set_hl(0, 'RMbH3', { fg = '#101010', bg = '#997993' })
      vim.api.nvim_set_hl(0, 'RMbH4', { fg = '#101010', bg = '#849971' })
      vim.api.nvim_set_hl(0, 'RMbH5', { fg = '#101010', bg = '#506e93' })
      vim.api.nvim_set_hl(0, 'RMbH6', { fg = '#101010', bg = '#7ba2a1' })
      vim.api.nvim_set_hl(0, 'RMfH1', { fg = '#99845b' })
      vim.api.nvim_set_hl(0, 'RMfH2', { fg = '#996253' })
      vim.api.nvim_set_hl(0, 'RMfH3', { fg = '#997993' })
      vim.api.nvim_set_hl(0, 'RMfH4', { fg = '#849971' })
      vim.api.nvim_set_hl(0, 'RMfH5', { fg = '#506e93' })
      vim.api.nvim_set_hl(0, 'RMfH6', { fg = '#7ba2a1' })
      vim.api.nvim_set_hl(0, 'RMdCodeBlock', { bg = '#434343' })

      return {
        heading = {
          sign = true,
            icons = { "", "", "", "", "", "" },
          backgrounds = {
            'RMbH1',
            'RMbH2',
            'RMbH3',
            'RMbH4',
            'RMbH5',
            'RMbH6',
          },
          foregrounds = {
            'RMfH1',
            'RMfH2',
            'RMfH3',
            'RMfH4',
            'RMfH5',
            'RMfH6',
          },
          border = true,
          above = '-',
          below = '-',
        },
        code = {
          sign = false,
          left_pad = 1,
          highlight = 'RMdCodeBlock',
        },
        quote = {
          icon = '┃',
        },
      }
    end,
}
