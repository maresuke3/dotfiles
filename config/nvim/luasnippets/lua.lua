local ls = require("luasnip")

local s = ls.snippet
-- local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "snip",
    fmt(
      [[
        local ls = require("luasnip")

        local s = ls.snippet
        -- local t = ls.text_node
        local i = ls.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        return {}
      ]],
      {i(1,"name")}
    )
  )
}
