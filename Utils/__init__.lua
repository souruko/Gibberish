import "Souru.Gibberish.Utils.Localisation"

if G.language == 1 then
    import "Souru.Gibberish.Utils.CombatChatParseEN"
elseif G.language == 2 then
    import "Souru.Gibberish.Utils.CombatChatParseDE"
elseif G.language == 3 then
    import "Souru.Gibberish.Utils.CombatChatParseFR"
else
    Turbine.Shell.WriteLine("ERROR: Client G.language not found!")
end

import "Souru.Gibberish.Utils.Format"
import "Souru.Gibberish.Utils.ChatCommand"

Thurallor = {}

import ("Souru.Gibberish.Utils.Common.UI.ColorPicker")

