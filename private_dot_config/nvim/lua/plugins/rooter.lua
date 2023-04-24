local status_ok, rooter = pcall(require, 'nvim-rooter')
if not status_ok then
  return
end

rooter.setup {
  rooter_patterns = { '.git', '.hg', '.svn' },
  trigger_patterns = { '*' },
  manual = false,
}
