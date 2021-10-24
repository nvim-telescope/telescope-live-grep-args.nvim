<!--
SPDX-FileCopyrightText: Michael Weimann <mail@michael-weimann.eu>

SPDX-License-Identifier: MIT
-->

> ![](https://weimann.digital/redbox.png) The actual development of this project takes place here:    
> [https://pubcode.weimann.digital/projects/telescope-live-grep-raw.nvim](https://pubcode.weimann.digital/projects/telescope-live-grep-raw.nvim)  
> You can easily log in with your GitHub account there.


# Telescope live grep raw

[![REUSE status](https://api.reuse.software/badge/pubcode.weimann.digital/telescope-live-grep-raw.nvim)](https://api.reuse.software/info/pubcode.weimann.digital/telescope-live-grep-raw.nvim)

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
        { 'weeman1337/telescope-live-grep-raw.nvim' }
    }
}
```


## Usage

Call or map this command

```
:lua require("telescope").extensions.live_grep_raw.live_gre"_raw()
```


### Acknowledgements

Based on the idea of this [pull request](https://github.com/nvim-telescope/telescope.nvim/pull/670).
