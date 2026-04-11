-- SPDX-FileCopyrightText: 2023 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local live_grep_args = require("telescope").extensions.live_grep_args
local helpers = require("telescope-live-grep-args.helpers")

local function get_visual()
  return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
end

local grep_under_default_opts = {
  postfix = " -F ",
  quote = true,
  trim = true,
}

local function process_grep_under_text(value, opts)
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

  opts["default_text"] = value

  return opts
end

local M = {}

M.grep_word_under_cursor = function(opts)
  opts = opts or {}
  local word_under_cursor = vim.fn.expand("<cword>")
  opts = process_grep_under_text(word_under_cursor, opts)
  live_grep_args.live_grep_args(opts)
end

M.grep_visual_selection = function(opts)
  opts = opts or {}
  local visual = get_visual()
  local text = visual[1] or ""
  opts = process_grep_under_text(text, opts)
  live_grep_args.live_grep_args(opts)
end

M.grep_word_visual_selection_current_buffer = function(opts)
  opts = opts or {}
  local curr_path = vim.fn.expand("%")
  opts["search_dirs"] = { curr_path }
  M.grep_visual_selection(opts)
end

M.grep_word_under_cursor_current_buffer = function(opts)
  opts = opts or {}
  local curr_path = vim.fn.expand("%")
  opts["search_dirs"] = { curr_path }
  M.grep_word_under_cursor(opts)
end

return M
