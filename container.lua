local redis = require "resty.redis"
local cjson = require "cjson"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local host, port = string.match(os.getenv('REDIS_URL'), '%a+://(.+):(%d+)')
local ok, err = red:connect(host, port)
if not ok then
    ngx.log(ngx.ERR, "failed to connect to redis: ", err)
    return ngx.exit(500)
end

local data, err = red:get("server_details_" .. ngx.var.serverId)
if not data or data == ngx.null then
    ngx.log(ngx.ERR, "failed to fetch details: ", err)
    return ngx.exit(404)
end

local details = cjson.decode(data)
ngx.var.container = details['container_id']:sub(1, 12)
