--[[
    TimerSelection child for displaying timer information
]]

Item = class( Turbine.UI.Control )

function Item:Constructor(parent, timer_type, timer_index)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.timer_type = timer_type
    self.timer_index = timer_index
    self.data = savedata[G.selected_index_window][self.timer_type][self.timer_index]

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Item:ContainsSearchText(searchText)

    if string.find(string.lower(self.data.token), searchText) then
        return true
    end

    return false

end

function Item:UpdateData()

    self.token_control:SetText(self.data.token)

    if self.data.icon ~= nil then
        self.icon_control:SetBackground(self.data.icon)
    else
        self.icon_control:SetBackColor(Turbine.UI.Color.Black)
    end

    if self.data.description ~= "" and self.data.description ~= nil then
        self.description_control:SetText(self.data.description)
    else
        self.description_control:SetText(self.data.text)
    end

end

function Item:CheckForUpdate(timer_type, timer_index)

    if self.timer_type == timer_type and self.timer_index == timer_index then

        self:UpdateData()

    end

end

---------------------------------------------------------------------------------------------------------
--private

Item_HEIGHT = 40
ITEM_SPACER = 2


function Item:Build()

    local width = WINDOWSELECTION_WIDTH - 15


    self:SetSize(width, Item_HEIGHT + ITEM_SPACER)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetMouseVisible(false)
    self.frame:SetLeft(2)
    self.frame:SetSize(width - 4, Item_HEIGHT)
    self.frame:SetBackColor(COLOR_VERY_DARK_GRAY)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self.frame)
    self.background:SetMouseVisible(false)
    self.background:SetSize(width - 6, Item_HEIGHT - 2)
    self.background:SetPosition(1,1)

    self.icon_frame = Turbine.UI.Control()
    self.icon_frame:SetParent(self.background)
    --self.icon_frame:SetSize(32, 32)
    --self.icon_frame:SetPosition(width - 40, 3)
    self.icon_frame:SetSize(Item_HEIGHT-4, Item_HEIGHT-4)
    self.icon_frame:SetPosition(width - Item_HEIGHT - 3, 1)
    self.icon_frame:SetBackColor(COLOR_VERY_DARK_GRAY)

    self.icon_control = Turbine.UI.Control()
    self.icon_control:SetParent(self.icon_frame)
    self.icon_control:SetPosition(2,2)
    self.icon_control:SetMouseVisible(false)
    self.icon_control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
    if self.data.icon ~= nil then
        self.icon_control:SetSize(32, 32)
        self.icon_control:SetBackground(self.data.icon)
    end
    self.icon_control:SetZOrder(5)

    self.type_control = Turbine.UI.Label()
    self.type_control:SetParent(self.background)
    self.type_control:SetMouseVisible(false)
    self.type_control:SetSize(32,32)
    self.type_control:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.type_control:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16)
    --self.type_control:SetPosition(3,3)
    self.type_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.type_control:SetZOrder(10)
    if self.timer_type == 1 then
        self.type_control:SetText(TRIGGER_TYPE.short[1])
        self.background:SetBackColor(Turbine.UI.Color(0.2, 0.2, 0.2))

    elseif self.timer_type == 2 then
        self.type_control:SetText(TRIGGER_TYPE.short[2])
        self.background:SetBackColor(Turbine.UI.Color(0.22, 0.22, 0.22))

    elseif self.timer_type == 3 then
        self.type_control:SetText(TRIGGER_TYPE.short[3])
        self.background:SetBackColor(Turbine.UI.Color(0.24, 0.24, 0.24))

    elseif self.timer_type == 4 then
        self.type_control:SetText(TRIGGER_TYPE.short[4])
        self.background:SetBackColor(Turbine.UI.Color(0.26, 0.26, 0.26))

    elseif self.timer_type == 5 then
        self.type_control:SetText(TRIGGER_TYPE.short[5])
        self.background:SetBackColor(Turbine.UI.Color(0.28, 0.28, 0.28))

    elseif self.timer_type == 6 then
        self.type_control:SetText(TRIGGER_TYPE.short[6])
        self.background:SetBackColor(Turbine.UI.Color(0.3, 0.3, 0.3))

    elseif self.timer_type == 7 then
        self.type_control:SetText(TRIGGER_TYPE.short[7])
        self.background:SetBackColor(Turbine.UI.Color(0.32, 0.32, 0.32))

    elseif self.timer_type == 8 then
        self.type_control:SetText(TRIGGER_TYPE.short[8])
        self.background:SetBackColor(Turbine.UI.Color(0.34, 0.34, 0.34))

    end

    -- self.collapse = Turbine.UI.Button()
    -- self.collapse:SetParent(self.background)
    -- self.collapse:SetPosition(3, Item_HEIGHT - 5 - COLLAPSE_SIZE)
    -- self.collapse:SetSize(COLLAPSE_SIZE, COLLAPSE_SIZE)
    -- self.collapse:SetBackColor(Turbine.UI.Color(0.1,0.1,0.1))
    -- self.collapse:SetText("-")
    -- self.collapse:SetVisible(true)
    -- self.collapse.MouseClick = function()

    -- end

    self.description_control = Turbine.UI.Label()
    self.description_control:SetParent(self.background)
    self.description_control:SetMouseVisible(false)
    self.description_control:SetSize(width - 75, Item_HEIGHT - 14)
    self.description_control:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.description_control:SetFont(OPTIONS_FONT)
    self.description_control:SetLeft(30)
    self.description_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    if self.data.description ~= "" and self.data.description ~= nil then
        self.description_control:SetText(self.data.description)
    else
        self.description_control:SetText(self.data.text)
    end

    self.token_control = Turbine.UI.Label()
    self.token_control:SetParent(self.background)
    self.token_control:SetMouseVisible(false)
    self.token_control:SetSize(width - 75, 14)
    self.token_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.token_control:SetForeColor(COLOR_VERY_LIGHT_GRAY)
    self.token_control:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.token_control:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.token_control:SetPosition(30, Item_HEIGHT - 14)
    --self.token_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    --self.token_control:SetForeColor(Turbine.UI.Color(0.5, 0.5, 0.5))
    self.token_control:SetText(self.data.token)

    self.MouseEnter = function()
        self.frame:SetBackColor(Turbine.UI.Color.White)
        self:SetZOrder(30)
    end

    self.MouseLeave = function()
        self.frame:SetBackColor(COLOR_VERY_DARK_GRAY)
        self:SetZOrder(nil)
    end

    self.MouseClick = function(sender, args)

        if args.Button == Turbine.UI.MouseButton.Right then 
            self.right_click_menu:ShowMenu()
        end
        
    end

    self.MouseDoubleClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then          
            self.parent:TimerEditClicked(self.timer_type, self.timer_index)
        end
    end

    self.MouseDown = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
            self.topSave = self:GetTop()
			self.dragStartX = args.X
            self.dragStartY = args.Y
		end
	end
	
	self.MouseMove = function( sender, args )
		if self.dragging then
			local x,y = self:GetPosition()	
            local x_offset = args.X - self.dragStartX
            local y_offset = args.Y - self.dragStartY
			x = x + x_offset
            y = y + y_offset	

            self:SetPosition( 0, y )	
		end
	end
	
	self.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
            self:SetPosition( 0,self.topSave )	
            self.parent:DraggingEnd(self)
		end
    end


    self.item_export = Turbine.UI.MenuItem( "Export" , true )
    self.item_edit = Turbine.UI.MenuItem( "Edit" , true )
    self.item_delete = Turbine.UI.MenuItem( "Delete" , true )

    self.right_click_menu = Turbine.UI.ContextMenu()
    self.menu_items = self.right_click_menu:GetItems()

    self.menu_items:Add(self.item_export)
    self.menu_items:Add(self.item_edit)
    self.menu_items:Add(self.item_delete)

    self.item_export.Click = function()

        Options.Import.WindowStateChanged(true)
        Options.Import.ExportTimer(self.data, self.timer_type)

    end

    self.item_edit.Click = function()

        self.parent:TimerEditClicked(self.timer_type, self.timer_index)

    end

    self.item_delete.Click = function()

        self.parent:DeleteTimerClicked(self.timer_type, self.timer_index)

    end

end