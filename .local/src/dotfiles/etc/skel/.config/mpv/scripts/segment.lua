local clip_start
local uri 

function set_clip_start()
	clip_start = mp.get_property_number("time-pos")
	local message = string.format("Start of clip: %s", clip_start)
	mp.osd_message(message)
end

function clip_end()
	local clip_end = mp.get_property_number("time-pos")
	local offset = clip_end - clip_start
	local uri = mp.get_property("path")

	local ffmpeg = string.format("ffmpeg -i %q -ss %s -t %s ~/Media/Video/Segments/$(date +%%s).mp4", uri, clip_start, offset)
	os.execute(ffmpeg)
end

function segment() 
	if not clip_start then
		set_clip_start()
	else
		clip_end()
		clip_start = nil
	end
end

mp.add_key_binding("s", "segment", segment)
