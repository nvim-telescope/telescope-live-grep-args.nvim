-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local prompt_parser = require("telescope-live-grep-raw.prompt_parser")

local tests = {
  {
    "test1",
    { "test1" }
  },
  {
    "test1 \"\" test2",
    { "test1", "", "test2" }
  },
  {
    "test1 '' test2",
    { "test1", "", "test2" }
  },
  {
    "test1 test2",
    { "test1", "test2" }
  },
  {
    "test1 \"test2 test3\"",
    { "test1", "test2 test3" }
  },
  {
    "test1 'test2 test3'",
    { "test1", "test2 test3" }
  },
  {
    "test1 \"test2\\\" test3\"",
    { "test1", "test2\" test3" }
  },
  {
    "test1 \"test2 test3",
    { "test1", "test2 test3" }
  },
  {
    "test1 'test2\" test3'",
    { "test1", "test2\" test3" }
  },
  {
    "test1 'test2 test3",
    { "test1", "test2 test3" }
  },
  {
    "'test1 test2' \"test3 test4\"",
    { "test1 test2", "test3 test4" }
  },
  {
    "--test1=\"test2 test3\" test4",
    { "--test1=test2 test3", "test4" }
  },
  {
    "--test1='test2 test3' test4",
    { "--test1=test2 test3", "test4" }
  },
  {
    "--test1=\"test2 test3\" test4 --test5=\"test6 test7\"",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
  {
    "--test1='test2 test3' test4 --test5='test6 test7'",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
  {
    "--test1=\"test2 test3\" test4 --test5='test6 test7'",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
}

describe("prompt_parser.parse", function ()
  for _, test in pairs(tests) do
    it('should parse »' .. test[1] .. '« correclty', function ()
      assert.are.same(test[2], prompt_parser.parse(test[1]))
    end)
  end
end)
