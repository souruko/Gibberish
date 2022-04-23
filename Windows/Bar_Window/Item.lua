
Item = class( Turbine.UI.Window )

function Item:Constructor(parent, data, key)
	Turbine.UI.Window.Constructor( self )

    self.parent = parent 
    self.token = string.gsub(data.token , "-", "")
    self.key = key
    self.data = data

    self.start_time = 0
    self.duration = 0
    self.endtime = 0
    self.first_threshold_frame = true

    self.text = data.text
    self.icon = data.icon

    self:Build()
    self:SetActiv(false)

end


---------------------------------------------------------------------------------------------------------
--public

function Item:GetReloadData()

    local list = {}

    list.token = self.token
    list.key = self.key
    list.parent = self.parent.index
    list.text = self.text
    list.icon = self.icon
    list.start_time = self.start_time
    list.duration = self.duration
    list.data = self.data

    return list

end

function Item:WillReset()

    return self.data.reset

end

function Item:Reset()

    self:ShutDown()

end

function Item:UpdateParameter(start_time, duration, icon, text, key, entity)
    
    self.key = key
    self.start_time = start_time
    self.duration = duration
    self.endtime = self.start_time + self.duration
    self.first_threshold_frame = true

    Trigger.Timer.CheckForWaitingTimerStart(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    if icon ~= nil then
        self.icon = icon
    end

    if text ~= nil then
        self.text = text
    end

    self.text_label:SetText(self.text)
    self.entity_control:SetEntity(entity)
    
    --self:ParameterChanged()

end

function Item:DataChanged()
    
    local frame = savedata[self.parent.index].frame
    local height, full_width, full_height

    self.orientation = savedata[self.parent.index].orientation
    self.number_format = savedata[self.parent.index].number_format
    self.max_bar = savedata[self.parent.index].width

    height = savedata[self.parent.index].height
    full_width = self.max_bar + (3*frame) + height
    full_height = height + (2*frame) + savedata[self.parent.index].spacing

    if self.orientation then

        self:SetSize(full_width, full_height)

        self.icon_control:SetSize(height, height)
        self.icon_control:SetPosition(frame, frame)
    
        self.frame:SetSize(full_width, height + (2*frame))
        self.background:SetSize(self.max_bar, height)
        self.background:SetPosition(height + (2*frame), frame)
    
        self.bar_back:SetSize(self.max_bar , height)
        self.bar_back:SetPosition(height + (2*frame), frame)
        self.bar:SetHeight(height)
    
        self.label_back:SetSize(self.max_bar -3 , height)
        self.label_back:SetPosition(height + (2*frame), frame)
        self.text_label:SetSize(self.max_bar -3 -30 , height)
        self.timer_label:SetSize(self.max_bar -3, height)
        self.entity_control:SetSize(full_width, full_height)

        self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
        self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)


    else

        self:SetSize(full_height, full_width)

        self.icon_control:SetSize(height, height)
        self.icon_control:SetPosition(frame, frame)
    
        self.frame:SetSize(height + (2*frame), full_width)
        self.background:SetSize(height, self.max_bar)
        self.background:SetPosition(frame, height + (2*frame))
    
        self.bar_back:SetSize(height, self.max_bar)
        self.bar_back:SetPosition(frame, height + (2*frame))
        self.bar:SetWidth(height)
    
        self.label_back:SetSize(height , self.max_bar -3)
        self.label_back:SetPosition(frame, height + (2*frame))
        self.text_label:SetSize(height, self.max_bar -3 - 30)
        self.timer_label:SetSize(height, self.max_bar -3)
        self.entity_control:SetSize(full_width, full_height)
        
        self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)
        self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter)

    end

    self.frame:SetBackColor(Utils.ColorFix(savedata[self.parent.index].frame_color))
    self.background_color = Utils.ColorFix(savedata[self.parent.index].back_color)
    self.background:SetBackColor(self.background_color)
    self.bar:SetBackColor(Utils.ColorFix(savedata[self.parent.index].bar_color))

    self.text_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_2))
    self.timer_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_1))
    self.timer_label:SetVisible(not(self.data.hide_timer))

    self.opacity = savedata[self.parent.index].opacity
    self.opacity2 = savedata[self.parent.index].opacity2
    self:SetOpacity(self.opacity)
    --self.icon_control:SetOpacity(opacity)

    if self.data.use_target_entity then
        self.entity_control:SetMouseVisible(true)
    else
        self.entity_control:SetMouseVisible(false)
    end

    self.text_label:SetFont(Utils.findfont(savedata[self.parent.index].font))
    self.timer_label:SetFont(Utils.findfont(savedata[self.parent.index].font))

    self.text_label:SetText(self.text)


end

