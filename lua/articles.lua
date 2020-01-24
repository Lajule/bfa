local pgmoon  = require "pgmoon"
local get     = require "articles.get"
local post    = require "articles.post"
local put     = require "articles.put"
local delete  = require "articles.delete"
local ngx     = ngx
local var     = ngx.var

local options = {
  host     = var.postgres_host,
  port     = var.postgres_port,
  database = var.postgres_database,
  user     = var.postgres_user,
  password = var.postgres_password
}

local _M = {}

function _M.get (id)
  local pg = pgmoon.new(options)

  return get.go(pg, id)
end

function _M.post ()
  local pg = pgmoon.new(options)

  return post.go(pg)
end

function _M.put (id)
  local pg = pgmoon.new(options)

  return put.go(pg, id)
end

function _M.delete (id)
  local pg = pgmoon.new(options)

  return delete.go(pg, id)
end

return _M
