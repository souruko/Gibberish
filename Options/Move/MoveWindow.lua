--[[
    Main MoveWindow at the Left Middle of the Screen
]]

MoveWindow = class( Turbine.UI.Window )

function MoveWindow:Constructor(group_index, window_index)
    Turbine.UI.Window.Constructor( self )

    self.group_index = group_index
    self.window_index = window_index 
    
    self.group_controls = {}
    self.grid = nil

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function MoveWindow:GroupEdited(index)

    if optionsdata.move.show_groups == true then

        self.group_controls[index]:UpdateData()

    end

end

function MoveWindow:GroupMoved(id)

    if G.selected_index_window ~= nil then
        if savedata[G.selected_index_window].group == id then
            self:SelectionUpdate()
        end
    end

end

function MoveWindow:SelectionUpdate()

    if G.selected_index_window == nil then

        self.window_name:SetText("")
        self.left_tb:SetText("")
        self.top_tb:SetText("")
        self.width_tb:SetText("")
        self.height_tb:SetText("")

    else

        self.window_name:SetText(savedata[G.selected_index_window].name)
        local left, top = Utils.ScreenRatioToPixel(savedata[G.selected_index_window].left, savedata[G.selected_index_window].top)
        self.left_tb:SetText(left)
        self.top_tb:SetText(top)
        self.width_tb:SetText(savedata[G.selected_index_window].width)
        self.height_tb:SetText(savedata[G.selected_index_window].height)

        if savedata[G.selected_index_window].group ~= nil then

            if optionsdata.move.show_groups == true then

                local index = DataFunctions.GetGroupIndexFromId(savedata[G.selected_index_window].group)

                if self.group_controls[index] ~= nil then
                    self.group_controls[index]:WindowMoved()
                end

            end

        end
    
    end

end

---------------------------------------------------------------------------------------------------------
--private

