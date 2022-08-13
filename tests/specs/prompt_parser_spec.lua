-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local prompt_parser = require("telescope-live-grep-args.prompt_parser")

local tests = {
  {
    "\"",
    {},
    {}
  },
  {
    "\"\"",
    {""},
    {""}
  },
  {
    "test1",     -- input value
    { "test1" }, -- expected with auto-quoting
    { "test1" }  -- expected without auto-quoting
  },
  {
    "test1 \"\" test2",
    { "test1 \"\" test2" },
    { "test1", "", "test2" }
  },
  {
    "test1 '' test2",
    { "test1 '' test2" },
    { "test1", "", "test2" }
  },
  {
    "test1 test2",
    { "test1 test2" },
    { "test1", "test2" }
  },
  {
    "test1 \"test2 test3\"",
    { "test1 \"test2 test3\"" },
    { "test1", "test2 test3" }
  },
  {
    "test1 'test2 test3'",
    { "test1 'test2 test3'" },
    { "test1", "test2 test3" }
  },
  {
    "test1 \"test2\\\" test3\"",
    { "test1 \"test2\\\" test3\"" },
    { "test1", "test2\" test3" }
  },
  {
    "test1 \"test2 test3",
    { "test1 \"test2 test3" },
    { "test1", "test2 test3" }
  },
  {
    "test1 'test2\" test3'",
    { "test1 'test2\" test3'" },
    { "test1", "test2\" test3" }
  },
  {
    "test1 'test2 test3",
    { "test1 'test2 test3" },
    { "test1", "test2 test3" }
  },
  {
    "'test1 test2' \"test3 test4\"",
    { "test1 test2", "test3 test4" },
    { "test1 test2", "test3 test4" }
  },
  {
    "\"test1 test2\" test3",
    { "test1 test2", "test3" },
    { "test1 test2", "test3" }
  },
  {
    "--test1 \"test2 test3",
    { "--test1", "test2 test3" },
    { "--test1", "test2 test3" },
  },
  {
    "--test1=\"test2 test3\" test4",
    { "--test1=test2 test3", "test4" },
    { "--test1=test2 test3", "test4" }
  },
  {
    "--test1='test2 test3' test4",
    { "--test1=test2 test3", "test4" },
    { "--test1=test2 test3", "test4" }
  },
  {
    "--test1=\"test2 test3\" test4 --test5=\"test6 test7\"",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" },
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
  {
    "--test1='test2 test3' test4 --test5='test6 test7'",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" },
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
  {
    "--test1=\"test2 test3\" test4 --test5='test6 test7'",
    { "--test1=test2 test3", "test4", "--test5=test6 test7" },
    { "--test1=test2 test3", "test4", "--test5=test6 test7" }
  },
}

describe("prompt_parser.parse", function ()
  for _, test in pairs(tests) do
    it('should parse »' .. test[1] .. '« correclty with auto-quoting', function ()
      assert.are.same(test[2], prompt_parser.parse(test[1], true))
    end)

    it('should parse »' .. test[1] .. '« correclty without auto-quoting', function ()
      assert.are.same(test[3], prompt_parser.parse(test[1], false))
    end)
  end
end)
