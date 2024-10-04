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

--functions that return the value of a keybind

function Custom:GetBindState (bind)
	if Custom.BindTable[bind] ~= nil then --check to make sure the bind exists
		return Custom.BindTable[bind]["Value"]
	else
		warn('Bind "' .. tostring(bind) .. '" does not exist or has not been created yet')
	end
end

function Custom:GetInputState (input)
	if Custom.InputTable[input] ~= nil then --check to make sure the input exists
		return Custom.InputTable[input]["Value"]
	else
		warn('Input "' .. tostring(input) .. '" does not exist or has not been created yet')
	end
end

function Custom.BindState (bind)
	warn("'RoKeys.BindState' IS DEPRECATED, USE 'RoKeys:GetBindState'")
	return Custom:GetBindState(bind)
end

function Custom.InputState (input)
	warn("'RoKeys.InputState' IS DEPRECATED, USE 'RoKeys:GetInputState'")
	return Custom:GetInputState(input)
end

--the functions for adding a KeyBinds (scroll down for starting function)

local function NewInput (input, toggle, bind)
	if Custom.InputTable[input] == nil then --check if the input exists
		Custom.InputTable[input] = {Value = false, Toggle = toggle, Refs = {}}
	end
	table.insert(Custom.InputTable[input]["Refs"], bind) --insert references to eachother
	table.insert(Custom.BindTable[bind]["Refs"], input)
end

local function NewBind (bind, toggle)
	if Custom.BindTable[bind] == nil then --checks if the bind exists
		Custom.BindTable[bind] = {Value = false, Toggle = toggle, Refs = {}}
	end
end

