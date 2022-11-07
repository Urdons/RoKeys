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

Custom.TagTable = {}

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
		return Custom.BindTable[bind].Value
	else
		warn(err(20) .. tostring(bind))
	end
end

function Custom:GetInputState (input)
	if Custom.InputTable[input] ~= nil then --check to make sure the input exists
		return Custom.InputTable[input].Value
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
function Custom.Format (item)
	local outcome = {}

	local function insert (item)
		table.insert(outcome, {
			--we need to make sure the name exists (if not error)
			Name = if item.Name then item.Name else warn(err(10)),
			--these other values are not as important
			Toggle = item.Toggle or nil,
			Value = item.Value or nil,
			Paused = item.Paused or nil,
			Refs = item.Refs or nil,
		})
	end

	if typeof(item) == "table" then
		if item[1] then --tells us if the item is an array or a dictonary
			--array (which means they are probobly providing multiple items)
			for i, iitem in ipairs(item) do
				if typeof(iitem) == "table" then
					--treats iitem as a table (TODO: assumes it's a dictonary so should probobly error if it's not)
					insert(iitem)
				else
					--treats iitem as just one value so sets Name
					insert({Name = iitem})
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
	local inputs = args["Inputs"] or nil --turn these into errors when nil
	local binds = args["Binds"] or nil
	
	local i = if inputs then Custom.Format(inputs) else {}
	local b = if binds then Custom.Format(binds) else {}
	--collects the names of all the keybinds as they are created and returns them
	local bs = {}
	local is = {}
	
	--these two for loops just set up the binds/inputs
	for j, ibind in ipairs(b) do
		if not Custom.BindTable[ibind.Name] then
			--if the bind does not already exist then create it
			Custom.BindTable[ibind.Name] = {
				Value = ibind.Value or args.Binds["Value"] or args["BindValue"] or false,
				Toggle = ibind.Toggle or args.Binds["Toggle"] or args["BindToggle"] or false,
				Paused = ibind.Paused or args.Binds["Paused"] or args["BindPaused"] or false,
				Refs = ibind.Refs or args.Binds["Refs"] or args["BindRefs"] or {},
			}
			table.insert(bs, ibind.Name)
		end
		--insert all references to inputs
		for k, iinput in ipairs(i) do
			if not table.find(Custom.BindTable[ibind.Name].Refs, iinput.Name) then
				table.insert(Custom.BindTable[ibind.Name].Refs, iinput.Name)
			end
		end
	end
	for j, iinput in ipairs(i) do
		if not Custom.InputTable[iinput.Name] then
			--if the input does not already exist then create it
			Custom.InputTable[iinput.Name] = {
				Value = iinput.Value or args.Inputs["Value"] or args["InputValue"] or false,
				Toggle = iinput.Toggle or args.Inputs["Toggle"] or args["InputToggle"] or false,
				Paused = iinput.Paused or args.Inputs["Paused"] or args["InputPaused"] or false,
				Refs = iinput.Refs or args.Inputs["Refs"] or args["InputRefs"] or {}
			}
			table.insert(is, iinput.Name)
		end
		--insert all references to binds
		for k, ibind in ipairs(b) do
			if not table.find(Custom.InputTable[iinput.Name].Refs, ibind.Name) then
				table.insert(Custom.InputTable[iinput.Name].Refs, ibind.Name)
			end
		end
	end
	
	return bs, is
end

function Custom.addKeyBind (b, i, bt, it) --DEPRECATED FUNCTION
	warn("'RoKeys.addKeyBind' IS DEPRECATED, USE 'RoKeys.New' INSTEAD")
end

--functions for removing keybinds

--main funtion for removing keybinds
function Custom.Remove (args)
	local inputs = args["Inputs"] or nil
	local binds = args["Binds"] or nil

	local i = if inputs then Custom.Format(inputs) else {}
	local b = if binds then Custom.Format(binds) else {}
	--collects the names of all the keybinds as they are created and returns them
	local bs = {}
	local is = {}
	
	for j, ibind in ipairs(b) do
		if not inputs then
			for k, iinput in ipairs(Custom.BindTable[ibind.Name].Refs) do
				--remove references to bind in it's inputs
				table.remove(Custom.InputTable[iinput].Refs, table.find(Custom.InputTable[iinput].Refs, ibind.Name))
			end
			Custom.BindTable[ibind.Name] = nil
		else
			--if an input is provided just remove any of the refs
			for k, iinput in ipairs(i) do
				table.remove(Custom.BindTable[ibind.Name].Refs, table.find(Custom.BindTable[ibind.Name].Refs, iinput.Name))
			end
		end
		table.remove(bs, ibind.Name)
	end
	for j, iinput in ipairs(b) do
		if not binds then
			for k, ibind in ipairs(Custom.InputTable[iinput.Name].Refs) do
				--remove references to input in it's binds
				table.remove(Custom.BindTable[ibind].Refs, table.find(Custom.BindTable[ibind].Refs, iinput.Name))
			end
			Custom.InputTable[iinput.Name] = nil
		else
			--if an bind is provided just remove any of the refs
			for k, ibind in ipairs(b) do
				table.remove(Custom.InputTable[iinput.Name].Refs, table.find(Custom.InputTable[iinput.Name].Refs, ibind.Name))
			end
		end
		table.remove(is, iinput.Name)
	end
	
	return bs, is
