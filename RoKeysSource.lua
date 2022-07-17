local uip = game:GetService("UserInputService")

local RoKeys = {}

RoKeys.inputTable = {}
RoKeys.bindTable = {}

--functions that return the value of a keybind
function RoKeys.BindState (bind)
	if RoKeys.bindTable[bind] ~= nil then --check to make sure the bind exists
		return RoKeys.bindTable[bind][1]
	else
		warn('Bind "' .. tostring(bind) .. '" does not exist or has not been created yet')
	end
end

function RoKeys.InputState (input)
	if RoKeys.inputTable[input] ~= nil then --check to make sure the input exists
		return RoKeys.inputTable[input][1]
	else
		warn('Input "' .. tostring(input) .. '" does not exist or has not been created yet')
	end
end

--the functions for adding a KeyBinds
local function addKey (input, toggle, bind)
	if RoKeys.inputTable[input] == nil then --check if the input exists
		RoKeys.inputTable[input] = {false, toggle}
	end
	table.insert(RoKeys.inputTable[input], bind) --insert references to eachother
	table.insert(RoKeys.bindTable[bind], input)
end

local function addBind (bind, toggle)
	if RoKeys.bindTable[bind] == nil then --checks if the bind exists
		RoKeys.bindTable[bind] = {false, toggle}
	end
end

