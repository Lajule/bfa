local routes = require "routes"
local ngx    = ngx
local var    = ngx.var
local re     = ngx.re
local say    = ngx.say

for _, route in pairs(routes) do
  local method, pattern, fn = unpack(route)

  if var.request_method == method then
    local m, err = re.match(var.uri, "^" .. pattern .. "$")

    if err then
      ngx.status = 500
      return say("Failed to match: ", err)
    end

    if m then return fn(m) end
  end
end

ngx.status = 404
return say("No handler defined: ", var.uri)
