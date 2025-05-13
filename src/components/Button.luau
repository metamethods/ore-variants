local Frame = require(script.Parent.Frame)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Parent.App.Theme)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local types = require(script.Parent.Parent.types)
local Rounded = require(script.Parent.Rounded)
local Text = require(script.Parent.Text)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local peek = Fusion.peek

type UsedAs<T> = Fusion.UsedAs<T>

type ButtonProps = {
	text: UsedAs<string>,
	disabled: UsedAs<boolean>?,
	onClick: () -> (),
	backgroundColor: UsedAs<Color3>?,
	backgroundTransparency: UsedAs<number>?,
	overlayBackgroundColor: UsedAs<Color3>?,
} & types.BaseComponentProps

local function Button(scope: Fusion.Scope<typeof(Fusion)>, props: ButtonProps)
	local scope = scope:deriveScope({
		Text = Text,
		Frame = Frame,
		Padding = Padding,
		Rounded = Rounded,
		Theme = Theme,
	})

	local hovering = scope:Value(false)
	local pressed = scope:Value(false)

	local overlayTransparency = scope:Computed(function(use)
		if use(props.disabled) or use(pressed) then
			return 0.5
		end

		if use(hovering) then
			return 0.75
		end

		return 1
	end)

	return scope:New "ImageButton" {
		BackgroundColor3 = props.backgroundColor or scope:Theme("medium"),
		BackgroundTransparency = props.backgroundTransparency,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Size = props.size,
		AutomaticSize = props.automaticSize or Enum.AutomaticSize.XY,
		LayoutOrder = props.layoutOrder,

		[OnEvent "MouseEnter"] = function()
			hovering:set(true)
		end,

		[OnEvent "MouseLeave"] = function()
			hovering:set(false)
			pressed:set(false)
		end,

		[OnEvent "MouseButton1Down"] = function()
			pressed:set(true)
		end,

		[OnEvent "MouseButton1Up"] = function()
			pressed:set(false)
		end,

		[OnEvent "MouseButton1Click"] = function()
			if not peek(props.disabled) and props.onClick then
				props.onClick()
			end
		end,

		[Children] = {
			scope:Frame {
				backgroundTransparency = 1,
				automaticSize = Enum.AutomaticSize.XY,

				[Children] = {
					scope:Text({
						text = props.text,
					}),
					scope:Padding(),
				},
			},

			scope:Frame {
				backgroundColor = props.overlayBackgroundColor or scope:Theme("base"),
				backgroundTransparency = scope:Tween(
					overlayTransparency,
					TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				),
				size = UDim2.fromScale(1, 1),

				[Children] = scope:Rounded(),
			},

			scope:Rounded(),

			props[Children],
		},
	}
end

return Button
