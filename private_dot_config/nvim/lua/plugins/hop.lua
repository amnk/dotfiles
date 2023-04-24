local status_ok, hop = pcall(require, 'hop')
if not status_ok then
  return
end

hop.setup()

vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar2AC<CR>", {noremap=false})
vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar2BC<CR>", {noremap=false})
