-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/vis-commentary')
require('plugins/vis-ctags')
require('plugins/vis-cursors')
require('plugins/vis-surround')
require('plugins/vis-toggler')
require('plugins/vis-quickfix')

vis.events.subscribe(vis.events.INIT, function()
	vis:command('set theme default-16')
	vis:command('set escdelay 0')
	vis:command('set autoindent on')

end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
	vis:map(vis.modes.NORMAL, "<Tab>", "<C-i>")

	-- Jumplist
	vis:map(vis.modes.NORMAL, "<C-i>", "g>")
	vis:map(vis.modes.NORMAL, "<C-o>", "g<")
	vis:operator_new("gq", function(file, range, pos)
		local status, out, err = vis:pipe(file, range, "fmt")
		if not status then
			vis:info(err)
		else
			file:delete(range)
			file:insert(range.start, out)
		end
		return range.start -- new cursor location
	end, "Formating operator, filter range through fmt(1)")
end)
