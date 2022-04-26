--[[
    OptionsWindow child for selected Window Settings (top right)
]]

WindowSettings = class( Turbine.UI.Control )

function WindowSettings:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.default_edit_mode = false

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function WindowSettings:Resize()


    self:SetHeight(optionsdata.options_window.height - SPACER - 100)
    self.background:SetHeight(optionsdata.options_window.height - SPACER - 110)


end

function WindowSettings:WindowSelectionChanged()

    if self.default_edit_mode == false then
        if G.selected_index_window ~= nil then
            self:FillInformation()
        else
            self:FillEmpty()
        end
        self:ResetEditColors()
    end

end

---------------------------------------------------------------------------------------------------------
--private

function WindowSettings:ChangeToDefaultMode()

    self:Save()
    self.default_edit_mode = not(self.default_edit_mode)

    if self.default_edit_mode == true then

        self.background:SetBackColor(COLOR_DARK_GRAY)
        self.name_tb:SetEnabled(false)
        local type = self.window_type_cb:GetSelection()
        if type == nil then
            type = 1
        end
        self.name_tb:SetText(L.defaultEditMode..WINDOW_TYPE[type])
        self.edit_default_button:SetText(L.leaveDefaultEditMode)
        self:ResetToDefault(false)
        --self:DefaultPosFix()
        self:ResetEditColors()
        

    else

        self.background:SetBackColor(Turbine.UI.Color.Black)
        self.name_tb:SetEnabled(true)
        self.edit_default_button:SetText(L.editDefault)
        if G.selected_index_window ~= nil then
            self:FillInformation()
        else
            self:FillEmpty()
        end
        self:ResetEditColors()

    end

end


function WindowSettings:ResetEditColors()

    self.name_lb:SetForeColor(Turbine.UI.Color.White)
    self.window_type_lb:SetForeColor(Turbine.UI.Color.White)

    -- self.left_lb:SetForeColor(Turbine.UI.Color.White)
    -- self.top_lb:SetForeColor(Turbine.UI.Color.White)
    self.width_lb:SetForeColor(Turbine.UI.Color.White)
    self.height_lb:SetForeColor(Turbine.UI.Color.White)
    self.spacing_lb:SetForeColor(Turbine.UI.Color.White)
    self.frame_lb:SetForeColor(Turbine.UI.Color.White)

    self.frame_color_lb:SetForeColor(Turbine.UI.Color.White)
    self.bar_color_lb:SetForeColor(Turbine.UI.Color.White)
    self.back_color_lb:SetForeColor(Turbine.UI.Color.White)
    self.timer_color_lb:SetForeColor(Turbine.UI.Color.White)
    self.text_color_lb:SetForeColor(Turbine.UI.Color.White)

    self.font_lb:SetForeColor(Turbine.UI.Color.White)
    self.number_format_lb:SetForeColor(Turbine.UI.Color.White)

    self.transparency1_lb:SetForeColor(Turbine.UI.Color.White)
    self.transparency2_lb:SetForeColor(Turbine.UI.Color.White)

    self.global_pos_lb:SetForeColor(Turbine.UI.Color.White)
    self.ascending_lb:SetForeColor(Turbine.UI.Color.White)
    self.orientation_lb:SetForeColor(Turbine.UI.Color.White)
    self.overlay_lb:SetForeColor(Turbine.UI.Color.White)

end

function WindowSettings:Save()

    if self.default_edit_mode == true then

        local type = self.window_type_cb:GetSelection()
        if type ~= nil then
            local data = optionsdata.default_visual[type]

            self:SaveChanges(data)
        end

    else
        if G.selected_index_window ~= nil then
            local data = savedata[G.selected_index_window]
            self:SaveChanges(data)
        end
    end

end

