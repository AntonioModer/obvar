return setmetatable({
    _vars = setmetatable({}, {__mode = 'v'}),
    update = function(t)
        for k, v in pairs(t._vars) do v.prev_v = v.v end
    end
}, {
    __call = function(t, v)
        local var = setmetatable({
            v = v, prev_v = v,
            enter = function(t, v) if t.prev_v ~= v and t.v == v then return true end end,
            exit = function(t, v) if t.prev_v == v and t.v ~= v then return true end end,
        }, {
            __call = function(t, v) t.prev_v = t.v; t.v = v end, 
            __add = function(t, v) if t.prev_v ~= v and t.v == v then return true end end,
            __sub = function(t, v) if t.prev_v == v and t.v ~= v then return true end end,
        })
        table.insert(t._vars, var)
        return var
    end
})

