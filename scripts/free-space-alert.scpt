tell the application "Finder"
	-- Change this if your drive is not called "Macintosh HD"
	set drive_name to "Macintosh HD"

	set free_bytes to (free space of disk drive_name)
	set free_gbytes to (free_bytes / (1024 * 1024 * 0.1024) div 100) / 100

	set total_bytes to (capacity of disk drive_name)
	set total_gbytes to (total_bytes / (1024 * 1024 * 0.1024) div 100) / 100

	set min_free_space to (total_gbytes * 0.2)

	if free_gbytes < 30 then
		return true
	else
		return false
	end if


end tell
