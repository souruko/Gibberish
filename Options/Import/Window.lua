--[[
    Main Import Window
]]

Window = class( Turbine.UI.Lotro.Window )

function Window:Constructor(parent)
    Turbine.UI.Lotro.Window.Constructor( self )

    self.parent = parent

    self.text = nil

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Window:SetImport()

    self:SetText(L.import)
    self.import_button:SetVisible(true)
    self.text_box:SetEnabled(true)
    self:SetVisible(true)

end

function Window:SetExport()

    self:SetText(L.export)
    self.import_button:SetVisible(false)
    self.text_box:SetEnabled(false)
    self:SetVisible(true)

end

function Window:ExportGroup(group_data)

    self:SetExport()

    self.text = "\n=== Gibberish 2.x ===\n"..self:GroupToString(group_data)
    self.text_box:SetText(self.text)

end

function Window:ExportWindow(window_data)

    self:SetExport()

    self.text = "\n=== Gibberish 2.x ===\n"..self:WindowToString(window_data)
    self.text_box:SetText(self.text)

end


function Window:ExportTimer(timer_data, timer_type)

    self:SetExport()

    self.text = "\n=== Gibberish 2.x ===\n"..self:TimerToString(timer_data, timer_type)
    self.text_box:SetText(self.text)

end

function Window:Import()

    self:SetImport()

end


---------------------------------------------------------------------------------------------------------
--export

function Window:GroupToString(group_data)

    local text = "\n=== group ===\n"
    text = text.."name~="..group_data.name..";\n"
    text = text.."color~="..Utils.ColorToString(group_data.color)..";\n"
    text = text.."=== group end ===\n"

    for index, window_data in ipairs(savedata) do

        if window_data.group == group_data.id then

            text = text..self:WindowToString(window_data)

        end

    end

    return text

end


function Window:WindowToString(window_data)

    local text = "\n=== window ===\n"

    text = text.."name~="..window_data.name..";\n"
    text = text.."type~="..window_data.type..";\n"
    text = text.."id~="..window_data.id..";\n"
    text = text.."load~="..tostring(window_data.load)..";\n"
    text = text.."width~="..window_data.width..";\n"
    text = text.."height~="..window_data.height..";\n"
    text = text.."left~="..window_data.left..";\n"
    text = text.."top~="..window_data.top..";\n"
    text = text.."frame~="..window_data.frame..";\n"
    text = text.."spacing~="..window_data.spacing..";\n"
    text = text.."number_format~="..window_data.number_format..";\n"
    text = text.."frame_color~="..Utils.ColorToString(window_data.frame_color)..";\n"
    text = text.."back_color~="..Utils.ColorToString(window_data.back_color)..";\n"
    text = text.."bar_color~="..Utils.ColorToString(window_data.bar_color)..";\n"
    text = text.."font_color_1~="..Utils.ColorToString(window_data.font_color_1)..";\n"
    text = text.."font_color_2~="..Utils.ColorToString(window_data.font_color_2)..";\n"
    text = text.."opacity~="..window_data.opacity..";\n"
    text = text.."opacity2~="..window_data.opacity2..";\n"
    text = text.."ascending~="..tostring(window_data.ascending)..";\n"
    text = text.."orientation~="..tostring(window_data.orientation)..";\n"
    text = text.."overlay~="..tostring(window_data.overlay)..";\n"
    text = text.."reset_on_target_change~="..tostring(window_data.reset_on_target_change)..";\n"
    text = text.."trigger_id~="..tostring(window_data.trigger_id)..";\n"


    text = text.."=== window end ===\n"

    for i, list in ipairs(window_data) do

        for j, timer_data in ipairs(list) do

            text = text..self:TimerToString(timer_data, i)

        end

    end

    return text

end


