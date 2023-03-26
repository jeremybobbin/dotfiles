-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/vis-commentary')
require('plugins/vis-ctags')
require('plugins/vis-cursors')
require('plugins/vis-surround')
require('plugins/vis-toggler')
require('plugins/vis-quickfix')
require('plugins/vis-ins-completion')

dictfiles =  { 
	text = '/usr/share/dict/words',
}

local function get_indent(win)
	local sel = win.selection
	local line = win.file:content(sel.pos-(sel.col-1), sel.col-1)
	return line:match("^%s+")
end

-- fancy string ops
local strdefi=getmetatable('').__index
getmetatable('').__index=function(str,i)
	if type(i) == "number" then
		return string.sub(str,i,i)
	else
		return strdefi[i]
	end
end

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
	vis:map(vis.modes.NORMAL, " ", function(keys)
		local file = win.file
		local pos = win.selection.pos
		if file:content(pos, 4) == "<++>" then
		else 
			vis:feedkeys("/<\\+\\+><Enter>")
		end
		vis:feedkeys("cf>")
	end, "jump to place holder")


	-- lines within selections
	vis:map(vis.modes.VISUAL, "<C-s>l", function(keys)
		vis:command('x/.*\\n/ y/^\\s+/')
		vis:command('g/\\S/')
	end, "jump to place holder")

	-- word within selections
	vis:map(vis.modes.VISUAL, "<C-s>w", function(keys)
		vis:command('x/[a-zA-Z_]+/')
	end, "jump to place holder")

	-- WORDs within selections
	vis:map(vis.modes.VISUAL, "<C-s>W", function(keys)
		vis:command('x/\\S+/')
	end, "jump to place holder")


	local register_snippets = function(snippets)
		for k, v in pairs(snippets) do
			local seq = string.format("<C-_>%s", k)
			--v = v:gsub("\n", "<enter>")
			vis:map(vis.modes.NORMAL, seq, function(keys)
				local indent = get_indent(vis.win)
				local v = v:gsub("\n", "\n"..(indent or ""))
				win.file:insert(win.selection.pos, v)
				local keys = string.format("%dh ", string.len(v))
				vis:feedkeys(keys)
			end, "Snippet")
			vis:map(vis.modes.INSERT, seq, function(keys)
				local indent = get_indent(vis.win)
				local v = v:gsub("\n", "\n"..(indent or ""))
				vis:insert(v)
				vis:feedkeys("<Escape>")
				local keys = string.format("%dh ", string.len(v))
				vis:feedkeys(keys)
			end, "Snippet")
		end
	end


	local on_syntax = {
		ansi_c = function()
			register_snippets({
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
			})
		end,
		bash = function()
			register_snippets({
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
			})
		end,
		go = function()
			register_snippets({
				po = "fmt.Println(\"<++>\")",
				pe = "fmt.Fprintln(os.Stderr, \"<++>\", <++>)",
				pf = "fmt.Fprintln(<++>, \"<++>\")",
				-- loop
				lw = "for {\n\t<++>\n}",
				lr = "for <++> := range <++>; {\n\t<++>\n}",
				ln = "for i := 0; i < <++>; i+= 1 do\n\t<++>\ndone",

				["if"] = "if <++>; then\n\t<++>\nfi",
				fn = "func <++>() <++> {\n\t<++>\n}",
				sw = "switch <++> {\ncase <++>:\n\t<++>\n}",
				sl = "select <++> {\ncase <++>:\n\t<++>\n}",
				hd = "<++> <<- EOF\n<++>\nEOF",

				ca = "awk '<++> {<++>}'",
			})
		end
	}

	-- snippets
	if on_syntax[win.syntax] ~= nil then
		on_syntax[win.syntax]()
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