function WindowSettings:SaveChanges(data)




    local name = self.name_tb:GetText()
    if name ~= "" then
        data.name = name
        self.name_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.name_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local window_type = self.window_type_cb:GetSelection()
    if window_type ~= nil then
        data.type = window_type
        self.window_type_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.window_type_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    -- local left = tonumber( self.left_tb:GetText() )
    -- local top = tonumber( self.top_tb:GetText() )
    local width = tonumber( self.width_tb:GetText() )
    local height = tonumber( self.height_tb:GetText() )

    -- if left ~= "" and 'number' == type(left) then
    --     data.left = left
    --     self.left_lb:SetForeColor(Turbine.UI.Color.White)

    -- else
    --     self.left_lb:SetForeColor(Turbine.UI.Color.Red)

    -- end


    -- if top ~= "" and 'number' == type(top) then
    --     data.top = top
    --     self.top_lb:SetForeColor(Turbine.UI.Color.White)

    -- else
    --     self.top_lb:SetForeColor(Turbine.UI.Color.Red)

    -- end

    if width ~= "" and 'number' == type(width) then
        data.width = width
        self.width_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.width_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    if height ~= "" and 'number' == type(height) then
        data.height = height
        self.height_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.height_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local spacing = tonumber( self.spacing_tb:GetText() )
    if spacing ~= "" and 'number' == type(spacing) then
        data.spacing = spacing
        self.spacing_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.spacing_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local frame = tonumber( self.frame_tb:GetText() )
    if frame ~= "" and 'number' == type(frame) then
        data.frame = frame
        self.frame_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.frame_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local frame_color_r, frame_color_g, frame_color_b = Utils.StringToColor( self.frame_color_tb:GetText() )
    if frame_color_r ~= nil then
        data.frame_color.R = frame_color_r
        data.frame_color.G = frame_color_g
        data.frame_color.B = frame_color_b
        self.frame_color_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.frame_color_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local back_color_r, back_color_g, back_color_b = Utils.StringToColor( self.back_color_tb:GetText() )
    if back_color_r ~= nil then
        data.back_color.R = back_color_r
        data.back_color.G = back_color_g
        data.back_color.B = back_color_b
        self.back_color_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.back_color_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local bar_color_r, bar_color_g, bar_color_b = Utils.StringToColor( self.bar_color_tb:GetText() )
    if bar_color_r ~= nil then
        data.bar_color.R = bar_color_r
        data.bar_color.G = bar_color_g
        data.bar_color.B = bar_color_b
        self.bar_color_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.bar_color_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local font_color_1_r, font_color_1_g, font_color_1_b = Utils.StringToColor( self.timer_color_tb:GetText() )
    if font_color_1_r ~= nil then
        data.font_color_1.R = font_color_1_r
        data.font_color_1.G = font_color_1_g
        data.font_color_1.B = font_color_1_b
        self.timer_color_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.timer_color_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local font_color_2_r, font_color_2_g, font_color_2_b = Utils.StringToColor( self.text_color_tb:GetText() )
    if font_color_2_r ~= nil then
        data.font_color_2.R = font_color_2_r
        data.font_color_2.G = font_color_2_g
        data.font_color_2.B = font_color_2_b
        self.text_color_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.text_color_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local font = self.font_cb:GetSelection()
    if font ~= nil then
        data.font = font
        self.font_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.font_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local number_format = self.number_format_cb:GetSelection()
    if number_format ~= nil then
        data.number_format = number_format
        self.number_format_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.number_format_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local opacity = tonumber( self.transparency1_value:GetText() )
    if opacity ~= "" and 'number' == type(opacity) and opacity <= 1 and opacity >= 0 then
        data.opacity = opacity
        self.transparency1_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.transparency1_lb:SetForeColor(Turbine.UI.Color.Red)

    end


    local opacity2 = tonumber( self.transparency2_value:GetText() )
    if opacity2 ~= "" and 'number' == type(opacity2) and opacity2 <= 1 and opacity2 >= 0 then
        data.opacity2 = opacity2
        self.transparency2_lb:SetForeColor(Turbine.UI.Color.White)

    else
        self.transparency2_lb:SetForeColor(Turbine.UI.Color.Red)

    end

    local trigger_id = self.trigger_id_cb:GetSelection()

    data.trigger_id = trigger_id
    self.trigger_id_lb:SetForeColor(Turbine.UI.Color.White)

    local global_pos = self.global_pos_cb:IsChecked()
    data.global_position = global_pos
    self.global_pos_lb:SetForeColor(Turbine.UI.Color.White)

    local ascending = self.ascending_cb:IsChecked()
    data.ascending = ascending
    self.ascending_lb:SetForeColor(Turbine.UI.Color.White)

    local orientation = self.orientation_cb:IsChecked()
    data.orientation = orientation
    self.orientation_lb:SetForeColor(Turbine.UI.Color.White)
 
    local overlay = self.overlay_cb:IsChecked()
    data.overlay = overlay
    self.overlay_lb:SetForeColor(Turbine.UI.Color.White)

    --self:ResetEditColors()
    SaveWindowData()
    Windows.Reload(G.selected_index_window)

end


-- function WindowSettings:DefaultPosFix()

--     local data
--     if self.window_type_cb:GetSelection() == nil then
--         data = optionsdata.default_visual[1]
--     else
--         data = optionsdata.default_visual[self.window_type_cb:GetSelection()]
--     end

--     if tonumber( self.left_tb:GetText() ) ~= data.left then
--         self.left_lb:SetForeColor(Turbine.UI.Color.Orange)
--     end
--     self.left_tb:SetText(data.left)

--     if tonumber( self.top_tb:GetText() ) ~= data.top then
--         self.top_lb:SetForeColor(Turbine.UI.Color.Orange)
--     end
--     self.top_tb:SetText(data.top)

-- end

