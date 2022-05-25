-- importing item class
import "Gibberish.Windows.Count_Down.Item"

Window = class( Turbine.UI.Window )

function Window:Constructor(index)
	Turbine.UI.Window.Constructor( self )

    self.index = index
    self.controls = {}

    self:Build()

    if self.index == G.selected_index_window then
        self:SelectionStatusChanged(true)
    end

    

end

---------------------------------------------------------------------------------------------------------
--public

function Window:GetChatTimerList()

    local list = {}

    -- for index, control in ipairs(self.controls) do

    --     if string.sub(control.key, 1 , 1) == "4" then
    --         list[table.getn(list) + 1] =  control:GetReloadData()
    --     end

    -- end

    return list

end

function Window:SelectionStatusChanged(bool)
    if bool ==  true then
        self.move_label:SetBackColor(Turbine.UI.Color.Orange)
        
    else
        self.move_label:SetBackColor(Turbine.UI.Color.Black)
    end

    if self.move_window:IsVisible() == true then
        if bool then
            self:SetZOrder(11)
        else
            self:SetZOrder(10)
        end
    else
        if savedata[self.index].overlay == true then
            self:SetZOrder(1)
        else
            self:SetZOrder(nil)
        end 
    end

end

function Window:MoveChanged(bool)

    self.move_window:SetVisible(bool)
    self.move_window:SetMouseVisible(bool)

    if bool == true then
        if G.selected_index_window == self.index then
            self:SetZOrder(11)
        else
            self:SetZOrder(10)
        end
    else
        if savedata[self.index].overlay == true then
            self:SetZOrder(1)
        else
            self:SetZOrder(nil)
        end 
    end

end

function Window:ItemRemove(control)

    local index = self:FindControlIndex(control)

    if index ~= -1 then

        self.controls[index] = self.controls[table.getn(self.controls)]
        self.controls[table.getn(self.controls)] = nil

    end

    if table.getn(self.controls) <= 0 then
        self.header_label:SetVisible(false)
    end

    self.list:RemoveItem(control)

end

function Window:Clear()

    self.list:ClearItems()

    self.list:ClearItems()
	for i,item in ipairs(self.controls) do
		item:Close()
	end
    self.controls = {}

end

function Window:TriggerHappend()

    self:Clear()

    for i=1, table.getn(TRIGGER_TYPE), 1 do

        for j, timer_data in ipairs(savedata[self.index][i]) do

            if timer_data.id ~= savedata[self.index].trigger_id then

                local index = table.getn(self.controls) + 1
                self.controls[index] = Item(self, timer_data)
                self.list:AddItem(self.controls[index])

            end

        end

    end

    self.header_label:SetVisible(true)
    self.list:Sort(function(elem1,elem2) if elem1.data.sort_index<elem2.data.sort_index then return true end end)

end

function Window:Add(token, key, start_time, duration, icon, text, timer_data)

    if timer_data.id == savedata[self.index].trigger_id then

        self:TriggerHappend()

    else

        token = string.gsub(token, "-", "")

        for i, control in ipairs(self.controls) do

            if string.find(token, control.token) then

                control:Increment()

            end

        end

    end





    -- local control = self:CheckRunning(token, key)

    -- if control then
    --     control:UpdateParameter(start_time, duration, icon, text)
    -- else
    --     local index = table.getn(self.controls) + 1

    --     self.controls[index] = Item(self, token, key, start_time, duration, icon, text, timer_data)
    --     self.list:AddItem(self.controls[index])

    -- end

    -- self.list:Sort(function(elem1,elem2) if elem1.endtime<elem2.endtime then return true end end)

end

function Window:Remove(key)

    for index, control in ipairs(self.controls) do

        if string.find(control.key, key) then

            control:ShutDown()

            self:Remove(key)

            break

        end

    end

end

