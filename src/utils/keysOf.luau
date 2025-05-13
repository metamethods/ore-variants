local function keysOf<T>(input: { [T]: any }): { T }
	local keys = {}

	for key in input do
		table.insert(keys, key)
	end

	return keys
end

return keysOf
