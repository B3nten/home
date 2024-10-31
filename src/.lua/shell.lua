local function Shell (props)
	return Html {
		Head {
			Meta { charset="utf-8" },
			Meta { name="viewport", content="width=device-width, initial-scale=1" },
			Stylesheet "/style.css",
			Module "/index.js",
			Importmap [[{
				"imports": {
					"three": "/static/three@0.169.0/mod.js,
				}
			}]],
			props.Head
		},
		Body {
			Navigation {

			},
			Main {
				props.Body
			},
			Footer {
				Text { "© 2021", class = "footer-text" }
			}
		}
	}
end

return Shell;
