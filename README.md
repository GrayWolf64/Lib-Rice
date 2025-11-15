# RiceLib

## Primary Goal

Try to make RiceLib an *Immediate Mode UI* library.

## Parts Removed

1. `RiceLib.PlayerRecord` and *all* its related SQL usage,
    please make it a separate extension.
2. `outline` module used to draw outline on an entity,
    please use its original author's addon or make it a separate extension.
3. `RiceLibClientReady` hook, please use it where it's
    actually needed. Don't just make others use your library
    when only a single hook is required from your library.
4. `RiceLib.SQL` and *all* its related SQL functions.
5. `RiceLib.VGUI.RegisterFontFixedAdv`,
    `RiceLib.VGUI.RegisterFont`,
    `RiceLib.VGUI.RegisterFontFixed`,
    `RiceLib.VGUI.RegisterFontAdv` and all old font related functions.
6. `RiceLib.String` and *all* its member functions.
7. `RiceLib.Util` and *all* its member functions.

## Subsystems Improved

...
