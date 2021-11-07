# SPDX-FileCopyrightText: 2021 Michael Weimann <mail@michael-weimann.eu>
#
# SPDX-License-Identifier: MIT

test:
	nvim --headless --noplugin -u scripts/minimal_init.vim -c "PlenaryBustedDirectory tests/specs/ { minimal_init = './scripts/minimal_init.vim' }"
