function table.shallow_copy(original_table)
	new_table = {}
	for k, v in pairs(original_table) do
		new_table[k] = v
	end
	return new_table
end

function math.randint(a, b)
	if not b then
		return math.random() % a
	else
		(math.random() % (a - b)) + a --return a number between a & b
	end
end
