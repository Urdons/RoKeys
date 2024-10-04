# Rokeys v3 ***dev branch***

**RoKeys** is an *Open-source* Keybinding script for **Roblox** that strives for *usability* and *versatility*

Links: 
- **Trello**: *https://trello.com/b/QfWxcNrH/rokeys*
- **Discord**: *https://discord.gg/AyqHpaUnTe*
- **Roblox**: *https://www.roblox.com/library/10263313095/RoKeys*

On this page you will find sections labeled as follows (click links to go to desired section):
- [**Installation**](#installation),
- [**Basic Use**](#basic-use),
- [**API Reference**](#api-reference),
- [**FAQ**](#faq),

# Installation
> needs to be updated, roblox studio beta changes a lot of things and this update does too

To **Install** all you need to do is download the *latest version* from the **Releases Page**. <br>

The file to look for will look *something* like this: `***`

> if using an older version: the documentation can be found in the source files on the download page, although **I would highly reccomend using v3 over the previous versions**

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

Once **RoKeys** is in replicated storage you can use it wherever you would like, except with one extra step: <br>

You must make a `script` *(this script can be placed anywhere)* <br>
Inside that script paste the following code: <br>
```lua
--script must be client side to work properly

local ReplicatedStorage = game:GetService("Replicated Storage")
local RoKeys = require(ReplicatedStorage.RoKeys)

--you may have to edit this depending on where you put RoKeys and the version of RoKeys
```
And now you are ready to take full advantage of **RoKeys**.

# Basic Use

## Import
### In Typescript
```ts
import RoKeysService from "shared/Rokeys";
```
### In Luau
```lua
--WIP
```

# API Reference

## Rokeys Class

### Description
When importing RoKeysService this is the class you are given. This class contains various methods for handling Bindings.

### Method Summary
| Method | Description |
| ------ | ----------- |
| **newBindFromKeyCode**(bindName: [**string**](https://create.roblox.com/docs/reference/engine/libraries/string), KeyCode?: [**Enum.KeyCode**](https://create.roblox.com/docs/reference/engine/enums/KeyCode)) : [**Binding**](#binding-class) | Creates a new Binding using a string as the name and, if provided, adds an Enum.Keycode as an input. |
| **removeBind**(BindName : [**string**](https://create.roblox.com/docs/reference/engine/libraries/string)) : **void** | WIP. |
| **getBindFromName**(BindName : [**string**](https://create.roblox.com/docs/reference/engine/libraries/string)) : [**Binding**](#binding-class) \| **undefined** | Returns a Binding using the provided string as the name to look for (case sensitive), if there is no bind with that name then the function returns undefined. |

## Binding Class

### Description
This class is the backbone of Rokeys. Whenever you use the RoKeys class' ```newBindFromKeyCode``` method, it creates and returns an object of this class.

### Attribute Summary
| Attribute | Description |
| --------- | ----------- |
| **bindActivated** | A readonly attribute which holds the event fired when the binding is activated by one of its inputs. |
| **bindChanged** | WIP. |
| **bindDeactivated** | A readonly attribute which holds the event fired when the binding is no longer being activated by any of its inputs. |

### Method Summary
| Method | Description |
| ------ | ----------- |
| **setBindName**(bindName : [**string**](https://create.roblox.com/docs/reference/engine/libraries/string)) : **void** | Sets the name of the binding to the provided string value. |
| **addInput**(inputToAdd : [**Enum.KeyCode**](https://create.roblox.com/docs/reference/engine/enums/KeyCode)) : **void** | Adds the desired Enum.KeyCode to the binding's table of inputs. |
| **removeInput**(inputToRemove : [**Enum.KeyCode**](https://create.roblox.com/docs/reference/engine/enums/KeyCode)) : **void** | Removes the desired Enum.KeyCode from the binding's table of inputs. |
| **getBindName**() : [**string**](https://create.roblox.com/docs/reference/engine/libraries/string) | Returns the name of the Binding as a string. |
| **getInputs**() : [**Enum.KeyCode**](https://create.roblox.com/docs/reference/engine/enums/KeyCode)[] | Returns an array of Enum.KeyCode containing all inputs given to the binding |
| **hasInput**(inputToCheck : [**Enum.KeyCode**](https://create.roblox.com/docs/reference/engine/enums/KeyCode)) : **boolean** | Takes an Enum.KeyCode and determines if it is an input given to the binding, returns true if it is found and false is not. |
| **disconnect**() : **void** | Destroys all events associated with the binding and clears the table of inputs, essentially making the binding unusable. |

# FAQ

**FAQ** or **Frequently Asked Questions**, more specific questions can be found in the **Discord** *(link found at start of the document)*

> Currently nothing here, this will become more populated as people ask questions. 

## Licensing ***TODO***

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