local function addKeyLogic (input, bind, toggle)
	if typeof(input) == "EnumItem" then --check if the key variable is an enum
		addKey(input, toggle, bind)
	elseif typeof(input) == "table" then
		for j, jInput in ipairs(input) do --if it is a table then set the values of all the inputs
			if typeof(jInput) == "EnumItem" then --checks if it provides if it's a table inside of a table
				if typeof(input[2]) == "EnumItem" then --deals with an edge case of {input, toggle} being thought of as {input, input}
					addKey(jInput, toggle, bind)
				elseif typeof(input[2]) == "boolean" then
					addKey(jInput, input[2], bind)
				else
					warn('Input "' .. tostring(jInput) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {{Enum.KeyCode.X, true}, {Enum.KeyCode.Y, false}}')
				end
			elseif typeof(jInput) == "table" then
				addKey(jInput[1], jInput[2], bind)
			else
				warn('Input "' .. tostring(jInput) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {{Enum.KeyCode.X, true}, {Enum.KeyCode.Y, false}}')
			end
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when binding multiple inputs or applying toggles please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end
--main function for adding keybinds
function RoKeys.AddKeyBind (bind, input, bToggle, iToggle)
	if bToggle == nil then --defaults for mass toggle
		bToggle = false
	end
	if iToggle == nil then
		iToggle = false
	end
	if typeof(bind) == "string" then --determines wether it is making one key or multiple
		addBind(bind, bToggle)
		addKeyLogic(input, bind, iToggle)
	elseif typeof(bind) == "table" then
		for i, iBind in ipairs(bind) do --iterates through the multiple keys it needs to make
			if typeof(iBind) == "string" then
				if typeof(bind[2]) == "string" then
					addBind(iBind, bToggle)
				elseif typeof(bind[2]) == "boolean" then
					addBind(iBind, bind[2])
				else
					warn('BindName "' .. tostring(iBind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {{"Interact", false}, {"LeanRight", true}}')
				end
				addKeyLogic(input, iBind, iToggle)
			elseif typeof(iBind) == "table" then
				addBind(iBind[1], iBind[2])
				addKeyLogic(input, iBind[1], iToggle)
			else
				warn('BindName "' .. tostring(iBind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {{"Interact", false}, {"LeanRight", true}}')
			end
		end
	else
		warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when creating multiple binds or applying toggles please put them in a table... ex: {"Interact", "LeanRight"}')
	end
end

--functions for removing keybinds
local function DelKey (input, bind) --deleting keys
	if RoKeys.inputTable[input] ~= nil then --checks to make sure the input exists
		if bind == nil then --determines what behavior to use, to delete all instances or to delete a filtered ammount of instances
			for i = 3, table.getn(RoKeys.inputTable[input]) do --finds the input then deletes it
				table.remove(RoKeys.bindTable[RoKeys.inputTable[input][i]], table.find(RoKeys.bindTable[RoKeys.inputTable[input][i]], input))
			end
			RoKeys.inputTable[input] = nil
		else
			table.remove(RoKeys.inputTable[input], table.find(RoKeys.inputTable[input], bind)) --remove all references to bind in inputTable
		end
	else
		warn('Input "' .. tostring(input) .. '" does not exist or has not been created yet')
	end
end

local function DelBind (bind, input) --deleting binds
	if RoKeys.bindTable[bind] ~= nil then --checks to make sure the bind exists
		if input == nil then --determines what behavior to use, to delete all instances or to delete a filtered ammount of instances
			for i = 3, table.getn(RoKeys.bindTable[bind]) do --finds the bind then deletes it
				table.remove(RoKeys.inputTable[RoKeys.bindTable[bind][i]], table.find(RoKeys.inputTable[RoKeys.bindTable[bind][i]], bind))
			end
			RoKeys.bindTable[bind] = nil
		else
			table.remove(RoKeys.bindTable[bind], table.find(RoKeys.bindTable[bind], input)) --remove all references to input in bindTable
		end
	else
		warn('Bind "' .. tostring(bind) .. '" does not exist or has not been created yet')
	end
end

local function DelKeyLogic (input) --checks if it should delete multiple inputs or just one
	if typeof(input) == "EnumItem" then
		DelKey(input)
	elseif typeof(input) == "table" then
		for i, iInput in ipairs(input) do
			DelKey(iInput)
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when deleting multiple inputs please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end

local function DelBindLogic (bind) --checks if it should delete multiple binds or just one
	if typeof(bind) == "string" then
		DelBind(bind)
	elseif typeof(bind) == "table" then
		for i, iBind in ipairs(bind) do
			DelBind(iBind)
		end
	else
		warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when deleting binds please put them in a table... ex: {"Interact", "LeanRight"}')
	end
end
--this script deletes a specific keybind (an example being: Key W in Bind Up)
local function DelKeyBindLogic (bind, input)
	if typeof(input) == "EnumItem" then --determines if it should do it for multiple inputs
		DelKey(input, bind)
		DelBind(bind, input)
	elseif typeof(input) == "table" then
		for i, iInput in pairs(input) do --this does the same as before but now also does it for multiple inputs by iterating through them with a for loop
			DelKey(iInput, bind)
			DelBind(bind, iInput)
		end
	else
		warn('Input "' .. tostring(input) .. '" provided not EnumItem or Table, when unbinding multiple inputs please put them in a table... ex: {Enum.KeyCode.X, Enum.KeyCode.Y}')
	end
end

function RoKeys.DelKeyBind (bind, input)
	if bind == nil then --if bind is nil then delete all instances mentioned in input
		DelKeyLogic(input)
	elseif input == nil then --same thing but swap bind and input
		DelBindLogic(bind)
	else --if neither are nil do the default behavior
		if typeof(bind) == "string" then --determine wether multiple binds are given
			DelKeyBindLogic(bind, input)
		elseif typeof(bind) == "table" then
			for i, iBind in ipairs(bind) do
				DelKeyBindLogic(iBind, input)
			end
		else
			warn('BindName "' .. tostring(bind) .. '" provided not String or Table, when unbinding multiple keybinds please put them in a table... ex: {"Interact", "LeanRight"}')
		end
	end
	--print(RoKeys.inputTable, RoKeys.bindTable)
end

--for these I need to add support for more stuff maybe
local function InputOn (bind, input)
	bind[1] = true --make's all the input's binds true
end

local function InputOff (bind, input)
	bind[1] = false --makes the bind false
	for j = 3, table.getn(bind) do --if so...
		if RoKeys.inputTable[bind[j]] ~= input and RoKeys.inputTable[bind[j]][1] == true then --...check if any of them is true
			bind[1] = true --then set the bind back to true because it still has true inputs
		end --also checks to make sure it does not use the input to decide this cus otherwise toggling would not work
	end
end

--stuff for detecting inputs
local function inputBegan (input)
	input[1] = true --makes the input true
	for i = 3, table.getn(input) do
		if RoKeys.bindTable[input[i]][2] == false then --if toggle is off
			InputOn(RoKeys.bindTable[input[i]], input)
		else
			if RoKeys.bindTable[input[i]][1] == false then --bind toggling behavior
				InputOn(RoKeys.bindTable[input[i]], input)
			else
				InputOff(RoKeys.bindTable[input[i]], input)
			end
		end
	end
end

local function inputEnded (input)
	input[1] = false --make the input false
	for i = 3, table.getn(input) do --runs the following for every bind related to the input
		if RoKeys.bindTable[input[i]][2] == false then --checks to make sure the bind is not toggleable
			InputOff(RoKeys.bindTable[input[i]])
		end
	end
end

uip.InputBegan:Connect(function (input)
	if RoKeys.inputTable[input.KeyCode] ~= nil then --just checks if the key exists so it does not error for non-existant values
		if RoKeys.inputTable[input.KeyCode][2] == false then --if toggle is off
			inputBegan(RoKeys.inputTable[input.KeyCode])
		else
			if RoKeys.inputTable[input.KeyCode][1] == false then --input toggling behavior
				inputBegan(RoKeys.inputTable[input.KeyCode])
			else
				inputEnded(RoKeys.inputTable[input.KeyCode])
			end
		end
	end
end)

uip.InputEnded:Connect(function (input)
	if RoKeys.inputTable[input.KeyCode] ~= nil then --just checks if the key exists so it does not error for non-existant values
		if RoKeys.inputTable[input.KeyCode][2] == false then --if toggle is off
			inputEnded(RoKeys.inputTable[input.KeyCode])
		end
	end
end)


return RoKeys
