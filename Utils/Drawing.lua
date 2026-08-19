return {
	DrawText = function(Size: number, Color: Color3)
		local Text = Drawing.new("Text")
		Text.Visible = false
		Text.Center = true
		Text.Outline = true
		Text.Size = Size
		Text.Color = Color
		Text.Transparency = 1

		return Text
	end,

	DrawLine = function(Thickness: number, Color: Color3)
		local Line = Drawing.new("Line")
		Line.Visible = false
		Line.Thickness = Thickness
		Line.Color = Color
		Line.Transparency = 1

		return Line
	end,

	DrawQuad = function(Thickness: number, Color: Color3)
		local Quad = Drawing.new("Quad")
		Quad.Visible = false
		Quad.Filled = false
		Quad.Thickness = Thickness
		Quad.Color = Color
		Quad.Transparency = 1

		return Quad
	end
}
