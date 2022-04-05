import "Turbine"
import "Turbine.UI"

local check  = 0
control_check = Turbine.UI.Control()

function control_check:Update()
	if check == 50 then
		Turbine.PluginManager.UnloadScriptState( "Gibberish" )
	elseif check == 51 then
		Turbine.PluginManager.LoadPlugin( "Gibberish" )
	elseif check > 51 then
        self:SetWantsUpdates( false )

		control_check = nil
	end

	check = check + 1
end

control_check:SetWantsUpdates( true )