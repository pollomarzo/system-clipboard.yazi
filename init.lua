-- Meant to run at async context. (yazi system-clipboard)

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(cx.yanked) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function url_encode(str)
    return str:gsub("([^%w-_.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

return {
	entry = function()
		ya.manager_emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end
		
		local url_t = {}
		for _,file in ipairs(urls) do
			table.insert(url_t, "file://" .. file)
		end
		local urls_joined = table.concat(url_t, '\n')
		local status, err =
				Command("wl-copy")
				:arg("-t")
				:arg("text/uri-list")
				:arg(urls_joined)
				:spawn()
				:wait()

		if status or status.succes then
			ya.notify({
				title = "System Clipboard",
				content = "Successfully copied the file(s) to system clipboard",
				level = "info",
				timeout = 5,
			})
		end

		if not status or not status.success then
			ya.notify({
				title = "System Clipboard",
				content = string.format(
					"Could not copy selected file(s) %s",
					status and status.code or err
				),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
