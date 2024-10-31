local fm = require "fullmoon"
local html = require "html"
local Shell = require "shell"

fm.setRoute("/static/*", fm.serveAsset)

fm.setRoute("/thinking/:post", "/test.lua")

fm.setRoute("/*luafile", "/*luafile.lua")
fm.setRoute("/*index", fm.serveIndex)

fm.run()
