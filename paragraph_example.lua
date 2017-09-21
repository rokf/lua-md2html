local md2html = require 'md2html'

local example = [[
First line.
Second line is in same paragraph.

Third line is in paragraph two.

Fourth line in paragraph three.
]]

print(md2html.convert(example,{}))
