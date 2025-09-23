local status, copilot = pcall(require, 'copilot.nvim')
if (not status) then
  print('not installed copilot.nvim')
  return
end
