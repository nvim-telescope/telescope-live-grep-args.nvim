<!--
SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>

SPDX-License-Identifier: CC0-1.0
-->

# Telescope live grep raw

[![REUSE status](https://api.reuse.software/badge/github.com/nvim-telescope/telescope-live-grep-raw.nvim)](https://api.reuse.software/info/github.com/nvim-telescope/telescope-live-grep-raw.nvim)

Live grep raw picker for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

![](./img/telescope-live-grep-raw.png)


## What it does

It passes the entire prompt to the grep command additionally to the vimgrep options.


## Installation

### Packer

Add `telescope-live-grep-raw.nvim` as `telescope.nvim` dependency, e.g.:

```lua
use {
    'nvim-telescope/telescope.nvim',
    requires = {
        { 'nvim-telescope/telescope-live-grep-raw.nvim' }
    }
}
```


## Usage

Call or map this command

```
:lua require("telescope").extensions.live_grep_raw.live_grep_raw()
```


## Development

### Running the tests

- Clone [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) next to this repo
- `make test`


## Acknowledgements

Based on the idea of this [pull request](https://github.com/nvim-telescope/telescope.nvim/pull/670).
