local live_grep_args = require("telescope").extensions.live_grep_args
local helpers = require("telescope-live-grep-args.helpers")

local function get_visual()
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

local grep_under_default_opts = {
  postfix = " -F ",
  quote = true,
  trim = true,
}

local function proces_grep_under_text(value, opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", grep_under_default_opts, opts)

  if opts.trim then
    value = vim.trim(value)
  end

  if opts.quote then
    value = helpers.quote(value, opts)
  end

  if opts.postfix then
    value = value .. opts.postfix
  end

  return value
end

local M = {}


M.grep_word_under_cursor = function(opts)
  local word_under_cursor = vim.fn.expand("<cword>")
  word_under_cursor = proces_grep_under_text(word_under_cursor, opts)
  live_grep_args.live_grep_args({ default_text = word_under_cursor })
end

M.grep_visual_selection = function(opts)
  local visual = get_visual()
  local text = visual[1] or ""
  text = proces_grep_under_text(text, opts)
  live_grep_args.live_grep_args({ default_text = text })
end

return M
