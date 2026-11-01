const compat = require("../../compat")
const CFrame, UDim2, Vector2, Vector3 = compat.CFrame, compat.UDim2, compat.Vector2, compat.Vector3

const color = require("../color")

const function lerp_color3(initial: Color3, goal: Color3, ratio: number)
	local initial_vector = color.color3_to_lab(initial)
	local goal_vector = color.color3_to_lab(goal)
	local interpolated_vector = initial_vector:Lerp(goal_vector, ratio)
	return color.lab_to_color3(interpolated_vector)
end

const lerp_types: { [string]: (initial: any, goal: any, ratio: number) -> any } = {
	number = math.lerp,
	vector = vector.lerp,

	Color3 = lerp_color3,
	CFrame = CFrame.identity.Lerp,
	UDim2 = UDim2.new().Lerp,

	Vector2 = Vector2.zero.Lerp,
	Vector3 = Vector3.zero.Lerp,

	ColorSequenceKeypoint = function(initial: ColorSequenceKeypoint, goal: ColorSequenceKeypoint, ratio: number)
		return ColorSequenceKeypoint.new(
			math.lerp(initial.Time, goal.Time, ratio),
			lerp_color3(initial.Value, goal.Value, ratio)
		)
	end,

	DateTime = function(initial: DateTime, goal: DateTime, ratio: number)
		return DateTime.fromUnixTimestampMillis(math.lerp(initial.UnixTimestampMillis, goal.UnixTimestampMillis, ratio))
	end,

	NumberRange = function(initial: NumberRange, goal: NumberRange, ratio: number)
		return NumberRange.new(math.lerp(initial.Min, goal.Min, ratio), math.lerp(initial.Max, goal.Max, ratio))
	end,

	NumberSequenceKeypoint = function(initial: NumberSequenceKeypoint, goal: NumberSequenceKeypoint, ratio: number)
		return NumberSequenceKeypoint.new(
			math.lerp(initial.Time, goal.Time, ratio),
			math.lerp(initial.Value, goal.Value, ratio)
		)
	end,

	PhysicalProperties = function(initial: PhysicalProperties, goal: PhysicalProperties, ratio: number)
		return PhysicalProperties.new(
			math.lerp(initial.Density, goal.Density, ratio),
			math.lerp(initial.Friction, goal.Friction, ratio),
			math.lerp(initial.Elasticity, goal.Elasticity, ratio),
			math.lerp(initial.FrictionWeight, goal.FrictionWeight, ratio),
			math.lerp(initial.ElasticityWeight, goal.ElasticityWeight, ratio),
			math.lerp(initial.AcousticAbsorption, goal.AcousticAbsorption, ratio)
		)
	end,

	Ray = function(initial: Ray, goal: Ray, ratio: number)
		return Ray.new(initial.Origin:Lerp(goal.Origin, ratio), initial.Direction:Lerp(goal.Direction, ratio))
	end,

	Rect = function(initial: Rect, goal: Rect, ratio: number)
		return Rect.new(initial.Min:Lerp(goal.Min, ratio), initial.Max:Lerp(goal.Max, ratio))
	end,

	Region3 = function(initial: Region3, goal: Region3, ratio: number)
		-- FUTURE: support rotated Region3s if/when they become constructable
		local position = initial.CFrame.Position:Lerp(goal.CFrame.Position, ratio)
		local half_size = initial.Size:Lerp(goal.Size, ratio) / 2
		return Region3.new(position - half_size, position + half_size)
	end,

	UDim = function(initial: UDim, goal: UDim, ratio: number)
		return UDim.new(math.lerp(initial.Scale, goal.Scale, ratio), math.lerp(initial.Offset, goal.Offset, ratio))
	end,
}

return lerp_types
