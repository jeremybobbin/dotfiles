-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/vis-commentary')
require('plugins/vis-ctags')
require('plugins/vis-cursors')
require('plugins/vis-surround')
require('plugins/vis-toggler')

vis.events.subscribe(vis.events.INIT, function()
	vis:command('set theme default-16')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
end)
