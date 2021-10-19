<!--
SPDX-FileCopyrightText: Michael Weimann <mail@michael-weimann.eu>

SPDX-License-Identifier: MIT
-->

# Telescope live grep raw

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
        { 'https://pubcode.weimann.digital/telescope-live-grep-raw.nvim' }
    }
}
```


### Acknowledgements

Based on the idea of this [pull request](https://github.com/nvim-telescope/telescope.nvim/pull/670).
