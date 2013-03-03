function table.shallow_copy(original_table)
	new_table = {}
	for k, v in pairs(original_table) do
		new_table[k] = v
	end
	return new_table
end
