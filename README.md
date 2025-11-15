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
