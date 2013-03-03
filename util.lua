function table.shallow_copy(original_table)
	local new_table = {}
	for k, v in pairs(original_table) do
		new_table[k] = v
	end
	return new_table
end

function math.randint(a, b)
	if not b then
		return math.ceil(math.random() * a) % a
	else
		return (math.ceil(math.random() * b) % (b - a)) + a --return a number between a & b
	end
end
