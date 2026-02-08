-- SPDX-FileCopyrightText: 2025 Federico Tassinari
--
-- SPDX-License-Identifier: MIT

local helpers = require("telescope-live-grep-args.helpers")

describe("helpers.quote", function()
  it("wraps value in quotes", function()
    assert.are.equal('"foo"', helpers.quote("foo"))
  end)

  it("escapes inner quotes", function()
    assert.are.equal('"foo\\"bar"', helpers.quote('foo"bar'))
  end)

  it("respects custom quote_char", function()
    assert.are.equal("'foo'", helpers.quote("foo", { quote_char = "'" }))
  end)
end)

describe("helpers.unquote", function()
  it("extracts content from quoted string", function()
    local term, args = helpers.unquote('"foo"')
    assert.are.equal("foo", term)
    assert.are.equal("", args)
  end)

  it("extracts args after closing quote", function()
    local term, args = helpers.unquote('"foo" -g *.lua')
    assert.are.equal("foo", term)
    assert.are.equal("-g *.lua", args)
  end)

  it("unescapes inner quotes", function()
    local term, args = helpers.unquote('"foo\\"bar"')
    assert.are.equal('foo"bar', term)
    assert.are.equal("", args)
  end)

  it("unescapes inner quotes and preserves args", function()
    local term, args = helpers.unquote('"foo\\"bar" -t py')
    assert.are.equal('foo"bar', term)
    assert.are.equal("-t py", args)
  end)

  it("returns unquoted value as-is when not quoted", function()
    local term, args = helpers.unquote("foo")
    assert.are.equal("foo", term)
    assert.are.equal("", args)
  end)

  it("handles empty quoted string", function()
    local term, args = helpers.unquote('""')
    assert.are.equal("", term)
    assert.are.equal("", args)
  end)

  it("handles unclosed quote", function()
    local term, args = helpers.unquote('"foo')
    assert.are.equal("foo", term)
    assert.are.equal("", args)
  end)

  it("respects custom quote_char", function()
    local term, args = helpers.unquote("'foo' -g *.rs", { quote_char = "'" })
    assert.are.equal("foo", term)
    assert.are.equal("-g *.rs", args)
  end)
end)

describe("quote/unquote roundtrip", function()
  local values = { "foo", 'foo"bar', "", "hello world" }
  for _, value in ipairs(values) do
    it("roundtrips " .. vim.inspect(value), function()
      local quoted = helpers.quote(value)
      local unquoted, args = helpers.unquote(quoted)
      assert.are.equal(value, unquoted)
      assert.are.equal("", args)
    end)
  end
end)
