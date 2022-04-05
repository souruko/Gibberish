
import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"

-- collection of global variables
import "Souru.Gibberish.Global"


-- importing libary with useful help functions
import "Souru.Gibberish.Utils"


-- importing libary with functions for handeling data
import "Souru.Gibberish.DataFunctions"



-- importing all window typ classes
import "Souru.Gibberish.Windows"


-- load all options items
import "Souru.Gibberish.Options"


-- starting up all the trigger tracking
import "Souru.Gibberish.Trigger"


-- get them juciy savefiles :3 and some saving stuff
import "Souru.Gibberish.Load_Save"





-- starting

-- effect tracking
Trigger.Effects.AddSelfEffectCallbacks()

if savedata.track_group_effects == true then
    Trigger.Effects.AddGroupEffectCallbacks()
end

if savedata.track_target_effects == true then
    Trigger.Effects.AddTargetEffectCallbacks()
end

-- skill tracking
Trigger.refreshAllSkillCallbacks()
