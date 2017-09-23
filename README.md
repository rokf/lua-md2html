#### md2html

Another Markdown to HTML conversion module for Lua.

It enables you to assign a class string for each of these elements:

- ul
- ol
- li
- code
- blockquote
- h1 - h4
- a
- img
- i
- b
- s
- p

The module exports one function only, `convert`.
It accepts a Markdown string and a table with
optional class entries. It returns a HTML string.

### Example

```
local md2html = require 'md2html'
local md = [[ ... ]]
local html = md2html.convert(md, {
  b = "strong",
  img = "image",
  a = "link",
  li = "listelement"
})
```

### Installation

The module isn't yet on `LuaRocks` but can be installed with the
contained `rockspec` file.

`sudo luarocks install md2html-dev-1.rockspec`