end

function Custom.Reset (scale : string)
	if scale == "ALL" then
		--resets everything
		Custom.BindTable = {}
		Custom.InputTable = {}
	elseif scale == "BINDS" then
		--resets only binds and their references
		for i, bind in pairs(Custom.BindTable) do
			for j, ref in ipairs(bind.Refs) do
				table.remove(Custom.InputTable[ref].Refs, table.find(Custom.InputTable[ref].Refs, bind))
			end
		end
		Custom.BindTable = {}
	elseif scale == "INPUTS" then
		--resets only binds and their references
		for i, input in pairs(Custom.BindTable) do
			for j, ref in ipairs(input.Refs) do
				table.remove(Custom.BindTable[ref].Refs, table.find(Custom.BindTable[ref].Refs, input))
			end
		end
		Custom.InputTable = {}
	end
end

function Custom.DelKeyBind (b, i) --DEPRECATED FUNCTION
	warn("'RoKeys.DelKeyBind' IS DEPRECATED, USE 'RoKeys.Remove' INSTEAD")
end

--stuff for detecting inputs
uip.InputBegan:Connect(function (i)
	if Custom.InputTable[i.KeyCode] and not Custom.InputTable[i.KeyCode].Paused then
		local input = Custom.InputTable[i.KeyCode]
		
		--input
		if input.Toggle then
			--toggle is true
			if input.Value then
				--toggle off
				input.Value = false
				script.InputEnded:Fire(i.KeyCode)
			else
				--toggle on
				input.Value = true
				script.InputBegan:Fire(i.KeyCode)
			end
		else
			--toggle is false
			if not input.Value then
				input.Value = true
				script.InputBegan:Fire(i.KeyCode)
			end
		end
		--bind
		for i, b in ipairs(input.Refs) do
			local bind = Custom.BindTable[b]
			
			if not bind.Paused then
				if bind.Toggle then
					--toggle is true
					if bind.Value then
						--toggle off
						bind.Value = false
						script.BindEnded:Fire(b)
					else
						--toggle on
						bind.Value = true
						script.BindBegan:Fire(b)
					end
				else
					--toggle is false
					if not bind.Value then
						bind.Value = true
						script.BindBegan:Fire(b)
					end
				end
			end
		end
	end
end)

uip.InputEnded:Connect(function (i)
	i = i.KeyCode
	if Custom.InputTable[i] and not Custom.InputTable[i].Paused then
		local input = Custom.InputTable[i]
		
		if not input.Toggle and input.Value then
			--toggle is false and the input's Value is true
			input.Value = false
			script.InputEnded:Fire(i)
			for j, b in ipairs(input.Refs) do
				local bind = Custom.BindTable[b]
				
				if not bind.Toggle and bind.Value and not bind.Paused then
					--toggle is false and the bind's Value is true
					bind.Value = false
					--for binds you must make a second check to make sure none of the inputs are true
					for k, ref in ipairs(bind.Refs) do
						--if one is true then set the bind back to true
						if Custom.InputTable[ref].Value then
							bind.Value = true
						end
					end
					--then check if the bind is still false
					if not bind.Value then
						script.BindEnded:Fire(b)
					end
				end
			end
		end
	end
end)

function Custom.Pause (args)	
	local binds = args["Binds"] or {}
	local inputs = args["Inputs"] or {}
	--if they arent tables just make them tables
	if typeof(binds) ~= "table" then binds = {binds} end
	if typeof(inputs) ~= "table" then inputs = {inputs} end
	
	for i, bind in ipairs(binds) do
		Custom.BindTable[bind].Paused = if Custom.BindTable[bind].Paused then false else true
	end
	for i, input in ipairs(inputs) do
		Custom.BindTable[input].Paused = if Custom.BindTable[input].Paused then false else true
	end
end

function Custom.Resume (args)	
	local binds = args["Binds"] or {}
	local inputs = args["Inputs"] or {}
	--if they arent tables just make them tables
	if typeof(binds) ~= "table" then binds = {binds} end
	if typeof(inputs) ~= "table" then inputs = {inputs} end

	for i, bind in ipairs(binds) do
		Custom.BindTable[bind].Paused = true
	end
	for i, input in ipairs(inputs) do
		Custom.BindTable[input].Paused = true
	end
end

return Custom
