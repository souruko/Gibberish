
-- Add a new window 
function AddGroup(name, color)

    local index = table.getn(savedata.groups) + 1

    savedata.groups[index] = {}

    savedata.groups[index].name = name
    savedata.groups[index].load = false
    savedata.groups[index].color = color
    savedata.groups[index].collapse = false
    savedata.groups[index].id = savedata.next_group_id

    savedata.next_group_id = savedata.next_group_id + 1

    SaveWindowData()

    return index

end

-- delete group with index
function DeleteGroup(index)

    local max_index = table.getn(savedata.groups)
    local id = savedata.groups[index].id

    local delete_list = {}
    for i, data in ipairs(savedata) do

        if data.group == id then
            delete_list[table.getn(delete_list) + 1] = i
        end

    end

    for i=table.getn(delete_list), 1, -1 do

        DeleteWindow(delete_list[i])

    end


    savedata.groups[index] = savedata.groups[max_index]
    savedata.groups[max_index] = nil

    SaveWindowData()

end

-- move all windows that are part of the group
function MoveWindowsWithGroup(id, x_offset, y_offset)

    for index, data in ipairs(savedata) do

        if data.group == id then

            local left, top = Utils.ScreenRatioToPixel(data.left, data.top)
            data.left, data.top = Utils.PixelToScreenRatio(left + x_offset, top + y_offset)

        end

    end

end


--calculates and returns left,top,width,height so every window is within groups boundrey
function GetSizeAndPositionForGroup(index)

    local left = SCREEN_WIDTH
    local top = SCREEN_HEIGHT

    local bottom = 0
    local right = 0

    local right_width = 0
    local bottom_height = 0

    local id = savedata.groups[index].id

    for window_index, data in ipairs(savedata) do

        if data.group == id then

            local width
            local height

            if data.orientation == true then
                width = data.width
                height = data.height

                if data.type < 3 then
                    width = width + data.height
                end
            else
                width = data.height
                height = data.width

                if data.type < 3 then
                    height = height + data.height
                end
            end

            local l, t = Utils.ScreenRatioToPixel(data.left, data.top)

            if l < left then
                left = l
            end

            if t < top then
                top = t
            end

            local right_value = l + width
            if right_value > right then
                right = right_value
            end

            local bottom_value = t + height
            if bottom_value > bottom then
                bottom = bottom_value
            end

        end

    end

    left = left - 10
    top = top - 20
    right = right + 10
    bottom = bottom + 10

    local width = right - left
    local height = bottom - top

    return left, top, width, height

end



--checks if any window within the group is loaded and sets group.load to that value
function UpdateGroupLoadStatus(id)

    local index = GetGroupIndexFromId(id) 

    if index == nil then
        return
    end

    local anythingLoaded = false

    for window_index, data in ipairs(savedata) do

        if data.group == id and data.load == true then
            anythingLoaded = true
            break
        end

    end

    local check = savedata.groups[index].load
    savedata.groups[index].load = anythingLoaded

    if check ~= anythingLoaded then
        Options.GroupLoadStatusChanged(index)
    end

end



--takes id and returns index for the same group
function GetGroupIndexFromId(id)

    for group_index, data in ipairs(savedata.groups) do

        if data.id == id then

            return group_index

        end

    end

    return nil

end