if CLIENT then
    function RL.Language.Define(id, word)
        RL.Language.Words[id] = word
    end

    function RL.Language.Get(id)
        return RL.Language.Words[id] or language.GetPhrase(id) or id
    end

    RL.Files.Iterator_Dir("rl_languages", "LUA", function(nameSpace, dir)
        local languageDir = dir .. nameSpace .. "/" .. GetConVar("cl_language"):GetString()

        if not file.Exists(languageDir, "LUA") then
            languageDir = dir .. nameSpace .. "/english"
        end

        RL.Files.Iterator(languageDir, "LUA", function(file, dir)
            table.Merge(RL.Language.Words, include(dir .. file))
        end)
    end)
else
    RL.AddCSFiles("rl_languages")
end