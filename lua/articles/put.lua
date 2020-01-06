local cjson = require "cjson"

local _M = {}

function _M.go (pg, id)
  local success, err = pg:connect()

  if not success then
    ngx.status = 500
    return ngx.say("Failed to connect: ", err)
  end

  ngx.req.read_body()
  local body = cjson.decode(ngx.var.request_body)

  local result, err = pg:query("update articles set content = " ..
  pg:escape_literal(body["content"]) .. " where id = " .. id)

  if not result then
    ngx.status = 500
    return ngx.say("Failed to query: ", err)
  end

  local success, err = pg:keepalive(10000, 10)

  if not success then
    ngx.status = 500
    return ngx.say("Failed to set keepalive: ", err)
  end

  ngx.status = 200
  return ngx.say(cjson.encode(result))
end

return _M
