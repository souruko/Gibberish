
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

    self.text = text
    -- self.icon = icon

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
    list.icon = nil
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

    -- if icon ~= nil then
    --     self.icon = icon
    -- end

    if text ~= nil then
        self.text = text
    end

    self.text_label:SetText(self.text)
    self.entity_control:SetEntity(entity)
    
    --self:ParameterChanged()

end

-- timer settings data was changed and will be updated
function Item:DataChanged()

    local height, width

    self.orientation = savedata[self.parent.index].orientation
    self.number_format = savedata[self.parent.index].number_format

    self.max_bar = savedata[self.parent.index].width

    height = savedata[self.parent.index].height
    width = savedata[self.parent.index].width

    self:SetSize(width, height)
    self.entity_control:SetSize(width, height)

    -- self.icon_control:SetSize(32, 32)
    -- self.icon_control:SetPosition(0, 0)


    self.background:SetPosition(0, 0)


    self.bar_back:SetSize(width , height)
    self.bar_back:SetPosition(0, 0)

    local label_spacing = height * 0.12
    self.label_back:SetSize(width , height - label_spacing * 2)
    self.label_back:SetPosition(0, label_spacing)
    self.text_label:SetSize(width , height - label_spacing * 2)
    self.timer_label:SetSize(width, height - label_spacing * 2)

    self.text_label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter)
    self.timer_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)

    self.background:SetSize(width, height)
    self.background.nativeWidth, self.background.nativeHeight = self.background:GetSize()

    self.background_color = Utils.ColorFix(savedata[self.parent.index].back_color)
    self.background:SetBackColor(self.background_color)
    self.background:SetBackground(CIRCEL[100])
    self.background:SetStretchMode(2)

    self.background.nativeWidth, self.background.nativeHeight = self.background:GetSize()
    
    self.bar:SetSize(width , height)
    self.bar.nativeWidth, self.bar.nativeHeight = self.bar:GetSize()

    self.bar:SetBackColor(Utils.ColorFix(savedata[self.parent.index].bar_color))

    self.text_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_2))
    self.timer_label:SetForeColor(Utils.ColorFix(savedata[self.parent.index].font_color_1))
    self.timer_label:SetVisible(not(self.data.hide_timer))

    local opacity = savedata[self.parent.index].opacity
    local opacity2 = savedata[self.parent.index].opacity2
    self.bar:SetOpacity(opacity)
    self.background:SetOpacity(opacity2)
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

    -- if self.icon == nil then
    --     self.icon_control:SetBackColor(Utils.ColorFix(savedata[self.parent.index].back_color))
    -- else
    --     self.icon_control:SetSize(Utils.GetImageSize(self.icon))
    --     self.icon_control:SetStretchMode(1)
    --     self.icon_control:SetBackground(self.icon)
    --     self.icon_control:SetSize(savedata[self.parent.index].height, savedata[self.parent.index].height)
    -- end

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

    -- Trigger.Timer.CheckForWaitingTimerEnd(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)

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

            local circel_id = 100 - math.round((time_left / self.duration ) * 100)

            self.bar:SetBackground(CIRCEL[circel_id])
            self.bar:SetStretchMode(2)


            if self.orientation == false then

                self.bar:SetRotation({x = 0, y = 0, z = 180})
        
            end
            
        else
            self.timer_label:SetText(Utils.SecondsToClock(time_left, self.number_format))

            local circel_id = math.round((time_left / self.duration ) * 100)

            self.bar:SetBackground(CIRCEL[circel_id])
            self.bar:SetStretchMode(2)

                
    if self.orientation == false then

        self.bar:SetRotation({x = 0, y = 0, z = 180})

    end

            if self.orientation then
                -- self.bar:SetWidth(time_left/self.duration*self.max_bar)
            else
                -- self.bar:SetHeight(time_left/self.duration*self.max_bar)
            end
        end




        -- if self.data.use_threshold == true then

        --     if time_left <= self.data.threshold then

        --         if self.first_threshold_frame == true then
        --             self.first_threshold_frame = false
        --             Trigger.Timer.CheckForWaitingTimerThreshold(savedata[self.parent.index].id.."wid_"..self.data.id.."tid", self.data)
        --         end

        --         if self.data.flashing == true then
        --             local value
        --             local flash_value = time_left * self.data.flashing_multi
        --             if math.floor(flash_value) % 2 == 0 then
        --                 value = 1-(flash_value-math.floor(flash_value))
        --             else
        --                 value = (flash_value-math.floor(flash_value))
        --             end
        
        --             self.background:SetBackColor(Turbine.UI.Color(1, value, value))
        --         else
        --             self.background:SetBackColor(Turbine.UI.Color.Red)
        --         end
                
        --     else
        --         self.background:SetBackColor(self.background_color)
        --     end

        -- end

	else
		self.timer_label:SetText("")
		-- self.bar:SetWidth(0)
	end

end

-- build item elements
function Item:Build()

    self.entity_control = Turbine.UI.Lotro.EntityControl()
    self.entity_control:SetParent(self)

    -- self.icon_control = Turbine.UI.Control()
    -- self.icon_control:SetParent(self)
    -- self.icon_control:SetMouseVisible(false)
    -- self.icon_control:SetZOrder(4)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetMouseVisible(false)
    self.background:SetBackColorBlendMode(Turbine.UI.BlendMode.Color)

    self.bar_back = Turbine.UI.Window()
    self.bar_back:SetParent(self)
    self.bar_back:SetMouseVisible(false)
    self.bar_back:SetZOrder(5)

    self.bar = Turbine.UI.Window()
    self.bar:SetParent(self.bar_back)
    self.bar:SetBackColorBlendMode(Turbine.UI.BlendMode.Color)
    self.bar:SetVisible(true)
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

function Item:Closing()

    self.label_back:Close()
    self.bar_back:Close()
    self:SetVisible(false)
    self.background:SetVisible(false)
    
end