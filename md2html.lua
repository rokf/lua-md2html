local re = require 're'

local M = {}

function M.convert(md,classes)
  local pattern = re.compile([[
  default <- {| (title / list / ml_code / hr / quote / para / %nl)* |} -> join
  title <- {| {:depth: '#'+ :} %s* {:title: [^%nl]+ :} %nl |} -> to_title
  para <- {| paraline+ |} -> concat
  paraline <- {| (img / link / b / i / ub / ui / s / sl_code / text)+ %nl |} -> concat_line
  b <- {| '**' {:b: {| (ui / {[^*]})+ |} :} '**' |} -> to_b
  ub <- {| '__' {:b: {| {[^_]+} |}  :} '__' |} -> to_b
  i <- {| '*' {:i: [^*]+ :} '*' |} -> to_i
  ui <- {| '_' {:i: [^_]+ :} '_' |} -> to_i
  s <- {| '~~' {:s: [^~]+ :} '~~' |} -> to_s
  img <- '!' (linkpat -> to_img)
  link <- linkpat -> to_a
  linkpat <- {| '[' {:txt: [^] ]+ :} ']' %s* '(' {:url: [^%s)]+ :} %s* link_title^-1 ')' |}
  link_title <- '"' {:title:  { [^"]+ }  :} '"'
  text <- { [^*~_%nl[!`]+ }
  hr <- { '---' / '***' / '___' } -> '<hr>'
  quote <- {| ('>' %s+ { [^%nl]+ } %nl)+ |} -> to_quote
  sl_code <- ('`' { [^`]* } '`') -> to_code
  ml_code <- ('```' { [^`]* } '```') -> to_code
  list <- ulist / olist
  ulist <- {| ([-+] %s+ { [^%nl]+ } %nl)+ |} -> to_ulist
  olist <- {| ([0-9]+ '.' %s+ { [^%nl]+ } %nl)+ |} -> to_olist
]],{
  to_ulist = function (t)
    local li_list = {}
    for _,v in ipairs(t) do
      table.insert(li_list, string.format('<li class="%s">%s</li>',classes.li or "",v))
    end
    return string.format('<ul class="%s">%s</ul>',classes.ul or "",table.concat(li_list))
  end,
  to_olist = function (t)
    local li_list = {}
    for _,v in ipairs(t) do
      table.insert(li_list, string.format('<li class="%s">%s</li>',classes.li or "",v))
    end
    return string.format('<ol class="%s">%s</ol>',classes.ol or "",table.concat(li_list))
  end,
  to_code = function (txt)
    return string.format('<code class="%s">%s</code>',classes.code or "", txt)
  end,
  to_quote = function (t)
    return string.format('<blockquote class="%s">%s</blockquote>',classes.blockquote or "",table.concat(t,' '))
  end,
  to_title = function (t)
    local depth = #t.depth
    if depth == 1 then
      return string.format('<h%d class="%s">%s</h%d>',depth,classes.h1 or "",t.title,depth)
    elseif depth == 2 then
      return string.format('<h%d class="%s">%s</h%d>',depth,classes.h2 or "",t.title,depth)
    elseif depth == 3 then
      return string.format('<h%d class="%s">%s</h%d>',depth,classes.h3 or "",t.title,depth)
    elseif depth == 4 then
      return string.format('<h%d class="%s">%s</h%d>',depth,classes.h4 or "",t.title,depth)
    end
  end,
  to_a = function (t)
    local lt = ""
    if t.title then
      lt = ' title="' .. t.title .. '"'
    end
    -- return '<a href="' .. t.url .. '"' .. lt .. '>' .. t.txt .. '</a>'
    return string.format('<a href="%s" class="%s"%s>%s</a>',t.url,classes.a or "",lt,t.txt)
  end,
  to_img = function (t)
    local lt = ""
    if t.title then
      lt = ' title="' .. t.title .. '"'
    end
    return string.format('<img src="%s" class="%s" alt="%s"%s>',t.url,classes.img or "",t.txt,lt)
  end,
  to_i = function (t)
    return string.format('<i class="%s">%s</i>',classes.i or "",t.i)
  end,
  to_b = function (t)
    return string.format('<b class="%s">%s</b>',classes.b or "", table.concat(t.b))
  end,
  to_s = function (t)
    return string.format('<s class="%s">%s</s>',classes.s or "",t.s)
  end,
  concat = function (t)
    return string.format('<p class="%s">%s</p>',classes.p or "",table.concat(t, ' '))
  end,
  concat_line = function (t)
    return table.concat(t)
  end,
  join = function (t)
    return table.concat(t,"\n")
  end
})
  return pattern:match(md)
end

return M
