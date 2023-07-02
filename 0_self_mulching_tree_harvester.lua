-- local function get_string(data, maxdepth)
-- 	local maxdepth = maxdepth or 3
-- 	if type(data) == "string" then return data
-- 	elseif type(data) == "table" and maxdepth > 0 then
-- 		local oString = "{"
-- 		for k, v in pairs(data) do
-- 			local val = v
-- 			if type(v) == "table" then val = get_string(val, maxdepth - 1) end
-- 			oString = oString .. tostring(k) .. "=" .. tostring(val) .. ", "
-- 		end
-- 		return string.sub(oString, 1, -3) .. "}"
-- 	else
-- 		return tostring(data)
-- 	end
-- 	return "Something went wrong!"
-- end
-- 
-- -- ########
-- -- Interrupt Queue
-- -- ########
-- if event.type == "program" then
-- 	if mem.iq == nil then mem.iq = {} end
-- 	if mem.iq.delay == nil then mem.iq.delay = {} end
-- 	if mem.iq.delay.min == nil then mem.iq.delay.min = 0 end
-- 	if mem.iq.delay.default == nil then mem.iq.delay.default = 4 end
-- 	if mem.iq.delay.max == nil then mem.iq.delay.max = 16 end
-- 	if mem.iq.queue == nil then mem.iq.queue = {} end
-- end
-- 
-- local iq = {
-- 	actions = {
-- 		default = {
-- 			exec = function ()
-- --                   table.insert(mem.iq.queue, iq.actions.default) -- BUG This doesn't work at the first run!
--                   digiline_send("mon", "default")
--                   return
-- 			end,
-- 			delay = mem.iq.delay.default
-- 		}
-- 	}
-- }
-- if event.type == "program" or #mem.iq.queue == 0 then table.insert(mem.iq.queue, iq.actions.default) end
-- 
-- interrupt(mem.iq.delay.default + heat)
-- 
-- if event.type == "interrupt" then
-- 	digiline_send("mon", "interrupt")
-- 	if #mem.iq.queue > 0 then
-- 		local queue = {}
-- 		for i, v in ipairs(mem.iq.queue) do
-- 			if i == 1 then
-- 				digiline_send("mon", get_string(mem.iq.queue[i]))
-- 				mem.iq.queue[i].exec()
-- 				if mem.iq.queue[i].delay then
-- 					interrupt(mem.iq.queue[i].delay + heat)
-- 				else
-- 					interrupt(mem.iq.delay.default + heat)
-- 				end
-- 			else
-- 				table.insert(queue, mem.iq.queue[i])
-- 			end
-- 		end
-- 		if #queue > 0 then
-- 			mem.iq.queue = queue
-- 		else
-- 			mem.iq.queue = {iq.actions.default}
-- 		end
-- 		-- Display action key
-- 	else
-- 		-- Display action key
-- 	end
-- end


-- ########
-- Self Mulching Tree Harvester
-- ########
smth = {
	delay = 2,
	plant_port = "a",
	mulch_port =  "b",
	cut_port = "c"
}
if mem.smth == nil then mem.smth = {} end
if mem.smth.cycle == nil then mem.smth.cycle = 0 end

if event.type == "program" then interrupt(smth.delay + heat * heat) end

if event.type == "interrupt" then
	if mem.smth.cycle == 0 then -- Plant
		digiline_send("smth.plant", {[smth.plant_port] = true})
	elseif mem.smth.cycle == 1 then -- Recharge
		digiline_send("smth.recharge", {slotseq = "random", exmatch = false})
		
		digiline_send("smth.plant", {a = false; b = false; c = false; d = false})
	elseif mem.smth.cycle == 2 then -- Mulch
		port[smth.mulch_port] = true
	elseif mem.smth.cycle == 3 then -- Mulch
		port[smth.mulch_port] = false
		
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 1, name = "technic:chainsaw"})
	elseif mem.smth.cycle == 4 then -- Mulch
		port[smth.mulch_port] = true
	elseif mem.smth.cycle == 5 then -- Wait for chainsaw
		port[smth.mulch_port] = false
		
		digiline_send("smth.craft_out", {slotseq = "random", exmatch = false})
	elseif mem.smth.cycle == 6 then -- Mulch
		port[smth.mulch_port] = true
	elseif mem.smth.cycle == 7 then -- Mulch
		port[smth.mulch_port] = false
		
		digiline_send("smth.craft_out", {slotseq = "random", exmatch = false})
	elseif mem.smth.cycle == 8 then -- Cut TODO Check with node detector
		port[smth.cut_port] = true
	elseif mem.smth.cycle == 9 then -- Wait for vacuum tube
		port[smth.cut_port] = false
		
		digiline_send("smth.craft_out", {slotseq = "random", exmatch = false})
	elseif mem.smth.cycle == 10 then -- Craft date_palm_
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:rubber_tree_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:rubber_tree_leaves"})
		
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:date_palm_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:date_palm_leaves"})
		
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:palm_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:palm_leaves"})
		
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:cedar_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:cedar_leaves"})
		
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:oak_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:oak_leaves"})

		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 1, name = "moretrees:fir_trunk"})
		digiline_send("smth.craft", {slotseq = "random", exmatch = true, count = 8, name = "moretrees:fir_leaves_bright"})
	elseif mem.smth.cycle == 11 then -- Eject
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:rubber_tree_sapling"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:rubber_tree_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:rubber_tree_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:rubber_tree_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:rubber_tree_trunk"})
		
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:date_palm_sapling"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:date_palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:date_palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:date_palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:date_palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:date_palm_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:date"})
-- 
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:palm_sapling"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:palm_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:palm_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:coconut"})
		
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:cedar_sapling"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:cedar_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:cedar_cone"})
		
		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:oak_sapling"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_leaves"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:oak_trunk"})
		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:acorn"})
		
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:fir_sapling"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves_bright"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves_bright"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves_bright"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves_bright"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_leaves_bright"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = true, count = 99, name = "moretrees:fir_trunk"})
-- 		digiline_send("smth.out", {slotseq = "random", exmatch = false, count = 99, name = "moretrees:fir_cone"})
		
		digiline_send("smth.craft_out", {slotseq = "random", exmatch = false})
		
	end
	digiline_send("mon", "C=" .. tostring(mem.smth.cycle))
	interrupt(smth.delay + heat)
	mem.smth.cycle = (mem.smth.cycle + 1)%12
end
