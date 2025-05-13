local function map<TI, K, TO>(input: { [K]: TI }, transformFn: (value: TI, key: K) -> TO): { [K]: TO }
	local new = {}

	for key, value in input do
		new[key] = transformFn(value, key)
	end

	return new
end

return map
