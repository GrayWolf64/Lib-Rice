local Element = {}
Element.Editor = {Category = "interact"}
function Element.Create(data,parent)
    RiceLib.table.Inherit(data,{
        x = 16,
        y = 16,
        size = 16
    })

    local panel = RiceUI.SimpleCreate({type = "rl_button",
        ProcessID = "RadioButton",

        x = x,
        y = y,

        w = size,
        h = size,
    }, parent)

    RiceUI.MergeData(panel, RiceUI.ProcessData(data))

    return panel
end

return Element