--[[
    WindowSelection child for displaying Windows
]]

WindowItem = class( Turbine.UI.Control )

function WindowItem:Constructor(parent, index)
    Turbine.UI.Control.Constructor( self )

    self.name = savedata[index].name
    self.parent = parent
    self.selected = false
    self.index = index
    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function WindowItem:SetSelected(bool)

    self.selected = bool

    if self.selected == true then

        self.background:SetBackColor(Turbine.UI.Color.Orange)

    else

        self.background:SetBackColor(COLOR_GRAY)

    end

end

function WindowItem:Select()
    self.parent:WindowItemClicked(self)
end

function WindowItem:ContainsSearchText(searchText)

    if string.find(string.lower(savedata[self.index].name), searchText) then
        return true
    end

    return false

end

 
---------------------------------------------------------------------------------------------------------
--private

function WindowItem:AddToGroup()

    local group_menu = Turbine.UI.ContextMenu()
    local group_items = group_menu:GetItems()

    local inserted

    for i , data in ipairs(savedata.groups) do

        inserted = false

        local item = Turbine.UI.MenuItem( data.name , true )

        for j=1, group_items:GetCount(), 1 do

            local text = group_items:Get(j):GetText()

            if data.name < text then

                group_items:Insert(j, item)
        
                inserted = true

                break

            end

        end

        if inserted == false then
            group_items:Add(item)
        end


        item.Click = function()
            savedata[self.index].group = data.id
            DataFunctions.UpdateGroupLoadStatus(data.id)
            Options.GroupSetupChanged()
        end

    end

    group_menu:ShowMenu()

end


function WindowItem:RemoveFromGroup()

    DataFunctions.UpdateGroupLoadStatus(savedata[self.index].group)
    savedata[self.index].group = nil
    Options.GroupSetupChanged()

end

WINDOWITEM_HEIGHT = 32
ITEM_SPACER = 2

function WindowItem:LoadChanged(bool)

    savedata[self.index].load = self.load:IsChecked()

    if savedata[self.index].group ~= nil then
        DataFunctions.UpdateGroupLoadStatus(savedata[self.index].group)
    else
        self.parent:FillLists()
    end

end

function WindowItem:Build()

    local width

    if savedata[self.index].group ~= nil then
        width = WINDOWSELECTION_WIDTH - 33 - FRAME
    else
        width = WINDOWSELECTION_WIDTH - 10 - FRAME
    end

    self:SetSize(width, WINDOWITEM_HEIGHT + ITEM_SPACER)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetMouseVisible(false)
    self.frame:SetLeft(2)
    self.frame:SetSize(width - 4, WINDOWITEM_HEIGHT)
    self.frame:SetBackColor(COLOR_VERY_DARK_GRAY)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self.frame)
    self.background:SetMouseVisible(false)
    self.background:SetSize(width - 6, WINDOWITEM_HEIGHT - 2)
    self.background:SetPosition(1,1)
    self.background:SetBackColor(COLOR_GRAY)

    self.name_control = Turbine.UI.Label()
    self.name_control:SetParent(self.background)
    self.name_control:SetMouseVisible(false)
    self.name_control:SetSize(width - 14 - 20 - 10, WINDOWITEM_HEIGHT - 4)
    self.name_control:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.name_control:SetFont(OPTIONS_FONT)
    self.name_control:SetLeft(7)
    self.name_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.name_control:SetText(savedata[self.index].name)

    self.load =  Turbine.UI.Lotro.CheckBox()
	self.load:SetParent(self.background)
    self.load:SetSize(20, 20)
    self.load:SetText("")
    self.load:SetPosition(width - 10 - 20, 5)
    self.load:SetChecked(savedata[self.index].load)
    self.load.CheckedChanged = function()
        self:LoadChanged(self.load:IsChecked())

        Windows.LoadChanged(self.index)
        Move.UpdateGroups()

        SaveWindowData()

    end

    self.MouseEnter = function()
        self.frame:SetBackColor(Turbine.UI.Color.White)
    end

    self.MouseLeave = function()
        self.frame:SetBackColor(COLOR_VERY_DARK_GRAY)
    end

    self.MouseClick = function(sender, args)

        self.parent:WindowItemClicked(self)

        if args.Button == Turbine.UI.MouseButton.Right then 
            self.right_click_menu:ShowMenu()
        end

    end

    self.item_export = Turbine.UI.MenuItem( "Export" , true )
    self.item_move = Turbine.UI.MenuItem( "Move" , true )

    if savedata[self.index].group == nil then
        self.item_group = Turbine.UI.MenuItem( "Add to Group" , true )
    else
        self.item_group = Turbine.UI.MenuItem( "Remove from Group" , true )
    end

    self.item_delete = Turbine.UI.MenuItem( "Delete" , true )

    self.right_click_menu = Turbine.UI.ContextMenu()
    self.menu_items = self.right_click_menu:GetItems()

    self.menu_items:Add(self.item_export)
    self.menu_items:Add(self.item_group)
    self.menu_items:Add(self.item_move)
    self.menu_items:Add(self.item_delete)

    self.item_export.Click = function()

        Options.Import.WindowStateChanged(true)
        Options.Import.ExportWindow(savedata[self.index])

    end


    self.item_group.Click = function()

        if savedata[self.index].group == nil then
            self:AddToGroup()
        else
            self:RemoveFromGroup()
        end
        SaveWindowData()

    end

    self.item_move.Click = function()

        Options.Move.MoveChanged(true, nil, self.index)

    end

    self.item_delete.Click = function()

        self.parent:DeleteWindowClicked(self.index)

    end


end