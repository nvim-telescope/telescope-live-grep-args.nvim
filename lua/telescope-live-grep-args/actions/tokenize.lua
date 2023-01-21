local action_state = require("telescope.actions.state")

local default_opts = {
	quote_char = '"',
	postfix = " ",
	trim = true,
}


return function(opts)
	opts = opts or {}
	opts = vim.tbl_extend("force", default_opts, opts)

	return function(prompt_bufnr)

		local wrap, yield = coroutine.wrap, coroutine.yield

		local function permgen(a, n)
				n = n or #a
				if n <= 1 then
						yield(a)
				else
						for i = 1, n do
								-- put i-th element as the last one
								a[n], a[i] = a[i], a[n]
								-- generate all permutations of the other elements
								permgen(a, n - 1)
								-- restore i-th element
								a[n], a[i] = a[i], a[n]
						end
				end
		end

		function permutations(a)
				-- call with coroutine.wrap()
				return wrap(function() permgen(a) end)
		end

		local picker = action_state.get_current_picker(prompt_bufnr)
		local prompt = picker:_get_prompt()
		if opts.trim then
			prompt = vim.trim(prompt)
		end
		local tokens = {}
		-- TODO interpret two spaces or more as a literal space
		for token in prompt:gmatch("%S+") do
			table.insert(tokens, token)
		end

		prompt = ""
		-- TODO Remove duplicate permutations
		-- a a b → a.*b.*a|b.*a.*a|b.*a.*a|a.*b.*a|a.*a.*b|a.*b.*a it should be:
		-- a a b → a.*b.*a|b.*a.*a|a.*a.*b
		for combo in permutations(tokens) do
			prompt = prompt .. "|" .. table.concat(combo, '.*')
		end
		prompt = prompt:sub(2)

		picker:set_prompt(prompt)
	end
end
