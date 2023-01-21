--[[
    TimerEdit child for displaying timer information
]]

TimerSettings = class( Turbine.UI.Control )

function TimerSettings:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.window_index = nil
    self.timer_type = nil
    self.timer_index = nil

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function TimerSettings:EffectControlClicked(token, icon, duration)

    if self.timer_type == TRIGGER_TYPE.Effect_Self or self.timer_type == TRIGGER_TYPE.Effect_Group or self.timer_type == TRIGGER_TYPE.Effect_Target then

        if token ~= nil and token ~= "" then
            self.token_tb:SetText(token)
        end

        if duration ~= nil and duration ~= "" then
            self.time_tb:SetText(duration)
        end

    end

    if icon ~= nil and icon ~= "" then
        self.icon_control:SetBackground(icon)
        self.icon_tb:SetText(icon)
    end

end

function TimerSettings:ChatControlClicked(token, icon, duration)

    if self.timer_type == TRIGGER_TYPE.Chat then

        if token ~= nil and token ~= "" then
            self.token_tb:SetText(token)
        end

    end

end

function TimerSettings:SkillControlClicked(token, icon, duration)

    if self.timer_type == TRIGGER_TYPE.Skill then

        if token ~= nil and token ~= "" then
            self.token_tb:SetText(token)
        end

        if duration ~= nil and duration ~= "" then
            self.time_tb:SetText(duration)
        end

    end

    if icon ~= nil and icon ~= "" then
        self.icon_control:SetBackground(icon)
        self.icon_tb:SetText(icon)
    end

end

function TimerSettings:TimerControlClicked(token, icon, duration)

    if self.timer_type == TRIGGER_TYPE.Timer_End or self.timer_type == TRIGGER_TYPE.Timer_Start or self.timer_type == TRIGGER_TYPE.Timer_Threshold then

        if token ~= nil and token ~= "" then
            self.token_tb:SetText(token)
        end

    end

    if icon ~= nil and icon ~= "" then
        self.icon_control:SetBackground(icon)
        self.icon_tb:SetText(icon)
    end

end


function TimerSettings:Resize(height)

    self:SetHeight(height - TOP_BAR - 3*FRAME - SPACER)
    self.background:SetHeight(self:GetHeight() - 2*FRAME - TOP_BAR)

    self.close:SetTop( self:GetHeight() - 20 - FRAME)
    self.reset_changes:SetTop(self:GetHeight() - 20 - FRAME)
    self.save:SetTop(self:GetHeight() - 20 - FRAME)


end

function TimerSettings:SetContent(window_index, timer_type, timer_index)

    self.window_index = window_index
    self.timer_type = timer_type
    self.timer_index = timer_index

    self:FillInformation()
    self:ResetColors()

end

---------------------------------------------------------------------------------------------------------
--private

function TimerSettings:SaveChanges()

    if self.window_index == nil or self.timer_type == nil or self.timer_index == nil then
        return
    end

    local data = savedata[self.window_index][self.timer_type][self.timer_index]

    data.description = self.description_tb:GetText()
    self.description_lb:SetForeColor(Turbine.UI.Color.White)

    data.token = self.token_tb:GetText()
    self.token_lb:SetForeColor(Turbine.UI.Color.White)

    local tm = self.textmodifier_cb:GetSelection()
    if tm ~= nil then
        data.text_modifier = tm
    else
        data.text_modifier = TEXTMODIFIER.Let_the_plugin_decide
    end
    data.text = self.text_tb:GetText()
    self.text_lb:SetForeColor(Turbine.UI.Color.White)

    local icon_id = self.icon_tb:GetText()
    if icon_id == "" then
        data.icon = nil
    else
        data.icon = tonumber(icon_id)
    end
    self.icon_lb:SetForeColor(Turbine.UI.Color.White)

    data.custom_timer = self.time_cb:IsChecked()
    data.timer = tonumber(self.time_tb:GetText())
    self.time_lb:SetForeColor(Turbine.UI.Color.White)

    data.use_threshold = self.threshold_cb:IsChecked()
    data.threshold = tonumber(self.threshold_tb:GetText())
    self.threshold_lb:SetForeColor(Turbine.UI.Color.White)

    data.flashing = self.flashing_cb:IsChecked()
    data.flashing_multi = tonumber(self.flashing_tb:GetText())
    self.flashing_lb:SetForeColor(Turbine.UI.Color.White)

    data.unique = self.unique_cb:IsChecked()
    data.reset = self.reset_cb:IsChecked()
    data.loop = self.loop_cb:IsChecked()

    data.use_regex = self.use_regex_cb:IsChecked()
    data.removable = self.removable_cb:IsChecked()
    data.hide_timer = self.hide_timer_cb:IsChecked()

    data.increment = self.increment_cb:IsChecked()
    data.show_grey = self.grey_cb:IsChecked()
    data.use_target_entity = self.use_target_entity_cb:IsChecked()

    data.target_list = Utils.TargetStringToList( self.target_list_tb:GetText() )

    local counter_start = self.counter_start_tb:GetText()
    if counter_start ~= "" then
        data.counter_start = counter_start
    else
        data.counter_start = nil
    end

    SaveWindowData()
    Windows.WindowDataChanged(self.window_index)

    if self.timer_type == TRIGGER_TYPE.Skill then
        Trigger.refreshAllSkillCallbacks()
    end

