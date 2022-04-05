
function SkillTreeChanged()

    for index, window_data in ipairs(savedata) do

        if window_data.load == true and (window_data.type == WINDOW_TYPE.Bar_Window or window_data.type == WINDOW_TYPE.Icon_Window ) then

            windows[index]:Fill()

        end

    end

end

function GroupDeleted()
    LoadAll()
end

function WindowDeleted(index)

    if windows[index] ~= nil then

        Unload(index)
        
    end

    local olb_max_index = table.getn(savedata) + 1
    if windows[olb_max_index] ~= nil then
        windows[index] = windows[olb_max_index]
    end

end

function WindowsWithGroupMoved(id)

    for index, window_data in ipairs(savedata) do

        if window_data.load == true and window_data.group == id then

            windows[index]:DataChanged()

        end

    end

end

function WindowDataChanged(index)

    if windows[index] ~= nil then

        windows[index]:DataChanged()
    
    end


end

function Load(index)

    if windows[index] == nil then

        if savedata[index].type == WINDOW_TYPE.Bar_ListBox then

            windows[index] = Bar_ListBox.Window(index)
        
        elseif savedata[index].type == WINDOW_TYPE.Bar_Window then

            windows[index] = Bar_Window.Window(index)

        elseif savedata[index].type == WINDOW_TYPE.Icon_ListBox then

            windows[index] = Icon_ListBox.Window(index)

        elseif savedata[index].type == WINDOW_TYPE.Icon_Window then

            windows[index] = Icon_Window.Window(index)

        elseif savedata[index].type == WINDOW_TYPE.Count_Down then

            windows[index] = Count_Down.Window(index)

        else
            Turbine.Shell.WriteLine("Window-Type ERORR!")
        end

    end

end

function LoadChanged(index)

    if savedata[index].load == true then
        Load(index)
    else
        Unload(index)
    end

end

function LoadAll()

    UnloadAll()

    for index, window_data in ipairs(savedata) do

        if window_data.load == true then
            
            Load(index)

        end

    end

end


function Unload(index)

    if windows[index] ~= nil then
        windows[index]:Close()
        windows[index] = nil
    end

end

function Reload(index)

    if windows[index] ~= nil then

        Unload(index)

    end

    Load(index)

    if optionsdata.moving == true then

        if optionsdata.movingGroup ~= nil then
            if savedata[index].group == optionsdata.movingGroup then
                windows[index]:MoveChanged(true)
            end

        elseif optionsdata.movingWindow ~= nil then
            if index == optionsdata.movingWindow then
                windows[index]:MoveChanged(true)
            end

        else

            windows[index]:MoveChanged(true)

        end

    end

end

function UnloadAll()

    for index, window_data in ipairs(savedata) do

        if windows[index] ~= nil then
            Unload(index)
        end

    end

end

function ResetAll()

    for index, window_data in ipairs(savedata) do

        if window_data.load == true then

            windows[index]:ResetAll()

        end

    end

end

function MoveChanged(bool, group_index, window_index)

    if group_index ~= nil then

        for index, window_data in ipairs(savedata) do

            if window_data.group == group_index then

                if window_data.load == true then

                    windows[index]:MoveChanged(bool)

                end

            end

        end

    elseif window_index ~= nil then

        if windows[window_index] ~= nil then

            windows[window_index]:MoveChanged(bool)

        end

    else

        for index, window_data in ipairs(savedata) do

            if window_data.load == true then

                windows[index]:MoveChanged(bool)

            end

        end

    end

end