local function NewInputLogic (input, bind, toggle)
	if typeof(input) == "EnumItem" then --check if the key variable is an enum
		NewInput(input, toggle, bind)
	elseif typeof(input) == "table" then
		for j, jInput in ipairs(input) do --if it is a table then set the values of all the inputs
			if typeof(jInput) == "EnumItem" then --checks if it provides if it's a table inside of a table
				if typeof(input[2]) == "EnumItem" then --deals with an edge case of {input, toggle} being thought of as {input, input}
					NewInput(jInput, toggle, bind)
				elseif typeof(input[2]) == "boolean" then
					NewInput(jInput, input[2], bind)
				else
					warn('Input "' .. tostring(jInput) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {{Enum.KeyCode.X, true}, {Enum.KeyCode.Y, false}}')
				end
			elseif typeof(jInput) == "table" then
				NewInput(jInput[1], jInput[2], bind)
			else
				warn('Input "' .. tostring(jInput) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {{Enum.KeyCode.X, true}, {Enum.KeyCode.Y, false}}')
			end
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end

--main function for adding keybinds
function Custom.New (args)
	local input = args["Input"]
	local bind = args["Bind"]
	local inputToggle = args["InputToggle"]
	local bindToggle = args["BindToggle"]
	
	if bindToggle == nil then --defaults for mass toggle
		bindToggle = false
	end
	if inputToggle == nil then
		inputToggle = false
	end
	if typeof(bind) == "string" then --determines wether it is making one key or multiple
		NewBind(bind, bindToggle)
		NewInputLogic(input, bind, inputToggle)
	elseif typeof(bind) == "table" then
		for i, iBind in ipairs(bind) do --iterates through the multiple keys it needs to make
			if typeof(iBind) == "string" then
				if typeof(bind[2]) == "string" then
					NewBind(iBind, bindToggle)
				elseif typeof(bind[2]) == "boolean" then
					NewBind(iBind, bind[2])
				else
					warn('BindName "' .. tostring(iBind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {{"Interact", false}, {"LeanRight", true}}')
				end
				NewInputLogic(input, iBind, inputToggle)
			elseif typeof(iBind) == "table" then
				NewBind(iBind[1], iBind[2])
				NewInputLogic(input, iBind[1], inputToggle)
			else
				warn('BindName "' .. tostring(iBind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {{"Interact", false}, {"LeanRight", true}}')
			end
		end
	else
		warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {"Interact", "LeanRight"}')
	end
end

function Custom.addKeyBind (b, i, bt, it) --DEPRECATED FUNCTION
	Custom.New({ bind = b, input = i, bindToggle = bt, inputToggle = it })
	warn("'RoKeys.addKeyBind' IS DEPRECATED, USE 'RoKeys.Add' INSTEAD")
end

--functions for removing keybinds (scroll down for starting function)
local function RemoveInput (input, bind) --deleting keys
	if Custom.InputTable[input] ~= nil then --checks to make sure the input exists
		if bind == nil then --determines what behavior to use, to delete all instances or to delete a filtered ammount of instances
			for i, bindref in ipairs(Custom.InputTable[input]["Refs"]) do --finds the input then deletes it
				table.remove(Custom.BindTable[bindref], table.find(Custom.BindTable[bindref], input))
			end
			Custom.InputTable[input] = nil
		else
			table.remove(Custom.InputTable[input]["Refs"], table.find(Custom.InputTable[input]["Refs"], bind)) --remove all references to bind in InputTable
		end
	else
		warn('Input "' .. tostring(input) .. '" does not exist or has not been created yet')
	end
end

local function RemoveBind (bind, input) --deleting binds
	if Custom.BindTable[bind] ~= nil then --checks to make sure the bind exists
		if input == nil then --determines what behavior to use, to delete all instances or to delete a filtered ammount of instances
			for i, inputref in ipairs(Custom.BindTable[bind]["Refs"]) do --finds the bind then deletes it
				table.remove(Custom.InputTable[inputref], table.find(Custom.InputTable[inputref], bind))
			end
			Custom.BindTable[bind] = nil
		else
			table.remove(Custom.BindTable[bind]["Refs"], table.find(Custom.BindTable[bind]["Refs"], input)) --remove all references to input in BindTable
		end
	else
		warn('Bind "' .. tostring(bind) .. '" does not exist or has not been created yet')
	end
end

local function RemoveInputLogic (input) --checks if it should delete multiple inputs or just one
	if typeof(input) == "EnumItem" then
		RemoveInput(input)
	elseif typeof(input) == "table" then
		for i, iInput in ipairs(input) do
			RemoveInput(iInput)
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when deleting multiple inputs please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end

local function RemoveBindLogic (bind) --checks if it should delete multiple binds or just one
	if typeof(bind) == "string" then
		RemoveBind(bind)
	elseif typeof(bind) == "table" then
		for i, iBind in ipairs(bind) do
			RemoveBind(iBind)
		end
	else
		warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when deleting binds please put them in a table... ex: {"Interact", "LeanRight"}')
	end
end
--this script deletes a specific keybind (an example being: Key W in Bind Up)
local function RemoveBothLogic (bind, input)
	if typeof(input) == "EnumItem" then --determines if it should do it for multiple inputs
		RemoveInput(input, bind)
		RemoveBind(bind, input)
	elseif typeof(input) == "table" then
		for i, iInput in pairs(input) do --this does the same as before but now also does it for multiple inputs by iterating through them with a for loop
			RemoveInput(iInput, bind)
			RemoveBind(bind, iInput)
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when unbinding multiple inputs please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end

--main funtion for deleting keybinds
function Custom.Remove (args)
	local input = args["Input"]
	local bind = args["Bind"]
	
	if bind == nil then --if bind is nil then delete all instances mentioned in input
		RemoveInputLogic(input)
	elseif input == nil then --same thing but swap bind and input
		RemoveBindLogic(bind)
	else --if neither are nil do the default behavior
		if typeof(bind) == "string" then --determine wether multiple binds are given
			RemoveBothLogic(bind, input)
		elseif typeof(bind) == "table" then
			for i, iBind in ipairs(bind) do
				RemoveBothLogic(iBind, input)
			end
		else
			warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when unbinding multiple keybinds please put them in a table... ex: {"Interact", "LeanRight"}')
		end
	end
	--print(Custom.InputTable, Custom.BindTable)
end

function Custom.DelKeyBind (b, i) --DEPRECATED FUNCTION
	Custom.Remove({ bind = b, input = i })
	warn("'RoKeys.DelKeyBind' IS DEPRECATED, USE 'RoKeys.Remove' INSTEAD")
end

--stuff for detecting inputs
--for these I need to add support for more stuff maybe
local function InputOn (bindName)
	Custom.BindTable[bindName]["Value"] = true --make's all the input's binds true
	script.BindBegan:Fire(bindName) --fires bind event
end

local function InputOff (bindName, input)
	Custom.BindTable[bindName]["Value"] = false --makes the bind false
	for i, inputref in ipairs(Custom.BindTable[bindName]["Refs"]) do --if so...
		if Custom.InputTable[inputref] ~= input and Custom.InputTable[inputref]["Value"] == true then --...check if any of them is true
			Custom.BindTable[bindName]["Value"] = true --then set the bind back to true because it still has true inputs
		end --also checks to make sure it does not use the input to decide this cus otherwise toggling would not work
	end
	if Custom.BindTable[bindName]["Value"] == false then --checks if bind is still made false
		script.BindEnded:Fire(bindName) --fires bind event
	end
end

local function inputBegan (inputName)
	Custom.InputTable[inputName]["Value"] = true --makes the input true
	script.InputBegan:Fire(inputName) --fires input event
	for i, bindref in ipairs(Custom.InputTable[inputName]["Refs"]) do
		if Custom.BindTable[bindref]["Toggle"] == false then --if toggle is off
			InputOn(bindref)
		else
			if Custom.BindTable[Custom.InputTable[inputName]["Refs"][i]]["Value"] == false then --bind toggling behavior
				InputOn(bindref)
			else
				InputOff(bindref, Custom.InputTable[inputName]["Refs"])
			end
		end
	end
end

local function inputEnded (inputName)
	Custom.InputTable[inputName]["Value"] = false --make the input false
	script.InputEnded:Fire(inputName) --fires input event
	for i, bindref in ipairs(Custom.InputTable[inputName]["Refs"]) do --runs the following for every bind related to the input
		if Custom.BindTable[bindref]["Toggle"] == false then --checks to make sure the bind is not toggleable
			InputOff(bindref)
		end
	end
end

uip.InputBegan:Connect(function (input)
	if Custom.InputTable[input.KeyCode] ~= nil then --just checks if the key exists so it does not error for non-existant values
		if Custom.InputTable[input.KeyCode]["Toggle"] == false then --if toggle is off
			inputBegan(input.KeyCode)
		else
			if Custom.InputTable[input.KeyCode]["Value"] == false then --input toggling behavior
				inputBegan(input.KeyCode)
			else
				inputEnded(input.KeyCode)
			end
		end
	end
end)

uip.InputEnded:Connect(function (input)
	if Custom.InputTable[input.KeyCode] ~= nil then --just checks if the key exists so it does not error for non-existant values
		if Custom.InputTable[input.KeyCode]["Toggle"] == false then --if toggle is off
			inputEnded(input.KeyCode)
		end
	end
end)

function Custom.Pause (args)
	local input = args["Input"]
	local bind = args["Input"]
end

return Custom
