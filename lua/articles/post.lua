local cjson     = require "cjson"
local ngx       = ngx
local var       = ngx.var
local req       = ngx.req
local say       = ngx.say
local read_body = req.read_body

local _M = {}

function _M.go (pg)
  local success, err = pg:connect()

  if not success then
    ngx.status = 500
    return say("Failed to connect: ", err)
  end

  read_body()
  local body = cjson.decode(var.request_body)

  local result, err = pg:query("insert into articles(content) values(" ..
  pg:escape_literal(body["content"]) .. ")")

  if not result then
    ngx.status = 500
    return say("Failed to query: ", err)
  end

  local success, err = pg:keepalive(10000, 10)

  if not success then
    ngx.status = 500
    return say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return say(cjson.encode(result))
end

return _M