function WindowSettings:ResetToDefault_Window()

    if G.selected_index_window == nil then
        return
    end

    local data
    if self.window_type_cb:GetSelection() == nil then
        data = optionsdata.default_visual[1]
    else
        data = optionsdata.default_visual[self.window_type_cb:GetSelection()]
    end


    if tonumber( self.width_tb:GetText() ) ~= data.width then
        self.width_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.width_tb:SetText(data.width)

    if tonumber( self.height_tb:GetText() ) ~= data.height then
        self.height_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.height_tb:SetText(data.height)

    if tonumber( self.spacing_tb:GetText() ) ~= data.spacing then
        self.spacing_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.spacing_tb:SetText(data.spacing)

    if tonumber( self.frame_tb:GetText() ) ~= data.frame then
        self.frame_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.frame_tb:SetText(data.frame)

    if self.font_cb:GetSelection() ~= data.font then
        self.font_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.font_cb:SetSelection(data.font)

    if self.number_format_cb:GetSelection() ~= data.number_format then
        self.number_format_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.number_format_cb:SetSelection(data.number_format)

    if tonumber( self.transparency1_value:GetText() ) ~= data.opacity then
        self.transparency1_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.transparency1_value:SetText(data.opacity)
    self.transparency1_bar:SetValue(data.opacity * 100)

    if tonumber( self.transparency2_value:GetText() ) ~= data.opacity2 then
        self.transparency2_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.transparency2_value:SetText(data.opacity2)
    self.transparency2_bar:SetValue(data.opacity2 * 100)

    self.global_pos_cb:SetChecked(data.global_position)
    self.ascending_cb:SetChecked(data.ascending)
    self.orientation_cb:SetChecked(data.orientation)
    self.overlay_cb:SetChecked(data.overlay)

    if self.frame_color_tb:GetText() ~= Utils.ColorToString(data.frame_color) then
        self.frame_color_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.frame_color_control:SetBackColor(Utils.ColorFix(data.frame_color))
    self.frame_color_tb:SetText(Utils.ColorToString(data.frame_color))

    if self.back_color_tb:GetText() ~= Utils.ColorToString(data.back_color) then
        self.back_color_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.back_color_control:SetBackColor(Utils.ColorFix(data.back_color))
    self.back_color_tb:SetText(Utils.ColorToString(data.back_color))
    
    if self.bar_color_tb:GetText() ~= Utils.ColorToString(data.bar_color) then
        self.bar_color_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.bar_color_control:SetBackColor(Utils.ColorFix(data.bar_color))
    self.bar_color_tb:SetText(Utils.ColorToString(data.bar_color))

    if self.timer_color_tb:GetText() ~= Utils.ColorToString(data.font_color_1) then
        self.timer_color_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.timer_color_control:SetBackColor(Utils.ColorFix(data.font_color_1))
    self.timer_color_tb:SetText(Utils.ColorToString(data.font_color_1))

    if self.text_color_tb:GetText() ~= Utils.ColorToString(data.font_color_2) then
        self.text_color_lb:SetForeColor(Turbine.UI.Color.Orange)
    end
    self.text_color_control:SetBackColor(Utils.ColorFix(data.font_color_2))
    self.text_color_tb:SetText(Utils.ColorToString(data.font_color_2))

end

function WindowSettings:ResetToDefault_Default()

    local type = self.window_type_cb:GetSelection()
    if type == nil then
        return
    end

    DataFunctions.ResetDefaultVisual(type)

    self:ResetToDefault_Window()


end

function WindowSettings:ResetToDefault(bool)

    if self.default_edit_mode == false or bool == false then
        self:ResetToDefault_Window()
    else
        self:ResetToDefault_Default()
    end

end

function WindowSettings:FillInformation()

    local data = savedata[G.selected_index_window]

    self.name_tb:SetText(data.name)
    self.window_type_cb:SetSelection(data.type)

    -- self.left_tb:SetText(data.left)
    -- self.top_tb:SetText(data.top)
    self.width_tb:SetText(data.width)
    self.height_tb:SetText(data.height)
    self.spacing_tb:SetText(data.spacing)
    self.frame_tb:SetText(data.frame)

    self.font_cb:SetSelection(data.font)
    self.number_format_cb:SetSelection(data.number_format)

    self.transparency1_value:SetText(data.opacity)
    self.transparency1_bar:SetValue(data.opacity * 100)
    self.transparency2_value:SetText(data.opacity2)
    self.transparency2_bar:SetValue(data.opacity2 * 100)

    self.trigger_id_cb:Clear()
    for i=1, table.getn(TRIGGER_TYPE), 1 do
        for j, timer_data in ipairs(data[i]) do
                self.trigger_id_cb:AddItem(timer_data.token, timer_data.id)
        end
    end
    self.trigger_id_cb:SetSelection(data.trigger_id)

    self.global_pos_cb:SetChecked(data.global_position)
    self.ascending_cb:SetChecked(data.ascending)
    self.orientation_cb:SetChecked(data.orientation)
    self.overlay_cb:SetChecked(data.overlay)

    self.frame_color_control:SetBackColor(Utils.ColorFix(data.frame_color))
    self.frame_color_tb:SetText(Utils.ColorToString(data.frame_color))

    self.back_color_control:SetBackColor(Utils.ColorFix(data.back_color))
    self.back_color_tb:SetText(Utils.ColorToString(data.back_color))
    
    self.bar_color_control:SetBackColor(Utils.ColorFix(data.bar_color))
    self.bar_color_tb:SetText(Utils.ColorToString(data.bar_color))

    self.timer_color_control:SetBackColor(Utils.ColorFix(data.font_color_1))
    self.timer_color_tb:SetText(Utils.ColorToString(data.font_color_1))

    self.text_color_control:SetBackColor(Utils.ColorFix(data.font_color_2))
    self.text_color_tb:SetText(Utils.ColorToString(data.font_color_2))


end


