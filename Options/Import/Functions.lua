--[[
    Import Functions
]]

function WindowStateChanged(bool)

    if bool == nil then
        if importWindow == nil then
            bool = true
        else
            bool = false
        end
    end

    if bool == true then
        if importWindow == nil then
            importWindow = Window()
            optionsdata.import.open = true
        end
    else
        if importWindow ~= nil then
            importWindow:Close()
            importWindow = nil
            optionsdata.import.open = false
        end
    end

    SaveOptions()
    
end


function ExportGroup(group_data)

    if importWindow ~= nil then
        importWindow:ExportGroup(group_data)
    end

end

function ExportWindow(window_data)

    if importWindow ~= nil then
        importWindow:ExportWindow(window_data)
    end

end


function ExportTimer(timer_data, timer_type)

    if importWindow ~= nil then
        importWindow:ExportTimer(timer_data, timer_type)
    end

end

function Import()

    if importWindow ~= nil then
        importWindow:Import()
    end

end