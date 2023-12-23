RiceLib.math = RiceLib.math or {}

function RiceLib.math.CubicSmooth5(input, store)
    store = store or {}
    table.insert(store, input)

    if #store > 5 then
        output = (-3 * store[1] + 12 * store[2] + 17 * store[3] + 12 * store[4] - 3 * store[5]) / 35
        table.remove(store, 1)
    else
        return store[#store]
    end

    return output
end

function RiceLib.math.CubicSmooth7(input, store)
    store = store or {}
    table.insert(store, input)

    if #store > 7 then
        output = (-2 * store[1] + 3 * store[2] + 6 * store[3] + 7 * store[4] + 6 * store[5] + 3 * store[6] - 2 * store[7]) / 21
        table.remove(store, 1)
    else
        return store[#store]
    end

    return output
end

function RiceLib.math.Sin(speed)
    speed = speed or 6

    return math.abs(math.sin(SysTime() * speed % 360))
end

function RiceLib.math.Cos(speed)
    speed = speed or 6

    return math.abs(math.cos(SysTime() * speed % 360))
end