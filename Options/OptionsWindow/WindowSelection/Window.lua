--[[
    OptionsWindow child for window selection
]]

Window = class( Turbine.UI.Control )

function Window:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.group_controls = {}
    self.window_controls = {}

    self.selected = nil
    self.searchText = ""


    self:Build()


end

---------------------------------------------------------------------------------------------------------
--public

function Window:DeleteWindowClicked(index)

    self.parent:DeleteWindowClicked(index)

end

function Window:DeleteGroupClicked(index)

    self.parent:DeleteGroupClicked(index)

end

function Window:GroupEdited(index)

    self.group_controls[index]:UpdateData()

end

function Window:EditGroup(index)

    self.parent:EditGroup(index)

end

function Window:GroupLoadStatusChanged(index)

    if self.group_controls[index] ~= nil then
        --self.group_controls[index].load:SetChecked(savedata.groups[index].load)
        self:CreateListControls()
        self:FillLists()
    end

end


function Window:Resize()

    local width = WINDOWSELECTION_WIDTH - (3 * FRAME)
    local height = optionsdata.options_window.height - 50

    self:SetSize(WINDOWSELECTION_WIDTH, height)
    self.list:SetSize(width, height - (2*FRAME) - TOP_BAR - SEARCH_HEIGHT)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetPosition(self:GetWidth()-10,self.list:GetTop())

    self.loaded_list:SetWidth(width)
    self.not_loaded_list:SetWidth(width)

    self.loaded_header:SetSize(width, 20)
    self.not_loaded_header:SetSize(width, 20)

end

function Window:ClearList()

    self.loaded_list:ClearItems()
    self.not_loaded_list:ClearItems()

    for index, item in ipairs(self.group_controls) do
        item.list:ClearItems()
    end


end


function Window:FillLists()

    self:ClearList()

    for index, window_data in ipairs(savedata) do

        if window_data.group ~= nil then

            local i =  DataFunctions.GetGroupIndexFromId(window_data.group)
            self.group_controls[i]:AddItem(self.window_controls[index])

        else

            if string.find(string.lower(window_data.name), self.searchText) then

                if window_data.load == true then

                    self.loaded_list:AddItem(self.window_controls[index])

                else

                    self.not_loaded_list:AddItem(self.window_controls[index])


                end

            end

        end

    end

    for index, group_data in ipairs(savedata.groups) do

        if self.group_controls[index]:ContainsSearchText(self.searchText) then

            if group_data.load == true then

                self.loaded_list:AddItem(self.group_controls[index])

            else

                self.not_loaded_list:AddItem(self.group_controls[index])

            end

        end

    end

    

    self:ResizeLists()
    self.loaded_list:Sort(function(elem1,elem2) if (elem1.name) < (elem2.name) then return true end end)
    self.not_loaded_list:Sort(function(elem1,elem2) if (elem1.name)<(elem2.name) then return true end end)

end


function Window:CreateListControls()

    self.window_controls = {}
    self.group_controls = {}

    for index, group_data in ipairs(savedata.groups) do

        self.group_controls[index] = GroupItem(self, index)

    end

    for index, window_data in ipairs(savedata) do

        self.window_controls[index] = WindowItem(self, index)

    end

    self:FillLists()

    self:ResizeLists()

end

function Window:ResizeLists()

    local height = 0
    for i=1, self.loaded_list:GetItemCount(), 1 do

        height = height + self.loaded_list:GetItem(i):GetHeight()

    end
    self.loaded_list:SetHeight(height)

    height = 0
    for i=1, self.not_loaded_list:GetItemCount(), 1 do

        height = height + self.not_loaded_list:GetItem(i):GetHeight()

    end
    self.not_loaded_list:SetHeight(height)

end

function Window:WindowItemClicked(window_item, group_item)

    self.selected = window_item

    for index, item in ipairs(self.group_controls) do

        item:SetSelected(false)

    end

    for index, item in ipairs( self.window_controls) do

        item:SetSelected(false)

    end

    for i=1, self.loaded_list:GetItemCount(), 1 do

        self.loaded_list:GetItem(i):SetSelected(false)

    end

    for i=1, self.not_loaded_list:GetItemCount(), 1 do

        self.not_loaded_list:GetItem(i):SetSelected(false)

    end
    
    if self.selected ~= nil then
    
        if group_item ~= nil then
            group_item:SetSelected(true)
        end

        window_item:SetSelected(true)

    end

    Options.WindowSelectionChanged(window_item.index)

end

function Window:WindowSelectionChanged()

    if self.selected ~= nil then
        if self.selected.index == G.selected_index_window then
            return
        end
    end
 
    if G.selected_index_window == nil then

    else
        self.window_controls[G.selected_index_window]:Select()
    end

end

---------------------------------------------------------------------------------------------------------
--private

function Window:CollapseAll()

    for index, control in ipairs(self.group_controls) do
        control:Collaps(true)
    end

end

