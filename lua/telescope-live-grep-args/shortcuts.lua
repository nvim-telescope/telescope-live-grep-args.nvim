local live_grep_raw = require("telescope").extensions.live_grep_args

local M = {}

M.grep_word_under_cursor = function ()
  live_grep_raw.live_grep_raw({ default_text = vim.fn.expand("<cword>")})
end

return M
