local fm = require "fullmoon"
local html = require "html"

fm.setRoute("/static/*", fm.serveAsset)

--------------- BEGIN CUSTOM ROUTING ---------------

fm.setRoute("/thinking/:post", "/test.lua")

fm.setRoute("/file", function()
	return fm.serveResponse(200, html.Render(load(Slurp("/zip/add.lua"))()))
end)

--------------- END CUSTOM ROUTING ---------------

-- try and serve .lua files for paths
fm.setRoute("/*luafile", "/*luafile.lua")
-- try and serve index paths
fm.setRoute("/*index", fm.serveIndex)

fm.run()
