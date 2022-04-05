--[[
    OptionsWindow child for timer selection from selected window
]]


Window = class( Turbine.UI.Control )

function Window:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.controls = {}

    self.searchText = ""

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Window:DraggingEnd(item)
    local x,y = self.list:GetMousePosition()

    local swap_item = self.list:GetItemAt(x, y) --math.floor(y / Item_HEIGHT) + 1

    if swap_item == nil or item == swap_item then
        return
    end

    local temp = swap_item.data.sort_index
    swap_item.data.sort_index = item.data.sort_index
    item.data.sort_index = temp

    self.list:Sort(function(elem1,elem2) if (elem1.data.sort_index) < (elem2.data.sort_index) then return true end end)

end

function Window:Resize()

    local width = TIMERSELECTION_WIDTH - (3 * FRAME)
    local height = optionsdata.options_window.height - 50

    self:SetSize(TIMERSELECTION_WIDTH, height)
    self.list:SetSize(width, height - (2*FRAME) - TOP_BAR - SEARCH_HEIGHT)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetPosition(self:GetWidth()-10,self.list:GetTop())


end

function Window:WindowSelectionChanged()

    self:ClearList()

    if G.selected_index_window == nil then
        self.add_button:SetEnabled(false)
        return
    end

    self.add_button:SetEnabled(true)
    self:CreateControls()
    self:FillList()

end

function Window:TimerEditClicked(timer_type, timer_index)

    self.parent:TimerEditClicked(timer_type, timer_index)

end

function Window:DeleteTimerClicked(timer_type, timer_index)

    self.parent:DeleteTimerClicked(timer_type, timer_index)

end


function Window:TimerDeleted()

    self:ClearList()
    self:CreateControls()
    self:FillList()


end

function Window:UpdateTimerItem(window_index, timer_type, timer_index)

    if G.selected_index_window == window_index then

        for index, control in ipairs(self.controls) do

            control:CheckForUpdate(timer_type, timer_index)

        end

    end

end


---------------------------------------------------------------------------------------------------------
--private

function Window:CreateControls()

    if G.selected_index_window ~= nil then

        for list_index, list in ipairs(savedata[G.selected_index_window]) do

            for index, data in ipairs(list) do

                local i = table.getn(self.controls) + 1

                self.controls[i] = Item(self, list_index, index)

            end

        end
        
    end

end


function Window:FillList()

    self.list:ClearItems()
    for index, control in ipairs(self.controls) do

        if control:ContainsSearchText(self.searchText) == true then
            self.list:AddItem(control)
        end

    end

    self.list:Sort(function(elem1,elem2) if (elem1.data.sort_index) < (elem2.data.sort_index) then return true end end)

end


function Window:ClearList()

    
    -- for index, control in ipairs(self.controls) do
        
    --     control:Close()
        
    -- end
    
    self.list:ClearItems()
    self.controls = {}

end

function Window:Build()

    self:SetPosition(SPACER + TIMERSELECTION_WIDTH + SPACER, TOP_SPACER)
    self:SetParent(self.parent)
    self:SetBackColor(COLOR_LIGHT_GRAY)
    
    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetSize(TIMERSELECTION_WIDTH, TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.timerHeader)
    self.header:SetMouseVisible(false)


    self.items = {}
    self.right_click_menu = Turbine.UI.ContextMenu()
    self.menu_items = self.right_click_menu:GetItems()
    
    for index, name in ipairs(TRIGGER_TYPE) do
        self.items[index] = Turbine.UI.MenuItem( name , true )
        self.menu_items:Add(self.items[index])
        self.items[index].Click = function()
            local i = DataFunctions.AddTimer(index, G.selected_index_window)
            self:TimerEditClicked(index, i)
            self:WindowSelectionChanged()
        end
    end


    self.add_button = Turbine.UI.Lotro.Button()
    self.add_button:SetParent(self)
    self.add_button:SetSize(40,20)
    self.add_button:SetLeft(FRAME)
    self.add_button:SetText(L.add)
    self.add_button:SetVisible(true)
    self.add_button:SetTop(FRAME)
    self.add_button.MouseClick = function()

        self.right_click_menu:ShowMenu()

    end


    self.search = Turbine.UI.Lotro.TextBox()
    self.search:SetSize(TIMERSELECTION_WIDTH - (3 * FRAME), SEARCH_HEIGHT)
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
		self:FillList()
	end

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetPosition(FRAME, FRAME + TOP_BAR + SEARCH_HEIGHT)
    self.list:SetBackColor(Turbine.UI.Color.Black)

    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetZOrder(100)
    self.list:SetVerticalScrollBar(self.scroll)

    self:Resize()

    self:SetVisible(true)

end