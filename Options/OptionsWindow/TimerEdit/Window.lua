--[[
    OptionsWindow child for timer information
]]

Window = class( Turbine.UI.Lotro.Window )

function Window:Constructor(parent)
    Turbine.UI.Lotro.Window.Constructor( self )

    self.parent = parent

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Window:EffectControlClicked(token, icon, duration)
    self.timer_settings:EffectControlClicked(token, icon, duration)
end

function Window:ChatControlClicked(token, icon, duration)
    self.timer_settings:ChatControlClicked(token, icon, duration)
end

function Window:SkillControlClicked(token, icon, duration)
    self.timer_settings:SkillControlClicked(token, icon, duration)
end

function Window:TimerControlClicked(token, icon, duration)
    self.timer_settings:TimerControlClicked(token, icon, duration)
end

function Window:SetContent(window_index, timer_type, timer_index)

    self:SetVisible(true)
    self:SetText("- "..TRIGGER_TYPE[timer_type].." -")

    self.timer_settings:SetContent(window_index, timer_type, timer_index)

end

function Window:UpdateTimerItem(window_index, timer_type, timer_index)

    self.parent:UpdateTimerItem(window_index, timer_type, timer_index)

end

function Window:CollectionChanged()

    self.collection_overview:CollectionChanged()

end

---------------------------------------------------------------------------------------------------------
--private

function Window:Build()

    self.timer_settings = TimerSettings(self)
    self.collection_overview = CollectionOverview(self)

    local width = optionsdata.timer_edit.width
    local height = math.max(optionsdata.timer_edit.height, OPTIONS_TIMEREDIT_HEIGHT)

    self:SetPosition(optionsdata.timer_edit.left, optionsdata.timer_edit.top)
    self:SetSize(width, height)
    self:SetResizable(true)
    self:SetMinimumSize(width, OPTIONS_TIMEREDIT_HEIGHT)
    self:SetMaximumWidth(width)
    self:SetZOrder(14)

end

function Window:SizeChanged()

    self.timer_settings:Resize(self:GetHeight())
    self.collection_overview:Resize(self:GetHeight())


    optionsdata.timer_edit.width, optionsdata.timer_edit.height = self:GetSize()
    SaveOptions()

end

function Window:PositionChanged()

    optionsdata.timer_edit.left, optionsdata.timer_edit.top = self:GetPosition()
    SaveOptions()

end

function Window:Closed()

    optionsdata.timer_edit.open = false
    SaveOptions()

end