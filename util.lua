function table.shallow_copy(original_table)
	local new_table = {}
	for k, v in pairs(original_table) do
		new_table[k] = v
	end
	return new_table
end

function math.randsin()
	if math.random() > 0.5 then
		return 1
	else
		return -1
	end
end

function math.distance(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
end

function table.join(t1, t2) --t2 overrides t1 keys
	t3 = table.shallow_copy(t1)
	for k, v in pairs(t2) do
		t3[k] = v
	end
	return t3
end

function table.index(t, item)
	for k, v in pairs(t) do
		if v == item then return k end
	end
end

function math.randint(a, b)
	if not b then
		return math.ceil(math.random() * a) % a
	else
		return (math.ceil(math.random() * b) % (b - a)) + a --return a number between a & b
	end
end

function math.round(n)
	if math.floor(n + n) >= (math.floor(n) + math.floor(n)) then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end
