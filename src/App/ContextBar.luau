local Dropdown = require(script.Parent.Parent.components.Dropdown)
local Fragment = require(script.Parent.Parent.components.Fragment)
local Padding = require(script.Parent.Parent.components.Padding)
local Rounded = require(script.Parent.Parent.components.Rounded)
local Text = require(script.Parent.Parent.components.Text)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local worlds = require(script.Parent.Parent.worlds)
local Theme = require(script.Parent.Theme)

local Children = Fusion.Children

type ContextBarProps = {
	selection: Fusion.Value<{ Instance }?>,
	world: Fusion.Value<string>,
	[typeof(Children)]: Fusion.Child,
}

local function ContextBar(scope: Fusion.Scope<typeof(Fusion)>, props: ContextBarProps)
	local scope = scope:deriveScope({
		Dropdown = Dropdown,
		Text = Text,
		Fragment = Fragment,
		Rounded = Rounded,
		Padding = Padding,
		Theme = Theme,
	})

	local selectionText = scope:Computed(function(use)
		local selection = use(props.selection)

		if not selection then
			return "No selected instance found"
		end

		return `Selected instance <b>{selection[1]:GetFullName()}</b>{if #selection > 1
			then ` <i>+{#selection - 1} more</i>`
			else ""}`
	end)

	return scope:Fragment {
		backgroundColor = scope:Theme("medium"),
		backgroundTransparency = 0,
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,

		[Children] = {
			scope:Text {
				text = selectionText,
			},

			scope:Text {
				text = "<i>Select a world below</i>",
				textColor = scope:Theme("subtext"),
			},

			scope:Dropdown {
				title = "World",
				selected = props.world,
				items = worlds,
				backgroundColor = scope:Theme("top"),
			},

			scope:Rounded(),
			scope:Padding(),
			props[Children],
		},
	}
end

return ContextBar
