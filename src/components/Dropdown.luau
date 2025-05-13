local Button = require(script.Parent.Button)
local Fusion = require(script.Parent.Parent.packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

type DropdownProps = {
	title: string,
	selected: Fusion.Value<string>,
	items: { [string]: string },
	backgroundColor: UsedAs<Color3>?,
}

local function Dropdown(scope: Fusion.Scope<typeof(Fusion) & { plugin: Plugin }>, props: DropdownProps)
	local scope = scope:deriveScope({
		Button = Button,
	})

	local selectedText = scope:Computed(function(use)
		return props.items[use(props.selected)] or "unknown"
	end)

	local pluginMenu = scope.plugin:CreatePluginMenu(tostring(math.random()), props.title)

	for itemId, name in props.items do
		local action = pluginMenu:AddNewAction(itemId, name)
		action.Name = itemId
	end

	return scope:Button {
		text = selectedText,
		onClick = function()
			local selectedAction = pluginMenu:ShowAsync()

			if selectedAction then
				props.selected:set(selectedAction.Name)
			end
		end,
		backgroundColor = props.backgroundColor,
	}
end

return Dropdown
