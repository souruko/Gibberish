--[[
    Collecting Settings and Searchbar
]]

TrackingWindow = class( Turbine.UI.Control )

function TrackingWindow:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.searchText = ""

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public


function TrackingWindow:Resize(height)

    self:SetHeight(height - TOP_BAR - 3*FRAME - SPACER)
    self.background:SetHeight(self:GetHeight() - 2*FRAME - TOP_BAR)

end

function TrackingWindow:SetContent()

    if collectEffects == false then
        self.effect_button:SetText(L.track)
        self.effect_button:SetForeColor(Turbine.UI.Color.Yellow)
        self.effect_header:SetForeColor(COLOR_LIGHT_GRAY)
    else
        self.effect_button:SetText(L.stop)
        self.effect_button:SetForeColor(Turbine.UI.Color.Red)
        self.effect_header:SetForeColor(Turbine.UI.Color.White)
    end

    if only_debuffs == true then
        self.onlydebuff_header:SetForeColor(Turbine.UI.Color.White)
    else
        self.onlydebuff_header:SetForeColor(COLOR_LIGHT_GRAY)
    end



    if collectChat == false then
        self.chat_button:SetText(L.track)
        self.chat_button:SetForeColor(Turbine.UI.Color.Yellow)
        self.chat_header:SetForeColor(COLOR_LIGHT_GRAY)
    else
        self.chat_button:SetText(L.stop)
        self.chat_button:SetForeColor(Turbine.UI.Color.Red)
        self.chat_header:SetForeColor(Turbine.UI.Color.White)
    end

    if only_say == true then
        self.onlysay_header:SetForeColor(Turbine.UI.Color.White)
    else
        self.onlysay_header:SetForeColor(COLOR_LIGHT_GRAY)
    end

end

---------------------------------------------------------------------------------------------------------
--private

COLLECTIONITEM_WIDTH = 200

