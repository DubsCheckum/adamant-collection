local str = {}

function str.split(s, delim)
	local ret = {}
	if not s then
		return ret
	end
	if not delim or delim == '' then
		for c in string.gmatch(s, '.') do
			table.insert(ret, c)
		end
		return ret
	end
	local n = 1
	while true do
		local i, j = string.find(s, delim, n)
		if not i then break end
		table.insert(ret, sub(s, n, i - 1))
		n = j + 1
	end
	table.insert(ret, sub(s, n))
	return ret
end

return str