local tbl = {}

tbl.Color = {
    white = Color(255, 255, 255, 50),
    black = Color(0, 0, 0, 60),
}

tbl.BackgroundColor = {
    white = Color(255, 255, 255, 25),
    black = Color(0, 0, 0, 150),
}

tbl.NonContentTextColor = {
    white = HSLToColor(0, 0, 0.2),
    black = HSLToColor(0, 0, 1),
}

tbl.TextColor = {
    white = Color(255, 255, 255, 255),
    black = Color(255, 255, 255, 255),
}

tbl.VBarColor = {
    white = Color(255, 255, 255, 50),
    black = Color(0, 0, 0, 50),
}

tbl.BarColor = {
    white = Color(255, 255, 255),
    black = Color(50, 50, 50),
}

tbl.FocusColor = {
    white = Color(150, 200, 255),
    black = Color(150, 200, 255),
}

tbl.DisableColor = {
    white = Color(50, 50, 50, 150),
    black = Color(255, 255, 255, 100),
}

tbl.HoverColor = {
    white = ColorAlpha(HSLToColor(0, 0, 1), 50),
    black = ColorAlpha(HSLToColor(0, 0, 1), 15),
    closeButton = Color(255, 75, 75)
}

tbl.ShadowAlpha = {
    white = 50,
    black = 50,
}

--[[

    Drawing Functions

]]--

local point = Material("gui/point.png")
local cross = Material("rl_icons/xmark.png")
local zoom = Material("icon16/zoom.png")

function tbl.DrawBox(pnl, w, h, color)
    if pnl.Theme.Blur then
        RL.VGUI.blurPanel(pnl, pnl.Theme.Blur)
    end

    if pnl.Theme.Shadow then
        if isbool(pnl.Theme.Shadow) then
            RiceUI.Render.DrawShadow(tbl, pnl)
        else
            RiceUI.Render.DrawShadowEx(RiceUI.GetShadowAlpha(tbl, pnl), pnl, unpack(pnl.Theme.Shadow))
        end
    end

    surface.SetDrawColor(color or RiceUI.GetColor(tbl, pnl))
    surface.DrawRect(0, 0, w, h)
end

function tbl.DrawButton(pnl, w, h)
    tbl.DrawBox(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl)

    if pnl:HasFocus() then
        color = RiceUI.GetColor(tbl, pnl, "Focus")
    end

    local height = RL.hudOffsetY(3)

    surface.SetDrawColor(color)
    surface.DrawRect(0, h - height, w, height)

    if pnl:IsHovered() then
        surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Hover"))
        surface.DrawRect(0, 0, w, h)
    end
end

function tbl.DrawTextCursor(pnl, w, h, offset)
    offset = offset or RL.hudScaleY(2)

    if pnl:HasFocus() then
        surface.SetDrawColor(ColorAlpha(RiceUI.GetColorBase(tbl, pnl, "Text"), 255 * math.abs(math.sin(SysTime() * 6 % 360))))

        local len = 0
        for i = 1,pnl:GetCaretPos() do
            local w = RL.VGUI.TextWide(pnl:GetFont(), utf8.sub(pnl:GetText(),i,i))

            len = len + w
        end
        surface.DrawRect(RL.hudScaleX(10) + len, 4 - offset / 2, 1, h - 8 - offset)
    end
end

--[[

    Themes

]]
--
function tbl.Panel(pnl, w, h)
    tbl.DrawBox(pnl, w, h)
end

