# State Machine

## ©2021 Red Canary Studios
   
### discord.canary.red

<br>

Usage:

`SM = stateMachine.new(default)` // Returns a new state machine with the default state being first parameter.  

`SM:CreateState(state)` // Creates a state.  

`SM:Link(name, to, from)` // Links a before state with an after state with an event.  

`SM:PushState(event)` // When :PushState is invoked, 'Name' event will be invoked. If the current state is "To" the state will be changed into "From". 

`SM:StateChanged(func)` // Provide a callback when the state changes. The callback will have 2 parameters: Before & After state.  

`SM:OnState(state, func)` // Provide a callback when the state changes into the specified state. The callback will have 2 parameters: Before & After state. 

`SM:FromState(state, func)`// Provide a callback when the state changes from the specified state. The callback will have 2 parameters: Before & After state. 

`SM:GetState()` // Returns the current state.  

`SM:SetState()` // Will explicitly set the state. State must exist.  


Examples:

```lua
local stateMachine = require "statemachine"

local SM = stateMachine.new("X")

SM:CreateState("Y")

SM:Link("Z", "X", "Y")

SM:StateChanged(function(old, new)
  print("State changed")
end)

SM:OnState("X", function(old, new)
  print("Changed to X")
end)

SM:OnState("Y", function(old, new)
  print("Changed to Y")
end)

print(SM:GetState())

SM:PushState("Z")
```

```
X
State changed
Changed to Y
```

```lua
local stateMachine = require "statemachine"

local SM = stateMachine.new("X")

SM:CreateState("Y")
SM:CreateState("W")


SM:Link("Z", "X", "Y")
SM:Link("A", "Y", "W")

local function foo(old, new)
  print("State changed into "..new..", yay!")
end

local function bar(old, new)
  print("State changed into "..new..", boo!")
end

SM:OnState("X", foo)

SM:OnState("Y", foo)

SM:OnState("W", bar)

SM:PushState("Z")
SM:PushState("A")
```

```
State changed into X, yay!
State changed into Y, boo!
```
