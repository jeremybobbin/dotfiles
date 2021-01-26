local keep_open
local start = nil

mp.add_key_binding("s", "segment", function()
	if start then
		local offset = mp.get_property_number("time-pos") - start
		if offset < 0 then
			mp.osd_message(string.format("start before end - cancelling"))
			start = nil
			return
		end
		local path = mp.get_property("path")
		local ext = path:match("^.+%.(.+)$")
		local ffmpeg = string.format("ffmpeg -i %q -ss %f -t %f -c copy ~/Media/Video/Segments/%d.%s", path, start, offset, os.time(), ext)
		mp.osd_message(string.format("Start: %.2f - Duration: %.2f", start, offset))
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
