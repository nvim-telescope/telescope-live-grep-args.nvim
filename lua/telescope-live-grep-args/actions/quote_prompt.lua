-- SPDX-FileCopyrightText: 2022 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local action_state = require "telescope.actions.state"
local helpers = require "telescope-live-grep-args.helpers"

local default_opts = {
  quote_char = '"',
  postfix = " ",
  trim = true,
}

return function (opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", default_opts, opts)

  return function (prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local prompt = picker:_get_prompt()
    if opts.trim then
      prompt = vim.trim(prompt)
    end
    if opts.quote_char == "" then
      prompt = prompt .. opts.postfix
    else
      prompt = helpers.quote(prompt, { quote_char =  opts.quote_char }) .. opts.postfix
    end
    picker:set_prompt(prompt)
  end
end
