const is_lune, lune_roblox = pcall(require, "@lune/roblox")

const function polyfill(api: string): never
	return if is_lune
		then lune_roblox[api] or error(`@lune/roblox doesn't provide {api}`)
		else error(`Runtime doesn't provide {api} as a global`)
end

const compat = {
	is_roblox = game == nil,
	is_lune = is_lune,

	game = game or lune_roblox.Instance.new("DataModel") :: never,
	task = task or require("@lune/task") :: never,

	Axes = Axes or polyfill("Axes"),
	BrickColor = BrickColor or polyfill("BrickColor"),
	CFrame = CFrame or polyfill("CFrame"),
	Color3 = Color3 or polyfill("Color3"),
	ColorSequence = ColorSequence or polyfill("ColorSequence"),
	ColorSequenceKeypoint = ColorSequenceKeypoint or polyfill("ColorSequenceKeypoint"),
	Enum = Enum or polyfill("Enum"),
	Faces = Faces or polyfill("Faces"),
	Font = Font or polyfill("Font"),
	Instance = Instance or polyfill("Instance"),
	NumberRange = NumberRange or polyfill("NumberRange"),
	NumberSequence = NumberSequence or polyfill("NumberSequence"),
	NumberSequenceKeypoint = NumberSequenceKeypoint or polyfill("NumberSequenceKeypoint"),
	PhysicalProperties = PhysicalProperties or polyfill("PhysicalProperties"),
	Ray = Ray or polyfill("Ray"),
	Rect = Rect or polyfill("Rect"),
	Region3 = Region3 or polyfill("Region3"),
	Region3int16 = Region3int16 or polyfill("Region3int16"),
	UDim = UDim or polyfill("UDim"),
	UDim2 = UDim2 or polyfill("UDim2"),
	Vector2 = Vector2 or polyfill("Vector2"),
	Vector2int16 = Vector2int16 or polyfill("Vector2int16"),
	Vector3 = Vector3 or polyfill("Vector3"),
	Vector3int16 = Vector3int16 or polyfill("Vector3int16"),
}

return table.freeze(compat)
