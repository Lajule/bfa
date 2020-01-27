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
  return get.go(pgmoon.new(options), id)
end

function _M.post ()
  return post.go(pgmoon.new(options))
end

function _M.put (id)
  return put.go(pgmoon.new(options), id)
end

function _M.delete (id)
  return delete.go(pgmoon.new(options), id)
end

return _M
