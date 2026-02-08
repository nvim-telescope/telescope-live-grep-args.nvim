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

M.unquote = function(value, opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", quote_default_opts, opts)

  local qc = opts.quote_char
  if value:sub(1, 1) ~= qc then
    return value, ""
  end

  local i = 2
  while i <= #value do
    if value:sub(i, i) == "\\" and value:sub(i + 1, i + 1) == qc then
      i = i + 2
    elseif value:sub(i, i) == qc then
      break
    else
      i = i + 1
    end
  end

  local inner = value:sub(2, i - 1):gsub("\\" .. qc, qc)
  local rest = vim.trim(value:sub(i + 1))
  return inner, rest
end

return M
