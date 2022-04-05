--[[
    OptionsWindow Functions
]]

function WindowDeleted()

    if optionsWindow ~= nil then
        optionsWindow:WindowAdded()
        optionsWindow:WindowSelectionChanged()
    end

end

function CollectionChanged()

    if optionsWindow ~= nil then

        optionsWindow:CollectionChanged()

    end

end

function GroupDeleted(index)
    if optionsWindow ~= nil then
        optionsWindow:WindowAdded()
        optionsWindow:WindowSelectionChanged()
    end
end

function TimerDeleted()
    if optionsWindow ~= nil then
        optionsWindow:TimerDeleted()
    end
end


function OptionsWindowChanged()

    if optionsWindow == nil then
        optionsWindow = MainWindow()
        optionsdata.options_window.open = true
    else
        optionsWindow:Close()
        optionsWindow = nil
        optionsdata.options_window.open = false
    end

    SaveOptions()

end

function OptionsWindowTimerEditClose()

    if optionsWindow ~= nil then
        optionsWindow:OptionsWindowTimerEditClose()
    end

end

function OptionsWindowCloseFix()

    optionsWindow = nil
    optionsdata.options_window.open = false

end


function WindowSelectionChanged()

    if optionsWindow ~= nil then
        optionsWindow:WindowSelectionChanged()
    end

end

function GroupLoadStatusChanged(index)

    if optionsWindow ~= nil then
        optionsWindow:GroupLoadStatusChanged(index)
    end

end


function WindowAdded(index)

    if optionsWindow ~= nil then
        optionsWindow:WindowAdded(index)
    end

end

function GroupAdded(index)

    if optionsWindow ~= nil then
        optionsWindow:GroupAdded(index)
    end

end

function GroupEdited(index)

    if optionsWindow ~= nil then
        optionsWindow:GroupEdited(index)
    end

end

function GroupSetupChanged()

    if optionsWindow ~= nil then
        optionsWindow:GroupSetupChanged()
    end

end

function OpenTimerEdit(window_index ,timer_type, timer_index)

    if optionsWindow == nil or
       savedata[window_index] == nil or
       savedata[window_index][timer_type][timer_index] == nil then

        return

    end

    optionsWindow:OpenTimerEdit(window_index, timer_type, timer_index)


end