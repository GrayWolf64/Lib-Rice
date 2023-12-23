# 迎来了很新的大变

更新依赖此插件的项目的指南：

1. 使用 `RiceLib.Warn()` 而不是 `RiceLib.Message_Warn()`
   使用 `RiceLib.Error()` 而不是 `RiceLib.Message_Error()`
   使用 `RiceLib.Info()` 而不是 `RiceLib.Message()`
2. `sh_playerrecord.lua`相关功能已被删除，已有现存替代
3. `RiceLib.Files.Iterator_Dir` 已更为 `RiceLib.IO.DirIterator`

   `RiceLib.Files` 内容已并入 `RiceLib.IO`

   `RiceLib.IO.LoadFiles` 已更为 `RiceLib.Util.LoadFiles`

   `RiceLib.IO.LoadFilesRaw` 已更为 `RiceLib.Util.LoadFilesRaw`

   `RiceLib.IO` 已更为 `RiceLib.FS`
4. `RiceLib.VGUI.HDiv`，
   `RiceLib.VGUI.VDiv`，
   `RiceLib.VGUI.Layout`，
   `RiceLib.VGUI.DockLayout`，
   `RiceLib.VGUI.ModernLabelEditable`，
   `RiceLib.VGUI.ModernButton`，
   `RiceLib.VGUI.ModernImageButton`，
   `RiceLib.VGUI.ModernTextEntry`，
   `RiceLib.VGUI.ModernCheckBox`，
   `RiceLib.VGUI.ModernComboBox`，
   `RiceLib.VGUI.ModernNumberWang`
   等函数已被删除

   `RiceLib.VGUI.ModernLabel` 已更为本地函数

   `RL_Slider` 元素已被删除
5. `RiceUI.Smooth_CreateController` 已更为 `RiceUI.SmoothController`
6. `RiceLib.Vector.RoundVector` 已更为 `RiceLib.Util.RoundVector`
