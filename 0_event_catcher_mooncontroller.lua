-- Event Catcher code for the mooncontroller



-- ########
-- Helper functions
-- ########

local function get_string(data, maxdepth)
	local maxdepth = maxdepth or 3
	if type(data) == "string" then return data
	elseif type(data) == "table" and maxdepth > 0 then
		local oString = "{"
		for k, v in pairs(data) do
			local val = v
			if type(v) == "table" then val = get_string(val, maxdepth - 1) end
			oString = oString .. tostring(k) .. "=" .. tostring(val) .. ", "
		end
		return string.sub(oString, 1, -3) .. "}"
	else
		return tostring(data)
	end
	return "Something went wrong!"
end

local function get_time_string(datetable)
	local date_table = datetable or os.datetable()
	local date_string = date_table.year .. "-" .. date_table.month .. "-" .. date_table.day
	local time_string = date_table.hour .. ":" .. date_table.min .. ":" .. date_table.sec
	return date_string .. "T" .. time_string
end


-- ########
-- Event Catcher
-- ########

if mem.events == nil then mem.events = {count = 0} end

print("#" .. tostring(mem.events.count) .. ", " .. get_time_string() .. ":")
print(get_string(event))

mem.events.count = (mem.events.count + 1)%1000


-- ########
-- Variable Printer
-- ########

help = "\tType 'variables' to get a list of all global variables"
help = help .. "\n\tType the name of a variable to print it e.g. _G or help"
if event.type == "program" then print(help) end

local variables = {}
for k, v in pairs(_G) do
	variables[k] = v
end

if event.type == "terminal" then
	if event.text == "variables" then
		n_vars = 0
		for k, v in pairs(variables) do
			n_vars = n_vars + 1
			print(k)
		end
		print("\t" .. tostring(n_vars) .. " variables")
	else
		print(variables[event.text])
	end
end


-- MIT License
-- 
-- Copyright (c) 2021 Florian Finke
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
