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

		local function permutations(a)
			-- call with coroutine.wrap()
			return wrap(function()
				permgen(a)
			end)
		end

		local function removeDuplicates(tbl)
			local newTbl = {}
			local seen = {}
			for _, value in ipairs(tbl) do
				if not seen[value] then
					table.insert(newTbl, value)
					seen[value] = true
				end
			end
			return newTbl
		end

		local picker = action_state.get_current_picker(prompt_bufnr)
		local prompt = picker:_get_prompt()
		if opts.trim then
			prompt = vim.trim(prompt)
		end
		local tokens = {}

		-- Pretty sure nobody will use this as part of the prompt!
		local unique_string = "<!token_separator!>"
		prompt = prompt:gsub("%s%s+", unique_string)
		for token in prompt:gmatch("%S+") do
			token = token:gsub(unique_string, " ")
			table.insert(tokens, token)
		end

		prompt = ""
		for combo in permutations(removeDuplicates(tokens)) do
			prompt = prompt .. "|" .. table.concat(combo, ".*")
		end
		prompt = prompt:sub(2)

		picker:set_prompt(prompt)
	end
end
