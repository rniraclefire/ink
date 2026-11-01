--!nolint LocalUnused
-- ^ You will see why

const color = require("../color")

const compat = require("../../compat")
const Axes, BrickColor, CFrame, Color3, ColorSequence, ColorSequenceKeypoint, Enum, Faces, Font, Instance, NumberRange, NumberSequence, NumberSequenceKeypoint, PhysicalProperties, Ray, Rect, Region3, Region3int16, UDim, UDim2, Vector2, Vector2int16, Vector3, Vector3int16 =
	compat.Axes,
	compat.BrickColor,
	compat.CFrame,
	compat.Color3,
	compat.ColorSequence,
	compat.ColorSequenceKeypoint,
	compat.Enum,
	compat.Faces,
	compat.Font,
	compat.Instance,
	compat.NumberRange,
	compat.NumberSequence,
	compat.NumberSequenceKeypoint,
	compat.PhysicalProperties,
	compat.Ray,
	compat.Rect,
	compat.Region3,
	compat.Region3int16,
	compat.UDim,
	compat.UDim2,
	compat.Vector2,
	compat.Vector2int16,
	compat.Vector3,
	compat.Vector3int16

const unpack_types: { [string]: (value: { number }) -> any } = {
	number = function(value)
		return value[1]
	end,

	vector = function(value)
		return vector.create(value[1], value[2], value[3])
	end,

	Color3 = function(v)
		const intermediate = Vector3.new(v[1], v[2], v[3])
		return color.lab_to_color3(intermediate)
	end,

	ColorSequenceKeypoint = function(v)
		return ColorSequenceKeypoint.new(math.clamp(v[1], 0, 1), color.lab_to_color3(Vector3.new(v[2], v[3], v[4])))
	end,

	DateTime = function(v)
		return DateTime.fromUnixTimestampMillis(v[1])
	end,

	CFrame = function(v)
		return CFrame.new(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12])
	end,

	NumberRange = function(v)
		return NumberRange.new(v[1], v[2])
	end,

	NumberSequenceKeypoint = function(v)
		return NumberSequenceKeypoint.new(v[1], v[2], v[3])
	end,

	PhysicalProperties = function(v)
		return PhysicalProperties.new(v[1], v[2], v[3], v[4], v[5], v[6])
	end,

	Ray = function(v)
		return Ray.new(Vector3.new(v[1], v[2], v[3]), Vector3.new(v[4], v[5], v[6]))
	end,

	Rect = function(v)
		return Rect.new(v[1], v[2], v[3], v[4])
	end,

	Region3 = function(v)
		const centre = Vector3.new(v[1], v[2], v[3])
		const half = Vector3.new(v[4], v[5], v[6]) / 2
		return Region3.new(centre - half, centre + half)
	end,

	Vector2 = function(v)
		return Vector2.new(v[1], v[2])
	end,

	Vector3 = function(v)
		return Vector3.new(v[1], v[2], v[3])
	end,

	UDim = function(v)
		return UDim.new(v[1], v[2])
	end,

	UDim2 = function(v)
		return UDim2.new(v[1], v[2], v[3], v[4])
	end,
}

return unpack_types
