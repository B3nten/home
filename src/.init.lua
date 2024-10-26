local fm = require "fullmoon"
local html = require "html"
local Shell = require "shell"

-- Try and serve static files from the /static directory first
fm.setRoute("/static/*", fm.serveAsset)

-- Home
fm.setRoute("/", function (r)
	return fm.serveResponse(200, html.Render(
		Shell {
			head = {
				Title "Home"
		 	},
			body = { "Hello World!" }
		}
	))
end)

-- Thoughts list route
fm.setRoute("/thinking", function ()
	return fm.serveResponse(200, html.Render(
		Shell {
			head = {
				Title "Posts"
		 	},
			body = { "Post list" }
		}
	))
end)

-- Thought route
fm.setRoute("/thinking/:slug", function (r)
	return fm.serveResponse(200, html.Render(
		Shell {
			head = {
				Title "Post"
		 	},
			body = { "a single post " .. r.params.slug }
		}
	))
end)

-- Elysia route
fm.setRoute("/elysia", function ()
	return fm.serveResponse(200, html.Render(
		Shell {
			head = {
				Title "Eysia"
		 	},
			body = { "Elysia" }
		}
	))
end)

fm.setRoute("*", fm.serveAsset)

fm.run()
