local status, autotag = pcall(require, 'nvim-ts-autotag')
if (not status) then
  print("not installed ts-autotag")
  return
end

autotag.setup{}
