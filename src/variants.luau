local variants: { [string]: { name: string, attributeName: string, worlds: { [string]: (color: Color3) -> Color3 } } } =
	{
		ionize = {
			name = "Ionize",
			attributeName = "Ionized",
			worlds = {
				natura = function(color: Color3)
					return Color3.new(1 - color.B, 1 - color.R, 1 - color.G)
				end,
				luna_refuge = function(color: Color3)
					return Color3.new(1 - color.R, 1 - color.G, 1 - color.B)
				end,
				caverna = function(color: Color3)
					return Color3.new((1 - color.R) / 2, 1 - color.B, (color.G + 1 / 3) % 1)
				end,
				aesteria = function(color: Color3)
					return Color3.new((color.G + color.B) % 1, math.min(color.R * 2, 1), 1 - color.B)
				end,
				lucernia = function(color: Color3)
					return Color3.new(math.sqrt(color.G), 1 - (color.B ^ 3), color.R)
				end,
			},
		},
		spectralize = {
			name = "Spectralize",
			attributeName = "Spectral",
			worlds = {
				natura = function(color: Color3)
					return Color3.new(
						math.sin((color.R * math.pi / 2) + 4 * math.pi / 9),
						math.asin((1 - color.B) * 0.4) + 0.3,
						math.pow(math.tan(color.G * 2 / math.pi), 1 / 3)
					)
				end,
				luna_refuge = function(color: Color3)
					return Color3.new(color.G, 1 - color.R, 1 - color.B)
				end,
				caverna = function(color: Color3)
					return Color3.new(
						2 * (1 / (1 + color.B)) - 1,
						-((2 * color.G - 1) ^ 2) + 1,
						(2 - color.R) * color.R / (color.R + 1 / 2)
					)
				end,
				aesteria = function(color: Color3)
					return Color3.new((color.G + color.B) % 1, (color.R + color.B) % 1, (color.R + color.G) % 1)
				end,
				lucernia = function(color: Color3)
					return Color3.new((color.B + 7 / 20) % 1, math.sqrt((color.R + 3 / 7) % 1), 1 - color.G ^ 2)
				end,
			},
		},
	}

return variants
