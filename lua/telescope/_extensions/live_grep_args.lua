-- SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
--
-- SPDX-License-Identifier: MIT

local prompt_parser = require("telescope-live-grep-args.prompt_parser")

local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local telescope = require("telescope")
local themes = require("telescope.themes")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

local tbl_clone = function(original)
  local copy = {}
  for key, value in pairs(original) do
    copy[key] = value
  end
  return copy
end

local setup_opts = {
  auto_quoting = true,
  mappings = {},
  history = {
    max = 10,
    keys = {
      cycle = "<C-y>",
      next = "<Down>",
      prev = "<Up>",
      submit = "<CR>",
    },
  },
}

-- local last_prompt = ""
local prompt_history = {}
local MAX_HISTORY = 10

local live_grep_args = function(opts)
  opts = vim.tbl_extend("force", setup_opts, opts or {})

  opts.vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd)

  local additional_args = {}
  if opts.additional_args ~= nil then
    if type(opts.additional_args) == "function" then
      additional_args = opts.additional_args(opts)
    elseif type(opts.additional_args) == "table" then
      additional_args = opts.additional_args
    end
  end

  if opts.search_dirs then
    for i, path in ipairs(opts.search_dirs) do
      opts.search_dirs[i] = vim.fn.expand(path)
    end
  end

  local cmd_generator = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local args = vim.iter({ tbl_clone(opts.vimgrep_arguments), tbl_clone(additional_args) }):flatten():totable()
    local prompt_parts = prompt_parser.parse(prompt, opts.auto_quoting)

    local cmd = vim.iter({ args, prompt_parts, opts.search_dirs }):flatten():totable()
    return cmd
  end

  -- apply theme
  if type(opts.theme) == "table" then
    opts = vim.tbl_extend("force", opts, opts.theme)
  elseif type(opts.theme) == "string" then
    if themes["get_" .. opts.theme] == nil then
      vim.notify_once("live grep args config theme »" .. opts.theme .. "« not found", vim.log.levels.WARN)
    else
      opts = themes["get_" .. opts.theme](opts)
    end
  end

  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  pickers
    .new(opts, {
      prompt_title = "Live Grep (Args)",
      finder = finders.new_job(cmd_generator, opts.entry_maker, opts.max_results, opts.cwd),
      previewer = conf.grep_previewer(opts),
      sorter = sorters.highlighter_only(opts),
      attach_mappings = function(prompt_bufnr, map)
        for mode, mappings in pairs(opts.mappings) do
          for key, action in pairs(mappings) do
            map(mode, key, action)
          end
        end

        -- history management
        local history_keys = (opts.history and opts.history.keys) or {}
        local max_history = (opts.history and opts.history.max) or MAX_HISTORY
        local history_index = 0

        -- cycle through history
        if history_keys.cycle then
          map({ "i", "n" }, history_keys.cycle, function(bufnr)
            if #prompt_history == 0 then
              return
            end
            history_index = history_index + 1
            if history_index > #prompt_history then
              history_index = 1
            end
            local picker = action_state.get_current_picker(bufnr)
            if not picker then
              return
            end
            picker:set_prompt(prompt_history[history_index])
          end)
        end

        -- capture used search prompt, when user moves the selection or submits
        local function capture_prompt()
          if not vim.api.nvim_buf_is_valid(prompt_bufnr) then
            return
          end
          local picker = action_state.get_current_picker(prompt_bufnr)
          local line = picker and picker:_get_prompt() or ""
          if not line or line == "" then
            return
          end

          -- remove existing duplicate and add at the front
          for i, p in ipairs(prompt_history) do
            if p == line then
              table.remove(prompt_history, i)
              break
            end
          end
          table.insert(prompt_history, 1, line)

          -- trim to max_history
          while #prompt_history > max_history do
            table.remove(prompt_history)
          end

          -- reset cycle so next session starts at the newest
          history_index = 0
        end

        local function wrap(action)
          return function()
            capture_prompt()
            action(prompt_bufnr)
          end
        end

        -- keymaps for triggering history cache update
        if history_keys.next then
          map({ "i", "n" }, history_keys.next, wrap(actions.move_selection_next))
        end
        if history_keys.prev then
          map({ "i", "n" }, history_keys.prev, wrap(actions.move_selection_previous))
        end
        if history_keys.submit then
          map({ "i", "n" }, history_keys.submit, wrap(actions.select_default))
        end

        return true
      end,
    })
    :find()
end

return telescope.register_extension({
  setup = function(ext_config)
    for k, v in pairs(ext_config) do
      setup_opts[k] = v
    end
  end,
  exports = {
    live_grep_args = live_grep_args,
    live_grep_raw = live_grep_args, -- historical name
  },
})
