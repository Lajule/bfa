local cjson     = require "cjson"
local redis     = require "resty.redis"
local ngx       = ngx
local var       = ngx.var
local req       = ngx.req
local say       = ngx.say
local read_body = req.read_body

local options = {
  host = var.redis_host,
  port = var.redis_port
}

local _M = {}

function _M.get ()
  local red = redis:new()

  local ok, err = red:connect(options.host, options.port)

  if not ok then
    ngx.status = 500
    return say("Failed to connect: ", err)
  end

  local res, err = red:get("k")

  if not res then
    ngx.status = 500
    return say("Failed to get: ", err)
  end

  local ok, err = red:set_keepalive(10000, 100)

  if not ok then
    ngx.status = 500
    return say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return say(cjson.encode({k = res}))
end

function _M.post ()
  local red = redis:new()

  local ok, err = red:connect(options.host, options.port)

  if not ok then
    ngx.status = 500
    return say("Failed to connect: ", err)
  end

  read_body()
  local body = cjson.decode(var.request_body)

  local ok, err = red:set("k", body["k"])

  if not ok then
    ngx.status = 500
    return say("Failed to set: ", err)
  end

  local ok, err = red:set_keepalive(10000, 100)

  if not ok then
    ngx.status = 500
    return say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return say(cjson.encode({k = body["k"]}))
end

return _M
