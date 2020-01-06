local cjson = require "cjson"
local redis = require "resty.redis"

local options = {host = ngx.var.redis_host, port = ngx.var.redis_port}

local _M = {}

function _M.get ()
  local red = redis:new()

  local ok, err = red:connect(options.host, options.port)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to connect: ", err)
  end

  local res, err = red:get("k")

  if not res then
    ngx.status = 500
    return ngx.say("Failed to get: ", err)
  end

  local ok, err = red:set_keepalive(10000, 100)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return ngx.say(cjson.encode({k = res}))
end

function _M.post ()
  local red = redis:new()

  local ok, err = red:connect(options.host, options.port)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to connect: ", err)
  end

  ngx.req.read_body()
  local body = cjson.decode(ngx.var.request_body)

  local ok, err = red:set("k", body["k"])

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to set: ", err)
  end

  local ok, err = red:set_keepalive(10000, 100)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return ngx.say(cjson.encode({k = body["k"]}))
end

return _M