-- reset all timers with the reset setting
function Window:ResetAll()

    local temp_list = {}

    for index, control in pairs(self.controls) do
       if control:WillReset() == true then
            temp_list[#temp_list+1] = index
       end
    end

    for i = #temp_list, 1, -1 do
        self.controls[temp_list[i]]:Reset()
    end
    
end

--update visual parameter
function Window:DataChanged()

    self:SetPosition(Utils.ScreenRatioToPixel(savedata[self.index].left, savedata[self.index].top))

    if savedata[self.index].orientation == ORIENTATION.Horizontal then

        self.list:SetOrientation( Turbine.UI.Orientation.Vertical )
        local width = savedata[self.index].width + (3 * savedata[self.index].frame ) + savedata[self.index].height + savedata[self.index].spacing
        local height = savedata[self.index].height + (2 * savedata[self.index].frame )
        local move_frame = 1

        self:SetSize(width, height)
        self.header_label:SetSize(width, 20)
        self.header_label:SetText(savedata[self.index].name)
        self.list:SetTop(20)
        self.list:SetSize(width, height)
        self.move_window:SetSize(width, height)

        self.move_label:SetSize(width - (2*move_frame), height - (2*move_frame))
        self.move_label:SetPosition(move_frame, move_frame)
        self.move_label:SetText(savedata[self.index].name)

    else

        self.list:SetOrientation( Turbine.UI.Orientation.Horizontal ) 
        local width = savedata[self.index].height + (2 * savedata[self.index].frame )
        local height = savedata[self.index].width + (3 * savedata[self.index].frame ) + savedata[self.index].height + savedata[self.index].spacing
        local move_frame = 1

        self:SetSize(width, height)
        self.header_label:SetSize(20, height)
        self.header_label:SetText(savedata[self.index].name)
        self.list:SetLeft(20)
        self.list:SetSize(width, height)
        self.move_window:SetSize(width, height)

        self.move_label:SetSize(width - (2*move_frame), height - (2*move_frame))
        self.move_label:SetPosition(move_frame, move_frame)
        self.move_label:SetText(savedata[self.index].name)

    end

    for index, control in ipairs(self.controls) do

        control:DataChanged()

    end

    self.list:SetReverseFill(savedata[self.index].ascending)
    self.list:SetFlippedLayout(savedata[self.index].ascending)

end

---------------------------------------------------------------------------------------------------------
--private

function Window:FindControlIndex(control)

    for index, item in ipairs(self.controls) do
        if item == control then
            return index
        end
    end

    return -1
    
end

function Window:CheckRunning(token, key)

    for index, control in ipairs(self.controls) do

        if control.key == key and control.token == token then

            return control

        end

    end

    return nil

end


--build visual scafolding
function Window:Build()

	self:SetMouseVisible(false)

    if savedata[self.index].overlay == true then
        self:SetZOrder(1)
    end

    --move element for movemode
    self.move_window = Turbine.UI.Window()
    self.move_window:SetParent(self)
    self.move_window:SetVisible(optionsdata.moving)
    self.move_window:SetMouseVisible(optionsdata.moving)
    self.move_window:SetBackColor(Turbine.UI.Color.Black)
    self.move_window:SetZOrder(2)

    self.move_label = Turbine.UI.Label()
    self.move_label:SetParent(self.move_window)
    self.move_label:SetMouseVisible(false)
    self.move_label:SetBackColor(Turbine.UI.Color.Black)
    self.move_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.move_label:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.move_label:SetFontStyle(Turbine.UI.FontStyle.Outline)

    self.move_window.MouseDown = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
			self.dragStartX = args.X
            self.dragStartY = args.Y
            Options.WindowSelectionChanged(self.index)
		end
	end
	
	self.move_window.MouseMove = function( sender, args )
		if self.dragging then
			local x,y = self:GetPosition()	
			x = x + ( args.X - self.dragStartX )
            y = y + ( args.Y - self.dragStartY )	
            self:SetPosition( x, y )	
            savedata[self.index].left, savedata[self.index].top = Utils.PixelToScreenRatio(self:GetPosition())
            Options.WindowSelectionMoved()
		end
	end
	
	self.move_window.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
			savedata[self.index].left, savedata[self.index].top = Utils.PixelToScreenRatio(self:GetPosition())
				
			SaveWindowData()
		end
    end

    self.header_label = Turbine.UI.Label()
    self.header_label:SetParent(self)
    self.header_label:SetMouseVisible(false)
    self.header_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header_label:SetFont(Turbine.UI.Lotro.Font.Verdana14)
    self.header_label:SetVisible(false)

    --listbox for the items
    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetMouseVisible(false)
    self.list:SetZOrder(1)


    self:DataChanged()

    if G.selected_index_window == self.index then
        self:SelectionStatusChanged(true)
    else
        self:SelectionStatusChanged(false)
    end

    --self:MoveChanged()


    self:SetVisible(true)

end