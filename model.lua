local function expanding_random(items, weights)
    local list = {}
    for _, item in ipairs(items) do
        local n = weights[item]
        for i = 1, n do table.insert(list, item) end
    end
    return function()
        return list[math.random(1, #list)]
    end
end

local url = "/container/%s"

local redis = require "resty.redis"
local cjson = require "cjson"
local red = redis:new()
local ok, err = red:connect("192.168.0.106", 6379)
if not ok then
    ngx.say("Failed to connect to redis", err)
    return
end

local res, _ = red:get(ngx.var.modelId)