function TrackingWindow:Build()

    self:SetParent(self.parent)
    self:SetPosition(FRAME , TOP_BAR + SPACER + FRAME)
    self:SetSize(COLLECTIONITEM_WIDTH + 2*FRAME, optionsdata.collection.height - TOP_BAR - 3*FRAME - SPACER)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.fillCollectionHeader)
    self.header:SetMouseVisible(false)
    self.header:SetWidth(COLLECTIONITEM_WIDTH)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, FRAME + TOP_BAR)
    self.background:SetSize(self:GetWidth() - 2*FRAME, self:GetHeight() - 2*FRAME - TOP_BAR)
    
    self.search = Turbine.UI.Lotro.TextBox()
    self.search:SetSize(COLLECTIONITEM_WIDTH, SEARCH_HEIGHT)
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
		self.parent:SearchChanged(self.searchText)
	end


    self.effect_header = Turbine.UI.Label()
    self.effect_header:SetParent(self.background)
    self.effect_header:SetFont(OPTIONS_FONT)
    self.effect_header:SetSize(self.background:GetWidth(), 20)
    self.effect_header:SetPosition(0, TOP_BAR + 20)
    self.effect_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.effect_header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.effect_header:SetText(L.effects)

    self.effect_button = Turbine.UI.Lotro.Button()
    self.effect_button:SetParent(self.background)
    self.effect_button:SetSize(60,20)
    self.effect_button:SetFont(OPTIONS_FONT)
    self.effect_button:SetPosition(SPACER, self.effect_header:GetTop() + 25)
    self.effect_button:SetVisible(true)


    self.onlydebuff_header = Turbine.UI.Label()
    self.onlydebuff_header:SetParent(self.background)
    self.onlydebuff_header:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.onlydebuff_header:SetSize(100, 20)
    self.onlydebuff_header:SetPosition(self.effect_button:GetWidth() + SPACER + 5,  self.effect_header:GetTop() + 25)
    self.onlydebuff_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.onlydebuff_header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.onlydebuff_header:SetText(L.onlyDebuffs)

    self.onlydebuff_checkbox =  Turbine.UI.Lotro.CheckBox()
	self.onlydebuff_checkbox:SetParent(self.background)
    self.onlydebuff_checkbox:SetSize(20, 20)
    self.onlydebuff_checkbox:SetText("")
    self.onlydebuff_checkbox:SetPosition(self.background:GetWidth() - SPACER - 20,  self.effect_header:GetTop() + 25)

    self.spacer_bar = Turbine.UI.Control()
    self.spacer_bar:SetParent(self.background)
    self.spacer_bar:SetSize(self.background:GetWidth(), 2)
    self.spacer_bar:SetBackColor(COLOR_LIGHT_GRAY)
    self.spacer_bar:SetTop(self.effect_header:GetTop() + 65)

    self.chat_header = Turbine.UI.Label()
    self.chat_header:SetParent(self.background)
    self.chat_header:SetFont(OPTIONS_FONT)
    self.chat_header:SetSize(self.background:GetWidth(), 20)
    self.chat_header:SetPosition(0, TOP_BAR + 100 + 20)
    self.chat_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.chat_header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.chat_header:SetText(L.chat)

    self.chat_button = Turbine.UI.Lotro.Button()
    self.chat_button:SetParent(self.background)
    self.chat_button:SetSize(60,20)
    self.chat_button:SetFont(OPTIONS_FONT)
    self.chat_button:SetPosition(SPACER, self.chat_header:GetTop() + 25)
    self.chat_button:SetVisible(true)


    self.onlysay_header = Turbine.UI.Label()
    self.onlysay_header:SetParent(self.background)
    self.onlysay_header:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.onlysay_header:SetSize(100, 20)
    self.onlysay_header:SetPosition(self.effect_button:GetWidth() + SPACER + 5,  self.chat_header:GetTop() + 25)
    self.onlysay_header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.onlysay_header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.onlysay_header:SetText(L.onlySay)

    self.onlysay_checkbox =  Turbine.UI.Lotro.CheckBox()
	self.onlysay_checkbox:SetParent(self.background)
    self.onlysay_checkbox:SetSize(20, 20)
    self.onlysay_checkbox:SetText("")
    self.onlysay_checkbox:SetPosition(self.background:GetWidth() - SPACER - 20,  self.chat_header:GetTop() + 25)

    self.spacer_bar2 = Turbine.UI.Control()
    self.spacer_bar2:SetParent(self.background)
    self.spacer_bar2:SetSize(self.background:GetWidth(), 2)
    self.spacer_bar2:SetBackColor(COLOR_LIGHT_GRAY)
    self.spacer_bar2:SetTop(self.chat_header:GetTop() + 65)

    self:SetContent()


    self.chat_button.MouseClick = function()
        collectChat = not(collectChat)

        if collectChat == false then
            self.chat_button:SetText(L.track)
            self.chat_button:SetForeColor(Turbine.UI.Color.Yellow)
            self.chat_header:SetForeColor(COLOR_LIGHT_GRAY)
        else
            self.chat_button:SetText(L.stop)
            self.chat_button:SetForeColor(Turbine.UI.Color.Red)
            self.chat_header:SetForeColor(Turbine.UI.Color.White)
        end
    end

    self.onlysay_checkbox.CheckedChanged = function()

        only_say = self.onlysay_checkbox:IsChecked()

        if only_say == true then
            self.onlysay_header:SetForeColor(Turbine.UI.Color.White)
        else
            self.onlysay_header:SetForeColor(COLOR_LIGHT_GRAY)
        end
    end

    self.effect_button.MouseClick = function()
        collectEffects = not(collectEffects)

        if collectEffects == false then
            self.effect_button:SetText(L.track)
            self.effect_button:SetForeColor(Turbine.UI.Color.Yellow)
            self.effect_header:SetForeColor(COLOR_LIGHT_GRAY)
        else
            self.effect_button:SetText(L.stop)
            self.effect_button:SetForeColor(Turbine.UI.Color.Red)
            self.effect_header:SetForeColor(Turbine.UI.Color.White)

            Trigger.Effects.checkAllActivEffectsForCollection()
        end
        
    end

    self.onlydebuff_checkbox.CheckedChanged = function()

        only_debuffs = self.onlydebuff_checkbox:IsChecked()

        if only_debuffs == true then
            self.onlydebuff_header:SetForeColor(Turbine.UI.Color.White)
        else
            self.onlydebuff_header:SetForeColor(COLOR_LIGHT_GRAY)
        end
    end

end