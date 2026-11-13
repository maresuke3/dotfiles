local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
--local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    {
      trig = "rfc",
      name = "react function component",
      desc = "reactの関数型コンポーネントを作るスニペット"
    },
    fmt(
      [[
        export const {} = () => {}
      ]],
      {i(1,"name"),i(2,"value")}
    )
  )
}