function Item:ParameterChanged()

    if self.icon == nil then
        self.icon_control:SetBackColor(Utils.ColorFix(savedata[self.parent.index].back_color))
    else
        self.icon_control:SetSize(Utils.GetImageSize(self.icon))
        self.icon_control:SetStretchMode(1)
        self.icon_control:SetBackground(self.icon)
        self.icon_control:SetSize(savedata[self.parent.index].height, savedata[self.parent.index].height)
    end

    self.text_label:SetText(self.text)
    
end

---------------------------------------------------------------------------------------------------------
--private

function Item:SetActiv(bool)

    if bool == true then

        self:SetWantsUpdates(true)
        self:SetOpacity(self.opacity)
        self.icon_control:SetOpacity(1)
        self.label_back:SetOpacity(1)

    else

        self:SetWantsUpdates(false)
        self.bar:SetWidth(0)
        self.background:SetBackColor(self.background_color)
        self:SetOpacity(self.opacity2)
        self.icon_control:SetOpacity(self.opacity2)
        self.label_back:SetOpacity(self.opacity2)
        self.timer_label:SetText("")
        self.text_label:SetText("")

    end

end

function Item:Loop()

    self:UpdateParameter(Turbine.Engine.GetGameTime(), self.duration, nil, nil)

end

function Item:ShutDown()
    Trigger.Timer.CheckForWaitingTimerEnd(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    self:SetActiv(false)
end

function Item:Update()
    
    local gt = Turbine.Engine.GetGameTime()
    local time_left = self.endtime - gt

    if time_left < 0 then
        if self.data.loop == true then
            self:Loop()
        else
            self:ShutDown()
        end
        return
    end

    if time_left < 99999 then

        if self.data.inkrement == true then
            self.timer_label:SetText(Utils.SecondsToClock( (self.duration - time_left), self.number_format))

            if self.orientation then
                self.bar:SetWidth((self.duration - time_left)/self.duration*self.max_bar)
            else
                self.bar:SetHeight((self.duration - time_left)/self.duration*self.max_bar)
            end

        else
            self.timer_label:SetText(Utils.SecondsToClock(time_left, self.number_format))

            if self.orientation then
                self.bar:SetWidth(time_left/self.duration*self.max_bar)
            else
                self.bar:SetHeight(time_left/self.duration*self.max_bar)
            end
        end

        if self.data.use_threshold == true then

            if time_left <= self.data.threshold then

                if self.first_threshold_frame == true then
                    self.first_threshold_frame = false
                    Trigger.Timer.CheckForWaitingTimerThreshold(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)
                end

                if self.data.flashing == true then
                    local value
                    local flash_value = time_left * self.data.flashing_multi
                    if math.floor(flash_value) % 2 == 0 then
                        value = 1-(flash_value-math.floor(flash_value))
                    else
                        value = (flash_value-math.floor(flash_value))
                    end
        
                    self.background:SetBackColor(Turbine.UI.Color(1, value, value))
                else
                    self.background:SetBackColor(Turbine.UI.Color.Red)
                end
                
            else
                self.background:SetBackColor(self.background_color)
            end

        end

	else
		self.timer_label:SetText("")
		self.bar:SetWidth(0)
	end

end

function Item:Build()

    self.entity_control = Turbine.UI.Lotro.EntityControl()
    self.entity_control:SetParent(self)

    self.icon_control = Turbine.UI.Control()
    self.icon_control:SetParent(self)
    self.icon_control:SetMouseVisible(false)
    self.icon_control:SetZOrder(4)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetMouseVisible(false)
    self.frame:SetZOrder(2)
    self.background = Turbine.UI.Control()
    self.background:SetParent(self.frame)
    self.background:SetMouseVisible(false)

    self.bar_back = Turbine.UI.Window()
    self.bar_back:SetParent(self)
    self.bar_back:SetMouseVisible(false)
    self.bar_back:SetZOrder(5)
    self.bar = Turbine.UI.Control()
    self.bar:SetParent(self.bar_back)
    self.bar:SetMouseVisible(false)
    self.bar:SetWidth(0)

    self.label_back = Turbine.UI.Window()
    self.label_back:SetParent(self)
    self.label_back:SetMouseVisible(false)
    self.label_back:SetZOrder(10)
    self.text_label = Turbine.UI.Label()
    self.text_label:SetParent(self.label_back)
    self.text_label:SetMouseVisible(false)
    self.text_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.timer_label = Turbine.UI.Label()
    self.timer_label:SetParent(self.label_back)
    self.timer_label:SetMouseVisible(false)
    self.timer_label:SetFontStyle(Turbine.UI.FontStyle.Outline)

    self:ParameterChanged()
    self:DataChanged()


    if self.orientation then
        self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
        self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    else
        self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)
        self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter)
    end

    self.bar_back:SetVisible(true)
    self.label_back:SetVisible(true)
    self:SetVisible(true)

end