function Window:TimerToString(timer_data, type)

    local text = "\n=== trigger ===\n"

    text = text.."type~="..type..";\n"
    text = text.."token~="..timer_data.token..";\n"
    text = text.."description~="..timer_data.description..";\n"
    text = text.."custom_timer~="..tostring(timer_data.custom_timer)..";\n"
    text = text.."timer~="..timer_data.timer..";\n"
    local icon
    if timer_data.icon ~= nil then
        icon = timer_data.icon
    else
        icon = ""
    end
    text = text.."icon~="..icon..";\n"
    text = text.."id~="..timer_data.id..";\n"
    text = text.."text~="..timer_data.text..";\n"
    text = text.."text_modifier~="..timer_data.text_modifier..";\n"
    text = text.."threshold~="..timer_data.threshold..";\n"
    text = text.."use_threshold~="..tostring(timer_data.use_threshold)..";\n"
    text = text.."flashing_multi~="..timer_data.flashing_multi..";\n"
    text = text.."flashing~="..tostring(timer_data.flashing)..";\n"
    text = text.."loop~="..tostring(timer_data.loop)..";\n"
    text = text.."reset~="..tostring(timer_data.reset)..";\n"
    text = text.."unique~="..tostring(timer_data.unique)..";\n"
    text = text.."removable~="..tostring(timer_data.removable)..";\n"
    text = text.."use_regex~="..tostring(timer_data.use_regex)..";\n"
    text = text.."hide_timer~="..tostring(timer_data.hide_timer)..";\n"
    text = text.."sort_index~="..tostring(timer_data.sort_index)..";\n"
    text = text.."counter_start~="..tostring(timer_data.counter_start)..";\n"

    return text

end

---------------------------------------------------------------------------------------------------------
--import


function Window:RowsToAttributeList(text)

    local list = {}
    local zeilen = Utils.split(text, ";")

    for i,zeile in pairs(zeilen) do

        if zeile ~= "" then

            local split_attributes = Utils.split(zeile, "~=")
            list[split_attributes[1]] = split_attributes[2]

        end

    end

    return list

end

function Window:ClearButtonPressed()

    self.text_box:SetText("")

end

function Window:ConvertText()

    local text = self.text_box:GetText()

    text = string.gsub(text, "\n", "")

    local old = true
    if string.find(text, "=== Gibberish 2.x ===") then
        old = false
        text = Utils.split(text, "=== Gibberish 2.x ===")[2]
    end

    if string.find(text, "=== group ===") then
        local group_id, group_index = self:ConvertGroup(text, old)
        
        DataFunctions.UpdateGroupLoadStatus(group_id)
        Options.GroupAdded(group_index)
        Windows.LoadAll()
        Options.OptionsWindow.WindowAdded()
        Options.WindowSelectionChanged(nil)

    elseif string.find(text, "=== window ===") then
        local window_index = self:ConvertWindow(text, old)

        Options.WindowAdded(window_index)


    elseif string.find(text, "=== trigger ===") then
        if G.selected_index_window ~= nil then
            self:ConvertTimer(text, G.selected_index_window, old)
            Options.OptionsWindow.WindowSelectionChanged()
        end

    else
        return
    end

    self:ClearButtonPressed()
    SaveWindowData()

end

function Window:InterpreteGroup(text, old)

    if old == true then

        local name = Utils.split(text, "name=")[2]

        local color = {}
        color.R = 0
        color.G = 0
        color.B = 0

        return name, color

    else

        local list = self:RowsToAttributeList(text)

        local name
        if list["name"] ~= nil then
            name = list["name"]
        else
            name = "Group"
        end
        local r,g,b
        if list["color"] ~= nil then
            r,g,b = Utils.StringToColor(list["color"])
        else
            r=0
            g=0
            b=0
        end

        local color = {}
        color.R = r
        color.G = g
        color.B = b

        return name, color

    end

end

function Window:ConvertGroup(text, old)

    local start_index1, end_index1  = string.find(text, "=== group ===")
    local start_index2, end_index2  = string.find(text, ";=== group end ===")
    local group_text = string.sub(text, end_index1 + 1, start_index2 - 1)

    local group_index = DataFunctions.AddGroup(self:InterpreteGroup(group_text, old))
    local group_id = savedata.groups[group_index].id

    text = Utils.split(text, ";=== group end ===")[2]

    local window_splitted_text  = Utils.split(text, "=== window ===")

    for i,window_text in pairs(window_splitted_text) do

        if window_text ~= "" then

            local index = self:ConvertWindow("=== window ==="..window_text, old)
            savedata[index].group = group_id

        end

    end

    return group_id, group_index

