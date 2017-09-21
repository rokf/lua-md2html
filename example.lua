local md2html = require 'md2html'

local example = [[
## Hello

This is some **fat** text.
Paragraphs are split on each newline, fix?.

***

Some _more_ *text* and ~~striked~~.

An ![image](img.png)

Combined **fat and _italic_**.

---

A __bold__ and [link](http://www.google.com "Link Title") in this paragraph.

> Here is a quote.
> Same quote, additional line.

___
]]

print(md2html.convert(example,{b="strong"}))
