-- mappy.yazi: mappy を使って Markdown をプレビューする yazi プラグイン
-- ~/.config/yazi/plugins/mappy.yazi/main.lua に配置する

local M = {}

function M:peek(job)
	local path = tostring(job.file.url)

	local child, err = Command("mappy")
		:arg(path)
		:stdout(Command.PIPED)
		:stderr(Command.NULL)
		:spawn()

	if not child then
		return
	end

	local limit = job.area.h
	local i = 0
	local lines = ""

	repeat
		local line, event = child:read_line()
		if event ~= 0 then
			break
		end
		i = i + 1
		if i > job.skip then
			lines = lines .. line
		end
	until i >= job.skip + limit

	child:start_kill()

	if job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", {
			tostring(math.max(0, i - limit)),
			only_if = job.file.url,
			upper_bound = true,
		})
	else
		ya.preview_widget(job, ui.Text.parse(lines):area(job.area))
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = math.floor(job.units * cx.active.preview.area.h / 10)
		ya.emit("peek", {
			tostring(math.max(0, cx.active.preview.skip + step)),
			only_if = job.file.url,
		})
	end
end

return M
