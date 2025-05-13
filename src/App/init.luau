local Flex = require(script.Parent.components.Flex)
local Fragment = require(script.Parent.components.Fragment)
local Frame = require(script.Parent.components.Frame)
local Padding = require(script.Parent.components.Padding)
local Text = require(script.Parent.components.Text)
local Fusion = require(script.Parent.packages.Fusion)
local types = require(script.Parent.types)
local ContextBar = require(script.ContextBar)
local Theme = require(script.Theme)
local Variants = require(script.Variants)

local Children = Fusion.Children

local function App(scope: types.AppScope)
	local scope = scope:deriveScope({
		Variants = Variants,
		ContextBar = ContextBar,
		Text = Text,
		Fragment = Fragment,
		Frame = Frame,
		Padding = Padding,
		Flex = Flex,
		Theme = Theme,
	})

	local world: Fusion.Value<string> = scope:Value("natura")

	return scope:Frame {
		backgroundColor = scope:Theme("base"),
		size = UDim2.fromScale(1, 1),

		[Children] = scope:Fragment {
			size = UDim2.fromScale(1, 1),
			horizontalFlex = Enum.UIFlexAlignment.Fill,
			verticalFlex = Enum.UIFlexAlignment.Fill,

			[Children] = {
				scope:Variants {
					world = world,
					selected = scope.selected,
				},

				scope:ContextBar {
					selection = scope.selected,
					world = world,
					[Children] = scope:Flex(),
				},

				scope:Padding(),
			},
		},
	}
end

return App