end


function TimerSettings:ResetColors()

    self.description_lb:SetForeColor(Turbine.UI.Color.White)
    self.token_lb:SetForeColor(Turbine.UI.Color.White)
    self.text_lb:SetForeColor(Turbine.UI.Color.White)
    self.icon_lb:SetForeColor(Turbine.UI.Color.White)
    self.time_lb:SetForeColor(Turbine.UI.Color.White)
    self.threshold_lb:SetForeColor(Turbine.UI.Color.White)
    self.flashing_lb:SetForeColor(Turbine.UI.Color.White)
    self.unique_lb:SetForeColor(Turbine.UI.Color.White)
    self.reset_lb:SetForeColor(Turbine.UI.Color.White)
    self.loop_lb:SetForeColor(Turbine.UI.Color.White)
    self.use_regex_lb:SetForeColor(Turbine.UI.Color.White)
    self.removable_lb:SetForeColor(Turbine.UI.Color.White)
    self.hide_timer_lb:SetForeColor(Turbine.UI.Color.White)
    self.target_list_lb:SetForeColor(Turbine.UI.Color.White)
    self.use_target_entity_lb:SetForeColor(Turbine.UI.Color.White)
    self.increment_lb:SetForeColor(Turbine.UI.Color.White)
    self.grey_lb:SetForeColor(Turbine.UI.Color.White)

end

function TimerSettings:Empty()

    self.description_tb:SetText("")
    self.token_tb:SetText("")

    self.textmodifier_cb:SetSelection(nil)
    self.text_tb:SetText("")

    self.time_cb:SetChecked(false)
    self.time_tb:SetText("")

    self.threshold_cb:SetChecked(false)
    self.threshold_tb:SetText("")

    self.flashing_cb:SetChecked(false)
    self.flashing_tb:SetText("")

    self.unique_cb:SetChecked(false)
    self.reset_cb:SetChecked(false)
    self.loop_cb:SetChecked(false)

    self.use_regex_cb:SetChecked(false)
    self.removable_cb:SetChecked(false)
    self.hide_timer_cb:SetChecked(false)
    self.use_target_entity_cb:SetChecked(false)
    self.increment_cb:SetChecked(false)
    self.grey_cb:SetChecked(false)
    self.hide_timer_cb:SetChecked(false)
    self.target_list_tb:SetText("")
    self.counter_start:SetText("")

end

