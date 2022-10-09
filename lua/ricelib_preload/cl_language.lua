function RL.Language.Define(id,word)
    RL.Language.Words[id] = word
end

function RL.Language.Get(id) return RL.Language.Words[id] or language.GetPhrase(id) or id end