local articles = require "articles"
local ip = require "ip"
local kv = require "kv"

local function go (routes)
  for _, route in pairs(routes) do
    local method, pattern, fn = table.unpack(route)

    if ngx.var.request_method == method then
      local m, err = ngx.re.match(ngx.var.uri, "^" .. pattern .. "$")

      if err then
        ngx.status = 500
        return ngx.say("Failed to match: ", err)
      end

      if m then return fn(m) end
    end
  end

  ngx.status = 404
  return ngx.say("No handler defined: ", ngx.var.uri)
end

return go({
  {"GET", "/ip", function ()
    return ip.get()
  end},
  {"GET", "/articles", function ()
    return articles.get()
  end},
  {"GET", "/articles/(?<id>[0-9]+)", function (m)
    return articles.get(m["id"])
  end},
  {"POST", "/articles", function ()
    return articles.post()
  end},
  {"PUT", "/articles/(?<id>[0-9]+)", function (m)
    return articles.put(m["id"])
  end},
  {"DELETE", "/articles/(?<id>[0-9]+)", function (m)
    return articles.delete(m["id"])
  end},
  {"GET", "/kv", function ()
    return kv.get()
  end},
  {"POST", "/kv", function ()
    return kv.post()
  end}
})
