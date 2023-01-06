RL.IncludeDir("ricelib/")

if CLIENT then 
    RL.IncludeDirAs("ricelib_vgui","RiceLib VGUI")
    RL.IncludeDir("riceui",true,true)

else
    RL.AddCSFiles("ricelib_vgui","RiceLib VGUI")
    RL.AddCSFiles("riceui","RiceGUI")
end