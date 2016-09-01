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
    if ngx.var.serverType == 'model' then
        local resp_text = cjson.encode({
            schema_version = "0.1",
            model_version = "1.0",
            timestamp = os.date("%Y-%m-%dT%TZ", os.time()),
            status = "error",
            reason = "model does not exist or is not running"
        })
        ngx.header['content-type'] = 'application/json; charset=utf-8'
        ngx.print(resp_text)
    end
    return ngx.exit(404)
end
local parsed = cjson.decode(data)
ngx.var.server = string.format('%s:%d', parsed['private_ip'], parsed['port'])
