local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

local Format = {}

function Format.short(n: number): string
	if n < 0 then
		return "-" .. Format.short(-n)
	end
	if n < 1000 then
		if n == math.floor(n) then
			return tostring(math.floor(n))
		end
		return string.format("%.1f", n)
	end

	local tier = 0
	local scaled = n
	while scaled >= 1000 and tier < #SUFFIXES - 1 do
		scaled /= 1000
		tier += 1
	end

	local suffix = SUFFIXES[tier + 1]
	if scaled >= 100 then
		return string.format("%.0f%s", scaled, suffix)
	elseif scaled >= 10 then
		return string.format("%.1f%s", scaled, suffix)
	end
	return string.format("%.2f%s", scaled, suffix)
end

function Format.rate(n: number): string
	return Format.short(n) .. "/s"
end

function Format.percent(fraction: number): string
	return string.format("%d%%", math.floor(fraction * 100 + 0.5))
end

return Format