end

function Window:InterpreteWindow(text, old)

    local list = self:RowsToAttributeList(text)

    if list["frame_color"] ~= nil then
        local r,g,b = Utils.StringToColor(list["frame_color"])
        list["frame_color"] = {}
        list["frame_color"].R = r
        list["frame_color"].G = g
        list["frame_color"].B = b
    end
    if list["back_color"] ~= nil then
        local r,g,b = Utils.StringToColor(list["back_color"])
        list["back_color"] = {}
        list["back_color"].R = r
        list["back_color"].G = g
        list["back_color"].B = b
    end
    if list["bar_color"] ~= nil then
        local r,g,b = Utils.StringToColor(list["bar_color"])
        list["bar_color"] = {}
        list["bar_color"].R = r
        list["bar_color"].G = g
        list["bar_color"].B = b
    end
    if list["font_color_1"] ~= nil then
        local r,g,b = Utils.StringToColor(list["font_color_1"])
        list["font_color_1"] = {}
        list["font_color_1"].R = r
        list["font_color_1"].G = g
        list["font_color_1"].B = b
    end
    if list["font_color_2"] ~= nil then
        local r,g,b = Utils.StringToColor(list["font_color_2"])
        list["font_color_2"] = {}
        list["font_color_2"].R = r
        list["font_color_2"].G = g
        list["font_color_2"].B = b
    end

    if list["ascending"] ~= nil then
        list["ascending"] = Utils.StringToBool(list["ascending"])
    end
    if list["orientation"] ~= nil then
        list["orientation"] = Utils.StringToBool(list["orientation"])
    end
    if list["overlay"] ~= nil then
        list["overlay"] = Utils.StringToBool(list["overlay"])
    end
    if list["reset_on_target_change"] ~= nil then
        list["reset_on_target_change"] = Utils.StringToBool(list["reset_on_target_change"])
    end
    if list["load"] ~= nil then
        list["load"] = Utils.StringToBool(list["load"])
    end

    if old == true then
        if list["type"] ~= nil then
        
            if list["type"] == "Bar_ListBox" then
                list["type"] = WINDOW_TYPE.Bar_ListBox
            elseif list["type"] == "Bar_Window" then
                list["type"] = WINDOW_TYPE.Bar_Window
            elseif list["type"] == "Icon_ListBox" then
                list["type"] = WINDOW_TYPE.Icon_ListBox
            elseif list["type"] == "Icon_Window" then
                list["type"] = WINDOW_TYPE.Icon_Window
            elseif list["type"] == "Count_Down" then
                list["type"] = WINDOW_TYPE.Count_Down
            elseif list["type"] == "Bar_Circel" then
                list["type"] = WINDOW_TYPE.Bar_Circel
            else
                list["type"] = WINDOW_TYPE.Bar_ListBox
            end

        else
            list["type"] = WINDOW_TYPE.Bar_ListBox
        end
    else
        if list["type"] ~= nil then
            list["type"] = tonumber(list["type"])
        end
    end

    if list["width"] ~= nil then
        list["width"] = tonumber(list["width"])
    end
    if list["height"] ~= nil then
        list["height"] = tonumber(list["height"])
    end
    if list["left"] ~= nil then
        list["left"] = tonumber(list["left"])
    end
    if list["top"] ~= nil then
        list["top"] = tonumber(list["top"])
    end
    if list["frame"] ~= nil then
        list["frame"] = tonumber(list["frame"])
    end
    if list["spacing"] ~= nil then
        list["spacing"] = tonumber(list["spacing"])
    end
    if list["number_format"] ~= nil then
        list["number_format"] = tonumber(list["number_format"])
    end
    if list["font"] ~= nil then
        list["font"] = tonumber(list["font"])
    end
    if list["opacity"] ~= nil then
        list["opacity"] = tonumber(list["opacity"])
    end
    if list["opacity2"] ~= nil then
        list["opacity2"] = tonumber(list["opacity2"])
    end
    if list["trigger_id"] ~= nil then
        list["trigger_id"] = tonumber(list["trigger_id"])
    end
    -- if list["id"] ~= nil then
    --     list["id"] = tonumber(list["id"])
    -- end


    return list

