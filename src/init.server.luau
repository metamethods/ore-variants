local SelectionService = game:GetService("Selection")

local App = require(script.App)
local Toolbar = require(script.components.plugin.Toolbar)
local ToolbarButton = require(script.components.plugin.ToolbarButton)
local Widget = require(script.components.plugin.Widget)
local constants = require(script.constants)
local Fusion = require(script.packages.Fusion)
local nullifyEmpty = require(script.utils.nullifyEmpty)

local scoped = Fusion.scoped

local scope = scoped(Fusion)
local selected = scope:Value(nullifyEmpty(SelectionService:Get()))

local toolbar = Toolbar(plugin, `{constants.PLUGIN_NAME} {constants.PLUGIN_VERSION}`)

local appWidget = Widget(plugin) {
	id = constants.PLUGIN_ID,
	title = `{constants.PLUGIN_NAME} {constants.PLUGIN_VERSION}`,
	root = App(scope:deriveScope({
		plugin = plugin,
		selected = selected,
	})),
}

ToolbarButton(toolbar) {
	id = constants.PLUGIN_NAME,
	icon = "",
	tooltip = `Click to toggle {constants.PLUGIN_NAME}`,
	clicked = function()
		appWidget.Enabled = not appWidget.Enabled
	end,
}

table.insert(scope, {
	SelectionService.SelectionChanged:Connect(function()
		selected:set(nullifyEmpty(SelectionService:Get()))
	end),

	plugin.Unloading:Connect(function()
		scope:doCleanup()
	end),
})
