-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/vis-commentary')
require('plugins/vis-ctags')
require('plugins/vis-cursors')
require('plugins/vis-surround')
require('plugins/vis-toggler')
require('plugins/vis-quickfix')

local snippets = {
	ansi_c = {
		po = "fprintf(stdout, \"<++>\", <++>);",
		pe = "fprintf(stderr, \"<++>\", <++>);",
		pf = "fprintf(<++>, \"<++>\", <++>);",
		ps = "sprintf(<++>, \"<++>\", <++>);",
		-- loop
		lf = "for (<++>;<++>;<++>) {\n\t<++>\n}",
		lw = "while (<++>) {\n\t<++>\n}",
		ld = "do {\n\t<++>\n} while (<++>);",

		["if"] = "if (<++>) {\n\t<++>\n}",

		fn = "<++>\n<++>(<++>)\n{\n\t<++>\n}",
		sw = "switch (<++>) {\ncase <++>:<++>;\n\tdefault:<++>;;\n}",
	},
	bash = {
		po = "printf '<++>'",
		pe = "printf '<++>' 1>&2",
		pf = "printf '<++>' > <++>",
		-- loop
		lw = "while <++>; do\n\t<++>\ndone",
		lu = "until <++>; do\n\t<++>\ndone",
		lf = "for <++> in <++>; do\n\t<++>\ndone",

		["if"] = "if <++>; then\n\t<++>\nfi",
		fn = "<++>()\n{\n\t<++>\n}",
		sw = "case <++> in\n\t<++>)<++>;;\n\t*)<++>;;\nesac",
		hd = "<++> <<- EOF\n<++>\nEOF",

		ca = "awk '<++> {<++>}'",
	},
};

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

	-- Jump to place holder
	vis:map(vis.modes.NORMAL, "<Space>", "/<\\+\\+><Enter>cf>")

	-- snippets
	if snippets[win.syntax] ~= nil then
		for k,v in pairs(snippets[win.syntax]) do
			local comment = "Snippets"
			local seq = string.format("<C-_>%s", k)
			--v = v:gsub("\n", "<Enter>")
			vis:map(vis.modes.NORMAL, seq, function(keys)
				vis:feedkeys("i")
				vis:insert(v)
				vis:feedkeys("<Escape>")
			end, comment)
			vis:map(vis.modes.INSERT, seq, function(keys)
				vis:insert(v)
				vis:feedkeys("<Escape>")
				vis:feedkeys(" ")
			end, comment)
		end
	end

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
