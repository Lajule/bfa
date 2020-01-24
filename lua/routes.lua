local articles = require "articles"
local ip       = require "ip"
local kv       = require "kv"

return {
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
}
