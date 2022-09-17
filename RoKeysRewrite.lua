--[[
Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

local uip = game:GetService("UserInputService")

local Custom = {}

Custom.InputTable = {}
Custom.BindTable = {}

Custom.InputBegan = script.InputBegan.Event
Custom.InputEnded = script.InputEnded.Event
Custom.BindBegan = script.BindBegan.Event
Custom.BindEnded = script.BindEnded.Event

local function err (num)
	--Depricated warnings
	if num == 00 then
		return "THIS FUNCTION IS DEPRICATED | INSTEAD USE:"
	end
	--Add/Remove
	if num == 10 then
		return "[Name] not provided"
	end
	--Get
	if num == 20 then
		return "Bind does not exist:"
	end
	if num == 21 then
		return "Input does not exist:"
	end
end

--functions that return the value of a keybind
function Custom:GetBindState (bind)
	if Custom.BindTable[bind] ~= nil then --check to make sure the bind exists
		return Custom.BindTable[bind]["Value"]
	else
		warn(err(20) .. tostring(bind))
	end
end

function Custom:GetInputState (input)
	if Custom.InputTable[input] ~= nil then --check to make sure the input exists
		return Custom.InputTable[input]["Value"]
	else
		warn(err(21) .. tostring(input))
	end
end

--DEPRECATED FUNCTIONS
function Custom.BindState (bind)
	warn(err(00) .. ":GetBindState")
end

function Custom.InputState (input)
	warn(err(00) .. ":GetInputState")
end

--The end all be all of reducing repeated code
local function Decode (item)
	local outcome = {}

	local function insert (foo)
		table.insert(outcome, {
			--we need to make sure the name exists (if not error)
			Name = if foo["Name"] then foo["Name"] else warn(err(10)),
			--these other values are not as important
			Toggle = if foo["Toggle"] then foo["Toggle"] else nil,
			Value = if foo["Value"] then foo["Value"] else nil,
		})
	end

	if typeof(item) == "table" then
		if item[1] then --tells us if the item is an array or a dictonary
			--array (which means they are probobly providing multiple items)
			for i, foo in ipairs(item) do
				if typeof(foo) == table then
					--treats foo as a table (TODO: assumes it's a dictonary so should probobly error if it's not)
					insert(foo)
				else
					--treats foo as just one value so sets Name
					insert({Name = foo})
				end
			end
		else
			--dictonary (which they are probobly providing more than just the name)
			insert(item)
		end
	else
		--item is just one value
		insert({Name = item})
	end
	
	return outcome
end

--The function for adding keybinds
function Custom.New (args)
	local input = args["Input"] or args["Inputs"] or nil
	local bind = args["Bind"] or args["Binds"] or nil
	local inputToggle = args["InputToggle"] or false
	local bindToggle = args["BindToggle"] or false
	local inputValue = args["InputValue"] or false
	local bindValue = args["BindValue"] or false
	
	local i = if input then Decode(input) else {}
	local b = if bind then Decode(bind) else {}
	
	--these two for loops just set up the binds/inputs
	for j, foo in ipairs(b) do
		Custom.BindTable[foo["Name"]] = {
			Value = foo["Value"] or bindValue or false,
			Toggle = foo["Toggle"] or bindToggle or false,
			Refs = {}
		}
		--insert all references to inputs
		for k, bar in ipairs(i) do
			table.insert(Custom.BindTable[foo["Name"]].Refs, bar["Name"])
		end
	end
	for j, foo in ipairs(i) do
		Custom.InputTable[foo["Name"]] = {
			Value = foo["Value"] or inputValue or false,
			Toggle = foo["Toggle"] or inputToggle or false,
			Refs = {}
		}
		--insert all references to binds
		for k, bar in ipairs(b) do
			table.insert(Custom.InputTable[foo["Name"]].Refs, bar["Name"])
		end
	end
end

function Custom.addKeyBind (b, i, bt, it) --DEPRECATED FUNCTION
	warn("'RoKeys.addKeyBind' IS DEPRECATED, USE 'RoKeys.Add' INSTEAD")
end

--functions for removing keybinds

--main funtion for removing keybinds
function Custom.Remove (args)
	local input = args["Input"] or args["Inputs"] or nil
	local bind = args["Bind"] or args["Inputs"] or nil
	
	
end

function Custom.DelKeyBind (b, i) --DEPRECATED FUNCTION
	warn("'RoKeys.DelKeyBind' IS DEPRECATED, USE 'RoKeys.Remove' INSTEAD")
end

--stuff for detecting inputs

uip.InputBegan:Connect(function (input)
	if Custom.InputTable[input] then --make sure it exists
		Custom.InputTable[input].Value = true
		--set all related binds to true
		for i, bind in ipairs(Custom.InputTable[input].Refs) do
			Custom.BindTable[bind].Value = true
		end
	end
end)

uip.InputEnded:Connect(function (input)
	if Custom.InputTable[input] then --make sure it exists
		Custom.InputTable[input].Value = false
		--set all related binds to true
		for i, foo in ipairs(Custom.InputTable[input].Refs) do
			Custom.BindTable[foo].Value = false
			--does a second check to see if any of the bind's inputs are true
			for j, bar in ipairs(Custom.BindTable[foo].Refs) do
				--if the input is true then set the bind back to true
				if Custom.InputTable[bar].Value == true then
					Custom.BindTable[foo].Value = true
				end
			end
		end
	end
end)

function Custom.Pause (args)
	local input = args["Input"]
	local bind = args["Bind"]
end

return Custom