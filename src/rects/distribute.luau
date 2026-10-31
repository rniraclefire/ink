type Length = number | { read fr: number }

--- Distributes fixed and fractional lengths to a container length.
const function distribute(container_length: number, lengths: { Length }, gap: number?): { number }
	const out = table.create(#lengths, 0)

	local remaining = container_length - (gap or 0) * math.max(#lengths - 1, 0)
	local total_weight = 0
	for index, length in lengths do
		if type(length) == "number" then
			out[index] = length
			remaining -= length
		else
			total_weight += length.fr
		end
	end

	if total_weight > 0 then
		const per_weight = math.max(remaining, 0) / total_weight
		for index, length in lengths do
			if type(length) ~= "number" then
				out[index] = per_weight * length.fr
			end
		end
	end

	return out
end

return distribute
