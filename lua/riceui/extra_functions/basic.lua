RiceUI.DefineExtraFunction("RiceUI_GetRoot", function(self)
    return RL.VGUI.GetRoot(self)
end)

RiceUI.DefineExtraFunction("GetElementValue", function(self, element)
    return self.RiceUI_Elements[element]:GetValue()
end)

RiceUI.DefineExtraFunction("GetElement", function(self, element)
    return self.RiceUI_Elements[element]
end)