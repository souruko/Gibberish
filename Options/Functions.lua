--[[
    Options Functions
]]

function WindowDeleted(index)

    G.selected_index_window = nil
    optionsdata.selected_id_window = nil
    Move.WindowDeleted()
    OptionsWindow.WindowDeleted()
    Windows.WindowDeleted(index)

end

function GroupDeleted(index)

    G.selected_index_window = nil
    optionsdata.selected_id_window = nil
    OptionsWindow.GroupDeleted()
    Move.GroupDeleted()
    Windows.GroupDeleted()
end

function WindowAdded(index)

    Windows.Load(index)

    OptionsWindow.WindowAdded(index)

    WindowSelectionChanged(index)

end


function GroupAdded(index)

    OptionsWindow.GroupAdded(index)

    Move.GroupAdded(index)

end


function WindowSelectionChanged(index)

    if G.selected_index_window == index then
        return
    end


    if G.selected_index_window ~= nil then
        if windows[G.selected_index_window] ~= nil then
            windows[G.selected_index_window]:SelectionStatusChanged(false)
        end
    end

    G.selected_index_window = index
    optionsdata.selected_id_window = savedata[index].id

    if G.selected_index_window ~= nil then
        if windows[G.selected_index_window] ~= nil then
            windows[G.selected_index_window]:SelectionStatusChanged(true)
        end
    end

    OptionsWindow.WindowSelectionChanged()

    Move.WindowSelectionChanged()

    SaveOptions()

end

function WindowSelectionMoved()

    Move.WindowSelectionMoved()

end

function GroupLoadStatusChanged(index)

    --Move.GroupLoadStatusChanged(index)

    OptionsWindow.GroupLoadStatusChanged(index)

end

function AutoReloadChanged(bool)

    savedata.automatic_reload = bool

    menuicon:AutoReloadChanged()

    SaveWindowData()

end

function TrackGroupChanged(bool)

    Trigger.Effects.TrackGroupChanged(bool)

    if menuicon ~= nil then
        menuicon:SetIconFromTrackInformation()
    end

end


function TrackTargetChanged(bool)

    Trigger.Effects.TrackTargetChanged(bool)

    if menuicon ~= nil then
        menuicon:SetIconFromTrackInformation()
    end

end



function GroupEdited(index)

    OptionsWindow.GroupEdited(index)

    Move.GroupEdited(index)

end

function GroupSetupChanged()

    OptionsWindow.GroupSetupChanged()

    Move.GroupSetupChanged()

end

