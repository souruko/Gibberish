--[[
    WindowSelection child for displaying Groups
]]

GroupItem = class( Turbine.UI.Control )

function GroupItem:Constructor(parent, index)
    Turbine.UI.Control.Constructor( self )
               
    self.parent = parent
    self.index = index
    self.name =  savedata.groups[self.index].name
    self.selected = false
    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function GroupItem:DeleteWindowClicked(index)

    self.parent:DeleteWindowClicked(index)

end

function GroupItem:AddItem(item)

    item.parent = self
    self.list:AddItem(item)

    self.list:Sort(function(elem1,elem2) if (elem1.name) < (elem2.name) then return true end end)
    self:Resize()

end

function GroupItem:WindowItemClicked(item)

    self.parent:WindowItemClicked(item, self)

end

function GroupItem:SetSelected(bool)

    self.selected = bool

    if self.selected == true then

        self.background:SetBackColor(self.color)

    else

        self.background:SetBackColor(COLOR_DARK_GRAY)

    end



end

function GroupItem:UpdateData()

    self.color = Utils.ColorFix(savedata.groups[self.index].color)
    if self.selected == true then
        self.background:SetBackColor(self.color)
    else
        self.background:SetBackColor(COLOR_DARK_GRAY)
    end

    self.name_control:SetText(savedata.groups[self.index].name)

end

function GroupItem:ContainsSearchText(searchText)

    if (savedata.groups[self.index].name ) ~= nil then
        if string.find(string.lower(savedata.groups[self.index].name), searchText) then
            return true
        end


        for i=1, self.list:GetItemCount(), 1 do
            if self.list:GetItem(i):ContainsSearchText(searchText) == true then
                return true
            end
        end
    end
    
    return false

end

function GroupItem:Collaps(bool)

    if bool == nil then
        bool = not(savedata.groups[self.index].collapse)
    end
    savedata.groups[self.index].collapse = bool
    self:Resize()
    self.parent:ResizeLists()

end

---------------------------------------------------------------------------------------------------------
--private

function GroupItem:Resize()

    local width = WINDOWSELECTION_WIDTH - 10 - FRAME

    if savedata.groups[self.index].collapse == true then
        self:SetHeight(WINDOWITEM_HEIGHT + ITEM_SPACER)
        self.frame:SetHeight(WINDOWITEM_HEIGHT)
        self.background:SetHeight( WINDOWITEM_HEIGHT - 2)
        self.list:SetVisible(false)
        self.collapsedSwitch:SetText("+")
    else
        local count = self.list:GetItemCount()

        self:SetHeight(WINDOWITEM_HEIGHT + ITEM_SPACER + (count * (WINDOWITEM_HEIGHT + ITEM_SPACER)) + 15)
        self.frame:SetHeight(WINDOWITEM_HEIGHT + (count * (WINDOWITEM_HEIGHT + ITEM_SPACER)) + 15)
        self.background:SetHeight(WINDOWITEM_HEIGHT + (count * (WINDOWITEM_HEIGHT + ITEM_SPACER)) - 2 + 15)
        self.list:SetHeight(count * (WINDOWITEM_HEIGHT + ITEM_SPACER) + 15)
        self.list:SetVisible(true)
        self.collapsedSwitch:SetText("-")
    end

end

function GroupItem:ChangeChildrenChecked(bool)

    for i=1, self.list:GetItemCount(), 1 do

        savedata[self.list:GetItem(i).index].load = bool

    end

    DataFunctions.UpdateGroupLoadStatus(savedata.groups[self.index].id)
    Windows.LoadAll()

end

function GroupItem:Build()

    local width = WINDOWSELECTION_WIDTH - 15
    self.color = Utils.ColorFix(savedata.groups[self.index].color)

    self:SetSize(width, WINDOWITEM_HEIGHT + ITEM_SPACER)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetMouseVisible(false)
    self.frame:SetLeft(2)
    self.frame:SetWidth(width - 4)
    self.frame:SetBackColor(COLOR_GRAY)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self.frame)
    self.background:SetMouseVisible(false)
    self.background:SetSize(width - 6, WINDOWITEM_HEIGHT - 2)
    self.background:SetPosition(1,1)
    self.background:SetBackColor(COLOR_DARK_GRAY)

    self.collapsedSwitch = Turbine.UI.Button()
    self.collapsedSwitch:SetParent(self)
    self.collapsedSwitch:SetPosition(10,8)
    self.collapsedSwitch:SetSize(COLLAPSE_SIZE, COLLAPSE_SIZE)
    self.collapsedSwitch:SetBackColor(COLOR_VERY_DARK_GRAY)
    self.collapsedSwitch:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.collapsedSwitch:SetVisible(true)
    self.collapsedSwitch.MouseClick = function()
        self:Collaps()
        SaveWindowData()
    end

    self.name_control = Turbine.UI.Label()
    self.name_control:SetParent(self.background)
    self.name_control:SetMouseVisible(false)
    self.name_control:SetSize(width - 14 - 20 - 8 - 25, WINDOWITEM_HEIGHT - 4)
    self.name_control:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.name_control:SetFont(OPTIONS_FONT)
    self.name_control:SetLeft(30)
    self.name_control:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.name_control:SetText(savedata.groups[self.index].name)

    self.load =  Turbine.UI.Lotro.CheckBox()
	self.load:SetParent(self.background)
    self.load:SetSize(20, 20)
    self.load:SetText("")
    self.load:SetPosition(width - 14 - 16, 5)
    self.load:SetChecked(savedata.groups[self.index].load)
    self.load.CheckedChanged = function()
        self:ChangeChildrenChecked(self.load:IsChecked())
        SaveWindowData()
    end

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self.background)
    self.list:SetPosition(20, WINDOWITEM_HEIGHT)
    self.list:SetWidth(width - 25)

    self.MouseEnter = function()
        self.frame:SetBackColor(Turbine.UI.Color.White)
    end

    self.MouseLeave = function()
        self.frame:SetBackColor(COLOR_GRAY)
    end

    self.MouseClick = function(sender, args)

        if args.Button == Turbine.UI.MouseButton.Right then 
            self.right_click_menu:ShowMenu()
        end

    end

    self.MouseDoubleClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then          
            savedata.groups[self.index].collapse = not(savedata.groups[self.index].collapse)
            self:Resize()
            self.parent:ResizeLists()
    
        end
    end


    self:Resize()

    self.item_export = Turbine.UI.MenuItem( "Export" , true )
    self.item_move = Turbine.UI.MenuItem( "Move" , true )
    self.item_edit = Turbine.UI.MenuItem( "Edit" , true )
    self.item_delete = Turbine.UI.MenuItem( "Delete" , true )

    self.right_click_menu = Turbine.UI.ContextMenu()
    self.menu_items = self.right_click_menu:GetItems()

    self.menu_items:Add(self.item_export)
    self.menu_items:Add(self.item_edit)
    self.menu_items:Add(self.item_move)
    self.menu_items:Add(self.item_delete)

    self.item_export.Click = function()

        Options.Import.WindowStateChanged(true)
        Options.Import.ExportGroup(savedata.groups[self.index])

    end

    self.item_edit.Click = function()

        self.parent:EditGroup(self.index)

    end

    self.item_move.Click = function()
        Options.Move.MoveChanged(false, nil, nil)
        Options.Move.MoveChanged(true, self.index, nil)

    end

    self.item_delete.Click = function()

        self.parent:DeleteGroupClicked(self.index)

    end

end