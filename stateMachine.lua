local stateMachine = {}

function stateMachine.new(default)
  assert(default, "No default state provided.")
  return {
    _Info = {
      cState = default;
      States = {[default] = function() end};
      Links = {};
      StateChangeCallback = function() end;
    };

    CreateState = function(self, name)
      self._Info.States[name] = function() end;
    end;

    PushState = function(self, name)
      for k, v in pairs(self._Info.Links) do
        if k == name and self:GetState() == v[1] then
          self._Info.cState = v[2]
          self._Info.StateChangeCallback(v[2])
          self._Info.States[self._Info.cState](v[2])
          return
        end
      end
    end;

    Link = function(self, link, from, to)
      assert(self._Info.States[from] and self._Info.States[to], "Invalid state(s) (State non-existant).")
      self._Info.Links[link] = {from, to}
    end;
    
    StateChanged = function(self, f)
      assert(type(f) == "function", "The given parameter is not a function.")
      self._Info.StateChangeCallback = f
    end;

    OnState = function(self, state, f)
      assert(self._Info.States[state], "Invalid state (State non-existant).")
      assert(type(f) == "function", "The given parameter is not a function.")
      self._Info.States[state] = f
    end;

    GetState = function(self)
      return self._Info.cState
    end;
  }
end

return stateMachine
