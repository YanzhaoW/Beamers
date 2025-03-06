-- converter data can be found here: https://abbrv.jabref.org/journals/

local M = {}

local function file_exists(filename)
	local file = io.open(filename, "rb")
	if file then
		file:close()
	end
	return file ~= nil
end

function M.convert(filename)
	if not file_exists(filename) then
		error(filename .. "doesn't exist!")
	end

	local output_str = [[

\DeclareSourcemap{
    \maps[datatype=bibtex,overwrite=true]{
        \map{
    ]]

	local map_str = ""
	for line in io.lines(filename) do
		local first, second = string.match(line, '^"(.*)","(.*)"')
        first = first:gsub("%&", "and")
		map_str = string.format(
			[[
\step[fieldsource=journal,
           match={%s},
           replace={%s}]
        ]],
			first,
			second
		)
		output_str = output_str .. map_str
	end
	output_str = output_str .. [[
    }
  }
}
    ]]
    print(output_str)
    return output_str
end

return M
