-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT
--
local telescope = require("telescope")

return telescope.register_extension {
  exports = { live_grep_raw = function ()
    vim.notify("telescope live_grep_raw has been renamed to live_grep_args - update your config!")
  end },
}