function Window:Build()

    self:SetPosition(SPACER, TOP_SPACER)
    self:SetParent(self.parent)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetSize(WINDOWSELECTION_WIDTH, TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText("- "..L.window.." -")
    self.header:SetMouseVisible(false)

    self.item_window = Turbine.UI.MenuItem( L.window , true )
    self.item_group = Turbine.UI.MenuItem( L.group , true )

    self.right_click_menu = Turbine.UI.ContextMenu()
    self.menu_items = self.right_click_menu:GetItems()

    self.menu_items:Add(self.item_window)
    self.menu_items:Add(self.item_group)

    self.add_button = Turbine.UI.Lotro.Button()
    self.add_button:SetParent(self)
    self.add_button:SetSize(40,20)
    self.add_button:SetLeft(FRAME)
    self.add_button:SetText(L.add )
    self.add_button:SetVisible(true)
    self.add_button:SetTop(FRAME)
    self.add_button.MouseClick = function()

        self.right_click_menu:ShowMenu()

    end

    self.item_window.Click = function()

        self.parent:AddNewWindow()

    end

    self.item_group.Click = function()

        self.parent:AddNewGroup()

    end


    self.collapse = Turbine.UI.Button()
    self.collapse:SetParent(self)
    self.collapse:SetPosition(WINDOWSELECTION_WIDTH - (2*FRAME) - COLLAPSE_SIZE, FRAME + 1)
    self.collapse:SetSize(COLLAPSE_SIZE, COLLAPSE_SIZE)
    self.collapse:SetBackColor(Turbine.UI.Color(0.1,0.1,0.1))
    self.collapse:SetText("-")
    self.collapse:SetVisible(true)
    self.collapse.MouseClick = function()

        self:CollapseAll()
        SaveWindowData()

    end

    self.search = Turbine.UI.Lotro.TextBox()
    self.search:SetSize(WINDOWSELECTION_WIDTH - (3 * FRAME), SEARCH_HEIGHT)
    self.search:SetPosition(FRAME, FRAME + TOP_BAR)
    self.search:SetParent(self)
    self.search:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search:SetFont(OPTIONS_FONT)
    self.search:SetText(L.search )
    self.search.FocusGained = function(sender, args)
		--self.search:SetForeColor(Turbine.UI.Color.White)
		if self.searchText == "" then
			self.search:SetText("")
		end		
	end
	self.search.FocusLost = function(sender, args)
		--self.search:SetForeColor(Turbine.UI.Color(0.7,0.7,0.7))
		if self.searchText == "" then
			self.search:SetText(L.search )
		end
	end
	self.search.TextChanged = function(sender, args)		
		self.searchText = string.lower(self.search:GetText())
		self:FillLists()
	end

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetPosition(FRAME, FRAME + TOP_BAR + SEARCH_HEIGHT)
    self.list:SetBackColor(Turbine.UI.Color.Black)

    self.loaded_list = Turbine.UI.ListBox()
    
    self.not_loaded_list = Turbine.UI.ListBox()
    
    self.loaded_header = Turbine.UI.Label()
    self.loaded_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.loaded_header:SetFont(OPTIONS_FONT)
    self.loaded_header:SetText(L.load)
    
    self.not_loaded_header = Turbine.UI.Label()
    self.not_loaded_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.not_loaded_header:SetFont(OPTIONS_FONT)
    self.not_loaded_header:SetText(L.not_load)
    
    self.list:AddItem(self.loaded_header)
    self.list:AddItem(self.loaded_list)
    self.list:AddItem(self.not_loaded_header)
    self.list:AddItem(self.not_loaded_list)
    
    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetZOrder(100)
    self.list:SetVerticalScrollBar(self.scroll)

    -- self.search = Turbine.UI.Lotro.TextBox()
	-- self.search:SetSize(self.foreground:GetWidth()-2, 25)
	-- self.search:SetPosition(1,26)
	-- self.search:SetParent(self.foreground)
	-- self.search:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    -- self.search:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    -- self.search:SetFontStyle(Turbine.UI.FontStyle.None)
	-- self.search:SetForeColor(FRAME_color)
    -- self.search:SetText("Search ...")
    -- self.search.FocusGained = function(sender, args)
	-- 	--self.search:SetForeColor(Turbine.UI.Color.White)
	-- 	if self.searchText == "" then
	-- 		self.search:SetText("")
	-- 	end		
	-- end
	-- self.search.FocusLost = function(sender, args)
	-- 	--self.search:SetForeColor(Turbine.UI.Color(0.7,0.7,0.7))
	-- 	if self.searchText == "" then
	-- 		self.search:SetText("Search ...")
	-- 	end
	-- end
	-- self.search.TextChanged = function(sender, args)		
	-- 	self.searchText = string.lower(self.search:GetText())
	-- 	self.parent:FilterContent(self.searchText, self)
	-- end

    self:CreateListControls()

    self:Resize()
    

    self:SetVisible(true)

end