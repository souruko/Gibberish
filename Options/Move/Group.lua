--[[
    Group UI Element for Moving
]]

Group = class( Turbine.UI.Window )

function Group:Constructor(group_index, id)
    Turbine.UI.Window.Constructor( self )

    self.index = group_index
    self.id = id

    self:Draw()
end

---------------------------------------------------------------------------------------------------------
--public

function Group:WindowMoved()

    self:Resize()

end

function Group:UpdateData()

    local color = Utils.ColorFix(savedata.groups[self.index].color)
    self:SetBackColor(color)
    self.name_back:SetBackColor(color)

    self.name = savedata.groups[self.index].name

end


---------------------------------------------------------------------------------------------------------
--private

function Group:Resize()

    local left, top, width, height = DataFunctions.GetSizeAndPositionForGroup(self.index)

    local name_width = 150
    local name_height = 26

    self:SetSize(width, height)
    self:SetPosition(left,top)

    self.name_frame:SetPosition((width / 2) - (name_width / 2), 0)--(-1 * name_height) + 10)

end


function Group:Draw()

    local name_width = 150
    local name_height = 26
    local opacity = 0.4
    local color = Utils.ColorFix(savedata.groups[self.index].color)

    self:SetBackColor(color)
    self:SetOpacity(opacity)
    self:SetZOrder(2)
    self:SetMouseVisible(false)

    self.name_frame = Turbine.UI.Window()
    self.name_frame:SetParent(self)
    self.name_frame:SetSize(name_width, name_height)
    self.name_frame:SetBackColor(Turbine.UI.Color.Black)
    self.name_frame:SetOpacity(opacity)

    self.name_back = Turbine.UI.Control()
    self.name_back:SetParent(self.name_frame)
    self.name_back:SetSize(name_width - 2, name_height - 2)
    self.name_back:SetPosition(1,1)
    self.name_back:SetBackColor(color)
    self.name_back:SetMouseVisible(false)
    
    
    self.label_back = Turbine.UI.Window()
    self.label_back:SetParent(self.name_frame)
    self.label_back:SetSize(name_width - 6, name_height - 2)
    self.label_back:SetPosition(3,1)
    self.label_back:SetOpacity(1)
    self.label_back:SetMouseVisible(false)

    self.name = Turbine.UI.Label()
    self.name:SetParent(self.label_back)
    self.name:SetMouseVisible(false)
    self.name:SetSize(self.label_back:GetSize())
    self.name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.name:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.name:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.name:SetForeColor(Turbine.UI.Color.Orange)
    self.name:SetText(savedata.groups[self.index].name)
    self.name:SetMouseVisible(false)

    self.name_frame.MouseDown = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
			self.dragStartX = args.X
            self.dragStartY = args.Y
		end
	end
	
	self.name_frame.MouseMove = function( sender, args )
		if self.dragging then
			local x,y = self:GetPosition()	
            local x_offset = args.X - self.dragStartX
            local y_offset = args.Y - self.dragStartY
			x = x + x_offset
            y = y + y_offset	
            self:SetPosition( x, y )	
            GroupMoved(self.id, x_offset, y_offset)
		end
	end
	
	self.name_frame.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
				
			SaveWindowData()
		end
    end

    self:Resize()
    
    self:SetVisible(true)
    self.name_frame:SetVisible(true)
    self.label_back:SetVisible(true)

end

function Group:Closed()

    self.name_frame:Close()
    self.label_back:Close()

end