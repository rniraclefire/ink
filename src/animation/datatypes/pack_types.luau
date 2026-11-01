const color = require("../color")

const pack_types: { [string]: (v: any, out: { number }) -> () } = {
	number = function(v: number, out)
		out[1] = v
	end,

	vector = function(v: vector, out)
		out[1], out[2], out[3] = v.x, v.y, v.z
	end,

	Color3 = function(v: Color3, out)
		const intermediate = color.color3_to_lab(v)
		out[1], out[2], out[3] = intermediate.X, intermediate.Y, intermediate.Z
	end,

	ColorSequenceKeypoint = function(v: ColorSequenceKeypoint, out)
		const intermediate = color.color3_to_lab(v.Value)
		out[1], out[2], out[3], out[4] = v.Time, intermediate.X, intermediate.Y, intermediate.Z
	end,

	DateTime = function(v: DateTime, out)
		out[1] = v.UnixTimestampMillis
	end,

	CFrame = function(v: CFrame, out)
		out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11], out[12] =
			v:GetComponents()
	end,

	NumberRange = function(v: NumberRange, out)
		out[1], out[2] = v.Min, v.Max
	end,

	NumberSequenceKeypoint = function(v: NumberSequenceKeypoint, out)
		out[1], out[2], out[3] = v.Time, v.Value, v.Envelope
	end,

	PhysicalProperties = function(v: PhysicalProperties, out)
		out[1], out[2], out[3], out[4], out[5], out[6] =
			v.Density, v.Friction, v.Elasticity, v.FrictionWeight, v.ElasticityWeight, v.AcousticAbsorption
	end,

	Ray = function(v: Ray, out)
		const origin, direction = v.Origin, v.Direction
		out[1], out[2], out[3], out[4], out[5], out[6] =
			origin.X, origin.Y, origin.Z, direction.X, direction.Y, direction.Z
	end,

	Rect = function(v: Rect, out)
		const min, max = v.Min, v.Max
		out[1], out[2], out[3], out[4] = min.X, min.Y, max.X, max.Y
	end,

	-- FUTURE: support rotated Region3s if/when they become constructable
	Region3 = function(v: Region3, out)
		const centre, size = v.CFrame.Position, v.Size
		out[1], out[2], out[3], out[4], out[5], out[6] = centre.X, centre.Y, centre.Z, size.X, size.Y, size.Z
	end,

	Vector2 = function(v: Vector2, out)
		out[1], out[2] = v.X, v.Y
	end,

	Vector3 = function(v: Vector3, out)
		out[1], out[2], out[3] = v.X, v.Y, v.Z
	end,

	UDim = function(v: UDim, out)
		out[1], out[2] = v.Scale, v.Offset
	end,

	UDim2 = function(v: UDim2, out)
		const x, y = v.X, v.Y
		out[1], out[2], out[3], out[4] = x.Scale, x.Offset, y.Scale, y.Offset
	end,
}

return table.freeze(pack_types)
