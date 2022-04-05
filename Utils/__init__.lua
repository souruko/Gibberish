import "Gibberish.Utils.Localisation"

if G.language == 1 then
    import "Gibberish.Utils.CombatChatParseEN"
elseif G.language == 2 then
    import "Gibberish.Utils.CombatChatParseDE"
elseif G.language == 3 then
    import "Gibberish.Utils.CombatChatParseFR"
else
    Turbine.Shell.WriteLine("ERROR: Client G.language not found!")
end

import "Gibberish.Utils.Format"
import "Gibberish.Utils.ChatCommand"

Thurallor = {}

import ("Gibberish.Utils.Common.UI.ColorPicker")

