
Item = class( Turbine.UI.Window )

function Item:Constructor(parent, token, key, start_time, duration, icon, text, data, entity)
	Turbine.UI.Window.Constructor( self )

    self.parent = parent
    self.token = token
    self.key = key
    self.data = data

    self.start_time = start_time
    self.duration = duration
    self.endtime = self.start_time + self.duration
    self.first_threshold_frame = true

    self.entity = entity
    self.text = text
    self.icon = icon

    Trigger.Timer.CheckForWaitingTimerStart(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    self:Build()

    self:SetWantsUpdates(true)

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

    if self.data.reset == true then
        self:ShutDown()
    end

end

function Item:UpdateParameter(start_time, duration, icon, text, entity)

    self.start_time = start_time
    self.duration = duration
    self.endtime = self.start_time + self.duration
    self.first_threshold_frame = true

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
    local full_width, full_height

    self.orientation = savedata[self.parent.index].orientation
    self.number_format = savedata[self.parent.index].number_format
    
    if self.orientation == true then -- horizontal

        self.width = savedata[self.parent.index].width
        self.height = savedata[self.parent.index].height
    else
        self.width = savedata[self.parent.index].height
        self.height = savedata[self.parent.index].width
    end

    full_width = self.width + savedata[self.parent.index].spacing
    full_height = self.height + savedata[self.parent.index].spacing

	self:SetSize(full_width, full_height)
	self.icon_control:SetSize(self.width, self.height)
    self.entity_control:SetSize(full_width, full_height)

	self.label_back:SetSize(self.width, self.height)
	self.text_label:SetSize(self.width, self.height)
	self.timer_label:SetSize(self.width, self.height)

    self.text_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_2))
    self.timer_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_1))

    self.opacity = savedata[self.parent.index].opacity
    self.opacity2 = savedata[self.parent.index].opacity2
    --self:SetOpacity(self.opacity)
    self.icon_control:SetOpacity(self.opacity)
    if self.data.use_target_entity then
        self.entity_control:SetMouseVisible(true)
    else
        self.entity_control:SetMouseVisible(false)
    end

    self.text_label:SetFont(Utils.findfont(savedata[self.parent.index].font))
    self.timer_label:SetFont(Utils.findfont(savedata[self.parent.index].font))
    self.timer_label:SetVisible(not(self.data.hide_timer))

    self.text_label:SetText(self.text)

end

function Item:ParameterChanged()

    if self.icon == nil then
        self.icon_control:SetBackColor(Utils.ColorFix(savedata[self.parent.index].back_color))
    else
        self.icon_control:SetSize(Utils.GetImageSize(self.icon))
        self.icon_control:SetStretchMode(1)
        self.icon_control:SetBackground(self.icon)
        if self.orientation then
            self.icon_control:SetSize(savedata[self.parent.index].width, savedata[self.parent.index].height)
        else
            self.icon_control:SetSize(savedata[self.parent.index].height, savedata[self.parent.index].width)
        end
    end

    self.text_label:SetText(self.text)

end

---------------------------------------------------------------------------------------------------------
--private

function Item:Loop()

    self:UpdateParameter(Turbine.Engine.GetGameTime(), self.duration, nil, nil)

end

function Item:ShutDown()

    self:SetWantsUpdates(false)
    self:SetVisible(false)
    self.label_back:SetVisible(false)

    Trigger.Timer.CheckForWaitingTimerEnd(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    self.parent:ItemRemove(self)

    self.label_back:Close()
    self:Close()

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

        if self.data.increment == true then
            self.timer_label:SetText(Utils.SecondsToClock( (self.duration - time_left), self.number_format))

        else
            self.timer_label:SetText(Utils.SecondsToClock(time_left, self.number_format))

        end
        
        if self.data.use_threshold == true then

            if time_left <= self.data.threshold then

                if self.first_threshold_frame == true then
                    self.first_threshold_frame = false
                    Trigger.Timer.CheckForWaitingTimerThreshold(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)
                end

                if self.data.flashing == true then

                    local width = (time_left / self.data.threshold * (self.data.flashing_multi - 1) + 1) * self.width
                    local height = (time_left / self.data.threshold * (self.data.flashing_multi - 1) + 1) * self.height

                    local left = (time_left / self.data.threshold * (self.data.flashing_multi - 1)) * self.width * (-1)/2
                    local top = (time_left / self.data.threshold * (self.data.flashing_multi - 1)) * self.height * (-1)/2
            
                    self.icon_control:SetPosition(left, top)
                    self.icon_control:SetSize(width, height)
                    self.icon_control:SetOpacity(self.opacity+(self.opacity2-self.opacity)*(1-(time_left/self.data.threshold)))
                    -- opa1 + ( ( opa2 - opa1 ) * (1 - (timeleft / threshold) ) )

                else

                    if self.orientation then
                        self.icon_control:SetSize(savedata[self.parent.index].width, savedata[self.parent.index].height)
                    else
                        self.icon_control:SetSize(savedata[self.parent.index].height, savedata[self.parent.index].width)
                    end
                    
                end
                
            else
                self.icon_control:SetOpacity(self.opacity)
            end

        else

            self.icon_control:SetSize(self.width, self.height)
           
        end

	else
		self.timer_label:SetText("")
	end

end

function Item:Build()

    self.entity_control = Turbine.UI.Lotro.EntityControl()
    self.entity_control:SetParent(self)

    self.icon_control = Turbine.UI.Control()
    self.icon_control:SetParent(self)
    self.icon_control:SetMouseVisible(false)
    self.icon_control:SetZOrder(4)

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

	self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
	self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)

	self:ParameterChanged()
    self:DataChanged()

    self.label_back:SetVisible(true)
    self:SetMouseVisible(false)
    self:SetVisible(true)

end