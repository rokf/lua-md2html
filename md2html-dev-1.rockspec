package = "md2html"
version = "dev-1"
source = {
  url = "git://github.com/rokf/lua-md2html"
}
description = {
  summary = "Convert Markdown into HTML",
  homepage = "https://github.com/rokf/lua-md2html",
  maintainer = "Rok Fajfar <snewix7@gmail.com>",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1", "lpeg"
}
build = {
  type = "builtin",
  modules = {
    md2html = "md2html.lua"
  }
}
