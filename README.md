# obvar

This is a small utility that helps in the creation of variables that can be checked for state changes in update functions. Code is worth a thousand words, so:

```lua
local obv = require 'obvar'

function love.load()
  variable = obv(true) -- variable = true
end

function love.update(dt)
  if var/false then print('var set to false') end
  if var^true then print('var changed from true') end
end

function love.keypressed(key)
  if key == ' ' then var = false end
end
```

Then the actions inside the conditions on update will only happen when on the frame var is set to false or is changed from being true, respectively. This means that when the `space` key is pressed both things will happen, and so `'var set to false'` and `'var changed from true'` will be printed once on that frame.

## Usage

The [module]() file should be dropped on your project and required like so:

```lua
obv = require 'obvar'
```

Then, at the END of your main update function, update:

```lua
function love.update(dt)
  -- your stuff here

  obv:update()
end
```

## Creating a new variable

```lua
var = obv(true)
```

Just call `obv` and pass in the value you want this variable to have.

## Accessing the value

```lua
print(var.v)
```

The variables value is on the `v` attribute.

## Assigning a new value

```lua
var(39)
```

This assigns the value `39` to the attribute `v` and also assigns the previous value (the one that was set before `39`) to the attribute `prev_v`. This is what allows variables created with this module to be checked for state changes. If you do `var.v = 39` then things should still work but not for this state change.

```lua
-- var.v is 38
var.v = 39 -- v is now 39 and prev_v is the previous prev_v, not 38
if var/39 then print('enter 39') end -- prints 'enter 39' if the state was changed from something else to 39, succeeds
if var^38 then print('exit 38') end -- prints 'exit 38' if the state was change from 38 to something else, fails because prev_v is not set properly
obv:observe() -- now prev_v is set to 39 and the step where prev_v = 38 never happened
```

In comparison with assigning appropriately:

```lua
-- var.v is 38
var(39) -- v is now 39 and prev_v is 38
if var/39 then print('enter 39') end -- prints 'enter 39' if the state was changed from something else to 39, succeeds
if var^38 then print('exit 38') end -- prints 'exit 38' if the state was change from 38 to something else, succeeds
obv:observe() -- now prev_v is set to 39
```

## LICENSE

You can do whatever you want with this. See the [LICENSE]().
