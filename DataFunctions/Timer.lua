-- base timer data
function GetBaseTimer()

    local data = {}

    data.token           = "<empty>"
    data.description     = ""
    data.custom_timer    = false
    data.timer           = 1
    data.icon            = nil
    data.id              = Turbine.Engine.GetGameTime()
    data.text            = ""
    data.text_modifier   = TEXTMODIFIER.Let_the_plugin_decide
    data.threshold       = 3
    data.use_threshold   = true
    data.flashing_multi  = 2
    data.flashing        = true
    data.flashing_animation = 1
    data.loop            = false
    data.reset           = false
    data.unique          = false
    data.removable       = true
	data.use_regex       = false
	data.hide_timer      = false
    data.counter_start   = nil
    data.increment       = false
    data.use_target_entity = false
    data.target_list = nil
    data.show_grey = false

    return data

end

-- create timer with trigger_type for window
function AddTimer(trigger_type, window_index)

    local index = table.getn(savedata[window_index][trigger_type]) + 1

    savedata[window_index][trigger_type][index] = GetBaseTimer()

    savedata[window_index][trigger_type][index].sort_index = savedata[window_index].next_index
    savedata[window_index].next_index = savedata[window_index].next_index + 1

    if trigger_type == TRIGGER_TYPE.Chat then
        savedata[window_index][trigger_type][index].use_regex = true
    end

    SaveWindowData()

    return index

end

-- delete timer
function DeleteTimer(trigger_type, window_index, timer_index)

    local max_index = table.getn(savedata[window_index][trigger_type])

    savedata[window_index][trigger_type][timer_index] = savedata[window_index][trigger_type][max_index]
    savedata[window_index][trigger_type][max_index] = nil

    SaveWindowData()

end
