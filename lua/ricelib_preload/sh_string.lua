RiceLib.String = {}

local upper = string.upper
local lower = string.lower
local sub = string.sub
local replace = string.Replace

---Turn a string into CamelCase format
---@param input string
---@param separator? string
---@return string output
function RiceLib.String.CamelCase(input, separator)
    separator = separator or " "

    local words = string.Split(input, separator)
    local output = ""

    for _, word in ipairs(words) do
        output = output .. upper(sub(word, 1, 1)) .. sub(word, 2)
    end

    return output
end

---Turn a string into pascalCase format
---@param input string
---@param separator? string
---@return string output
function RiceLib.String.PascalCase(input, separator)
    separator = separator or " "

    local words = string.Split(input, separator)
    local output = ""

    local word = table.remove(words, 1)
    output = output .. lower(sub(word, 1, 1)) .. sub(word, 2)

    for _, word in ipairs(words) do
        output = output .. upper(sub(word, 1, 1)) .. sub(word, 2)
    end

    return output
end

---Turn a string into snake_case format
---@param input string
---@param separator? string
---@return string output
function RiceLib.String.SnakeCase(input, separator)
    separator = separator or " "

    return replace(lower(input), separator, "_")
end

---Turn a string into SCREAMING_SNAKE_CASE format
---@param input string
---@param separator? string
---@return string output
function RiceLib.String.ScreamingSnakeCase(input, separator)
    separator = separator or " "

    return replace(upper(input), separator, "_")
end