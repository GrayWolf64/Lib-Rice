local test_str = "Innovation in China 中国智造，慧及全球 0123456789"

concommand.Add("ricelib_font_viewer",function(_, _, args)
    local fontName = args[1]
    local labels = {}

    for i = 8, 100 do
        table.insert(labels, {type = "label",
            Dock = TOP,

            Text = string.format("%s %s", i * 2, test_str),
            Font = string.format("%s_%s", fontName, i * 2)
        })
    end

    RiceUI.SimpleCreate({type = "rl_frame2",
        Center = true,
        Root = true,

        Title = "Font Viewer",

        w = 1800,
        h = 900,

        children = {
            {type = "scrollpanel",
                ID = "ScrollPanel",

                Dock = FILL,

                children = labels
            }
        }
    })
end)