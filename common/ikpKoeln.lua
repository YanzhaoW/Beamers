M = {}

M.author_names = {}
M.main_author_name = ""
M.affiliations = {}
M.title = ""
M.title_short = ""

M.add_author_name = function(input)
    table.insert(M.author_names,
        {
            is_stared = input.is_stared,
            full_name = input.first_name .. " " .. input.family_name,
            affiliation_number =
                input.affiliation_number
        })
    if input.is_stared == "*" then
        M.main_author_name = input.first_name .. " " .. input.family_name
    end
end

M.add_affiliation = function(input)
    table.insert(M.affiliations, input)
end

M.get_title = function()
    return string.format([[\title[%s]{%s}]], M.title_short, M.title)
end

M.get_names = function()
    local name_strings = {}
    for _, author_name in ipairs(M.author_names) do
        local name_string = author_name.full_name .. [[\inst{]] .. author_name.affiliation_number .. [[}]]
        table.insert(name_strings, name_string)
    end
    local full_string = [[{ ]] .. table.concat(name_strings, ", ") .. [[ }]]
    full_string = [[\author[ ]] .. M.main_author_name .. [[ ] ]] .. full_string
    return full_string
end

M.get_affiliations = function()
    local strings = {}
    for _, affiliation in ipairs(M.affiliations) do
        table.insert(strings, [[ \inst{ ]] .. affiliation.id .. [[ } ]] .. affiliation.affiliation)
    end
    local full_string = [[{ ]] .. table.concat(strings, [[\\]]) .. [[ }]]
    full_string = [[\institute[University of Cologne $\vert$ AG Zilges $\vert$ ] ]] .. full_string
    return full_string
end

return M
