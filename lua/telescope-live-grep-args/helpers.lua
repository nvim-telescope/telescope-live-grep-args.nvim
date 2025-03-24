-- SPDX-FileCopyrightText: 2023 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local M = {}

local quote_default_opts = {
  quote_char = '"',
}

M.quote = function(value, opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", quote_default_opts, opts)

  local quoted = value:gsub(opts.quote_char, "\\" .. opts.quote_char)
  return opts.quote_char .. quoted .. opts.quote_char
end

M.extract_quotes = function(input)
  local match = input:match('"(.-)"')
  if match then
    return match
  else
    return input
  end
end

return M