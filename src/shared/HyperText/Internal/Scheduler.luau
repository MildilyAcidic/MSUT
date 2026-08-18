--!strict

local scheduler = {}
scheduler.__index = scheduler

export type classType = typeof(
	setmetatable(
		{} :: {
			_queue : {[number] : () -> ()},
			
			index : number?
		},
		scheduler
	)
)

scheduler.new = function() : classType
	local self = setmetatable(
		{
			_queue = {},
			
			index = nil :: number?
		},
		scheduler
	)
	
	return self
end

function scheduler.Append(self : classType, callback : () -> ())
	table.insert(self._queue, callback)
end

function scheduler.Insert(self : classType, callback : () -> (), pos : number)
	if pos <= #self._queue then
		table.insert(self._queue, pos, callback)
	else
		self:Append(callback)
	end
end

function scheduler.Iterate(self : classType)
	for i, callback in ipairs(self._queue) do
		self.index = i
		
		callback()
	end
end

function scheduler.Empty(self : classType)
	self._queue = {}
end

return scheduler
