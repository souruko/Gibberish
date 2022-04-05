
import "Turbine.Gameplay"
import "Turbine.UI"
import "Turbine.UI.Lotro"

-- collection of global variables
import "Gibberish.Global"


-- importing libary with useful help functions
import "Gibberish.Utils"


-- importing libary with functions for handeling data
import "Gibberish.DataFunctions"



-- importing all window typ classes
import "Gibberish.Windows"


-- load all options items
import "Gibberish.Options"


-- starting up all the trigger tracking
import "Gibberish.Trigger"


-- get them juciy savefiles :3 and some saving stuff
import "Gibberish.Load_Save"



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
