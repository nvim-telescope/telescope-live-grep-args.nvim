-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local prompt_parser = require("telescope-live-grep-raw.prompt_parser")

local telescope = require("telescope")
local pickers = require "telescope.pickers"
local sorters = require('telescope.sorters')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')
local finders = require "telescope.finders"

local tbl_clone = function(original)
  local copy = {}
  for key, value in pairs(original) do
    copy[key] = value
  end
  return copy
end

local grep_highlighter_only = function(opts)
  return sorters.Sorter:new {
    scoring_function = function() return 0 end,

    highlighter = function(_, prompt, display)
      return {}
    end,
  }
end

local live_grep_raw = function(opts)
  opts = opts or {}

  opts.vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd)

  local cmd_generator = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local args = tbl_clone(opts.vimgrep_arguments)
    local prompt_parts = prompt_parser.parse(prompt)

    local cmd = vim.tbl_flatten { args, prompt_parts }
    return cmd
  end

  pickers.new(opts, {
    prompt_title = 'Live Grep Raw',
    finder = finders.new_job(cmd_generator, opts.entry_maker, opts.max_results, opts.cwd),
    previewer = conf.grep_previewer(opts),
    sorter = grep_highlighter_only(opts),
  }):find()
end

return telescope.register_extension {
  exports = { live_grep_raw = live_grep_raw },
}