end

function Window:ConvertWindow(text, old)

    local start_index1, end_index1  = string.find(text, "=== window ===")
    local start_index2, end_index2  = string.find(text, ";=== window end ===")
    local window_text = string.sub(text, end_index1 + 1, start_index2 - 1)

    local window_info_list = self:InterpreteWindow(window_text, old)

    local window_index = DataFunctions.AddWindow(window_info_list.name, window_info_list.type)

    if window_info_list["frame_color"] ~= nil then
        savedata[window_index].frame_color = window_info_list["frame_color"]
    end
    if window_info_list["back_color"] ~= nil then
        savedata[window_index].back_color = window_info_list["back_color"]
    end
    if window_info_list["bar_color"] ~= nil then
        savedata[window_index].bar_color = window_info_list["bar_color"]
    end
    if window_info_list["font_color_1"] ~= nil then
        savedata[window_index].font_color_1 = window_info_list["font_color_1"]
    end
    if window_info_list["font_color_2"] ~= nil then
        savedata[window_index].font_color_2 = window_info_list["font_color_2"]
    end

    if window_info_list["ascending"] ~= nil then
        savedata[window_index].ascending = window_info_list["ascending"]
    end
    if window_info_list["orientation"] ~= nil then
        savedata[window_index].orientation = window_info_list["orientation"]
    end
    if window_info_list["overlay"] ~= nil then
        savedata[window_index].overlay = window_info_list["overlay"]
    end
    if window_info_list["reset_on_target_change"] ~= nil then
        savedata[window_index].reset_on_target_change = window_info_list["reset_on_target_change"]
    end
    if window_info_list["load"] ~= nil then
        savedata[window_index].load = window_info_list["load"]
    end

    if window_info_list["width"] ~= nil then
        savedata[window_index].width = window_info_list["width"]
    end
    if window_info_list["height"] ~= nil then
        savedata[window_index].height = window_info_list["height"]
    end
    if window_info_list["left"] ~= nil then
        savedata[window_index].left = window_info_list["left"]
    end
    if window_info_list["top"] ~= nil then
        savedata[window_index].top = window_info_list["top"]
    end
    if window_info_list["frame"] ~= nil then
        savedata[window_index].frame = window_info_list["frame"]
    end
    if window_info_list["spacing"] ~= nil then
        savedata[window_index].spacing = window_info_list["spacing"]
    end
    if window_info_list["number_format"] ~= nil then
        savedata[window_index].number_format = window_info_list["number_format"]
    end
    if window_info_list["font"] ~= nil then
        savedata[window_index].font = window_info_list["font"]
    end
    if window_info_list["opacity"] ~= nil then
        savedata[window_index].opacity = window_info_list["opacity"]
    end
    if window_info_list["opacity2"] ~= nil then
        savedata[window_index].opacity2 = window_info_list["opacity2"]
    end
    if window_info_list["trigger_id"] ~= nil then
        savedata[window_index].trigger_id = window_info_list["trigger_id"]
    end
    -- if window_info_list["id"] ~= nil then
    --     savedata[window_index].id = window_info_list["id"]
    -- end

    text = Utils.split(text,  ";=== window end ===")[2]
    self:ConvertTimer(text, window_index, old)

    return window_index

end

function Window:ConvertTimer(text, window_index, old)

    local splitted_text  = Utils.split(text, "=== trigger ===")

    for index, timer_text in pairs(splitted_text) do
