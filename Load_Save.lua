---------------------------------------------------------------------------------------------------------
--Reload

--this is just to unload the reloader plugin if it is loaded on load up
local status  = 0
close_reload_plugin = Turbine.UI.Control()
 
function close_reload_plugin:Update()
	if status == 1 then
        Turbine.PluginManager.UnloadScriptState( "GibberishReloader" )
    elseif status > 1 then
        self:SetWantsUpdates( false )
        
        close_reload_plugin = nil
	end

    status = status + 1
end

close_reload_plugin:SetWantsUpdates( true )


--saving all chat running chat timers to start them up again after reload
function SaveChatTimer()

    local list = {}

    for index, window_data in ipairs(savedata) do

        if window_data.load == true and windows[index] ~= nil then

            local temp = windows[index]:GetChatTimerList()

            if #temp > 0 then
                list[#list + 1] = temp
            end

        end

    end

    if G.language == LANGUAGE.English then
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_chat_timer_" .. LANGUAGE[G.language], list)
    else
        local converted = convertToEuro(list)
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_chat_timer_" .. LANGUAGE[G.language], converted)
    end

end

function Turbine.Plugin.Unload()
    SaveChatTimer()
end


--this will load the reload plugin as you cant reload a plugin from within
function Reload()

    Turbine.PluginManager.LoadPlugin( "GibberishReloader" )

end

-- fix for german/french client
function convertToEuro(dataRaw)
	local newData = {};
	for i, myData in pairs(dataRaw) do
		local tempIndex = nil;
		local tempData = nil;
		if (type(i) == "number") then
			tempIndex = tostring(i);
		else
			tempIndex = i;
		end
		if (type(myData) == "table") then
			tempData = convertToEuro(myData);
		elseif (type(myData) == "number") then
			tempData = tostring(myData);
		else
			tempData = myData;
		end
		newData[tempIndex] = tempData;
	end
	return newData;
end

function convertFromEuro(dataRaw)
	local newData = {}
	for i, myData in pairs(dataRaw) do
		local tempIndex = tonumber(i);
		if (tempIndex == nil) then
			tempIndex = i;
		end
		local tempData = nil;

		if (type(myData) == "table") then
			tempData = convertFromEuro(myData);
		else
			tempData = tonumber(myData);
			if (tempData == nil) then
				tempData = myData;
			end
		end
		newData[tempIndex] = tempData;
	end
	return newData;
	
end


---------------------------------------------------------------------------------------------------------
--SAVE

--[[ gibberish_global_options_

*   options window positions and size
*   options window loadstatus
*   selected window
*   default visuals

]]
function SaveOptions()

    if G.language == LANGUAGE.English then
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_options_" .. LANGUAGE[G.language], optionsdata)
    else
        local converted = convertToEuro(optionsdata)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_options_" .. LANGUAGE[G.language], converted)
    end

end

--[[ gibberish_collection_

*   permanent collection of effects and chat lines

]]
function SaveLibrary()

    if G.language == LANGUAGE.English then
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_collection_" .. LANGUAGE[G.language], collectiondata)
    else
        local converted = convertToEuro(collectiondata)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_collection_" .. LANGUAGE[G.language], converted)
    end

end

--[[ gibberish_global_backup_ // gibberish2x_char_file_

*   window and group information
*   load status
*   next_window_id
*   next_group_id
*   track_group_effects
*   track_target_effects
*   automatic_reload

]]
function SaveWindowData()

    if G.language == LANGUAGE.English then
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish2x_char_file_" .. LANGUAGE[G.language], savedata)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_backup_" .. LANGUAGE[G.language], savedata)
    else
        local converted = convertToEuro(savedata)
        Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish2x_char_file_" .. LANGUAGE[G.language], converted)
        Turbine.PluginData.Save(Turbine.DataScope.Account, "gibberish_global_backup_" .. LANGUAGE[G.language], converted)
    end

end


---------------------------------------------------------------------------------------------------------
--LOAD

-- loading permanent collection
if Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_collection_" .. LANGUAGE[G.language]) ~= nil then

    collectiondata = Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_collection_" .. LANGUAGE[G.language])
    if G.language ~= LANGUAGE.English then
        collectiondata = convertFromEuro(collectiondata)
    end

else

    collectiondata.effects = {}
    collectiondata.chat = {}

end




-- return index for id from datatable
function CheckForIDInData(id, data)

    for i, value in ipairs(data) do

        if value.id == id then
            return i
        end

    end

    return nil

end


-- load window- and groupinformation
if Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_global_backup_" .. LANGUAGE[G.language]) ~= nil then

    savedata = Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_global_backup_" .. LANGUAGE[G.language])
    if G.language ~= LANGUAGE.English then
        savedata = convertFromEuro(savedata);
    end

    if Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish2x_char_file_" .. LANGUAGE[G.language]) ~= nil then

        local chardata = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish2x_char_file_" .. LANGUAGE[G.language])
        if G.language ~= LANGUAGE.English then
            chardata = convertFromEuro(chardata);
        end

        --fix tracking
        savedata.track_group_effects = chardata.track_group_effects
        savedata.track_target_effects = chardata.track_target_effects

        --fix groups
        for i, group_data in ipairs(savedata.groups) do

            local index = CheckForIDInData(group_data.id, chardata.groups)

            if index ~= nil then

                group_data.load = chardata.groups[index].load
                group_data.collapse = chardata.groups[index].collapse

            else

                group_data.load = false
                group_data.collapse = true

            end

        end

        --fix windowdata
        for i, window_data in ipairs(savedata) do

            local index = CheckForIDInData(window_data.id, chardata)

            if index ~= nil then

                window_data.load = chardata[index].load

                if not(window_data.global_position) then
                    window_data.left = chardata[index].left
                    window_data.top = chardata[index].top
                end

                

            else

                window_data.load = false

            end

        end

    else

        for i, window_data in ipairs(savedata) do

            window_data.load = false

        end

        for i, group_data in ipairs(savedata.groups) do

            group_data.load = false

        end

    end

