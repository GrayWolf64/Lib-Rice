if CLIENT then
    function RL.Language.Define(id,word)
        RL.Language.Words[id] = word
    end

    function RL.Language.Get(id) return RL.Language.Words[id] or language.GetPhrase(id) or id end

    local CUR_Lang = GetConVar("cl_language"):GetString()
    RL.Files.Iterator_Dir("rl_languages","LUA",function(dirs,dir,path)
        local languageDir = dir .. dirs .. "/" .. CUR_Lang

        RL.Files.Iterator(languageDir, "LUA", function(file,dir,path)
            table.Merge(RL.Language.Words, include(dir .."/" .. file))
        end)
    end)
else
    RL.AddCSFiles("rl_languages")
end