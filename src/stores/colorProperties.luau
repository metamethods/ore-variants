local apiDump = require(script.Parent.apiDump)

local colorProperties: { [string]: { string } } = {
	-- the "special" instances lol
	SpecialMesh = { "VertexColor" },
	BlockMesh = { "VertexColor" },
}

local function getColorProperties(className: string): { string }
	local class = apiDump.Classes[className]

	local properties = {}

	for _, member in class.Members do
		if
			member.MemberType ~= "Property"
			or not member.ValueType
			or (member.ValueType.Name ~= "Color3" and member.ValueType.Name ~= "ColorSequence")
		then
			continue
		end
		table.insert(properties, member.Name)
	end

	if class.Superclass and class.Superclass ~= "<<<ROOT>>>" then
		local superProperties = getColorProperties(class.Superclass)
		table.move(superProperties, 1, #superProperties, #properties + 1, properties)
	end

	return properties
end

for className, _ in apiDump.Classes do
	local properties = getColorProperties(className)

	if #properties == 0 then
		continue
	end

	colorProperties[className] = properties
end

return colorProperties
