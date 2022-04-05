--[[
    Temporary Collection UI Element
]]

Collection = class( Turbine.UI.Control )

function Collection:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.searchText = ""
    self.effect_controls = {}
    self.chat_controls = {}

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Collection:SearchChanged(searchText)

    self.searchText = searchText
     self:Fill()

end


function Collection:CollectionChanged()

    self:CreateControls()
    self:Fill()

end

function Collection:Resize(height)

    self:SetHeight(height - TOP_BAR - 3*FRAME - SPACER)
    self.list:SetHeight(self:GetHeight() - 2*FRAME - TOP_BAR)
    self.scroll:SetHeight(self.list:GetHeight())

end

function Collection:EffectItemClicked(index)

    EffectToLibrary(index)
    self:CollectionChanged()
    self.parent:LibraryChanged()

end

function Collection:ChatItemClicked(index)

    ChatToLibrary(index)
    self:CollectionChanged()
    self.parent:LibraryChanged()

end



---------------------------------------------------------------------------------------------------------
--private

function Collection:CreateControls()

    local width = self.list:GetWidth()

    self.effect_controls = nil
    self.effect_controls = {}

    for index, data in ipairs(collectiontemp.effects) do
        self.effect_controls[index] = EffectItem(self, index, data, width)
    end

    self.chat_controls = nil
    self.chat_controls = {}

    for index, data in ipairs(collectiontemp.chat) do
        self.chat_controls[index] = ChatItem(self, index, data, width)
    end


end

function Collection:Fill()

    self.effect_list:ClearItems()
    self.chat_list:ClearItems()

    for index, item in ipairs(self.effect_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.effect_list:AddItem(item)
        end
    end
    self.effect_list:Resize()
    self.effect_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)

    for index, item in ipairs(self.chat_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.chat_list:AddItem(item)
        end
    end
    self.chat_list:Resize()
    self.chat_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)


end

function Collection:Build()

    self:SetParent(self.parent)
    self:SetPosition(3*FRAME + SPACER + COLLECTIONITEM_WIDTH , TOP_BAR + SPACER + FRAME)
    self:SetSize(COLLECTIONITEM_WIDTH + 2*FRAME, optionsdata.collection.height - TOP_BAR - 3*FRAME - SPACER)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.collectionHeader)
    self.header:SetMouseVisible(false)
    self.header:SetWidth(COLLECTIONITEM_WIDTH)

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetBackColor(Turbine.UI.Color.Black)
    self.list:SetPosition(FRAME, FRAME + TOP_BAR)
    self.list:SetSize(self:GetWidth() - 3*FRAME, self:GetHeight() - 2*FRAME - TOP_BAR)

    self.effect_list =  CollectionList(self,L.effects , self.list:GetWidth())
    self.chat_list =  CollectionList(self, L.chat, self.list:GetWidth())

    self.list:AddItem(self.effect_list)
    self.list:AddItem(self.chat_list)

    -- self.effect_list = Turbine.UI.ListBox()
    -- self.effect_list:SetPosition(FRAME, FRAME + TOP_BAR)
    -- self.effect_list:SetSize(self:GetWidth() - 3*FRAME, self:GetHeight() - 2*FRAME - TOP_BAR)

    -- self.chat_list = Turbine.UI.ListBox()ss
    -- self.chat_list:SetBackColor(Turbine.UI.Color.Black)
    -- self.chat_list:SetPosition(FRAME, FRAME + TOP_BAR)
    -- self.chat_list:SetSize(self:GetWidth() - 3*FRAME, self:GetHeight() - 2*FRAME - TOP_BAR)

    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetPosition(self:GetWidth() - 10 ,self.list:GetTop())
    self.scroll:SetZOrder(100)
    self.list:SetVerticalScrollBar(self.scroll)

    self:CollectionChanged()

end
