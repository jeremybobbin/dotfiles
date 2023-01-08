local keep_open
local start = nil

mp.add_key_binding("s", "segment", function()
	if start then
		local to = mp.get_property_number("time-pos")
		if to < 0 then
			mp.osd_message(string.format("start before end - cancelling"))
			start = nil
			return
		end
		local path = mp.get_property("path")
		local ext = path:match("^.+%.(.+)$")
		local name = path:match("^([^/]+)%..+$")
		local ffmpeg = string.format("ffmpeg -i %q -ss %.2f -to %.2f ~/Media/Video/Segments/%s-%d.%s",
			path,
			start,
			to,
			name,
			os.time(),
			ext
		)
		mp.osd_message(string.format("Start: %.2f - Duration: %.2f", start, to))
		os.execute(ffmpeg)
	        mp.set_property("keep-open", keep_open)
	else
	        keep_open = mp.get_property("keep-open")
	        mp.set_property("keep-open", "always")
		start = mp.get_property_number("time-pos")
		if start < 0 then
			start = 0
		end
		mp.osd_message(string.format("Start of clip: %s", start))
	end
end)