--Turbine.Shell.WriteLine(timer_text)
        if timer_text ~= "" then

            local timer_info_list = self:InterpreteTimer(timer_text, old)

            local timer_index = DataFunctions.AddTimer(timer_info_list.type, window_index)


            if timer_info_list["token"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].token = timer_info_list["token"]
            end
            if timer_info_list["description"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].description = timer_info_list["description"]
            end
            if timer_info_list["text"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].text = timer_info_list["text"]
            end
            if timer_info_list["text_modifier"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].text_modifier = timer_info_list["text_modifier"]
            end
            if timer_info_list["icon"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].icon = timer_info_list["icon"]
            end
            if timer_info_list["timer"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].timer = timer_info_list["timer"]
            end
            if timer_info_list["threshold"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].threshold = timer_info_list["threshold"]
            end
            -- if timer_info_list["sort_index"] ~= nil then
            --     savedata[window_index][timer_info_list.type][timer_index].sort_index = timer_info_list["sort_index"]
            -- end
            if timer_info_list["flashing_multi"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].flashing_multi = timer_info_list["flashing_multi"]
            end
            if timer_info_list["custom_timer"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].custom_timer = timer_info_list["custom_timer"]
            end
            if timer_info_list["use_threshold"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].use_threshold = timer_info_list["use_threshold"]
            end
            if timer_info_list["flashing"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].flashing = timer_info_list["flashing"]
            end
            if timer_info_list["loop"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].loop = timer_info_list["loop"]
            end
            if timer_info_list["reset"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].reset = timer_info_list["reset"]
            end
            if timer_info_list["unique"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].unique = timer_info_list["unique"]
            end
            if timer_info_list["removable"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].removable = timer_info_list["removable"]
            end
            if timer_info_list["use_regex"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].use_regex = timer_info_list["use_regex"]
            end
            if timer_info_list["hide_timer"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].hide_timer = timer_info_list["hide_timer"]
            end
            if timer_info_list["id"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].id = timer_info_list["id"]
            end
            if timer_info_list["counter_start"] ~= nil then
                savedata[window_index][timer_info_list.type][timer_index].counter_start = timer_info_list["counter_start"]
            end

        end

    end

end


function Window:InterpreteTimer(text, old)

    local list = self:RowsToAttributeList(text)

    if list["type"] ~= nil then
        list["type"] = tonumber(list["type"])
    else
        list["type"] = TRIGGER_TYPE.Chat
    end
    if list["icon"] ~= nil then
        list["icon"] = tonumber(list["icon"])
    end
    if list["id"] ~= nil then
        list["id"] = tonumber(list["id"])
    end
    if list["timer"] ~= nil then
        list["timer"] = tonumber(list["timer"])
    end
    if list["threshold"] ~= nil then
        list["threshold"] = tonumber(list["threshold"])
    end
    if list["sort_index"] ~= nil then
        list["sort_index"] = tonumber(list["sort_index"])
    end
    if old == true then
        if list["text"] == " " then
            list["text_modifier"] = TEXTMODIFIER.No_Text
        elseif list["text"] == "" or list["text"] == nil then
            list["text_modifier"] = TEXTMODIFIER.Let_the_plugin_decide
        else
            list["text_modifier"] = TEXTMODIFIER.Custom_Text
        end

    else
        if list["text_modifier"] ~= nil then
            list["text_modifier"] = tonumber(list["text_modifier"])
        end
    end
    if list["use_threshold"] ~= nil then
        list["use_threshold"] = Utils.StringToBool(list["use_threshold"])
    end

    if old == true then
        if list["timer"] == 0 then
            list["custom_timer"] = false
        else
            list["custom_timer"] = true
        end
    else
        if list["custom_timer"] ~= nil then
            list["custom_timer"] = Utils.StringToBool(list["custom_timer"])
        end
    end

    if list["flashing"] ~= nil then
        list["flashing"] = Utils.StringToBool(list["flashing"])
    end
    if list["loop"] ~= nil then
        list["loop"] = Utils.StringToBool(list["loop"])
    end
    if list["reset"] ~= nil then
        list["reset"] = Utils.StringToBool(list["reset"])
    end
    if list["unique"] ~= nil then
        list["unique"] = Utils.StringToBool(list["unique"])
    end
    if list["removable"] ~= nil then
        list["removable"] = Utils.StringToBool(list["removable"])
    end
    if old == true then
        if list["type"] == TRIGGER_TYPE.Chat then
            list["use_regex"] = true
        else
            list["use_regex"] = false
        end
    else
        if list["use_regex"] ~= nil then
            list["use_regex"] = Utils.StringToBool(list["use_regex"])
        end
    end
    
    if list["hide_timer"] ~= nil then
        list["hide_timer"] = Utils.StringToBool(list["hide_timer"])
    end

    if list["counter_start"] ~= nil then
        list["counter_start"] = tonumber(list["counter_start"])
    end

    return list