function MoveWindow:Build()

    local width = 130
    local height = 280
    local top = (Turbine.UI.Display:GetHeight()/2) - (height/2)
    local left = 0
    local opacity = 0.8

    local row_height = 20
    local row = 0

    self:SetBackColor(Turbine.UI.Color.Black)
    self:SetSize(width,height)
    self:SetPosition(left, top)
    self:SetOpacity(opacity)
    self:SetZOrder(3)

    self.foreground = Turbine.UI.Window()
    self.foreground:SetParent(self)
    self.foreground:SetOpacity(1)
    self.foreground:SetSize(width,height)    

    self.window_name = Turbine.UI.Label()
    self.window_name:SetParent(self.foreground)
    self.window_name:SetPosition(1, row*row_height + 1)
    self.window_name:SetSize(width - 2, 30 - 1)
    self.window_name:SetMouseVisible(false)
    self.window_name:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.window_name:SetFont(OPTIONS_FONT)
    self.window_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.window_name:SetText("")
    self.window_name:SetBackColor(COLOR_GRAY)

    row = row + 2

    self.left_label = Turbine.UI.Label()
    self.left_label:SetParent(self.foreground)
    self.left_label:SetPosition(5, row*row_height)
    self.left_label:SetSize((width / 2) - 5, row_height)
    self.left_label:SetMouseVisible(false)
    self.left_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.left_label:SetFont(OPTIONS_FONT)
    self.left_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.left_label:SetText(L.left2)

    self.left_tb = Turbine.UI.Lotro.TextBox()
	self.left_tb:SetParent(self.foreground)
	self.left_tb:SetSize((width / 2) - 10, row_height)
	self.left_tb:SetPosition((width / 2),row * row_height)
	self.left_tb:SetFont(OPTIONS_FONT)
    self.left_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.left_tb:SetText("")
 


    row = row + 1

    self.top_label = Turbine.UI.Label()
    self.top_label:SetParent(self.foreground)
    self.top_label:SetPosition(5, row*row_height)
    self.top_label:SetSize((width / 2) - 5, row_height)
    self.top_label:SetMouseVisible(false)
    self.top_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.top_label:SetFont(OPTIONS_FONT)
    self.top_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.top_label:SetText(L.top2)

    self.top_tb = Turbine.UI.Lotro.TextBox()
	self.top_tb:SetParent(self.foreground)
	self.top_tb:SetSize((width / 2) - 10, row_height)
	self.top_tb:SetPosition((width / 2),row * row_height)
	self.top_tb:SetFont(OPTIONS_FONT)
    self.top_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.top_tb:SetText("")
 

    row = row + 1

    self.width_label = Turbine.UI.Label()
    self.width_label:SetParent(self.foreground)
    self.width_label:SetPosition(5, row*row_height)
    self.width_label:SetSize((width / 2) - 5, row_height)
    self.width_label:SetMouseVisible(false)
    self.width_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.width_label:SetFont(OPTIONS_FONT)
    self.width_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.width_label:SetText(L.width2)

    self.width_tb = Turbine.UI.Lotro.TextBox()
	self.width_tb:SetParent(self.foreground)
	self.width_tb:SetSize((width / 2) - 10, row_height)
	self.width_tb:SetPosition((width / 2),row * row_height)
	self.width_tb:SetFont(OPTIONS_FONT)
    self.width_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.width_tb:SetText("")

    row = row + 1

    self.height_label = Turbine.UI.Label()
    self.height_label:SetParent(self.foreground)
    self.height_label:SetPosition(5, row*row_height)
    self.height_label:SetSize((width / 2) - 5, row_height)
    self.height_label:SetMouseVisible(false)
    self.height_label:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.height_label:SetFont(OPTIONS_FONT)
    self.height_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.height_label:SetText(L.height2)

    self.height_tb = Turbine.UI.Lotro.TextBox()
	self.height_tb:SetParent(self.foreground)
	self.height_tb:SetSize((width / 2) - 10, row_height)
	self.height_tb:SetPosition((width / 2),row * row_height)
	self.height_tb:SetFont(OPTIONS_FONT)
    self.height_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.height_tb:SetText("")

    row = row + 2

    self.update_button = Turbine.UI.Lotro.Button()
    self.update_button:SetParent(self.foreground)
    self.update_button:SetPosition((width / 4), row * row_height)
    self.update_button:SetSize((width / 2),row_height)
    self.update_button:SetText(L.update )
    self.update_button:SetVisible(true)

    self.update_button.Click = function(sender, args)

        local left, top = Utils.PixelToScreenRatio(tonumber(self.left_tb:GetText()), tonumber(self.top_tb:GetText()))
        savedata[G.selected_index_window].left = left
        savedata[G.selected_index_window].top = top
        savedata[G.selected_index_window].width = tonumber(self.width_tb:GetText())
        savedata[G.selected_index_window].height = tonumber(self.height_tb:GetText())
        Windows.WindowDataChanged(G.selected_index_window)
        SaveWindowData()

    end

    row = row + 2 

    self.show_groups =  Turbine.UI.Lotro.CheckBox()
	self.show_groups:SetParent(self.foreground)
	self.show_groups:SetMouseVisible(false)
	self.show_groups:SetSize(width, row_height)
	self.show_groups:SetPosition(10, row * row_height)
	self.show_groups:SetFont(OPTIONS_FONT)
	self.show_groups:SetText(L.show_groups )
    self.show_groups:SetChecked(optionsdata.move.show_groups)
    self.show_groups.CheckedChanged = function()

        optionsdata.move.show_groups = self.show_groups:IsChecked()
        self:ShowGroupChanged()

    end

    row = row + 1 

    self.show_grid =  Turbine.UI.Lotro.CheckBox()
	self.show_grid:SetParent(self.foreground)
	self.show_grid:SetMouseVisible(false)
	self.show_grid:SetSize(width, row_height)
	self.show_grid:SetPosition(10, row * row_height)
	self.show_grid:SetFont(OPTIONS_FONT)
	self.show_grid:SetText(L.show_grid )
    self.show_grid:SetChecked(optionsdata.move.show_grid)
    self.show_grid.CheckedChanged = function()

        optionsdata.move.show_grid = self.show_grid:IsChecked()
        self:ShowGridChanged()

    end

    row = row + 2

    self.done_button = Turbine.UI.Lotro.Button()
    self.done_button:SetParent(self.foreground)
    self.done_button:SetPosition((width / 4), row * row_height)
    self.done_button:SetSize((width / 2),row_height)
    self.done_button:SetText(L.done)
    self.done_button:SetVisible(true)

    self.done_button.Click = function(sender, args)
        optionsdata.moving = false
        MoveChanged(false, nil, nil)
    end


    self:ShowGridChanged()

    self:ShowGroupChanged()

    self:SelectionUpdate()
    
    self:SetWantsKeyEvents(true)
    self:SetVisible(true)
    self.foreground:SetVisible(true)

end

function MoveWindow:ClearGroupControls()

    for index, item in pairs(self.group_controls) do

        item:Close()

    end

    self.group_controls = {}

end

function MoveWindow:CreateGroupControls()

    if self.window_index == nil then

        if self.group_index == nil then

            for index, data in ipairs(savedata.groups) do

                if data.load then
                    self.group_controls[index] = Group(index, data.id)
                end

            end

        else

            if savedata.groups[self.group_index].load then
                self.group_controls[self.group_index] = Group(self.group_index, savedata.groups[self.group_index].id)
            end

        end
    
    end

end

function MoveWindow:ShowGroupChanged()

    if optionsdata.move.show_groups == true then

        self:ClearGroupControls()
        self:CreateGroupControls()

    else

        self:ClearGroupControls()

    end

end

function MoveWindow:ShowGridChanged()

    if optionsdata.move.show_grid == true then

        if self.grid == nil then
            self.grid = Grid()
        end

    else

        if self.grid ~= nil then
            self.grid:Close()
            self.grid = nil
        end

    end

end

-- function MoveWindow.KeyDown(sender, args)

--     if args.Action == 145 then
--         MoveChanged(false)
--     end

-- end

function MoveWindow:Closing()

    if self.grid ~= nil then
        self.grid:Close()
    end

    self:ClearGroupControls()

    self.foreground:Close()
    
    optionsdata.move.open = false
    SaveOptions()

end

