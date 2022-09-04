RL.IncludeDir("ricelib/")

if CLIENT then 
    RL.IncludeDirAs("ricelib_vgui","RiceLib VGUI")
else
    RL.AddCSFiles("ricelib_vgui","RiceLib VGUI")
end