function tbl.RL_Frame(pnl, w, h)
    tbl.DrawBox(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Bar"))
    surface.DrawRect(0, 0, w, pnl.Title:GetTall() + 10)
end

function tbl.Raw(pnl, w, h)
    RL.VGUI.blurPanel(pnl, pnl.Theme.Blur)
end

function tbl.Button(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    local color = RiceUI.GetColorBase(tbl, pnl, "Text")

    if pnl:IsDown() then color = RiceUI.GetColorBase(tbl, pnl, "Focus") end

    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.TransButton(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")


    surface.SetDrawColor(ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20) / 3))
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "NonContentText"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_TextLeft(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    surface.SetDrawColor(ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20) / 3))
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, RiceUI.GetColorBase(tbl, pnl, "NonContentText"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.TransButton_F(pnl, w, h)
    local color = RiceUI.GetColor(tbl, pnl, "Hover", "closeButton")

    surface.SetDrawColor(ColorAlpha(color, RiceUI.HoverAlpha(pnl, 20) / 3))
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(pnl.Text, pnl:GetFont(), w / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "NonContentText"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function tbl.Entry(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    local height = RL.hudScaleY(2)

    if pnl:GetValue() == "" then
        draw.SimpleText(pnl:GetPlaceholderText(), pnl:GetFont(), 10, h / 2 - height, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(pnl:GetText(), pnl:GetFont(), 10, h / 2 - height, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    tbl.DrawTextCursor(pnl, w, h, height)
end

function tbl.Switch(pnl, w, h)
    surface.SetDrawColor(pnl:GetColor())
    surface.DrawRect(0, 0, w, h)
    local fraction = pnl.togglePos / (pnl:GetWide() / 2)
    surface.SetDrawColor(Color(250, 250, 250))
    surface.DrawRect(fraction * w + 3 - ((h / 1.5 + 6) * fraction), 3, h / 1.5, h - 6)
end

function tbl.Slider(pnl, w, h)
    local pos = w * pnl:GetSlideX()
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Focus"))
    surface.DrawRect(0, h / 3, pos, h / 3)
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Disable"))
    surface.DrawRect(pos, h / 3, w - pos, h / 3)
    DisableClipping(true)
    surface.SetDrawColor(250, 250, 250)
    surface.DrawRect(pos - h / 4, 0, h / 2, h)

    if pnl:GetDragging() then
        RiceUI.Render.ShadowText(tostring(pnl:GetValue()), "OPPOSans_" .. tostring(h), pos, -h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    DisableClipping(false)
end

function tbl.ScrollPanel_VBar(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "VBar"))
    surface.DrawRect(0, 0, w, h)
end

function tbl.ScrollPanel_VBar_Grip(pnl, w, h)
    surface.SetDrawColor(ColorAlpha(RiceUI.GetColor(tbl, pnl), 100))
    surface.DrawRect(0, 0, w, h)
end

function tbl.Form(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    local h = pnl.h
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.Spacer(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColor(tbl, pnl, "Outline"))
    surface.DrawRect(0, h / 2 - RL.hudOffsetY(1), w, RL.hudOffsetY(2))
end

function tbl.RL_Combo(pnl, w, h)
    tbl.DrawButton(pnl, w, h)

    if pnl.Value then
        draw.SimpleText(pnl.Value, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(pnl.Text, pnl:GetFont(), h / 2, h / 2, RiceUI.GetColorBase(tbl, pnl, "Disable"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    surface.DrawTexturedRectRotated(w - h / 2, h / 2, h / 3, h / 3, pnl.a_pointang)
end

function tbl.RL_Combo_Choice(pnl, w, h)
    local height = RL.hudOffsetY(3)

    if pnl:IsHovered() then
        surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Hover"))
        surface.DrawRect(0, 0, w, h)
    end

    local color = RiceUI.GetColorBase(tbl, pnl, "Text")
    local bar_color = RiceUI.GetColor(tbl, pnl)

    if pnl:IsDown() or pnl.Selected then
        color = RiceUI.GetColorBase(tbl, pnl, "Focus")
        bar_color = color
    end

    
    surface.SetDrawColor(bar_color)
    surface.DrawRect(RL.hudOffsetY(2), height, RL.hudOffsetY(2) + RL.hudOffsetY(1), h - height)

    RiceUI.Render.ShadowText(pnl.Text, pnl:GetFont(), RL.hudScaleX(10), h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function tbl.RL_NumberWang(pnl, w, h)
    tbl.DrawButton(pnl, w, h)
    draw.SimpleText(pnl:GetValue(), pnl:GetFont(), 10, h / 2, RiceUI.GetColorBase(tbl, pnl, "Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    tbl.DrawTextCursor(pnl, w, h)
end

function tbl.NumberWang_Button(pnl, w, h)
    surface.SetDrawColor(RiceUI.GetColorBase(tbl, pnl, "Text"))
    surface.SetMaterial(point)
    local size = h / 2 + RL.hudScaleY(pnl.Theme.Scale or 0)
    surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, pnl.Theme.Ang)
end

--[[
    
    Example

]]--

function tbl.OnLoaded()
    RiceUI.Examples.Glass = {
        {type = "rl_frame",
            Text = "Example",
            Center = true,
            Root = true,

            w = 1200,
            h = 800,

            UseNewTheme = true,
            Theme = {
                ThemeName = "glass",
                ThemeType = "RL_Frame",
                Color = "white",
                TextColor = "white",

                Blur = 5,
            },

            Alpha = 0,
            Anim = {
                {
                    type = "alpha",
                    time = 0.075,
                    alpha = 255
                }
            },
            children = {
                {type = "button",
                    x = 10,
                    y = 40,
                    w = 100,
                    h = 50
                },
                {type = "entry",
                    x = 10,
                    y = 100,
                    w = 300,
                    h = 30
                },
                {type = "switch",
                    x = 120,
                    y = 38,
                    w = 50,
                    h = 25
                },
                {type = "switch",
                    x = 120,
                    y = 67,
                    w = 50,
                    h = 25,
                    Value = true
                },
                {type = "image",
                    x = 320,
                    y = 40,
                    w = 90,
                    h = 90,
                    Image = "gui/dupe_bg.png"
                },
                {type = "web_image",
                    x = 420,
                    y = 40,
                    w = 90,
                    h = 90,
                    Image = "https://i.328888.xyz/2023/01/29/jM97x.jpeg"
                },
                {type = "rl_numberwang",
                    x = 10,
                    y = 140
                },
                {type = "rl_numberwang",
                    x = 140,
                    y = 140,
                    Step = 5
                },
                {type = "button",
                    ID = "btn_Anim_Expand",
                    Text = "Animation 1",
                    x = 10,
                    y = 180,
                    w = 200,
                    h = 50,
                },
                {type = "button",
                    ID = "btn_Menu",
                    Text = "Menu 1",
                    x = 10,
                    y = 240,
                    w = 200,
                    h = 50,
                    DoClick = function(self)
                        RiceUI.SimpleCreate({
                            type = "rl_menu"
                        })
                    end
                },
                {type = "rl_form",
                    Text = "Form",
                    x = 10,
                    y = 300,
                    children = {
                        {
                            type = "rl_button",
                            Dock = TOP
                        }
                    }
                },
                {type = "rl_panel",
                    ID = "Anim_Expand",
                    w = 0,
                    h = 0,
                    NoGTheme = true,
                    Theme = {
                        ThemeName = "modern",
                        ThemeType = "Panel",
                        Color = "black"
                    },
                },
                {type = "rl_colorbutton",
                    x = 10,
                    y = 405,
                },
                {type = "rl_frame",
                    x = 520,
                    y = 40,
                    w = 670,
                    Text = "Frame In Frame",

                    children = {
                        {type = "slider",
                            y = 40
                        },
                        {type = "rl_combo",
                            y = 80,
                            Choice = {
                                {"选项1"},
                                {"选项2"},
                                {"选项3"}
                            }
                        },
                        {type = "rl_button", x = 220, y = 80, h = 40,
                            Text = "Message",

                            DoClick = function() RunConsoleCommand("riceui_notify_message","Message") end
                        },

                        {type = "rl_button", x = 220, y = 130, h = 40,
                            Text = "Warning",

                            DoClick = function() RunConsoleCommand("riceui_notify_warn","WARNING!") end
                        },

                        {type = "rl_button", x = 220, y = 180, h = 40,
                            Text = "Error",

                            DoClick = function() RunConsoleCommand("riceui_notify_error","ERROR!") end
                        },
                    },
                },
            },
            RiceUI_Event = function(event, id, data)
                if id ~= "btn_Anim_Expand" then return end
                local frame = data:GetParent()

                RiceUI.Animation.ExpandFromPos(frame.Elements.Anim_Expand, {
                    StartX = gui.MouseX() - frame:GetX(),
                    StartY = gui.MouseY() - frame:GetY(),
                    EndX = 0,
                    EndY = 30,
                    SizeW = 1200,
                    SizeH = 770,
                    callback = function()
                        RiceUI.SimpleCreate({type = "rl_button",
                            Center = true,
                            DoClick = function()
                                RiceUI.Animation.Shrink(frame.Elements.Anim_Expand, {
                                    callback = function()
                                        frame.Elements.Anim_Expand:Clear()
                                    end
                                })
                            end
                        }, frame.Elements.Anim_Expand)
                    end
                })
            end
        }
    }

    RiceUI.Examples.GlassBlack = table.Copy(RiceUI.Examples.Glass)

    RiceUI.Examples.GlassBlack[1].Theme = {
        ThemeName = "glass",
        ThemeType = "RL_Frame",
        Color = "black",
        TextColor = "black",

        Blur = 5,
    }
end

return tbl