![RoKeysIconFullTransparent](https://user-images.githubusercontent.com/56717172/179380379-839275a7-7558-4770-91a3-9f79baef7d1e.png)
![RoKeysTitleWhite](https://user-images.githubusercontent.com/56717172/179380393-f7eef77b-5d62-4598-9b62-4828f6aadb9e.png#gh-dark-mode-only)
![RoKeysTitleBlack](https://user-images.githubusercontent.com/56717172/179382515-69fef072-3b67-4a44-b917-2eb5b1b33488.png#gh-light-mode-only)

**RoKeys** is an *Open-source* Keybinding script for **Roblox** that strives for *usability* and *versatility*

Links: 
- **Discord**: *https://discord.gg/AyqHpaUnTe*
- **Roblox**: *https://www.roblox.com/library/10263313095/RoKeys*

On this page you will find sections labeled as follows: <br>
- **Terms of Use**
- **Installation**, <br>
- **Basic Use**, <br>
- **Advanced Use,** <br>
- **FAQ,** and <br>
- **Licensing** <br>

## Terms of Use

### By using this project you Agree to these terms and the terms of the official licesing. <br>

When using **RoKeys** in your game, please give credit back to this project, exposing this project to people who may need it is a big goal of mine and I hope that those of you who use it can abide by this rule. <br>
**Official Branding can be found in the folder labeled `Branding`**.

When **branching off** of this project, **redistributing** it, or making **your own distribution**, please reference back to this page. For those who create their own distribution, please provide evidence that there is an **original** change in the code from this project to yours, copying code is not tolerated unless otherwise given permission *(this applies to copying code from other distributions, make sure you have permission before reusing code)*.

**Do not forget** to take note of the `licensing` file, these additional terms are layered on top of terms found in that file *(**Apache License 2.0**)* and are not directly affiliated to the original lisencing. **You should thoroughly read through those conditions before using this project**.
> you can also find a *link* to the **Apache License 2.0** along with some other info in the section labeled **Licensing**

## Installation

**BEFORE INSTALLING PLEASE READ THE TERMS OF USE**

To **Install** all you need to do is download the *latest version* from the **Releases Page**. <br>
The file to look for will look *something* like this: `RoKeysV1.lua`

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
local RoKeys = require(ReplicatedStorage.RoKeysV1)

--you may have to edit this depending on where you put RoKeys and the version of RoKeys
```
And now you are ready to take full advantage of **RoKeys**.

### Adding keybinds

To add a **keybind** use the function `AddKeyBind`. the function takes the name of a `bind` *(as a string)*, the `input` you want to assign to the bind *(as an EnumItem)*, and two `booleans` which determine wether then `bind` and `input` are *toggleable*.
> as of v1 `Enum.KeyCode` is the only supported input type.
```lua
AddKeyBind("example", Enum.KeyCode.X, true. false)
--the first boolean effects the bind while the second effects the input
```
This function can also be written where the `bind` and/or `input` are tables, containing both the `bind`/`input` and wether they are *toggleable* or not.
```lua
AddKeyBind({"example", true}, {Enum.KeyCode.X, false}) --notice the surrounding {} brackets
--this will execute the same as the previous example
```
You can also add *multiple* `inputs`, `binds`, or both in **one** function!
```lua
AddKeyBind("two inputs", {Enum.KeyCode.X, Enum.KeyCode.Y}) --one bind has two inputs

AddKeyBind({"bind 1", "bind 2"}, Enum.KeyCode.X) --two binds, each with one input

AddKeyBind({"two inputs 1", "two inputs 2"}, {Enum.KeyCode.X, Enum.KeyCode.Y}) --two binds, each with two inputs
```
> **not limited to two for each**. you can also still provide `toggles` for each individual `bind` and `input`, any toggles provided in the `3rd` and `4th` slots will apply for any `bind` or `input` without a toggle behavior provided.

### Removing keybinds

The function `DelKeyBind` takes the name of a `bind` *(as a string)* and an `input` *(as an EnumItem)*. The function will use the provided values to filter through the existing Keybinds and delete only the `input` for the provided `bind` and the `bind` for the provided `input`, essentially making a `bind` no longer usable with the provided `input`.
```lua
DelKeyBind("example", Enum.KeyCode.X)
--the input "Enum.KeyCode.X" will no longer interact with the bind "example"
```
> similarly to `AddKeyBind`, `DelKeyBind` supports deleting multiple `binds` and `inputs`, I reccomend being more careful however, as you could accidentally delete keybinds.

You can also delete `inputs` or `binds` en-masse as shown below:
```lua
DelKeyBind("example", nil) --notice the input is nil
--the bind "example" will be deleted in it's entirety

DelKeyBind(nil, Enum.KeyCode.X) --notice the bind is nil
--the input Enum.KeyCode.X will be deleted in it's entirety
```

### Reading Keybinds

Reading Keybinds is a lot simpler as compared to *adding* or *removing* them. To read keybinds you are provided *two* functions; `BindState` and `InputState`, in each all you need to do is provide either the `bind` or `input` *(depening on which function you are using)* and the function will **return** a `boolean` of wether the `bind`/`input` is **off** or **on**.
```lua
if BindState("example") then --if bind "example" is on...
  --do something
end
--notice the function is in an if statement, that is because it returns a boolean
```
> `InputState` has the same usage except reads from wether an input is on.

## Advanced Usage

this section is for advanced users, ready to get their hands dirty and work with my dirty code lol

### Manually reading data

All data for **Keybinds** are stored in two tables, `bindTable` and `inputTable` *(both in the form of a dictionary)*. These two tables' formatting is as follows:
```lua
bindTable {
  bindName { --the name of the bind, depending on how many binds you have there will be that many of these
    boolean, --wether it is on or off
    boolean, --wether toggle is on
    input --reference(s) to it's input(s), multiple may be listed here
  }
}

inputTable { --same layout as bindTable
  input { --this will likely say token followed by a string of numbers, do not worry as it is just a side effect of using EnumItems
    boolean,
    boolean,
    bindName --like bindTable, multiple may be listed here
  }
}
```
I strongly recommend using the built in functions to add and remove Keybinds. this section is for if you want to be able to read more data or have a better understanding of how it is stored

### Changing the code

**BEFORE CHANGING THE CODE PLEASE READ THE TERMS OF USE**

I made my best effort to comment as much as possible inside of my code and will incrementally be bringing some of that here, if you have any questions you can ask them on **Github Issues** *(may not respond very fast)* or **Discord** *(link found at start of the document)*. 
> For frequently asked questions look in the following section (**FAQ**).

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
