<!--
SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>

SPDX-License-Identifier: CC0-1.0
-->

# Telescope live grep args

[![REUSE status](https://api.reuse.software/badge/github.com/nvim-telescope/telescope-live-grep-args.nvim)](https://api.reuse.software/info/github.com/nvim-telescope/telescope-live-grep-args.nvim)

Live grep args picker for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

![](./img/telescope-live-grep-args.nvim.png)


## What it does

It enables passing arguments to the grep command, `rg` examples:

- `foo` → press `<C-k>` → `"foo" ` → `"foo" -tmd`
  - Only works if you set up the `<C-k>` mapping
- `--no-ignore foo`
- `"foo bar" bazdir`
- `"foo" --iglob **/bar/**`

Find the full [ripgrep guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) here to find out what is possible.


## Installation

<details>
    <summary>Packer</summary>
Add `telescope-live-grep-args.nvim` as `telescope.nvim` dependency, e.g.:

```lua
use {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function()
    require("telescope").load_extension("live_grep_args")
  end
}
```
</details>

<details>
    <summary>Other</summary>
Once live grep args is available as lua module, load the extension:

```
require("telescope").load_extension("live_grep_args")
```
</details>


## Setup

Map live grep args:

```
keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
```

Call live grep args:

```
:lua require("telescope").extensions.live_grep_args.live_grep_args()
```


## Usage

### Grep argument examples

(Some examples are ripgrep specific)

| Prompt | Args | Description |
| --- | --- | --- |
| `foo bar` | `foo bar` | search for „foo bar“ |
| `"foo bar" baz` | `foo bar`, `baz` | search for „foo bar“ in dir „baz“ |
| `--no-ignore "foo bar` | `--no-ignore`, `foo bar` | search for „foo bar“ ignoring ignores |
| `"foo" --iglob **/test/**` | search for „foo“ in any „test“ path |
| `"foo" ../other-project` | `foo`, `../other-project` | search for „foo“ in `../other-project` |

If the prompt value does not begin with `'`, `"` or `-` the entire prompt is treated as a single argument.
This behaviour can be turned off by setting the `auto_quoting` option to `false`.


## Configuration

```lua
local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
      
      -- custom prompt parse function
      -- prompt_parse_fun = function(prompt, autoquote) … end,
    }
  }
}
```

This extension accepts the same options as `builtin.live_grep`, check out `:help live_grep` and `:help vimgrep_arguments` for more information. Additionally it also accepts `theme` and `layout_config`.


### Mapping recipes:

This table provides some mapping ideas:

| Mapped function | Description | Example |
| --- | --- | --- |
| `actions.quote_prompt()` | Quote prompt | `foo` → `"foo"` |
| `actions.quote_prompt({ postfix = ' --iglob ' })` | Quote prompt and add `--iglob` | `foo` → `"foo" --iglob ` |
| `actions.quote_prompt({ postfix = ' -t' })` | Quote prompt and add `-t` | `foo` → `"foo" -t` |


## Development

### Running the tests

- Clone [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) next to this repo
- `make test`


## Acknowledgements

Based on the idea of this [pull request](https://github.com/nvim-telescope/telescope.nvim/pull/670).
