-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT
--

local migration = [[
"live_grep_raw" has been renamed to "live_grep_args":
- Change the plugin source to "nvim-telescope/telescope-live-grep-args.nvim"
  (new Git repo: https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
- Replace all occurrences of "live_grep_raw" with "live_grep_args" in your config
]]
vim.notify(migration, vim.log.levels.WARN)
vim.fn.input("Press ENTER to continue")

return require("telescope._extensions.live_grep_args")