function WindowSettings:FillEmpty()

    self.name_tb:SetText("")
    self.window_type_cb:SetSelection(nil)

    self.width_tb:SetText("")
    self.height_tb:SetText("")
    self.spacing_tb:SetText("")
    self.frame_tb:SetText("")

    self.font_cb:SetSelection(nil)
    self.number_format_cb:SetSelection(nil)

    self.transparency1_bar:SetValue(50)
    self.transparency1_value:SetText("")
    self.transparency2_bar:SetValue(50)
    self.transparency2_value:SetText("")

    self.trigger_id_cb:Clear()

    self.global_pos_cb:SetChecked(false)
    self.ascending_cb:SetChecked(false)
    self.orientation_cb:SetChecked(false)
    self.overlay_cb:SetChecked(false)

    self.frame_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.frame_color_tb:SetText("")

    self.back_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.back_color_tb:SetText("")
    
    self.bar_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.bar_color_tb:SetText("")

    self.timer_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.timer_color_tb:SetText("")

    self.text_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.text_color_tb:SetText("")


end


function WindowSettings:Build()

    local width = optionsdata.options_window.width - (SPACER + WINDOWSELECTION_WIDTH + SPACER + WINDOWSELECTION_WIDTH + SPACER + SPACER)


    self:SetPosition(SPACER + WINDOWSELECTION_WIDTH + SPACER + WINDOWSELECTION_WIDTH + SPACER, TOP_SPACER)
    self:SetParent(self.parent)
    self:SetSize(width, WINDOW_SETTINGS_HEIGHT + TOP_BAR + (2*FRAME))
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.windowOptionsHeader)
    self.header:SetMouseVisible(false)
    self.header:SetWidth(width - 100)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, TOP_BAR + FRAME)
    self.background:SetSize(width - (2*FRAME), WINDOW_SETTINGS_HEIGHT)


    local row = 1
    local row_height = 20

    self.name_lb = Turbine.UI.Label()
    self.name_lb:SetParent(self.background)
    self.name_lb:SetFont(OPTIONS_FONT)
    self.name_lb:SetSize(50, row_height)
    self.name_lb:SetPosition(SPACER, row*row_height)
    self.name_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.name_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.name_lb:SetText(L.name)

    self.name_tb = Turbine.UI.Lotro.TextBox()
    self.name_tb:SetSize(290 , row_height)
    self.name_tb:SetPosition(SPACER + 50, row*row_height)
    self.name_tb:SetParent(self.background)
    self.name_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.name_tb:SetFont(OPTIONS_FONT)
    self.name_tb.TextChanged = function()
        self.name_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.window_type_lb = Turbine.UI.Label()
    self.window_type_lb:SetParent(self.background)
    self.window_type_lb:SetFont(OPTIONS_FONT)
    self.window_type_lb:SetSize(100, row_height)
    self.window_type_lb:SetPosition(SPACER, row*row_height)
    self.window_type_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.window_type_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.window_type_lb:SetText(L.windowType)

    self.window_type_cb = LabelledComboBox(nil, nil, 160)
	self.window_type_cb:SetParent(self.background)
    self.window_type_cb:SetPosition(350 - 160, row * row_height)
    for k,v in ipairs(WINDOW_TYPE) do
        self.window_type_cb:AddItem(v, k)
    end


    row = row + 2

    self.global_pos_lb = Turbine.UI.Label()
    self.global_pos_lb:SetParent(self.background)
    self.global_pos_lb:SetFont(OPTIONS_FONT)
    self.global_pos_lb:SetSize(150, row_height)
    self.global_pos_lb:SetPosition(SPACER, row*row_height)
    self.global_pos_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.global_pos_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.global_pos_lb:SetText(L.global_pos)
    

    self.global_pos_cb =  Turbine.UI.Lotro.CheckBox()
	self.global_pos_cb:SetParent(self.background)
    self.global_pos_cb:SetSize(120, 25)
    self.global_pos_cb:SetFont(OPTIONS_FONT)
    self.global_pos_cb:SetText("")
    self.global_pos_cb:SetPosition(335, row* row_height)
    self.global_pos_cb.CheckedChanged = function()
        self.global_pos_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.width_lb = Turbine.UI.Label()
    self.width_lb:SetParent(self.background)
    self.width_lb:SetFont(OPTIONS_FONT)
    self.width_lb:SetSize(50, row_height)
    self.width_lb:SetPosition(SPACER, row*row_height)
    self.width_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.width_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.width_lb:SetText(L.width)

    self.width_tb = Turbine.UI.Lotro.TextBox()
    self.width_tb:SetSize(60 , row_height)
    self.width_tb:SetPosition(290 , row*row_height)
    self.width_tb:SetParent(self.background)
    self.width_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.width_tb:SetFont(OPTIONS_FONT)
    self.width_tb.TextChanged = function()
        self.width_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.height_lb = Turbine.UI.Label()
    self.height_lb:SetParent(self.background)
    self.height_lb:SetFont(OPTIONS_FONT)
    self.height_lb:SetSize(50, row_height)
    self.height_lb:SetPosition(SPACER, row*row_height)
    self.height_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.height_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.height_lb:SetText(L.height)

    self.height_tb = Turbine.UI.Lotro.TextBox()
    self.height_tb:SetSize(60 , row_height)
    self.height_tb:SetPosition(290 , row*row_height)
    self.height_tb:SetParent(self.background)
    self.height_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.height_tb:SetFont(OPTIONS_FONT)
    self.height_tb.TextChanged = function()
        self.height_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.spacing_lb = Turbine.UI.Label()
    self.spacing_lb:SetParent(self.background)
    self.spacing_lb:SetFont(OPTIONS_FONT)
    self.spacing_lb:SetSize(50, row_height)
    self.spacing_lb:SetPosition(SPACER, row*row_height)
    self.spacing_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.spacing_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.spacing_lb:SetText(L.spacing)

    self.spacing_tb = Turbine.UI.Lotro.TextBox()
    self.spacing_tb:SetSize(60 , row_height)
    self.spacing_tb:SetPosition(290 , row*row_height)
    self.spacing_tb:SetParent(self.background)
    self.spacing_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.spacing_tb:SetFont(OPTIONS_FONT)
    self.spacing_tb.TextChanged = function()
        self.spacing_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.frame_lb = Turbine.UI.Label()
    self.frame_lb:SetParent(self.background)
    self.frame_lb:SetFont(OPTIONS_FONT)
    self.frame_lb:SetSize(50, row_height)
    self.frame_lb:SetPosition(SPACER, row*row_height)
    self.frame_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.frame_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.frame_lb:SetText(L.frame)

    self.frame_tb = Turbine.UI.Lotro.TextBox()
    self.frame_tb:SetSize(60 , row_height)
    self.frame_tb:SetPosition(290 , row*row_height)
    self.frame_tb:SetParent(self.background)
    self.frame_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.frame_tb:SetFont(OPTIONS_FONT)
    self.frame_tb.TextChanged = function()
        self.frame_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2 

    self.frame_color_lb = Turbine.UI.Label()
    self.frame_color_lb:SetParent(self.background)
    self.frame_color_lb:SetFont(OPTIONS_FONT)
    self.frame_color_lb:SetSize(100, row_height)
    self.frame_color_lb:SetPosition(SPACER, row*row_height)
    self.frame_color_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.frame_color_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.frame_color_lb:SetText(L.frame_color)

    self.color_for_frames = Turbine.UI.Control()
    self.color_for_frames:SetParent(self.background)
    self.color_for_frames:SetSize(row_height, row_height*5)
    self.color_for_frames:SetPosition(250 - 10 - row_height , row*row_height)
    self.color_for_frames:SetBackColor(COLOR_DARK_GRAY)
    self.color_for_frames:SetMouseVisible(true)

    self.frame_color_control = Turbine.UI.Control()
    self.frame_color_control:SetParent(self.background)
    self.frame_color_control:SetSize(row_height -2, row_height - 2)
    self.frame_color_control:SetPosition(250 - 10 - row_height +1 , row*row_height +1)
    self.frame_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.frame_color_control:SetMouseVisible(true)
    self.frame_color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.frame_color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.frame_color_control:SetBackColor(newColor)
            self.frame_color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.frame_color_tb = Turbine.UI.Lotro.TextBox()
    self.frame_color_tb:SetSize(100 , row_height)
    self.frame_color_tb:SetPosition(250 , row*row_height)
    self.frame_color_tb:SetParent(self.background)
    self.frame_color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.frame_color_tb:SetFont(OPTIONS_FONT)
    self.frame_color_tb.TextChanged = function()
        self.frame_color_lb:SetForeColor(Turbine.UI.Color.Orange)

        local r, g, b = Utils.StringToColor(self.frame_color_tb:GetText())

        if r ~= nil then
            self.frame_color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end
    end

    row = row + 1

    self.back_color_lb = Turbine.UI.Label()
    self.back_color_lb:SetParent(self.background)
    self.back_color_lb:SetFont(OPTIONS_FONT)
    self.back_color_lb:SetSize(100, row_height)
    self.back_color_lb:SetPosition(SPACER, row*row_height)
    self.back_color_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.back_color_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.back_color_lb:SetText(L.back_color)

    self.back_color_control = Turbine.UI.Control()
    self.back_color_control:SetParent(self.background)
    self.back_color_control:SetSize(row_height -2, row_height-2)
    self.back_color_control:SetPosition(250 - 10 - row_height +1, row*row_height+1)
    self.back_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.back_color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.back_color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.back_color_control:SetBackColor(newColor)
            self.back_color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.back_color_tb = Turbine.UI.Lotro.TextBox()
    self.back_color_tb:SetSize(100 , row_height)
    self.back_color_tb:SetPosition(250 , row*row_height)
    self.back_color_tb:SetParent(self.background)
    self.back_color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.back_color_tb:SetFont(OPTIONS_FONT)
    self.back_color_tb.TextChanged = function()
        self.back_color_lb:SetForeColor(Turbine.UI.Color.Orange)

        local r, g, b = Utils.StringToColor(self.back_color_tb:GetText())

        if r ~= nil then
            self.back_color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end
    end

    row = row + 1

    self.bar_color_lb = Turbine.UI.Label()
    self.bar_color_lb:SetParent(self.background)
    self.bar_color_lb:SetFont(OPTIONS_FONT)
    self.bar_color_lb:SetSize(100, row_height)
    self.bar_color_lb:SetPosition(SPACER, row*row_height)
    self.bar_color_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.bar_color_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.bar_color_lb:SetText(L.bar_color)

    self.bar_color_control = Turbine.UI.Control()
    self.bar_color_control:SetParent(self.background)
    self.bar_color_control:SetSize(row_height -2 , row_height- 2)
    self.bar_color_control:SetPosition(250 - 10 - row_height +1, row*row_height+1)
    self.bar_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.bar_color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.bar_color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.bar_color_control:SetBackColor(newColor)
            self.bar_color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.bar_color_tb = Turbine.UI.Lotro.TextBox()
    self.bar_color_tb:SetSize(100 , row_height)
    self.bar_color_tb:SetPosition(250 , row*row_height)
    self.bar_color_tb:SetParent(self.background)
    self.bar_color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.bar_color_tb:SetFont(OPTIONS_FONT)
    self.bar_color_tb.TextChanged = function()
        self.bar_color_lb:SetForeColor(Turbine.UI.Color.Orange)

        local r, g, b = Utils.StringToColor(self.bar_color_tb:GetText())

        if r ~= nil then
            self.bar_color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end
    end

    row = row + 1

    self.timer_color_lb = Turbine.UI.Label()
    self.timer_color_lb:SetParent(self.background)
    self.timer_color_lb:SetFont(OPTIONS_FONT)
    self.timer_color_lb:SetSize(100, row_height)
    self.timer_color_lb:SetPosition(SPACER, row*row_height)
    self.timer_color_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.timer_color_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.timer_color_lb:SetText(L.timer_color)

    self.timer_color_control = Turbine.UI.Control()
    self.timer_color_control:SetParent(self.background)
    self.timer_color_control:SetSize(row_height -2, row_height -2)
    self.timer_color_control:SetPosition(250 - 10 - row_height +1 , row*row_height+1)
    self.timer_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.timer_color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.timer_color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.timer_color_control:SetBackColor(newColor)
            self.timer_color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.timer_color_tb = Turbine.UI.Lotro.TextBox()
    self.timer_color_tb:SetSize(100 , row_height)
    self.timer_color_tb:SetPosition(250 , row*row_height)
    self.timer_color_tb:SetParent(self.background)
    self.timer_color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.timer_color_tb:SetFont(OPTIONS_FONT)
    self.timer_color_tb.TextChanged = function()
        self.timer_color_lb:SetForeColor(Turbine.UI.Color.Orange)

        local r, g, b = Utils.StringToColor(self.timer_color_tb:GetText())

        if r ~= nil then
            self.timer_color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end
    end

    row = row + 1

    self.text_color_lb = Turbine.UI.Label()
    self.text_color_lb:SetParent(self.background)
    self.text_color_lb:SetFont(OPTIONS_FONT)
    self.text_color_lb:SetSize(100, row_height)
    self.text_color_lb:SetPosition(SPACER, row*row_height)
    self.text_color_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.text_color_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.text_color_lb:SetText(L.text_color)

    self.text_color_control = Turbine.UI.Control()
    self.text_color_control:SetParent(self.background)
    self.text_color_control:SetSize(row_height -2, row_height -2)
    self.text_color_control:SetPosition(250 - 10 - row_height  +1, row*row_height +1)
    self.text_color_control:SetBackColor(Turbine.UI.Color.Black)
    self.text_color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.text_color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.text_color_control:SetBackColor(newColor)
            self.text_color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.text_color_tb = Turbine.UI.Lotro.TextBox()
    self.text_color_tb:SetSize(100 , row_height)
    self.text_color_tb:SetPosition(250 , row*row_height)
    self.text_color_tb:SetParent(self.background)
    self.text_color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.text_color_tb:SetFont(OPTIONS_FONT)
    self.text_color_tb.TextChanged = function()
        self.text_color_lb:SetForeColor(Turbine.UI.Color.Orange)

        local r, g, b = Utils.StringToColor(self.text_color_tb:GetText())

        if r ~= nil then
            self.text_color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end
    end

    row = row + 2

    self.font_lb = Turbine.UI.Label()
    self.font_lb:SetParent(self.background)
    self.font_lb:SetFont(OPTIONS_FONT)
    self.font_lb:SetSize(100, row_height)
    self.font_lb:SetPosition(SPACER, row*row_height)
    self.font_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.font_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.font_lb:SetText(L.font)

    self.font_cb = LabelledComboBox(nil, nil, 160)
	self.font_cb:SetParent(self.background)
    self.font_cb:SetPosition(350 -160, row * row_height)
	self.font_cb:AddItem("Arial 12", 1);
	self.font_cb:AddItem("TrajanPro 13", 2);
	self.font_cb:AddItem("TrajanPro 14", 3);
	self.font_cb:AddItem("TrajanPro 15", 4);
	self.font_cb:AddItem("TrajanPro 16", 5);
	self.font_cb:AddItem("TrajanPro 18", 6);
	self.font_cb:AddItem("TrajanPro 19", 7);
	self.font_cb:AddItem("TrajanPro 20", 8);
	self.font_cb:AddItem("TrajanPro 21", 9);
	self.font_cb:AddItem("TrajanPro 23", 10);
	self.font_cb:AddItem("TrajanPro 24", 11);
	self.font_cb:AddItem("TrajanPro 25", 12);
	self.font_cb:AddItem("TrajanPro 26", 13);
	self.font_cb:AddItem("TrajanPro 28", 14);
	self.font_cb:AddItem("TrajanProBold 16", 15);
	self.font_cb:AddItem("TrajanProBold 22", 16);
	self.font_cb:AddItem("TrajanProBold 24", 17);
	self.font_cb:AddItem("TrajanProBold 25", 18);
	self.font_cb:AddItem("TrajanProBold 30", 19);
	self.font_cb:AddItem("TrajanProBold 36", 20);
	self.font_cb:AddItem("Verdana 10", 21);
	self.font_cb:AddItem("Verdana 12", 22);
	self.font_cb:AddItem("Verdana 14", 23);
	self.font_cb:AddItem("Verdana 16", 24);
	self.font_cb:AddItem("Verdana 18", 25);
	self.font_cb:AddItem("Verdana 20", 26);
	self.font_cb:AddItem("Verdana 22", 27);
    self.font_cb:AddItem("Verdana 23", 28);

    row = row + 1

    self.number_format_lb = Turbine.UI.Label()
    self.number_format_lb:SetParent(self.background)
    self.number_format_lb:SetFont(OPTIONS_FONT)
    self.number_format_lb:SetSize(100, row_height)
    self.number_format_lb:SetPosition(SPACER, row*row_height)
    self.number_format_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.number_format_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.number_format_lb:SetText(L.number_format)

    self.number_format_cb = LabelledComboBox(nil, nil, 160)
	self.number_format_cb:SetParent(self.background)
    self.number_format_cb:SetPosition(350 -160, row * row_height)
    for k,v in ipairs(NUMBER_FORMAT) do
        self.number_format_cb:AddItem(v, k)
    end

    row = row + 2

    self.transparency1_lb = Turbine.UI.Label()
    self.transparency1_lb:SetParent(self.background)
    self.transparency1_lb:SetFont(OPTIONS_FONT)
    self.transparency1_lb:SetSize(100, row_height*2)
    self.transparency1_lb:SetPosition(SPACER, row*row_height)
    self.transparency1_lb:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.transparency1_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.transparency1_lb:SetText(L.transparency1)

    self.transparency1_value = Turbine.UI.Lotro.TextBox()
    self.transparency1_value:SetParent(self.background)
    self.transparency1_value:SetFont(OPTIONS_FONT)
    self.transparency1_value:SetSize(40, row_height)
    self.transparency1_value:SetPosition(135, row*row_height)
    self.transparency1_value:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.transparency1_value:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.transparency1_value.TextChanged = function()
        self.transparency1_lb:SetForeColor(Turbine.UI.Color.Orange)
    end


    self.transparency1_bar = Turbine.UI.Lotro.ScrollBar()
    self.transparency1_bar:SetOrientation(Turbine.UI.Orientation.Horizontal)
    self.transparency1_bar:SetParent(self.background)
    self.transparency1_bar:SetPosition(190, row*row_height + 5)
    self.transparency1_bar:SetWidth(160)
    self.transparency1_bar:SetHeight(10)
    self.transparency1_bar:SetValue(50)
    self.transparency1_bar:SetBackColor(COLOR_LIGHT_GRAY)
    self.transparency1_bar.ValueChanged = function()
        self.transparency1_value:SetText(self.transparency1_bar:GetValue()/100)
        self.transparency1_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.transparency2_lb = Turbine.UI.Label()
    self.transparency2_lb:SetParent(self.background)
    self.transparency2_lb:SetFont(OPTIONS_FONT)
    self.transparency2_lb:SetSize(100, row_height*2)
    self.transparency2_lb:SetPosition(SPACER, row*row_height)
    self.transparency2_lb:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.transparency2_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.transparency2_lb:SetText(L.transparency2)

    self.transparency2_value = Turbine.UI.Lotro.TextBox()
    self.transparency2_value:SetParent(self.background)
    self.transparency2_value:SetFont(OPTIONS_FONT)
    self.transparency2_value:SetSize(40, row_height)
    self.transparency2_value:SetPosition(135, row*row_height)
    self.transparency2_value:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.transparency2_value:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.transparency2_value.TextChanged = function()
        self.transparency2_lb:SetForeColor(Turbine.UI.Color.Orange)
    end


    self.transparency2_bar = Turbine.UI.Lotro.ScrollBar()
    self.transparency2_bar:SetOrientation(Turbine.UI.Orientation.Horizontal)
    self.transparency2_bar:SetParent(self.background)
    self.transparency2_bar:SetPosition(190, row*row_height + 5)
    self.transparency2_bar:SetWidth(160)
    self.transparency2_bar:SetHeight(10)
    self.transparency2_bar:SetValue(50)
    self.transparency2_bar:SetBackColor(COLOR_LIGHT_GRAY)
    self.transparency2_bar.ValueChanged = function()
        self.transparency2_value:SetText(self.transparency2_bar:GetValue()/100)
        self.transparency2_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.trigger_id_lb = Turbine.UI.Label()
    self.trigger_id_lb:SetParent(self.background)
    self.trigger_id_lb:SetFont(OPTIONS_FONT)
    self.trigger_id_lb:SetSize(70, row_height)
    self.trigger_id_lb:SetPosition(SPACER, row*row_height)
    self.trigger_id_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.trigger_id_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.trigger_id_lb:SetText(L.trigger_id)

    self.trigger_id_cb = LabelledComboBox(nil, nil, 160)
	self.trigger_id_cb:SetParent(self.background)
    self.trigger_id_cb:SetPosition(350 -160, row * row_height)
    -- for k,v in ipairs(NUMBER_FORMAT) do
    --     self.number_format_cb:AddItem(v, k)
    -- end

    row = row + 2

    self.ascending_lb = Turbine.UI.Label()
    self.ascending_lb:SetParent(self.background)
    self.ascending_lb:SetFont(OPTIONS_FONT)
    self.ascending_lb:SetSize(100, row_height)
    self.ascending_lb:SetPosition(SPACER, row*row_height)
    self.ascending_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.ascending_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.ascending_lb:SetText(L.ascending)
    

    self.ascending_cb =  Turbine.UI.Lotro.CheckBox()
	self.ascending_cb:SetParent(self.background)
    self.ascending_cb:SetSize(120, 25)
    self.ascending_cb:SetFont(OPTIONS_FONT)
    self.ascending_cb:SetText("")
    self.ascending_cb:SetPosition(100, row* row_height)
    self.ascending_cb.CheckedChanged = function()
        self.ascending_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.orientation_lb = Turbine.UI.Label()
    self.orientation_lb:SetParent(self.background)
    self.orientation_lb:SetFont(OPTIONS_FONT)
    self.orientation_lb:SetSize(100, row_height)
    self.orientation_lb:SetPosition(SPACER, row*row_height)
    self.orientation_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.orientation_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.orientation_lb:SetText(L.orientation)

    self.orientation_cb =  Turbine.UI.Lotro.CheckBox()
	self.orientation_cb:SetParent(self.background)
    self.orientation_cb:SetSize(120, 25)
    self.orientation_cb:SetFont(OPTIONS_FONT)
    self.orientation_cb:SetText("")
    self.orientation_cb:SetPosition(100, row* row_height)
    self.orientation_cb.CheckedChanged = function()
        self.orientation_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.overlay_lb = Turbine.UI.Label()
    self.overlay_lb:SetParent(self.background)
    self.overlay_lb:SetFont(OPTIONS_FONT)
    self.overlay_lb:SetSize(100, row_height)
    self.overlay_lb:SetPosition(SPACER, row*row_height)
    self.overlay_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.overlay_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.overlay_lb:SetText(L.overlay)

    self.overlay_cb =  Turbine.UI.Lotro.CheckBox()
	self.overlay_cb:SetParent(self.background)
    self.overlay_cb:SetSize(120, 25)
    self.overlay_cb:SetFont(OPTIONS_FONT)
    self.overlay_cb:SetText("")
    self.overlay_cb:SetPosition(100, row* row_height)
    self.overlay_cb.CheckedChanged = function()
        self.overlay_lb:SetForeColor(Turbine.UI.Color.Orange)
    end


    self.edit_default_button = Turbine.UI.Lotro.Button()
    self.edit_default_button:SetParent(self)
    self.edit_default_button:SetSize(115,20)
    self.edit_default_button:SetPosition(350 - 100, 5)
    self.edit_default_button:SetText(L.editDefault)
    self.edit_default_button:SetVisible(true)
    self.edit_default_button.MouseClick = function()

        self:ChangeToDefaultMode()

    end

    self.reset_to_default_button = Turbine.UI.Lotro.Button()
    self.reset_to_default_button:SetParent(self.background)
    self.reset_to_default_button:SetSize(120,20)
    self.reset_to_default_button:SetPosition(140, row*row_height)
    self.reset_to_default_button:SetText(L.resetToDefault)
    self.reset_to_default_button:SetVisible(true)
    self.reset_to_default_button.MouseClick = function()

        self:ResetToDefault()

    end

    self.save_button = Turbine.UI.Lotro.Button()
    self.save_button:SetParent(self.background)
    self.save_button:SetSize(80,20)
    self.save_button:SetPosition(350 - 80, row*row_height)
    self.save_button:SetText(L.save)
    self.save_button:SetVisible(true)
    self.save_button.MouseClick = function()

        self:Save()

    end


    
    function self.background:FillSelected(value, sender)

        if sender == self:GetParent().window_type_cb then
            self:GetParent().window_type_lb:SetForeColor(Turbine.UI.Color.Orange)

            self:GetParent():ResetToDefault(false)
            --self:GetParent():DefaultPosFix()
            if  self:GetParent().default_edit_mode == true then
                self:GetParent().name_tb:SetText(L.defaultEditMode..WINDOW_TYPE[ self:GetParent().window_type_cb:GetSelection()])
            end
            self:GetParent():ResetEditColors()

        elseif sender == self:GetParent().font_cb then
            self:GetParent().font_lb:SetForeColor(Turbine.UI.Color.Orange)

        elseif sender == self:GetParent().number_format_cb then
            self:GetParent().number_format_lb:SetForeColor(Turbine.UI.Color.Orange)
        end
    
    end

    self:Resize()

    self:SetVisible(true)

end