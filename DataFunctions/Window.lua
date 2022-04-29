-- Add a new window 
function AddWindow(name, type)

    local index = table.getn(savedata) + 1

    savedata[index] = {}
    savedata[index].name                        = name
    savedata[index].type                        = type
    savedata[index].id                          = savedata.next_window_id
    savedata[index].load                        = true
    savedata[index].group                       = nil
    savedata[index].width                       = optionsdata.default_visual[type].width
    savedata[index].height                      = optionsdata.default_visual[type].height
    savedata[index].left                        = optionsdata.default_visual[type].left
    savedata[index].top                         = optionsdata.default_visual[type].top
    savedata[index].frame                       = optionsdata.default_visual[type].frame
    savedata[index].spacing                     = optionsdata.default_visual[type].spacing
    savedata[index].number_format               = optionsdata.default_visual[type].number_format
    savedata[index].next_index                  = 1
    savedata[index].frame_color                 = {}
    savedata[index].frame_color.R               = optionsdata.default_visual[type].frame_color.R    
    savedata[index].frame_color.G               = optionsdata.default_visual[type].frame_color.G    
    savedata[index].frame_color.B               = optionsdata.default_visual[type].frame_color.B    
    savedata[index].back_color                  = {}
    savedata[index].back_color.R                = optionsdata.default_visual[type].back_color.R   
    savedata[index].back_color.G                = optionsdata.default_visual[type].back_color.G   
    savedata[index].back_color.B                = optionsdata.default_visual[type].back_color.B   
    savedata[index].bar_color                   = {}
    savedata[index].bar_color.R                 = optionsdata.default_visual[type].bar_color.R
    savedata[index].bar_color.G                 = optionsdata.default_visual[type].bar_color.G
    savedata[index].bar_color.B                 = optionsdata.default_visual[type].bar_color.B
	savedata[index].font_color_1                = {}
    savedata[index].font_color_1.R              = optionsdata.default_visual[type].font_color_1.R
    savedata[index].font_color_1.G              = optionsdata.default_visual[type].font_color_1.G
    savedata[index].font_color_1.B              = optionsdata.default_visual[type].font_color_1.B
	savedata[index].font_color_2                = {}
    savedata[index].font_color_2.R              = optionsdata.default_visual[type].font_color_2.R 
    savedata[index].font_color_2.G              = optionsdata.default_visual[type].font_color_2.G
    savedata[index].font_color_2.B              = optionsdata.default_visual[type].font_color_2.B 
    savedata[index].font                        = optionsdata.default_visual[type].font
    savedata[index].opacity                     = optionsdata.default_visual[type].opacity
    savedata[index].opacity2                    = optionsdata.default_visual[type].opacity2
    savedata[index].ascending                   = optionsdata.default_visual[type].ascending
    savedata[index].orientation                 = optionsdata.default_visual[type].orientation
    savedata[index].overlay                     = optionsdata.default_visual[type].overlay
    savedata[index].reset_on_target_change      = optionsdata.default_visual[type].reset_on_target_change
    
    savedata[index][TRIGGER_TYPE.Effect_Self]           = {}
    savedata[index][TRIGGER_TYPE.Effect_Group]           = {}
    savedata[index][TRIGGER_TYPE.Chat]                   = {}
    savedata[index][TRIGGER_TYPE.Skill]                  = {}
    savedata[index][TRIGGER_TYPE.Effect_Target]         = {}
    savedata[index][TRIGGER_TYPE.Timer_End]           = {}
    savedata[index][TRIGGER_TYPE.Timer_Start]         = {}
    savedata[index][TRIGGER_TYPE.Timer_Threshold]     = {}
    savedata[index].trigger_id                        = nil

    savedata.next_window_id = savedata.next_window_id + 1

    SaveWindowData()

    return index

end

-- delete window with index
function DeleteWindow(index)

    local max_index = table.getn(savedata)

    if savedata[index].group ~= nil then
        local id = savedata[index].group
        savedata[index].group = nil
        UpdateGroupLoadStatus(id)
    end

    savedata[index] = savedata[max_index]
    savedata[max_index] = nil

    SaveWindowData()

end

