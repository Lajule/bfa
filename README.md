bfa
===

Build some Blazing Fast APIs, An [OpenResty][1] starter kit to write pure
[Lua][2] APIs.

No framework ! Forget about your favorite framework, forget about Flask,
Express or even Sinatra, here the HTTP requests are handled directly in
[nginx][3] by executing [Lua][2] scripts.

Install
-------

First you need [OpenResty][1] to be installed, then you can launch [nginx][3]
with :

```shell
openresty -p . -c conf/nginx.conf
```

[1]: https://github.com/openresty
[2]: http://www.lua.org
[3]: https://nginx.org
