local md2html = require 'md2html'

local example = [[
> First blockqoute. Can cointain **same** _elements_ as a ~~paragraph~~.
> Another part of the first blockqoute.

> Second blockquote.
]]

print(md2html.convert(example,{}))