function TimerSettings:FillInformation()

    if self.window_index == nil or self.timer_type == nil or self.timer_index == nil then
        self:Empty()
        return
    end

    local data = savedata[self.window_index][self.timer_type][self.timer_index]

    self.description_tb:SetText(data.description)
    self.token_tb:SetText(data.token)

    self.textmodifier_cb:SetSelection(data.text_modifier)
    self.text_tb:SetText(data.text)

    self.icon_tb:SetText(data.icon)
    self.icon_control:SetSize(32,32)
    self.icon_control:SetBackground(data.icon)
    self.icon_control:SetStretchMode(1)
    self.icon_control:SetSize(100,100)

    self.time_cb:SetChecked(data.custom_timer)
    self.time_tb:SetText(data.timer)

    self.threshold_cb:SetChecked(data.use_threshold)
    self.threshold_tb:SetText(data.threshold)

    self.flashing_cb:SetChecked(data.flashing)
    self.flashing_tb:SetText(data.flashing_multi)

    self.unique_cb:SetChecked(data.unique)
    self.loop_cb:SetChecked(data.loop)
    self.reset_cb:SetChecked(data.reset)

    self.use_regex_cb:SetChecked(data.use_regex)
    self.removable_cb:SetChecked(data.removable)
    self.hide_timer_cb:SetChecked(data.hide_timer)

    self.increment_cb:SetChecked(data.increment)
    self.grey_cb:SetChecked(data.show_grey)
    self.use_target_entity_cb:SetChecked(data.use_target_entity)

    self.target_list_tb:SetText( Utils.TargetListToString( data.target_list ) )

    self.counter_start_tb:SetText(data.counter_start)

end

TIMERSETTINGS_WIDTH = 400

