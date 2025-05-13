local function instances(instance: Instance): { Instance }
	local descendants = instance:GetDescendants()
	table.insert(descendants, instance)
	return descendants
end

return instances
