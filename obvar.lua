return setmetatable({
    _vars = setmetatable({}, {__mode = 'v'}),
    update = function(t)
        for k, v in pairs(t._vars) do 
            if not v._deferred then
                v.prev_v = v.v 
            end
        end
    end
}, {
    __call = function(t, v)
        local var = setmetatable({
            v = v, prev_v = v, _deferred = false,
            set = function(t, v) 
                t.prev_v = t.v
                t.v = v 
            end,
            setd = function(t, v)
                if v == false then v = 'false' end
                t._deferred = v
            end,
            enter = function(t, v) 
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v ~= v and t.v == v then 
                    return true 
                end 
            end,
            exit = function(t, v) 
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v == v and t.v ~= v then 
                    return true 
                end 
            end,
            le = function(t, v)
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v > v and t.v <= v then 
                    return true 
                end 
            end,
            ge = function(t, v)
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v < v and t.v >= v then 
                    return true 
                end 
            end,

        }, {
            __add = function(t, v) 
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v ~= v and t.v == v then 
                    return true 
                end 
            end,
            __sub = function(t, v) 
                if t._deferred then
                    if t._deferred == 'false' then t._deferred = false end
                    t.prev_v = t.v
                    t.v = t._deferred
                    t._deferred = nil
                end
                if t.prev_v == v and t.v ~= v then 
                    return true 
                end 
            end,
        })
        table.insert(t._vars, var)
        return var
    end
})

