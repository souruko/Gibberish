--[[
    TimerEdit child for displaying CollectionLists
]]

CollectionOverview = class( Turbine.UI.Control )

function CollectionOverview:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.searchText = ""

    self.effect_controls = {}
    self.chat_controls = {}
    self.skill_controls = {}
    self.timer_controls = {}

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function CollectionOverview:EffectControlClicked(token, icon, duration)
    self.parent:EffectControlClicked(token, icon, duration)
end

function CollectionOverview:ChatControlClicked(token, icon, duration)
    self.parent:ChatControlClicked(token, icon, duration)
end

function CollectionOverview:SkillControlClicked(token, icon, duration)
    self.parent:SkillControlClicked(token, icon, duration)
end

function CollectionOverview:TimerControlClicked(token, icon, duration)
    self.parent:TimerControlClicked(token, icon, duration)
end



function CollectionOverview:Resize(height)

    self:SetHeight(height - TOP_BAR - 3*FRAME - SPACER)
    self.background:SetHeight(self:GetHeight() - 2*FRAME )
    self.list:SetHeight(self.background:GetHeight() - SEARCH_HEIGHT )
    self.scroll:SetHeight(self.list:GetHeight())

end

function CollectionOverview:SetContent(window_index, timer_type, timer_index)

    self:SetVisible(true)

end

function CollectionOverview:CollectionChanged()

    self:CreateEffectControls()
    self:CreateChatControls()

    self:FillLists()

end

---------------------------------------------------------------------------------------------------------
--private

function CollectionOverview:CreateEffectControls()

    local width = self.list:GetWidth()

    self.effect_controls = nil
    self.effect_controls = {}

    for index, data in ipairs(collectiondata.effects) do
        self.effect_controls[index] = Items.EffectControl(self, width, data)
    end
    local i = table.getn(self.effect_controls)
    for index, data in ipairs(collectiontemp.effects) do
        self.effect_controls[i + index] = Items.EffectControl(self, width, data)
    end

end

function CollectionOverview:CreateChatControls()

    local width = self.list:GetWidth()

    self.chat_controls = nil
    self.chat_controls = {}

    for index, data in ipairs(collectiondata.chat) do
        self.chat_controls[index] = Items.ChatControl(self, width, data)
    end
    local i = table.getn(self.chat_controls)
    for index, data in ipairs(collectiontemp.chat) do
        self.chat_controls[i + index] = Items.ChatControl(self, width, data)
    end

end

function CollectionOverview:CreateSkillControls()

    local width = self.list:GetWidth()

    self.skill_controls = nil
    self.skill_controls = {}


    local list_of_skills = LOCALPLAYER:GetTrainedSkills()

    for index=1, list_of_skills:GetCount(), 1 do

        local skill = list_of_skills:GetItem(index)
        self.skill_controls[index] = Items.SkillControl(self, width, skill)

    end

end

function CollectionOverview:CreateTimerControls()

    local width = self.list:GetWidth()

    self.timer_controls = {}

    for i, window_data in ipairs(savedata) do
        for j, name in ipairs(TRIGGER_TYPE) do
            for k, timer_data in ipairs(window_data[j]) do

                local index = table.getn(self.timer_controls) + 1 
                self.timer_controls[index] = Items.TimerControl(self, width, i, j, k, timer_data)

            end
        end
    end

end

function CollectionOverview:CreateControls()

    self:CreateEffectControls()
    self:CreateChatControls()
    self:CreateSkillControls()
    self:CreateTimerControls()

end

function CollectionOverview:ClearLists()

    self.effect_list:ClearItems()
    self.chat_list:ClearItems()
    self.skill_list:ClearItems()
    self.timer_list:ClearItems()

end

function CollectionOverview:FillLists()

    self:ClearLists()

    --effects
    for index, item in ipairs(self.effect_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.effect_list:AddItem(item)
        end
    end
    self.effect_list:Resize()
    self.effect_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)

    --chat
    for index, item in ipairs(self.chat_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.chat_list:AddItem(item)
        end
    end
    self.chat_list:Resize()
    self.chat_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)

    --skills
    for index, item in ipairs(self.skill_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.skill_list:AddItem(item)
        end
    end
    self.skill_list:Resize()
    self.skill_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)

    --timer
    for index, item in ipairs(self.timer_controls) do
        if string.find(string.lower(item.token), self.searchText) then 
            self.timer_list:AddItem(item)
        end
    end
    self.timer_list:Resize()
    self.timer_list:Sort(function(elem1,elem2) if (elem1.token) < (elem2.token) then return true end end)


end

COLLECTIONOVERVIEW_WIDTH = 200

function CollectionOverview:Build()

    self:SetParent(self.parent)
    self:SetPosition(FRAME + TIMERSETTINGS_WIDTH + 2*SPACER, TOP_BAR + SPACER +FRAME)
    self:SetSize(COLLECTIONOVERVIEW_WIDTH + 2*FRAME, optionsdata.timer_edit.height - TOP_BAR - 3*FRAME - SPACER)
    self:SetBackColor(COLOR_LIGHT_GRAY)


    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, FRAME)
    self.background:SetSize(self:GetWidth() - 3*FRAME, self:GetHeight() - 2*FRAME )

    self.search = Turbine.UI.Lotro.TextBox()
    self.search:SetSize(self.background:GetWidth(), SEARCH_HEIGHT)
    self.search:SetPosition(0,0)
    self.search:SetParent(self.background)
    self.search:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search:SetFont(OPTIONS_FONT)
    self.search:SetText(L.search)
    self.search.FocusGained = function(sender, args)
		--self.search:SetForeColor(Turbine.UI.Color.White)
		if self.searchText == "" then
			self.search:SetText("")
		end		
	end
	self.search.FocusLost = function(sender, args)
		--self.search:SetForeColor(Turbine.UI.Color(0.7,0.7,0.7))
		if self.searchText == "" then
			self.search:SetText(L.search)
		end
	end
	self.search.TextChanged = function(sender, args)		
		self.searchText = string.lower(self.search:GetText())
		self:FillLists()
	end

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self.background)
    self.list:SetPosition(0, SEARCH_HEIGHT)
    self.list:SetSize(self.background:GetWidth() , self:GetHeight() - 2*FRAME - SEARCH_HEIGHT )

    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetHeight(self.list:GetHeight())
    self.scroll:SetPosition(self:GetWidth() - 10 ,self.list:GetTop())
    self.scroll:SetZOrder(100)
    self.list:SetVerticalScrollBar(self.scroll)


    self.effect_list = CollectionList(self, L.effects, self.list:GetWidth())
    self.chat_list = CollectionList(self, L.chat, self.list:GetWidth())
    self.skill_list = CollectionList(self, L.skills, self.list:GetWidth())
    self.timer_list = CollectionList(self, L.timer, self.list:GetWidth())

    self.list:AddItem(self.effect_list)
    self.list:AddItem(self.chat_list)
    self.list:AddItem(self.skill_list)
    self.list:AddItem(self.timer_list)

    self:CreateControls()
    self:FillLists()

end