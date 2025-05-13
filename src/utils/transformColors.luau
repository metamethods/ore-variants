local colorProperties = require(script.Parent.Parent.stores.colorProperties)

local function transformColors(instance: Instance, transformFn: (color: Color3) -> Color3)
	local properties = colorProperties[instance.ClassName]

	if not properties then
		return
	end

	for _, property in properties do
		local value = instance[property] :: Color3 | ColorSequence | Vector3

		if typeof(value) == "Color3" then
			instance[property] = transformFn(value)
		elseif typeof(value) == "ColorSequence" then
			local transformedSequenceKeypoints = {}
			for _, keypoint in value.Keypoints do
				table.insert(
					transformedSequenceKeypoints,
					ColorSequenceKeypoint.new(keypoint.Time, transformFn(keypoint.Value))
				)
			end
			instance[property] = ColorSequence.new(transformedSequenceKeypoints)
		else
			local transformedColor = transformFn(Color3.new(value.X, value.Y, value.Z))
			instance[property] = Vector3.new(transformedColor.R, transformedColor.G, transformedColor.B)
		end
	end
end

return transformColors
