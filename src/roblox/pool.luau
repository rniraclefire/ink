const primitives = require("../core/primitives")

export type Slot = {
	instance: Instance,
	written: { [string]: unknown },
	modifiers: { [string]: Instance },
	write: primitives.Write,
}

const pool = {}
pool.__index = pool

export type Pool = setmetatable<{
	kind: primitives.Kind<any, any>,
	slots: { Slot },
	used: number,
}, typeof(pool)>

const function new_slot(kind: primitives.Kind<any, any>): Slot
	const instance = Instance.new(kind.instance_class)
	const slot = { instance = instance, written = {}, modifiers = {} } :: Slot

	function slot.write(target: Instance, property: string, value: unknown)
		if target ~= instance then
			(target :: any)[property] = value
		elseif slot.written[property] ~= value then
			slot.written[property] = value;
			(instance :: any)[property] = value
		end
	end

	kind.init(instance, slot.write)
	return slot
end

function pool.new(kind: primitives.Kind<any, any>): Pool
	return setmetatable({ kind = kind, slots = {}, used = 0 }, pool)
end

function pool.reset(self: Pool)
	self.used = 0
end

function pool.acquire(self: Pool): Slot
	self.used += 1
	local slot = self.slots[self.used]
	if not slot then
		slot = new_slot(self.kind)
		self.slots[self.used] = slot
	end
	return slot
end

function pool.release_unused(self: Pool)
	for i = self.used + 1, #self.slots do
		const slot = self.slots[i]
		slot.write(slot.instance, "Parent", nil)
	end
end

function pool.trim(self: Pool, keep: number)
	for i = #self.slots, math.max(keep, self.used) + 1, -1 do
		self.slots[i].instance:Destroy()
		self.slots[i] = nil
	end
end

function pool.destroy(self: Pool)
	for _, slot in self.slots do
		slot.instance:Destroy()
	end
	table.clear(self.slots)
	self.used = 0
end

return table.freeze(pool)
