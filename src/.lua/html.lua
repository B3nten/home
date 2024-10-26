local M = { }

local SELF_CLOSING_TAGS = {
	area = true,
	base = true,
	col = true,
	embed = true,
	param = true,
	source = true,
	track = true,
	wbr = true,
    img = true,
    input = true,
    br = true,
    hr = true,
    meta = true,
    link = true,
}

local BOOLEAN_ATTRIBUTES = {
    allowfullscreen = true,
    async = true,
    autofocus = true,
    autoplay = true,
    checked = true,
    controls = true,
    default = true,
    defer = true,
    disabled = true,
    formnovalidate = true,
    inert = true,
    ismap = true,
	itemscope = true,
	loop = true,
	multiple = true,
	muted = true,
	nomodule = true,
	novalidate = true,
	open = true,
	playsinline = true,
	readonly = true,
	required = true,
	reversed = true,
	selected = true,
	shadowrootclonable = true,
	shadowrootdelegatesfocus = true,
	shadowrootserializable = true,
}

local function escape_html(str)
    local escape_patterns = {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['"'] = '&quot;',
        ["'"] = '&#39;'
    }
    return str:gsub('[&<>"\']', escape_patterns)
end

local function camel_to_kebab(str)
    return str:gsub("%u", function(c) return "-" .. c:lower() end)
end

local function parseStyles(style)
    local str = ""
    for i, v in pairs(style) do
        str = str .. camel_to_kebab(i) .. ":" .. v .. ";"
    end
    return escape_html(str)
end

local function renderPrimitive(element, indentLevel)
	indentLevel = indentLevel or 0

	if type(element) == "table" and element.__unsafe == true then
    	return element.str
    end
	if type(element) == "string" then
		return escape_html(element)
	elseif type(element) == "number" then
		return element
	elseif type(element) == "boolean" then
		return ""
	elseif type(element) == "table" and not element.__tag then
		local html = ""
		for _, v in pairs(element) do
			html = html .. renderPrimitive(v, indentLevel)
		end
		return html
	elseif type(element) == "table" and element.__tag then
		return M.Render(element, indentLevel)
	else
		return ""
	end
end

function M.Render(element, indentLevel)
	indentLevel = indentLevel or 0
    local indent = string.rep("\t", indentLevel)

    if type(element) == "table" and element.__unsafe == true then
    	return element.str
    end

    if type(element) ~= "table" or not element.__tag then
        return indent .. renderPrimitive(element)
    end

    local html = indent .. "<" .. element.__tag

    -- Add attributes
    for k, v in pairs(element) do
        if k == "style" and type(v) == "table" then
            html = html .. string.format(' %s="%s"', k, parseStyles(v))
        elseif type(k) == "string" and k ~= "__tag" and type(v) ~= "table" then
            if BOOLEAN_ATTRIBUTES[k] and v == true then
                html = html .. " " .. k
            elseif not BOOLEAN_ATTRIBUTES[k] then
                html = html .. string.format(' %s="%s"', camel_to_kebab(k), escape_html(v))
            end
        end
    end

    if SELF_CLOSING_TAGS[element.__tag] then
        return html .. "/>\n"
    end

    html = html .. ">\n"

    for k, v in pairs(element) do
        if type(v) == "table" then
            html = html .. M.Render(v, indentLevel + 1)
        elseif k ~= "__tag" and type(k) == "number" then
            html = html .. indent .. "\t" .. escape_html(tostring(v)) .. "\n"
        end
    end

    html = html .. indent .. "</" .. element.__tag .. ">\n"
    return html
end

-- Helper functions for conditional rendering
function M.When(condition, element)
    return condition and element or nil
end

function M.Unless(condition, element)
    return not condition and element or nil
end

function M.Switch(value, cases)
    return cases[value] or cases.default
end

local tags = {
    "div", "span", "p", "a", "button", "input", "img", "form",
    "h1", "h2", "h3", "h4", "h5", "h6",
    "ul", "ol", "li",
    "table", "tr", "td", "th",
    "section", "header", "footer", "aside", "article", "nav",
    "main", "aside", "figure", "figcaption",
    "label", "select", "option", "textarea",
    "strong", "em", "i", "b", "u", "s", "small", "sub", "sup",
    "br", "hr", "meta", "link",
    "iframe", "video", "audio", "source", "track",
    "head", "html", "body", "title", "style", "script",
    "stylesheet", "module", "importmap"
}

function M.unsafe(str)
	return { __unsafe = true, str = str }
end

local function createElementFactory(tag)
    return function(props)
        local obj = { __tag = tag }

        if tag == "stylesheet" then
			obj.__tag = "link"
			obj.rel = "stylesheet"
			obj.type = "text/css"
			obj.href = props
			return obj
		end

		if tag == "module" then
			obj.__tag = "script"
			obj.type = "module"
			obj.src = props
			return obj
		end

		if tag == "importmap" then
			obj.__tag = "script"
			obj.type = "importmap"
			obj.src = M.unsafe(props)
			return obj
		end

        if type(props) ~= "table" then
			obj[1] = props
			return obj
		end

		if tag == "h1" and props.level then
			obj.__tag = "h" .. props.level
		end

        for k, v in pairs(props) do
			obj[k] = v
		end

        return obj
    end
end

for _, tag in ipairs(tags) do
	M[tag] = createElementFactory(tag)
end

_G["Html"] = M.html
_G["Head"] = M.head
_G["Link"] = M.link
_G["Meta"] = M.meta
_G["Body"] = M.body
_G["Title"] = M.title
_G["Style"] = M.style
_G["Stylesheet"] = M.stylesheet
_G["Importmap"] = M.importmap
_G["Module"] = M.module
_G["Script"] = M.script
_G["Div"] = M.div
_G["Span"] = M.span
_G["Text"] = M.p
_G["Anchor"] = M.a
_G["Button"] = M.button
_G["Input"] = M.input
_G["Image"] = M.img
_G["Form"] = M.form
_G["Title"] = M.h1
_G["UnorderedList"] = M.ul
_G["OrderedList"] = M.ol
_G["ListItem"] = M.li
_G["Table"] = M.table
_G["TableRow"] = M.tr
_G["TableData"] = M.td
_G["TableHeader"] = M.th
_G["Section"] = M.section
_G["Header"] = M.header
_G["Footer"] = M.footer
_G["Aside"] = M.aside
_G["Article"] = M.article
_G["Navigation"] = M.nav
_G["Main"] = M.main
_G["Aside"] = M.aside
_G["Figure"] = M.figure
_G["Figcaption"] = M.figcaption
_G["Label"] = M.label
_G["Select"] = M.select
_G["Option"] = M.option
_G["Textarea"] = M.textarea
_G["Strong"] = M.strong
_G["Emphasis"] = M.em
_G["Italic"] = M.i
_G["Bold"] = M.b
_G["Underline"] = M.u
_G["Strikethrough"] = M.s

return M
