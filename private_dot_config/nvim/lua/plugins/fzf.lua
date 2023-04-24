local status_ok, fzf_lua = pcall(require, 'fzf-lua')
if not status_ok then
  return
end

fzf_lua.setup({})

vim.api.nvim_set_keymap('n', '<Leader>f', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>g', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })
