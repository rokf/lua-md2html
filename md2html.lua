local re = require 're'

local function class_str(cls)
  if cls then
    return string.format(' class="%s"', cls)
  end
  return ""
end

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
        table.insert(li_list, string.format('<li%s>%s</li>',class_str(classes.li),v))
      end
      return string.format('<ul%s>%s</ul>',class_str(classes.ul),table.concat(li_list))
    end,
    to_olist = function (t)
      local li_list = {}
      for _,v in ipairs(t) do
        table.insert(li_list, string.format('<li%s>%s</li>',class_str(classes.li),v))
      end
      return string.format('<ol%s>%s</ol>',class_str(classes.ol),table.concat(li_list))
    end,
    to_code = function (txt)
      return string.format('<code%s>%s</code>',class_str(classes.code), txt)
    end,
    to_quote = function (t)
      return string.format('<blockquote%s>%s</blockquote>',class_str(classes.blockquote),table.concat(t,' '))
    end,
    to_title = function (t)
      local depth = #t.depth
      return string.format('<h%d%s>%s</h%d>',depth,class_str(classes["h"..tostring(depth)]),t.title,depth)
    end,
    to_a = function (t)
      local lt = ""; if t.title then lt = ' title="' .. t.title .. '"' end
      return string.format('<a href="%s"%s%s>%s</a>',t.url,class_str(classes.a),lt,t.txt)
    end,
    to_img = function (t)
      local lt = ""; if t.title then lt = ' title="' .. t.title .. '"' end
      return string.format('<img src="%s"%salt="%s"%s>',t.url,class_str(classes.img),t.txt,lt)
    end,
    to_i = function (t)
      return string.format('<i%s>%s</i>',class_str(classes.i),t.i)
    end,
    to_b = function (t)
      return string.format('<b%s>%s</b>',class_str(classes.b), table.concat(t.b))
    end,
    to_s = function (t)
      return string.format('<s%s>%s</s>',class_str(classes.s),t.s)
    end,
    concat = function (t)
      return string.format('<p%s>%s</p>',class_str(classes.p),table.concat(t, ' '))
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
