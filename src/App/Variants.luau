local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Button = require(script.Parent.Parent.components.Button)
local Fragment = require(script.Parent.Parent.components.Fragment)
local Fusion = require(script.Parent.Parent.packages.Fusion)
local instances = require(script.Parent.Parent.utils.instances)
local keysOf = require(script.Parent.Parent.utils.keysOf)
local transformColors = require(script.Parent.Parent.utils.transformColors)
local variants = require(script.Parent.Parent.variants)

local Children = Fusion.Children
local peek = Fusion.peek

type VariantProps = {
	name: string,
	attributeName: string,
	variantFn: (color: Color3) -> Color3,
	selected: Fusion.Value<{ Instance }?>,
}

local function Variant(scope: Fusion.Scope<typeof(Fusion)>, props: VariantProps)
	local scope = scope:deriveScope({
		Button = Button,
	})

	local disabled = scope:Computed(function(use)
		return use(props.selected) == nil
	end)

	return scope:Button {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		text = props.name,
		disabled = disabled,
		onClick = function()
			ChangeHistoryService:SetWaypoint("preapplied variant")
			for _, selectedInstance in peek(props.selected) do
				for _, instance in instances(selectedInstance) do
					transformColors(instance, props.variantFn)
				end
				selectedInstance:SetAttribute(props.attributeName, true)
			end
			ChangeHistoryService:SetWaypoint("applied variant")
		end,
	}
end

type VariantsProps = {
	world: Fusion.Value<string>,
	selected: Fusion.Value<{ Instance }?>,
}

local function Variants(scope: Fusion.Scope<typeof(Fusion)>, props: VariantsProps)
	local scope = scope:deriveScope({
		Variant = Variant,
		Fragment = Fragment,
	})

	return scope:Fragment {
		[Children] = scope:ForValues(keysOf(variants), function(use, scope: typeof(scope), variant)
			local variantInfo = variants[variant]

			return scope:Variant {
				name = variantInfo.name,
				attributeName = variantInfo.attributeName,
				variantFn = variantInfo.worlds[use(props.world)],
				selected = props.selected,
			}
		end),
	}
end

return Variants
