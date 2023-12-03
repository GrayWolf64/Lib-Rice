# 迎来了很新的大变

更新依赖此插件的项目的指南：

1. 使用 `RL.UpdateHUDOffset()` 而不是 `RL.Change_HUDOffset()`.
2. 使用 `RL.ClearHUDOffset()` 而不是 `RL.Clear_HUDOffset()`.
3. `RL.VGUI.OffsetButton()` 不再可用
4. `RL.Vector.ConvertString()` 不再可用，使用`Vector()`(官方字符串解析实现)
