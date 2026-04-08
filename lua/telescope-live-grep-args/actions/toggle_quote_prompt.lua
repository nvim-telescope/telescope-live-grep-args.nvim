-- SPDX-FileCopyrightText: 2025 Federico Tassinari
--
-- SPDX-License-Identifier: MIT

local action_state = require("telescope.actions.state")
local helpers = require("telescope-live-grep-args.helpers")

local default_opts = {
  quote_char = '"',
  postfix = " ",
  trim = true,
}

local last_args = ""

return function(opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", default_opts, opts)

  return function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local prompt = picker:_get_prompt()
    if opts.trim then
      prompt = vim.trim(prompt)
    end

    local qc = opts.quote_char
    if prompt:sub(1, 1) == qc then
      local search_term, args = helpers.unquote(prompt, { quote_char = qc })
      last_args = args
      picker:set_prompt(search_term)
    else
      local quoted = helpers.quote(prompt, { quote_char = qc })
      local suffix = last_args ~= "" and (" " .. last_args) or opts.postfix
      picker:set_prompt(quoted .. suffix)
    end
  end
end
