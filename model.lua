local function expanding_random(items, weights)
    local list = {}
    for i, item in ipairs(items) do
        local n = weights[i]
        for j = 1, n do
            table.insert(list, item)
        end
    end
    return list[math.random(1, #list)]
end

local re = ngx.location.capture(ngx.var.url_ips)
ngx.var.server = re.body

local url = "/container/%s/tree"

local redis = require "resty.redis"
local cjson = require "cjson"
local red = redis:new()
local ok, err = red:connect("192.168.88.207", 6379)
if not ok then
    ngx.say("Failed to connect to redis: ", err)
    return
end

local res, _ = red:get(ngx.var.modelId)
local hashes = cjson.decode(res)
local items = {}
local weights = {}
hash = ""
if table.getn(hashes) > 1 then
    for _, v in ipairs(hashes) do
        table.insert(items, v["hashid"])
        table.insert(weights, v["percent"])
    end
    hash = expanding_random(items, weights)
else
    hash = hashes[1]["hashid"]
end
ngx.var.path = string.format(url, hash)
return
