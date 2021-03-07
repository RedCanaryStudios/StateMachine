local stateMachine = {}

function stateMachine.new(default)
    assert(default, "No default state provided.")
    return {
        _Info = {
            cState = default;
            States = {[default] = {function() end, function() end}};
            Links = {};
            StateChangeCallback = function() end;
        };

        CreateState = function(self, name)
            self._Info.States[name] = {function() end, function() end};
        end;

        PushState = function(self, name)
            for _, v in ipairs(self._Info.Links) do
                if v[3] == name and self:GetState() == v[1] then
                    self:SetState(v[2])
                    return
                end
            end
        end;

        Link = function(self, link, from, to)
            assert(self._Info.States[from] and self._Info.States[to], "Invalid state(s) (State non-existant).")
            table.insert(self._Info.Links, {from, to, link})
        end;

        StateChanged = function(self, f)
            assert(type(f) == "function", "The given parameter is not a function.")
            self._Info.StateChangeCallback = f
        end;

        OnState = function(self, state, f)
            assert(self._Info.States[state], "Invalid state (State non-existant).")
            assert(type(f) == "function", "The given parameter is not a function.")
            self._Info.States[state][1] = f
        end;

        FromState = function(self, state, f)
            assert(self._Info.States[state], "Invalid state (State non-existant).")
            assert(type(f) == "function", "The given parameter is not a function.")
            self._Info.States[state][2] = f
        end;

        GetState = function(self)
            return self._Info.cState
        end;

        SetState = function(self, state)
            assert(self._Info.States[state], "Invalid state (State non-existant).")
            local oldState = self:GetState()
            self._Info.cState = state
            self._Info.StateChangeCallback(oldState, state)
            self._Info.States[state][1](oldState, state)
            self._Info.States[state][2](oldState, state)
        end;
    }
end

return stateMachine
