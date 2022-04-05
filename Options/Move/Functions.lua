--[[
    Move Functions
]]

function WindowDeleted()

    if moveWindow ~= nil then
        moveWindow:ShowGroupChanged()
        moveWindow:SelectionUpdate()
    end

end

function GroupDeleted(index)
    if moveWindow ~= nil then
        moveWindow:ShowGroupChanged()
        moveWindow:SelectionUpdate()
    end
end


-- function MoveChanged(bool)

--     optionsdata.moving = bool
--     if menuicon ~= nil then
--         menuicon.item_movewindows:SetChecked(optionsdata.moving)
--     end

--     if optionsdata.moving == true then

--         if moveWindow ~= nil then
--             return
--         end

--         moveWindow = MoveWindow()
--         optionsdata.move.open = true

--         Windows.MoveChanged()

--     else

--         if moveWindow == nil then
--             return
--         end

--         moveWindow:Close()
--         moveWindow = nil
--         optionsdata.move.open = false

--         Windows.MoveChanged()

--     end

--     SaveOptions()

-- end

function MoveChanged(bool, group_index, window_index)

    if bool == nil then
        bool = true
    end

    optionsdata.moving = bool
    optionsdata.movingGroup = group_index
    optionsdata.movingWindow = window_index
    if menuicon ~= nil then
        menuicon.item_movewindows:SetChecked(optionsdata.moving)
    end


    if optionsdata.moving == true then

        if moveWindow == nil then
            moveWindow = MoveWindow(group_index, window_index)
            optionsdata.move.open = true
        end

        Windows.MoveChanged(bool, group_index, window_index)

    else

        if moveWindow ~= nil then
            moveWindow:Close()
            moveWindow = nil
            optionsdata.move.open = false
        end

        Windows.MoveChanged(bool, group_index, window_index)

    end

    
    SaveOptions()

end

function WindowSelectionChanged()

    if moveWindow ~= nil then
        moveWindow:SelectionUpdate()
    end

end

function WindowSelectionMoved()

    if moveWindow ~= nil then
        moveWindow:SelectionUpdate()
    end

end

function GroupMoved(id, x_offset, y_offset)

    DataFunctions.MoveWindowsWithGroup(id, x_offset, y_offset)
    Windows.WindowsWithGroupMoved(id)
    
    if moveWindow ~= nil then
        moveWindow:GroupMoved(id)
    end

end

function GroupAdded(index)

    if moveWindow ~= nil then
        moveWindow:ShowGroupChanged()
    end

end

function UpdateGroups()

    if moveWindow ~= nil then
        moveWindow:ShowGroupChanged()
    end

end

function GroupEdited(index)

    if moveWindow ~= nil then
        moveWindow:GroupEdited(index)
    end

end

function GroupSetupChanged()

    if moveWindow ~= nil then
        moveWindow:ShowGroupChanged()
    end

end