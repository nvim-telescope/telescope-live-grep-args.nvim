-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local prompt_parser = require("telescope-live-grep-args.prompt_parser")

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

local setup_opts = {}

local live_grep_args = function(opts)
  opts = vim.tbl_extend('force', setup_opts, opts or {})

  opts.vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd)

  local cmd_generator = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local args = tbl_clone(opts.vimgrep_arguments)
    local prompt_parts = prompt_parser.parse(prompt, opts.auto_quoting)

    local cmd = vim.tbl_flatten { args, prompt_parts }
    return cmd
  end

  pickers.new(opts, {
    prompt_title = 'live grep (args)',
    finder = finders.new_job(cmd_generator, opts.entry_maker, opts.max_results, opts.cwd),
    previewer = conf.grep_previewer(opts),
    sorter = sorters.highlighter_only(opts),
  }):find()
end

return telescope.register_extension {
  setup = function(ext_config)
    for k, v in pairs(ext_config) do
      setup_opts[k] = v
    end
  end,
  exports = { live_grep_args = live_grep_args },
}
