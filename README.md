# obvar

This is a small utility module that helps in the creation of variables that can be checked for state changes in update functions. Code is worth a thousand words, so:

```lua
local obv = require 'obvar'

function love.load()
  var = obv(true)
end

function love.update(dt)
  if var+false then print('var changed to false') end
  if var-true then print('var changed from true') end
end

function love.keypressed(key)
  if key == ' ' then var:set(false) end
end
```

Then the actions inside the conditions on update will only happen on the frame `var` is set to false or is changed from being true. This means that when the `space` key is pressed both things will happen, and so `'var changed to false'` and `'var changed from true'` will be printed once on that frame.

## Usage

The [module](https://github.com/adonaac/obvar/blob/master/obvar.lua) file should be dropped on your project and required like so:

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

The variable's value is on the `v` attribute.

## Assigning a new value

```lua
var:set(39)
```

This assigns the value `39` to the attribute `v` and also assigns the previous value (the one that was set before `39`) to the attribute `prev_v`. This is what allows variables created with this module to be checked for state changes. If you do `var.v = 39` then things should still work but not for this state change.

```lua
-- var.v is 38
var.v = 39 -- v is now 39 and prev_v is the previous prev_v, not 38
if var+39 then print('enter 39') end -- prints 'enter 39' if the state was changed from something else to 39, succeeds
if var-38 then print('exit 38') end -- prints 'exit 38' if the state was change from 38 to something else, fails because prev_v is not set properly
obv:update() -- now prev_v is set to 39 and the step where prev_v = 38 never happened
```

In comparison with assigning appropriately:

```lua
-- var.v is 38
var:set(39) -- v is now 39 and prev_v is 38
if var+39 then print('enter 39') end -- prints 'enter 39' if the state was changed from something else to 39, succeeds
if var-38 then print('exit 38') end -- prints 'exit 38' if the state was change from 38 to something else, succeeds
obv:update() -- now prev_v is set to 39
```

## Checking for state changes

Use `+` to check for `enter` state changes and `-` for `exit` state changes:

```lua
function love.update(dt)
  if var+true then print('var changed to true') end
  if var-true then print('var changed from true') end
end
```

Alternatively you can just use `enter` or `exit` directly:

```lua
function love.update(dt)
  if var:enter(true) then print('var changed to true') end
  if var:exit(true) then print('var changed from true') end
end
```

## Deferred state changes

Sometimes you want to change some state after a previous state check but also make sure that that previous state check gets triggered. For instance, say in your game your entities are update in the following order: `Enemies -> Player -> obv:update()`. And then say that in the `Player` class, after doing something, you have to change the state of some `obvar` on an enemy:

```lua
enemy.o_attacker:set(self)
```

Then in the enemy class, you wanna do something if some state change from the player happened:

```lua
if self.o_attacker-nil then
  local player = self.o_attacker.v
  player:dealDamage(10)
end
```

In this case it's just checking to see if `o_attacker` was set to something and exited its `nil` state. In any case, given the order of updates is `Enemies -> Player -> obv:update()`, this check will fail because the `obv:update()` call after the player will set `o_attacker.prev_v` to its current value, meaning that on the next frame, when the check in the enemy class is performed, `o_attacker` will have the current value pointing to the player as well as the previous one, so the check will fail. To prevent stuff like this from happening an additional call exists:

```lua
enemy.o_attacker:setd(self)
```

`setd` will make it so that state changes are **only** performed on the first next state check, meaning that in this example the `o_attacker` variable will only actually start holding a reference to the player when the enemy class checks `if self.o_attacker-nil` on the next frame.

## LICENSE

You can do whatever you want with this. See the [LICENSE](https://github.com/adonaac/obvar/blob/master/LICENSE).
