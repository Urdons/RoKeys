## THIS BRANCH IS WORK IN PROGRESS
The Readme may be inaccurate to the current state of RoKeys <br>
**UNSTABLE: MAY NOT WORK AS INTENDED**

![RoKeysIconFullTransparent](https://user-images.githubusercontent.com/56717172/179380379-839275a7-7558-4770-91a3-9f79baef7d1e.png)
![RoKeysTitleWhite](https://user-images.githubusercontent.com/56717172/179380393-f7eef77b-5d62-4598-9b62-4828f6aadb9e.png#gh-dark-mode-only)
![RoKeysTitleBlack](https://user-images.githubusercontent.com/56717172/179382515-69fef072-3b67-4a44-b917-2eb5b1b33488.png#gh-light-mode-only)

**RoKeys** is an *Open-source* Keybinding script for **Roblox** that strives for *usability* and *versatility*

Links: 
- **Trello**: *https://trello.com/b/QfWxcNrH/rokeys*
- **Discord**: *https://discord.gg/AyqHpaUnTe*
- **Roblox**: *https://www.roblox.com/library/10263313095/RoKeys*

On this page you will find sections labeled as follows: <br>
- **Installation**, <br>
- **Basic Use**, <br>
- **Advanced Use,** <br>
- **FAQ,** and <br>
- **Licensing** <br>

## Installation

To **Install** all you need to do is download the *latest version* from the **Releases Page**. <br>
The file to look for will look *something* like this: `RoKeys.lua`
> if using an older version: the documentation can be found in the source files on the download page

Once you've downloaded the file to your *prefered destination* all you have to do is make a **Roblox project** <br>
Then *(assuming you know how to make a new project)*, in **Roblox Studio** navigate to the `View` tab as seen at the *top* of the window. <br>
![Screenshot_20220716_235308](https://user-images.githubusercontent.com/56717172/179383183-84b3c395-edd8-4ee8-a378-2577b82ecfad.png) <br>

And *enable* the `Explorer` <br>
![Screenshot_20220716_235420](https://user-images.githubusercontent.com/56717172/179383241-c3bae21e-d38f-47ef-b675-15dc7eb40d96.png) <br>

In the **Explorer** navigate to a **service** called `ReplicatedStorage` and *Right Click* it to bring up a menu, <br>
in that menu look for the option: `Insert from File` <br>
![Screenshot_20220716_235814](https://user-images.githubusercontent.com/56717172/179383467-f80f1fb9-6343-4cf6-a0ae-9a44cf040707.png)
![Screenshot_20220717_000404](https://user-images.githubusercontent.com/56717172/179383482-464aecae-d9d4-49ed-8a92-ef88f8c8f326.png) <br>

From there all you have to do is *look* for the file you downloaded and **open** it.

## Basic Use

Once installed you can now use **RoKeys**, except with one extra step. <br>

**First** you must make a `script` *(this script can be placed anywhere)* <br>
Inside that script paste the following code: <br>
```lua
local ReplicatedStorage = game:GetService("Replicated Storage")
local RoKeys = require(ReplicatedStorage.RoKeys)

--you may have to edit this depending on where you put RoKeys and the version of RoKeys
```
And now you are ready to take full advantage of **RoKeys**.

### Adding keybinds

To add a **KeyBind** use the function `New`. the function takes the name of a `Bind` *(as a string)*, the `Input` you want to assign to the `Bind` *(as an EnumItem)*, and `BindToggle` and `InputToggle` *(as booleans)* which determine wether the bind and input should use a toggle behavior.
> as of v2 `Enum.KeyCode` is the only supported input type.
```lua
RoKeys.New({ 
  Bind = "example", 
  Input = Enum.KeyCode.X, 
  BindToggle = true. 
  InputToggle = false
})
--because this is a dictionary it does not matter what order you provide values in
```
This function can also be written where the `Bind`/`Input` are tables, containing both the `Bind`/`Input`'s `Name` and wether they use a toggle behavior.
```lua
RoKeys.New({ 
  Bind = {
    Name = "example", 
    Toggle = true
  }, 
  Input = {
    Name = Enum.KeyCode.X, 
    Toggle = false
  } 
  --notice the {} brackets surrounding the binds and inputs
}) 
--this does the same thing as the previous example
```
You can also add *multiple* `Inputs`, `Binds`, or both in **one** function!
```lua
RoKeys.New({ 
  Bind = "two inputs", 
  Input = {
    Enum.KeyCode.X, 
    Enum.KeyCode.Y
  } 
  --one bind has two inputs
}) 

RoKeys.New({ 
  Bind = {
    "bind 1", 
    "bind 2"
  }, 
  Input = Enum.KeyCode.X 
  --two binds, each with one input
}) 

RoKeys.New({ 
  Bind = {
    "two inputs 1", 
    "two inputs 2"
  }, 
  Input = {
    Enum.KeyCode.X, 
    Enum.KeyCode.Y
  } 
  --two binds, each with two inputs
}) 
```
> **not limited to two for each**. you can also still provide `Toggle` for each individual `Bind` and `Input`, any toggles provided as `BindToggle` or `InputToggle` slots will apply for every `Bind` or `Input` without their own toggle provided.

### Removing keybinds

The function `Remove` takes the name of a `Bind` *(as a string)* and an `Input` *(as an EnumItem)*. The function will use the provided values to filter through the existing Keybinds and delete only the `Input` for the provided `Bind` and the `Bind` for the provided `Input`.
```lua
RoKeys.Remove({ 
  Bind = "example", 
  Input = Enum.KeyCode.X 
})
--the Input "Enum.KeyCode.X" and the Bind "example" will no longer interact
```
> similarly to `Add`, `Remove` supports deleting multiple `Binds` and `Inputs`.

You can also delete `Inputs` or `Binds` en-masse as shown below:
```lua
RoKeys.Remove({ 
  Bind = "example" 
  --notice you are not providing input
}) 
--the Bind "example" will be deleted in it's entirety

RoKeys.Remove({ 
  Input = Enum.KeyCode.X 
  --notice you are not providing bind
}) 
--the Input Enum.KeyCode.X will be deleted in it's entirety
```

### Reading Keybinds

Reading Keybinds is a lot simpler as compared to *Adding* or *Removing* them. To read keybinds you are provided *two* functions; `BindState` and `InputState`, in each all you need to do is provide either the `bind` or `input` *(depending on which function you are using)* and the function will **return** a `boolean` of wether the `Bind`/`Input` is **true** or **false**.
```lua
if RoKeys:BindState("example") then --if bind "example" is on...
  --do something
end
--notice the function is in an if statement
```
> `InputState` has the same usage except reads from wether an input is on.

##Pausing and Resuming Keybinds

Pausing Keybinds is about the easiest thing you can do, provide the `binds` and `inputs` you want to pause/resume and your comand will be upheld
```lua
Rokeys.Pause({Binds = {"example1", "example2"}, Inputs = Enum.KeyCode.X)
--like other functions, you only need to give one or the other

--Rokeys.Resume() works the same way except will only resume the keybinds
```

##Clearing Keybinds

When clearing keybinds you have three choices, **"ALL"** (which clears all binds and inputs), **"BINDS"** (which clears all binds), and **"INPUTS"** (which you can imagine what it'd do)

```lua
Rokeys.Reset("ALL") --when this line is run everything is reset
```

## Advanced Usage

### Adding keybinds... Part 2

this will outline more you can do with the `New` function, as an example, here is a way to apply toggles, values, or pauses en-masse without BindToggle or InputToggle:

```lua
Rokeys.New({
  Binds = {
    { Name = "example1" },
    { Name = "example2" },
    Toggle = true --all binds have a toggle
  }
})
```

The fction also returns two tables (as of v2), one holding the Binds created and one holding the Inputs created

```lua
local binds, inputs = Rokesy.New
```

### The Format Function

This `Format` Function Takes what you would use as the `Input` or the `Bind` in the `New` function and returns it as a standard format
```lua
print(Rokeys.Format({ 
  { Name = "example1", Toggle = true, Refs = {Enum.KeyCode.X} }, 
  { Name = "example2", Value = true, Paused = true }
}))
```
output:
```lua
{
  { 
    Name = "example1",
    Toggle = true,
    Refs = {Enum.KeyCode.X}
  },
  {
    Name = "exaple2",
    Value = true,
    Paused = true
  }
}
--the changes aren't as noticable here
```

## Changing the code

**BEFORE CHANGING THE CODE PLEASE READ THE LICENSE**

I made my best effort to comment as much as possible inside of my code and will incrementally be bringing some of that here, if you have any questions you can ask them on **Github Issues** *(may not respond very fast)* or **Discord** *(link found at start of the document)*. 
> For frequently asked questions look in the following section (**FAQ**).

### Manually reading data

All data for **Keybinds** are stored in two tables, `BindTable` and `InputTable` *(both in the form of a dictionary)*. These two tables' formatting are as follows:
```lua
RoKeys.BindTable {
  bindName { --the name of the bind, depending on how many binds you have there will be that many of these
    Value = boolean, --wether it is on or off
    Toggle = boolean, --wether toggle is on
    Paused = boolean, --wether it is paused
    Refs { --reference(s) to it's input(s)
      InputName, --names of the input(s)
      ...
    }
  }
}

RoKeys.InputTable { --same layout as bindTable
  input { --this will likely say token followed by a string of numbers, do not worry as it is just a side effect of using EnumItems
    Value = boolean,
    Toggle = boolean,
    Paused = boolean,
    Refs {
      BindName
    }
  }
}
```
I strongly recommend using the built in functions to add and remove Keybinds. this section is for if you want to be able to read more data or have a better understanding of how it is stored

## FAQ

**FAQ** or **Frequently Asked Questions**, more specific questions can be found in the **Discord** *(link found at start of the document)*

> Currently nothing here, this will become more populated as people ask questions. 

## Licensing 

Copyright [2022] [Urdons]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
