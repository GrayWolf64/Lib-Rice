local Query = sql.Query
local QueryValue = sql.QueryValue

local function connnectQuerys(querys)
    if not querys then return "" end
    local output = ""

    for index, value in ipairs(querys) do
        output = Format("%s, %s", output, value)
    end

    return string.sub(output, 2)
end

local function connnectValues(values)
    if not values then return "" end
    local output = ""

    for index, value in ipairs(values) do
        if isnumber(value) then
            output = Format("%s, %s", output, value)
            continue
        end

        output = Format("%s, '%s'", output, value)
    end

    return string.sub(output, 3)
end

local function createTable(tableName, values)
    return Query(Format("CREATE TABLE IF NOT EXISTS %s (%s);", tableName, connnectQuerys(values)))
end

local function select(keys, tableName, condition)
    return Query(Format("SELECT %s FROM %s %s;", keys, tableName, condition))
end

local function selectValue(keys, tableName, condition)
    return QueryValue(Format("SELECT %s FROM %s %s;", keys, tableName, condition))
end

local function insert(tableName, keys, values)
    local query = Format("INSERT INTO %s VALUES(%s);", tableName, connnectValues(values))

    if keys then
        query = Format("INSERT INTO %s (%s) VALUES(%s);", tableName, connnectQuerys(keys), connnectValues(values))
    end

    return Query(query)
end

local function delete(tableName, condition)
    Query(Format("DELETE FROM %s %s", tableName, condition))
end

local function update(tableName, keys, value, condition)
    return Query(Format("UPDATE %s SET %s = %s %s", tableName, keys, value, condition))
end

RiceLib.SQL = {
    CreateTable = createTable,
    Select = select,
    SelectValue = selectValue,
    Insert = insert,
    Delete = delete,
    Update = update
}