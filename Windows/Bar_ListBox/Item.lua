
Item = class( Turbine.UI.Window )

--constructor
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

    self.animation_step = 1
    self.last_animation = 1

    self.text = text
    self.icon = icon

    Trigger.Timer.CheckForWaitingTimerStart(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    self:Build()

    self:SetWantsUpdates(true)

end



---------------------------------------------------------------------------------------------------------
--public

-- get data for reload save
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

-- check if timer will reset
function Item:WillReset()

    return self.data.reset

end

-- reset timer
function Item:Reset()

    if self.data.reset == true then
        self:ShutDown()
    end

end

-- update parameters
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

-- timer settings data was changed and will be updated
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
        self.entity_control:SetSize(full_width, full_height)

        self.icon_control:SetSize(height, height)
        self.icon_control:SetPosition(frame, frame)
    
        self.frame:SetSize(full_width, height + (2*frame))
        self.background:SetSize(self.max_bar, height)
        self.background:SetPosition(height + (2*frame), frame)

        self.animation:SetSize(full_width, height + (2*frame))
        self.animation.nativeWidth, self.animation.nativeHeight = self.animation:GetSize()
    
    
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
        self.entity_control:SetSize(full_width, full_height)

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
        self.text_label:SetSize(height, self.max_bar -3 - 30) -- 50 is for overlap issue with timer
        self.timer_label:SetSize(height, self.max_bar -3)

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

    local opacity = savedata[self.parent.index].opacity
    self:SetOpacity(opacity)
    --self.icon_control:SetOpacity(opacity)

    self.text_label:SetFont(Utils.findfont(savedata[self.parent.index].font))
    self.timer_label:SetFont(Utils.findfont(savedata[self.parent.index].font))

    if self.data.use_target_entity then
        self.entity_control:SetMouseVisible(true)
    else
        self.entity_control:SetMouseVisible(false)
    end
    self.text_label:SetText(self.text)

end

-- fix parameters
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
    self.entity_control:SetEntity(self.entity)
    
end

---------------------------------------------------------------------------------------------------------
--private

-- chage timestamps for next loop
function Item:Loop()

    self:UpdateParameter(Turbine.Engine.GetGameTime(), self.duration, nil, nil)

end

-- shutdown item 
function Item:ShutDown()

    self:SetWantsUpdates(false)

    self:SetVisible(false)
    self.bar_back:SetVisible(false)
    self.label_back:SetVisible(false)

    Trigger.Timer.CheckForWaitingTimerEnd(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

    self.parent:ItemRemove(self)

    self.label_back:Close()
    self.bar_back:Close()
    self:Close()

end

-- updates timer every frame
function Item:Update()

    local gt = Turbine.Engine.GetGameTime()
    local time_left = self.endtime - gt

    if time_left <= 0 then
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

                    if self.data.flashing_animation == nil or self.data.flashing_animation == ANIMATION_TYPE.Flashing then


                        local value
                        local flash_value = time_left * self.data.flashing_multi
                        if math.floor(flash_value) % 2 == 0 then
                            value = 1-(flash_value-math.floor(flash_value))
                        else
                            value = (flash_value-math.floor(flash_value))
                        end
            
                        self.background:SetBackColor(Turbine.UI.Color(1, value, value))

                    elseif self.data.flashing_animation == ANIMATION_TYPE.Dotted_Border then

                        if self.last_animation < gt then

                            self.animation:SetSize(32, 32)
                            self.animation:SetBackground(DOTTED_BORDER[self.animation_step])
                            self.animation:SetStretchMode(1)
                            self.animation:SetSize(self.frame:GetSize())

                            self.animation_step = self.animation_step + 1

                            if self.animation_step > 13 then
                                self.animation_step = 1
                            end

                            self.last_animation = gt + (0.2/self.data.flashing_multi)
                        end

                    elseif self.data.flashing_animation == ANIMATION_TYPE.Activation_Border then

                        if self.last_animation < gt then

                            self.animation:SetSize(32, 32)
                            self.animation:SetBackground(ACTIVATION_BORDER[self.animation_step])
                            self.animation:SetStretchMode(1)
                            self.animation:SetSize(self.frame:GetSize())
                        

                            self.animation_step = self.animation_step + 1

                            if self.animation_step > 9 then
                                self.animation_step = 1
                            end

                            self.last_animation = gt + (0.2/self.data.flashing_multi)
                        end

                    elseif self.data.flashing_animation == ANIMATION_TYPE.New_Activation_Border then

                        if self.last_animation < gt then

                            self.animation:SetSize(32, 32)
                            self.animation:SetBackground(NEW_ACTIVATION_BORDER[self.animation_step])
                            self.animation:SetStretchMode(1)
                            self.animation:SetSize(self.frame:GetSize())
                        

                            self.animation_step = self.animation_step + 1

                            if self.animation_step > 12 then
                                self.animation_step = 1
                            end

                            self.last_animation = gt + (0.2/self.data.flashing_multi)
                        end

                    elseif self.data.flashing_animation == ANIMATION_TYPE.New_Dotted_Border then

                        if self.last_animation < gt then

                            self.animation:SetSize(32, 32)
                            self.animation:SetBackground(NEW_DOTTED_BORDER[self.animation_step])
                            self.animation:SetStretchMode(1)
                            self.animation:SetSize(self.frame:GetSize())
                        

                            self.animation_step = self.animation_step + 1

                            if self.animation_step > 12 then
                                self.animation_step = 1
                            end

                            self.last_animation = gt + (0.2/self.data.flashing_multi)
                        end



                    end

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

-- build item elements
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

    self.animation = Turbine.UI.Control()
    self.animation:SetParent(self.frame)
    -- self.animation:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
    self.animation:SetMouseVisible(false);
    -- self.animation:SetZOrder(6);

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

    self.bar_back:SetVisible(true)
    self.label_back:SetVisible(true)
    self:SetVisible(true)
    self:SetMouseVisible(false)

end