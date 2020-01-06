local cjson = require "cjson"
local http = require "resty.http"

local options = {host = "ipinfo.io", port = 80, path = "/ip"}

local _M = {}

function _M.get ()
  local httpc = http.new()

  httpc:set_timeout(500)
  local ok, err = httpc:connect(options.host, options.port)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to connect: ", err)
  end

  local res, err = httpc:request({path = options.path})

  if not res then
    ngx.status = 500
    return ngx.say("Failed to request: ", err)
  end

  local body, err = res:read_body()

  if not body then
    ngx.status = 500
    return ngx.say("Failed to read body: ", err)
  end

  local ok, err = httpc:set_keepalive(10000, 10)

  if not ok then
    ngx.status = 500
    return ngx.say("Failed to set keepalive: ", err)
  end

  ngx.status = res.status
  return ngx.say(cjson.encode({ip = body}))
end

return _M