end

---------------------------------------------------------------------------------------------------------
--private

function Window:Build()

    self:SetPosition(optionsdata.import.left, optionsdata.import.top)
    self:SetResizable(true)
    self:SetMinimumSize(optionsdata.import.width, optionsdata.import.width)
    self:SetMaximumWidth(optionsdata.import.width)
    self:SetZOrder(14)
    
    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetPosition(SPACER, TOP_BAR + SPACER +FRAME)
    self.frame:SetBackColor(COLOR_LIGHT_GRAY)
    
    self.text_box = Turbine.UI.Lotro.TextBox()
    self.text_box:SetParent(self.frame)
    self.text_box:SetBackColor(Turbine.UI.Color.Black)
    self.text_box:SetForeColor(Turbine.UI.Color.White)
    self.text_box:SetPosition(FRAME, FRAME)
    self.text_box:SetFont(OPTIONS_FONT)
    self.text_box:SetMultiline(true)
    
    self.v_scroll = Turbine.UI.Lotro.ScrollBar()
    self.v_scroll:SetParent(self.frame)
    self.v_scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.v_scroll:SetVisible(false)
    self.v_scroll:SetZOrder(200001)
    self.text_box:SetVerticalScrollBar(self.v_scroll)
    
    self.import_button = Turbine.UI.Lotro.Button()
    self.import_button:SetParent(self.frame)
    self.import_button:SetSize(80,20)
    self.import_button:SetPosition(self.frame:GetWidth() - SPACER - 80 - SPACER, self.frame:GetHeight() - SPACER - 20)
    self.import_button:SetText(L.buttonText)
    self.import_button:SetVisible(false)
    self.import_button.MouseClick = function()
        self:ConvertText()
    end

    self.clear_button = Turbine.UI.Lotro.Button()
    self.clear_button:SetParent(self.frame)
    self.clear_button:SetSize(80,20)
    self.clear_button:SetPosition(10, self.frame:GetHeight() - SPACER - 20)
    self.clear_button:SetText(L.clearButtonText)
    self.clear_button.MouseClick = function()
        self:ClearButtonPressed()
    end
    
    self:SetSize(optionsdata.import.width, optionsdata.import.height)
    self:SetVisible(true)

end

function Window:SizeChanged()

        self.frame:SetSize(self:GetWidth() - 2*SPACER, self:GetHeight() - TOP_BAR - 3*FRAME - SPACER)
        self.text_box:SetSize(self.frame:GetWidth() - FRAME - SPACER, self.frame:GetHeight() - 2*FRAME )
        self.import_button:SetPosition(self.frame:GetWidth() - SPACER - 80 - FRAME, self.frame:GetHeight() - SPACER - 20)
        self.clear_button:SetPosition(10, self.frame:GetHeight() - SPACER - 20)
        self.v_scroll:SetLeft((self.frame:GetWidth() - 10))
        self.v_scroll:SetSize(10,self.frame:GetHeight())

        optionsdata.import.width, optionsdata.import.height = self:GetSize()
        SaveOptions()

end

function Window:PositionChanged()

    optionsdata.import.left, optionsdata.import.top = self:GetPosition()
    SaveOptions()

end


function Window:Closed()

    optionsdata.import.open = false
    SaveOptions()

end