else 

    savedata.next_window_id = 1
    savedata.next_group_id = 1
    savedata.track_group_effects = true
    savedata.track_target_effects = false
    savedata.automatic_reload = false
    
end


-- load options settings
if Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_global_options_" .. LANGUAGE[G.language]) ~= nil then


    optionsdata = Turbine.PluginData.Load(Turbine.DataScope.Account, "gibberish_global_options_" .. LANGUAGE[G.language])
    if G.language ~= LANGUAGE.English then
        optionsdata = convertFromEuro(optionsdata)
    end

    --fix new window default
    if optionsdata.default_visual[WINDOW_TYPE.Count_Down] == nil then
        DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Count_Down)
    end

    --fix new window default
    if optionsdata.default_visual[WINDOW_TYPE.Bar_Circel] == nil then
        DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Bar_Circel)
    end

else

    optionsdata.default_visual = {}

    optionsdata.menuicon.left = 200
    optionsdata.menuicon.top = 200
    optionsdata.menuicon.moveing = true

    optionsdata.move.show_groups = true
    optionsdata.move.show_grid = true

    optionsdata.options_window.left = 800
    optionsdata.options_window.top = 500
    optionsdata.options_window.width = OPTIONS_MAINWINDOW_WIDTH
    optionsdata.options_window.height = OPTIONS_MAINWINDOW_HEIGHT
    optionsdata.options_window.show_tooltips = true

    optionsdata.timer_edit.left = 800
    optionsdata.timer_edit.top = 500
    optionsdata.timer_edit.width = 640
    optionsdata.timer_edit.height = OPTIONS_TIMEREDIT_HEIGHT
    optionsdata.timer_edit.window_index = nil
    optionsdata.timer_edit.timer_type = nil
    optionsdata.timer_edit.timer_index = nil

    optionsdata.collection.left = 800
    optionsdata.collection.top = 500
    optionsdata.collection.width = 660
    optionsdata.collection.height = 420

    optionsdata.import.left = 800
    optionsdata.import.top = 500
    optionsdata.import.width = 300
    optionsdata.import.height = 600

    optionsdata.moving = false
    optionsdata.movingGroup = nil
    optionsdata.movingWindow = nil

    optionsdata.selected_id_window = nil
    optionsdata.selected_index_timer = nil 

    optionsdata.move.open = false
    optionsdata.options_window.open = false
    optionsdata.timer_edit.open = false
    optionsdata.collection.open = false
    optionsdata.import.open = false



    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Bar_ListBox)
    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Bar_Window)
    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Icon_ListBox)
    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Icon_Window)
    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Count_Down)
    DataFunctions.ResetDefaultVisual(WINDOW_TYPE.Bar_Circel)

end




-- find index to selected id
if optionsdata.selected_id_window ~= nil then

    for i,data in ipairs(savedata) do
        if optionsdata.selected_id_window == data.id then
            G.selected_index_window = i
            break
        end
    end

    if G.selected_index_window == nil then
        optionsdata.selected_id_window = nil
    end

end

Windows.LoadAll()

-- open windows if optionsdata says so
if optionsdata.options_window.open == true then
    Options.OptionsWindow.OptionsWindowChanged()
end

if optionsdata.move.open == true then
    Options.Move.MoveChanged(true, optionsdata.movingGroup, optionsdata.movingWindow)
end

if optionsdata.import.open == true then
    Options.Import.WindowStateChanged(true)
    Options.Import.Import()
end

if optionsdata.collection.open == true then
    Options.Collection.CollectionStateChanged()
end

if optionsdata.timer_edit.open == true then
    Options.OptionsWindow.OpenTimerEdit(optionsdata.timer_edit.window_index, optionsdata.timer_edit.timer_type, optionsdata.timer_edit.timer_index)
end

-- create menu icon
menuicon = Options.MenuIcon.Window()


-- load saved chat timers and check if they are still runing
if Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_chat_timer_" .. LANGUAGE[G.language]) ~= nil then

    local list = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_chat_timer_" .. LANGUAGE[G.language])
    if G.language ~= LANGUAGE.English then
        list = convertFromEuro(list)
    end

    for i, window_data in ipairs(list) do

        for j, timer_data in ipairs(window_data) do

            if timer_data ~= nil and timer_data.data ~= nil then

                if timer_data.data.loop == true then

                    local time_past = Turbine.Engine.GetGameTime() - timer_data.start_time
                    local time_left = math.fmod(time_past, timer_data.duration)
                    local new_start_time = Turbine.Engine.GetGameTime() - time_left

                    if windows[timer_data.parent] ~= nil then

                        windows[timer_data.parent]:Add(timer_data.token, timer_data.key, new_start_time, timer_data.duration, timer_data.icon, timer_data.text, timer_data.data)
                    
                    end

                elseif (timer_data.start_time + timer_data.duration) > Turbine.Engine.GetGameTime() then

                    if windows[timer_data.parent] ~= nil then

                        windows[timer_data.parent]:Add(timer_data.token, timer_data.key, timer_data.start_time, timer_data.duration, timer_data.icon, timer_data.text, timer_data.data)

                    end

                end

            end

        end

    end

end