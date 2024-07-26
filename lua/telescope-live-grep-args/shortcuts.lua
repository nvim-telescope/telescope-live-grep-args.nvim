-- SPDX-FileCopyrightText: 2023 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local live_grep_args = require("telescope").extensions.live_grep_args
local helpers = require("telescope-live-grep-args.helpers")

local function get_visual()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  -- nvim_buf_get_text requires start and end args be in correct order
  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
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

M.grep_visual_selection_current_buffer = function(opts)
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
local function search_switch(user_func)
    local function current_buffer_live_grep_args(_opts, is_current_buffer)
      _opts = _opts or {}
      _opts.attach_mappings = function(_, _map)
          _map({ "n", "i" }, "<C-a>", function(prompt_bufnr) -- <C-h> to toggle modes
            local prompt = require("telescope.actions.state").get_current_line()
            require("telescope.actions").close(prompt_bufnr)
            is_current_buffer = not is_current_buffer
            current_buffer_live_grep_args({ default_text = prompt}, is_current_buffer)
          end)
          return true
      end
      if is_current_buffer then
          _opts.prompt_title = "Live Grep Args (Current Buffer)"
          local curr_path = vim.fn.expand("%")
          _opts["search_dirs"] = { curr_path }
          live_grep_args.live_grep_args(_opts)
      else
          _opts.prompt_title = "Live Grep (Args)"
          user_func(_opts)
          -- switch back do not need word/visual selection shortcut again
          user_func = live_grep_args.live_grep_args
      end
    end
  return current_buffer_live_grep_args
end
local normal_grep  = M.live_grep_args_shortcuts.grep_word_under_cursor
local v_normal_grep = M.live_grep_args_shortcuts.grep_visual_selection
-- now you can use <C-a> to ennable powerful switch bewteen current buffer and normal grep
M.grep_word_under_cursor_switch = search_switch(normal_grep)
M.grep_word_visual_selection_switch = search_switch(v_normal_grep)

return M