-- reset default visuals to "factory settings"
function ResetDefaultVisual(window_type)

    if window_type == WINDOW_TYPE.Bar_ListBox then

        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox]                         = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].width                   = 150
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].height                  = 20
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].left                    = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].top                     = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].frame                   = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].spacing                 = 2
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].number_format           = NUMBER_FORMAT.Minutes
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].frame_color             = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].frame_color.R           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].frame_color.G           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].frame_color.B           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].back_color              = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].back_color.R            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].back_color.G            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].back_color.B            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].bar_color               = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].bar_color.R             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].bar_color.G             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].bar_color.B             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_1            = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_1.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_1.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_1.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_2            = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_2.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_2.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font_color_2.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].font                    = 23
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].opacity                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].opacity2                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].ascending               = false
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].orientation             = true
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].overlay                 = false
        optionsdata.default_visual[WINDOW_TYPE.Bar_ListBox].reset_on_target_change  = false
    
    elseif window_type == WINDOW_TYPE.Bar_Window then

        optionsdata.default_visual[WINDOW_TYPE.Bar_Window]                         = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].width                   = 150
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].height                  = 20
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].left                    = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].top                     = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].frame                   = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].spacing                 = 2
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].number_format           = NUMBER_FORMAT.Minutes
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].frame_color             = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].frame_color.R           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].frame_color.G           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].frame_color.B           = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].back_color              = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].back_color.R            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].back_color.G            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].back_color.B            = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].bar_color               = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].bar_color.R             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].bar_color.G             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].bar_color.B             = 0
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_1            = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_1.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_1.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_1.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_2            = {}
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_2.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_2.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font_color_2.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].font                    = 23
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].opacity                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].opacity2                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].ascending               = false
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].orientation             = true
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].overlay                 = false
        optionsdata.default_visual[WINDOW_TYPE.Bar_Window].reset_on_target_change  = false

    elseif window_type == WINDOW_TYPE.Icon_ListBox then

        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox]                         = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].width                   = 32
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].height                  = 32
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].left                    = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].top                     = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].frame                   = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].spacing                 = 2
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].number_format           = NUMBER_FORMAT.Seconds
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].frame_color             = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].frame_color.R           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].frame_color.G           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].frame_color.B           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].back_color              = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].back_color.R            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].back_color.G            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].back_color.B            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].bar_color               = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].bar_color.R             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].bar_color.G             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].bar_color.B             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_1            = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_1.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_1.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_1.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_2            = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_2.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_2.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font_color_2.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].font                    = 23
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].opacity                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].opacity2                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].ascending               = false
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].orientation             = true
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].overlay                 = false
        optionsdata.default_visual[WINDOW_TYPE.Icon_ListBox].reset_on_target_change  = false

    elseif window_type == WINDOW_TYPE.Icon_Window then

        optionsdata.default_visual[WINDOW_TYPE.Icon_Window]                         = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].width                   = 32
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].height                  = 32
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].left                    = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].top                     = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].frame                   = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].spacing                 = 2
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].number_format           = NUMBER_FORMAT.Seconds
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].frame_color             = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].frame_color.R           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].frame_color.G           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].frame_color.B           = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].back_color              = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].back_color.R            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].back_color.G            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].back_color.B            = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].bar_color               = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].bar_color.R             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].bar_color.G             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].bar_color.B             = 0
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_1            = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_1.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_1.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_1.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_2            = {}
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_2.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_2.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font_color_2.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].font                    = 23
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].opacity                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].opacity2                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].ascending               = false
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].orientation             = true
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].overlay                 = false
        optionsdata.default_visual[WINDOW_TYPE.Icon_Window].reset_on_target_change  = false

    elseif window_type == WINDOW_TYPE.Count_Down then

        optionsdata.default_visual[WINDOW_TYPE.Count_Down]                         = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].width                   = 150
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].height                  = 20
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].left                    = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].top                     = 0.1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].frame                   = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].spacing                 = 2
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].number_format           = NUMBER_FORMAT.Minutes
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].frame_color             = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].frame_color.R           = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].frame_color.G           = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].frame_color.B           = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].back_color              = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].back_color.R            = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].back_color.G            = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].back_color.B            = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].bar_color               = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].bar_color.R             = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].bar_color.G             = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].bar_color.B             = 0
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_1            = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_1.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_1.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_1.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_2            = {}
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_2.R          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_2.G          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font_color_2.B          = 1
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].font                    = 23
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].opacity                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].opacity2                 = 0.5
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].ascending               = false
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].orientation             = true
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].overlay                 = false
        optionsdata.default_visual[WINDOW_TYPE.Count_Down].reset_on_target_change  = false

    end

end