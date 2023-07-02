--[[ Multi Ingredient Autocrafter (MIA)

Setup:
	Input tube for stacks of ingredients
		Mithril Chest (Channel stored in mithril_chest)
			Digiline Injector (Channel stored in injector_excess)
				Output tube for excess/wrong stacks put in
			Digiline Injector (Channel stored in injector_craft)
				Autocrafter (Channel stored in autocrafter)
					Digiline Injector (Channel stored in injector_output)
						Output tube for crafted items

BUG	Hardcoded Stacksize, doesn't propperly work with buckets and unnecessarily resource intense for minegeld
]]

-- Settings
local recipe = {
	{"default:stick", "default:wood", "default:stick"},
	{"default:wood", "", "default:wood"},
	{"default:stick", "default:wood", "default:stick"}
}

local channels = {
	mithril_chest = "mc",
	autocrafter = "ac",
	injector_craft = "i_craft",
	injector_excess = "i_excess",
	injector_output = "i_out"
}

local cycle_length = 33
local max_cafts_per_cycle = cycle_length
local max_craft_ingredients_kept = max_cafts_per_cycle * 9

-- Functions
local function get_ingredient_list(reci)
	reci = reci or recipe
	local ingredients = {}
	for i, v in ipairs(reci) do
		for j, w in ipairs(v) do
			if w ~= "" then
				if ingredients[w] == nil then ingredients[w] = 1
				else ingredients[w] = ingredients[w] + 1
				end
			end
		end
	end
	local ingredient_list = {type = {}, amount = {}}
	for t, a in pairs(ingredients) do
		table.insert(ingredient_list.type, t)
		table.insert(ingredient_list.amount, a)
	end
	return ingredient_list
end

local function get_max_crafts (ingredient_list, content)
	ingredient_list = ingredient_list or get_ingredient_list(recipe)
	content = content or event.msg
	local available = {}
	for i, t in ipairs(ingredient_list.type) do table.insert(available, 0)	end
	for slot, stack in ipairs(content) do
		local i_seperator = stack:find(" ", 1, true)
		if i_seperator ~= nil then
			for i, t in ipairs(ingredient_list.type) do
				if stack:sub(1, i_seperator - 1) == t then
					available[i] = available[i] + tonumber(stack:sub(i_seperator + 1))
					break
				end
			end
		end
	end
	local max_crafts = 10000
	for i, a in ipairs(ingredient_list.amount) do
		available[i] = math.floor(available[i] / a)
		if max_crafts > available[i] then max_crafts = available[i] end
	end
	return max_crafts
end

-- Do stuff
if event.type == "program" then
	digiline_send(channels.autocrafter, recipe)
	digiline_send(channels.autocrafter, "on")
	interrupt(cycle_length + heat)
elseif event.type == "interrupt" then
	digiline_send(channels.mithril_chest, {command = "sort"})
	digiline_send(channels.mithril_chest, {command = "get_list"})
	for i = 1, 9 do digiline_send(channels.injector_output, {slotseq = 0, exmatch = false}) end
	interrupt(cycle_length + heat)
elseif event.type == "digiline" then
	if event.channel == channels.mithril_chest and type(event.msg) == "table" then
		local ingredient_list = get_ingredient_list()
		local crafts = math.min(get_max_crafts(ingredient_list), max_cafts_per_cycle)
		for i, a in ipairs(ingredient_list.amount) do
			local to_send = crafts * a
			-- BUG: Hardcoded Stacksize
			local full_stacks = math.floor(to_send / 99)
			for n = 1, full_stacks do
				digiline_send(channels.injector_craft, {slotseq = 0, exmatch = true, name = ingredient_list.type[i], count = 99})
			end
			to_send = to_send - 99 * full_stacks
			if to_send > 0 then
				digiline_send(channels.injector_craft, {slotseq = 0, exmatch = true, name = ingredient_list.type[i], count = to_send})
			end
			-- TODO Extract non fitting and overdue stacks
		end
	end
end