function TimerSettings:Build()

    self:SetParent(self.parent)
    self:SetPosition(FRAME, TOP_BAR + SPACER +FRAME)
    self:SetSize(TIMERSETTINGS_WIDTH + 2*FRAME, optionsdata.timer_edit.height - TOP_BAR - 3*FRAME - SPACER)
    self:SetBackColor(COLOR_LIGHT_GRAY)


    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, FRAME)
    self.background:SetSize(self:GetWidth() - 2*FRAME, self:GetHeight() - 2*FRAME - TOP_BAR)

    local row_height = 20
    local row = 1
    
    local column1 = SPACER
    local column2 = 200 + SPACER


    self.description_lb = Turbine.UI.Label()
    self.description_lb:SetParent(self.background)
    self.description_lb:SetFont(OPTIONS_FONT)
    self.description_lb:SetSize(100, row_height)
    self.description_lb:SetPosition(SPACER, row*row_height)
    self.description_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.description_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.description_lb:SetText(L.description)

    self.description_tb = Turbine.UI.Lotro.TextBox()
    self.description_tb:SetSize(TIMERSETTINGS_WIDTH - 2*SPACER - 100 , 74)
    self.description_tb:SetPosition(SPACER + 100, row*row_height)
    self.description_tb:SetParent(self.background)
    self.description_tb:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.description_tb:SetFont(OPTIONS_FONT)
    self.description_tb.TextChanged = function()
        self.description_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 4

    self.token_lb = Turbine.UI.Label()
    self.token_lb:SetParent(self.background)
    self.token_lb:SetFont(OPTIONS_FONT)
    self.token_lb:SetSize(50, row_height)
    self.token_lb:SetPosition(SPACER, row*row_height)
    self.token_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.token_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.token_lb:SetText(L.token)

    self.token_tb = Turbine.UI.Lotro.TextBox()
    self.token_tb:SetSize(TIMERSETTINGS_WIDTH - 2*SPACER - 100 , 74)
    self.token_tb:SetPosition(SPACER + 100, row*row_height)
    self.token_tb:SetParent(self.background)
    self.token_tb:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.token_tb:SetFont(OPTIONS_FONT)
    self.token_tb.TextChanged = function()
        self.token_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 4

    self.text_lb = Turbine.UI.Label()
    self.text_lb:SetParent(self.background)
    self.text_lb:SetFont(OPTIONS_FONT)
    self.text_lb:SetSize(100, row_height)
    self.text_lb:SetPosition(SPACER, row*row_height)
    self.text_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.text_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.text_lb:SetText(L.text)

    self.textmodifier_cb = LabelledComboBox(nil, nil, 160)
	self.textmodifier_cb:SetParent(self.background)
    self.textmodifier_cb:SetPosition(SPACER + 50, row * row_height)
    for k,v in ipairs(TEXTMODIFIER) do
        self.textmodifier_cb:AddItem(v, k)
    end

    self.text_tb = Turbine.UI.Lotro.TextBox()
    self.text_tb:SetSize(TIMERSETTINGS_WIDTH - SPACER - 230 , 20)
    self.text_tb:SetPosition(230, row*row_height)
    self.text_tb:SetParent(self.background)
    self.text_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.text_tb:SetFont(OPTIONS_FONT)
    self.text_tb.TextChanged = function()
        self.text_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    self.background.FillSelected = function(sender, value)
        self.text_lb:SetForeColor(Turbine.UI.Color.Orange)
        
        if value ~= TEXTMODIFIER.Custom_Text then
            self.text_tb:SetEnabled(false)
        else
            self.text_tb:SetEnabled(true)
        end

    end

    row = row + 2

    self.icon_lb = Turbine.UI.Label()
    self.icon_lb:SetParent(self.background)
    self.icon_lb:SetFont(OPTIONS_FONT)
    self.icon_lb:SetSize(50, row_height)
    self.icon_lb:SetPosition(column2, row*row_height)
    self.icon_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.icon_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.icon_lb:SetText(L.icon)



    self.icon_frame = Turbine.UI.Control()
    self.icon_frame:SetParent(self.background)
    self.icon_frame:SetSize(104, 104)
    self.icon_frame:SetPosition(48 , row*row_height - 2)
    self.icon_frame:SetBackColor(COLOR_VERY_DARK_GRAY)

    self.icon_control = Turbine.UI.Control()
    self.icon_control:SetParent(self.icon_frame)
    self.icon_control:SetSize(32, 32)
    self.icon_control:SetPosition(2,2)


    self.icon_tb = Turbine.UI.Lotro.TextBox()
    self.icon_tb:SetSize(100 , row_height)
    self.icon_tb:SetPosition(290, row*row_height)
    self.icon_tb:SetParent(self.background)
    self.icon_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.icon_tb:SetFont(OPTIONS_FONT)
    self.icon_tb.TextChanged = function()
        self.icon_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.time_lb = Turbine.UI.Label()
    self.time_lb:SetParent(self.background)
    self.time_lb:SetFont(OPTIONS_FONT)
    self.time_lb:SetSize(100, row_height)
    self.time_lb:SetPosition(column2, row*row_height)
    self.time_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.time_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.time_lb:SetText(L.custom_timer)

    self.time_cb =  Turbine.UI.Lotro.CheckBox()
	self.time_cb:SetParent(self.background)
    self.time_cb:SetSize(20, 20)
    self.time_cb:SetFont(OPTIONS_FONT)
    self.time_cb:SetText("")
    self.time_cb:SetPosition(400 - 50  - 35, row*row_height)
    self.time_cb:SetChecked()
    self.time_cb.CheckedChanged = function()
        self.time_lb:SetForeColor(Turbine.UI.Color.Orange)
        
        self.time_tb:SetEnabled(self.time_cb:IsChecked())
    end

    self.time_tb = Turbine.UI.Lotro.TextBox()
    self.time_tb:SetSize(50 , 20)
    self.time_tb:SetPosition(400 - 60 , row*row_height)
    self.time_tb:SetParent(self.background)
    self.time_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.time_tb:SetFont(OPTIONS_FONT)
    self.time_tb.TextChanged = function()
        self.time_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.threshold_lb = Turbine.UI.Label()
    self.threshold_lb:SetParent(self.background)
    self.threshold_lb:SetFont(OPTIONS_FONT)
    self.threshold_lb:SetSize(100, row_height)
    self.threshold_lb:SetPosition(column2, row*row_height)
    self.threshold_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.threshold_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.threshold_lb:SetText(L.threshold)

    self.threshold_cb =  Turbine.UI.Lotro.CheckBox()
	self.threshold_cb:SetParent(self.background)
    self.threshold_cb:SetSize(20, 20)
    self.threshold_cb:SetFont(OPTIONS_FONT)
    self.threshold_cb:SetText("")
    self.threshold_cb:SetPosition(400 - 60  - 25, row*row_height)
    self.threshold_cb:SetChecked()
    self.threshold_cb.CheckedChanged = function()
        self.threshold_lb:SetForeColor(Turbine.UI.Color.Orange)

        self.threshold_tb:SetEnabled(self.threshold_cb:IsChecked())
    end

    self.threshold_tb = Turbine.UI.Lotro.TextBox()
    self.threshold_tb:SetSize(50 , 20)
    self.threshold_tb:SetPosition(400 - 60 , row*row_height)
    self.threshold_tb:SetParent(self.background)
    self.threshold_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.threshold_tb:SetFont(OPTIONS_FONT)
    self.threshold_tb.TextChanged = function()
        self.threshold_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.flashing_lb = Turbine.UI.Label()
    self.flashing_lb:SetParent(self.background)
    self.flashing_lb:SetFont(OPTIONS_FONT)
    self.flashing_lb:SetSize(100, row_height)
    self.flashing_lb:SetPosition(column2, row*row_height)
    self.flashing_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.flashing_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.flashing_lb:SetText(L.flashing)

    self.flashing_cb =  Turbine.UI.Lotro.CheckBox()
	self.flashing_cb:SetParent(self.background)
    self.flashing_cb:SetSize(20, 20)
    self.flashing_cb:SetFont(OPTIONS_FONT)
    self.flashing_cb:SetText("")
    self.flashing_cb:SetPosition(400 - 60  - 25, row*row_height)
    self.flashing_cb:SetChecked()
    self.flashing_cb.CheckedChanged = function()
        self.flashing_lb:SetForeColor(Turbine.UI.Color.Orange)

        self.flashing_tb:SetEnabled(self.flashing_cb:IsChecked())
    end

    self.flashing_tb = Turbine.UI.Lotro.TextBox()
    self.flashing_tb:SetSize(50 , 20)
    self.flashing_tb:SetPosition(400 - 60 , row*row_height)
    self.flashing_tb:SetParent(self.background)
    self.flashing_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.flashing_tb:SetFont(OPTIONS_FONT)
    self.flashing_tb.TextChanged = function()
        self.flashing_cb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.unique_lb = Turbine.UI.Label()
    self.unique_lb:SetParent(self.background)
    self.unique_lb:SetFont(OPTIONS_FONT)
    self.unique_lb:SetSize(100, row_height)
    self.unique_lb:SetPosition(SPACER, row*row_height)
    self.unique_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.unique_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.unique_lb:SetText(L.unique)

    self.unique_cb =  Turbine.UI.Lotro.CheckBox()
	self.unique_cb:SetParent(self.background)
    self.unique_cb:SetSize(20, 20)
    self.unique_cb:SetFont(OPTIONS_FONT)
    self.unique_cb:SetText("")
    self.unique_cb:SetPosition(200 - 20, row*row_height)
    self.unique_cb:SetChecked()
    self.unique_cb.CheckedChanged = function()
        self.unique_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.reset_lb = Turbine.UI.Label()
    self.reset_lb:SetParent(self.background)
    self.reset_lb:SetFont(OPTIONS_FONT)
    self.reset_lb:SetSize(100, row_height)
    self.reset_lb:SetPosition(SPACER, row*row_height)
    self.reset_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.reset_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.reset_lb:SetText(L.reset)

    self.reset_cb =  Turbine.UI.Lotro.CheckBox()
	self.reset_cb:SetParent(self.background)
    self.reset_cb:SetSize(20, 20)
    self.reset_cb:SetFont(OPTIONS_FONT)
    self.reset_cb:SetText("")
    self.reset_cb:SetPosition(200 - 20, row*row_height)
    self.reset_cb:SetChecked()
    self.reset_cb.CheckedChanged = function()
        self.reset_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.loop_lb = Turbine.UI.Label()
    self.loop_lb:SetParent(self.background)
    self.loop_lb:SetFont(OPTIONS_FONT)
    self.loop_lb:SetSize(100, row_height)
    self.loop_lb:SetPosition(SPACER, row*row_height)
    self.loop_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.loop_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.loop_lb:SetText(L.loop)

    self.loop_cb =  Turbine.UI.Lotro.CheckBox()
	self.loop_cb:SetParent(self.background)
    self.loop_cb:SetSize(20, 20)
    self.loop_cb:SetFont(OPTIONS_FONT)
    self.loop_cb:SetText("")
    self.loop_cb:SetPosition(200 - 20, row*row_height)
    self.loop_cb:SetChecked()
    self.loop_cb.CheckedChanged = function()
        self.loop_lb:SetForeColor(Turbine.UI.Color.Orange)
        local checked = self.loop_cb:IsChecked()
        self.reset_cb:SetChecked(checked)
        self.reset_cb:SetEnabled(not(checked))
    end

    row = row + 1

    self.use_target_entity_lb = Turbine.UI.Label()
    self.use_target_entity_lb:SetParent(self.background)
    self.use_target_entity_lb:SetFont(OPTIONS_FONT)
    self.use_target_entity_lb:SetSize(150, row_height)
    self.use_target_entity_lb:SetPosition(SPACER, row*row_height)
    self.use_target_entity_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.use_target_entity_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.use_target_entity_lb:SetText(L.use_target_entity)

    self.use_target_entity_cb =  Turbine.UI.Lotro.CheckBox()
	self.use_target_entity_cb:SetParent(self.background)
    self.use_target_entity_cb:SetSize(20, 20)
    self.use_target_entity_cb:SetFont(OPTIONS_FONT)
    self.use_target_entity_cb:SetText("")
    self.use_target_entity_cb:SetPosition(200 - 20, row*row_height)
    self.use_target_entity_cb:SetChecked()
    self.use_target_entity_cb.CheckedChanged = function()
        self.use_target_entity_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    local collumn2 = 210
    row = row - 3

    self.use_regex_lb = Turbine.UI.Label()
    self.use_regex_lb:SetParent(self.background)
    self.use_regex_lb:SetFont(OPTIONS_FONT)
    self.use_regex_lb:SetSize(100, row_height)
    self.use_regex_lb:SetPosition(collumn2, row*row_height)
    self.use_regex_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.use_regex_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.use_regex_lb:SetText(L.use_regex)

    self.use_regex_cb =  Turbine.UI.Lotro.CheckBox()
	self.use_regex_cb:SetParent(self.background)
    self.use_regex_cb:SetSize(20, 20)
    self.use_regex_cb:SetFont(OPTIONS_FONT)
    self.use_regex_cb:SetText("")
    self.use_regex_cb:SetPosition(400 - 30, row*row_height)
    self.use_regex_cb:SetChecked()
    self.use_regex_cb.CheckedChanged = function()
        self.use_regex_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.removable_lb = Turbine.UI.Label()
    self.removable_lb:SetParent(self.background)
    self.removable_lb:SetFont(OPTIONS_FONT)
    self.removable_lb:SetSize(100, row_height)
    self.removable_lb:SetPosition(collumn2, row*row_height)
    self.removable_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.removable_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.removable_lb:SetText(L.removable)

    self.removable_cb =  Turbine.UI.Lotro.CheckBox()
	self.removable_cb:SetParent(self.background)
    self.removable_cb:SetSize(20, 20)
    self.removable_cb:SetFont(OPTIONS_FONT)
    self.removable_cb:SetText("")
    self.removable_cb:SetPosition(400 - 30, row*row_height)
    self.removable_cb:SetChecked()
    self.removable_cb.CheckedChanged = function()
        self.removable_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.hide_timer_lb = Turbine.UI.Label()
    self.hide_timer_lb:SetParent(self.background)
    self.hide_timer_lb:SetFont(OPTIONS_FONT)
    self.hide_timer_lb:SetSize(100, row_height)
    self.hide_timer_lb:SetPosition(collumn2, row*row_height)
    self.hide_timer_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.hide_timer_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.hide_timer_lb:SetText(L.hide_timer)

    self.hide_timer_cb =  Turbine.UI.Lotro.CheckBox()
	self.hide_timer_cb:SetParent(self.background)
    self.hide_timer_cb:SetSize(20, 20)
    self.hide_timer_cb:SetFont(OPTIONS_FONT)
    self.hide_timer_cb:SetText("")
    self.hide_timer_cb:SetPosition(400 - 30, row*row_height)
    self.hide_timer_cb:SetChecked()
    self.hide_timer_cb.CheckedChanged = function()
        self.hide_timer_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.increment_lb = Turbine.UI.Label()
    self.increment_lb:SetParent(self.background)
    self.increment_lb:SetFont(OPTIONS_FONT)
    self.increment_lb:SetSize(100, row_height)
    self.increment_lb:SetPosition(collumn2, row*row_height)
    self.increment_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.increment_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.increment_lb:SetText(L.increment)

    self.increment_cb =  Turbine.UI.Lotro.CheckBox()
	self.increment_cb:SetParent(self.background)
    self.increment_cb:SetSize(20, 20)
    self.increment_cb:SetFont(OPTIONS_FONT)
    self.increment_cb:SetText("")
    self.increment_cb:SetPosition(400 - 30, row*row_height)
    self.increment_cb:SetChecked()
    self.increment_cb.CheckedChanged = function()
        self.increment_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 1

    self.grey_lb = Turbine.UI.Label()
    self.grey_lb:SetParent(self.background)
    self.grey_lb:SetFont(OPTIONS_FONT)
    self.grey_lb:SetSize(100, row_height)
    self.grey_lb:SetPosition(collumn2, row*row_height)
    self.grey_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.grey_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.grey_lb:SetText(L.grey)

    self.grey_cb =  Turbine.UI.Lotro.CheckBox()
	self.grey_cb:SetParent(self.background)
    self.grey_cb:SetSize(20, 20)
    self.grey_cb:SetFont(OPTIONS_FONT)
    self.grey_cb:SetText("")
    self.grey_cb:SetPosition(400 - 30, row*row_height)
    self.grey_cb:SetChecked()
    self.grey_cb.CheckedChanged = function()
        self.grey_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 2

    self.target_list_lb = Turbine.UI.Label()
    self.target_list_lb:SetParent(self.background)
    self.target_list_lb:SetFont(OPTIONS_FONT)
    self.target_list_lb:SetSize(100, row_height)
    self.target_list_lb:SetPosition(SPACER, row*row_height)
    self.target_list_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.target_list_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.target_list_lb:SetText(L.target_list)

    self.target_list_tb = Turbine.UI.Lotro.TextBox()
    self.target_list_tb:SetSize(TIMERSETTINGS_WIDTH - 2*SPACER - 100 , 74)
    self.target_list_tb:SetPosition(SPACER + 100, row*row_height)
    self.target_list_tb:SetParent(self.background)
    self.target_list_tb:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.target_list_tb:SetFont(OPTIONS_FONT)
    self.target_list_tb.TextChanged = function()
        self.target_list_lb:SetForeColor(Turbine.UI.Color.Orange)
    end

    row = row + 4

    self.counter_start_lb = Turbine.UI.Label()
    self.counter_start_lb:SetParent(self.background)
    self.counter_start_lb:SetFont(OPTIONS_FONT)
    self.counter_start_lb:SetSize(100, row_height)
    self.counter_start_lb:SetPosition(column2, row*row_height)
    self.counter_start_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.counter_start_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.counter_start_lb:SetText(L.counter_start)

    self.counter_start_tb = Turbine.UI.Lotro.TextBox()
    self.counter_start_tb:SetSize(50 , 20)
    self.counter_start_tb:SetPosition(400 - 60 , row*row_height)
    self.counter_start_tb:SetParent(self.background)
    self.counter_start_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.counter_start_tb:SetFont(OPTIONS_FONT)
    self.counter_start_tb.TextChanged = function()
        self.counter_start_tb:SetForeColor(Turbine.UI.Color.Orange)
    end




    self.close = Turbine.UI.Lotro.Button()
    self.close:SetParent(self)
    self.close:SetSize(80,row_height)
    self.close:SetPosition(FRAME, self:GetHeight() - row_height - FRAME)
    self.close:SetText(L.close)
    self.close:SetVisible(true)
    self.close.MouseClick = function()

        self.parent:SetVisible(false)

    end

    self.reset_changes = Turbine.UI.Lotro.Button()
    self.reset_changes:SetParent(self)
    self.reset_changes:SetSize(120,row_height)
    self.reset_changes:SetPosition(self:GetWidth()/2 - 60, self:GetHeight() - row_height - FRAME)
    self.reset_changes:SetText(L.resetChanges)
    self.reset_changes:SetVisible(true)
    self.reset_changes.MouseClick = function()

        self:FillInformation()
        self:ResetColors()

    end

    self.save = Turbine.UI.Lotro.Button()
    self.save:SetParent(self)
    self.save:SetSize(80,row_height)
    self.save:SetPosition(self:GetWidth() - 80 - FRAME, self:GetHeight() - row_height - FRAME)
    self.save:SetText(L.save)
    self.save:SetVisible(true)
    self.save.MouseClick = function()

        self:SaveChanges()
        self.parent:UpdateTimerItem(self.window_index, self.timer_type, self.timer_index)
        --self.parent:SetVisible(false)
        OptionsWindowTimerEditClose()

    end


end