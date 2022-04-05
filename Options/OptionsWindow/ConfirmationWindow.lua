--[[
    OptionsWindow delete confirmation window
]]

ConfirmationWindow = class( Turbine.UI.Window )

function ConfirmationWindow:Constructor(parent)
    Turbine.UI.Window.Constructor( self )

    self.parent = parent

    --type: 1 == window, 2 == group, 3 == timer
    self.delete_type = nil
    self.index = nil
    self.index2 = nil

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function ConfirmationWindow:SetContent(delete_type, text, index, index2)

    self.delete_type = delete_type
    self.index = index
    self.index2 = index2

    self.text:SetText(text)

end

---------------------------------------------------------------------------------------------------------
--private

function ConfirmationWindow:DeleteClicked()

    if self.delete_type == 1 then

        DataFunctions.DeleteWindow(self.index)
        Options.WindowDeleted(self.index)

    elseif self.delete_type == 2 then
        
        Windows.UnloadAll()
        DataFunctions.DeleteGroup(self.index)
        Options.GroupDeleted(self.index)

    elseif self.delete_type == 3 then
        
        DataFunctions.DeleteTimer(self.index2, G.selected_index_window, self.index)
        Options.OptionsWindow.TimerDeleted()

    end

end

CONFIRMATIONWINDOW_HEIGHT = 130

function ConfirmationWindow:Build()

    self:SetParent(self.parent)
    self:SetSize(ADDWINDOW_WIDTH, CONFIRMATIONWINDOW_HEIGHT)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self:SetLeft((self.parent:GetWidth() / 2) - (ADDWINDOW_WIDTH / 2))
    self:SetTop((self.parent:GetHeight() / 2) - (CONFIRMATIONWINDOW_HEIGHT / 2))


    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.deleteConfirmationHeader)
    self.header:SetMouseVisible(false)
    self.header:SetWidth(ADDWINDOW_WIDTH)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, TOP_BAR + FRAME)
    self.background:SetSize(ADDWINDOW_WIDTH - (2*FRAME), CONFIRMATIONWINDOW_HEIGHT - TOP_BAR - (2*FRAME))

    function self.background:FillSelected()

    end

    local row = 1
    local row_height = 20

    self.text = Turbine.UI.Label()
    self.text:SetParent(self.background)
    self.text:SetFont(OPTIONS_FONT)
    self.text:SetSize(self.background:GetWidth(), 70)
    self.text:SetTop(row*row_height/2)
    self.text:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)
    self.text:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.text:SetMarkupEnabled(true)

    row = row + 4

    self.cancel_button = Turbine.UI.Lotro.Button()
    self.cancel_button:SetParent(self)
    self.cancel_button:SetSize(100,20)
    self.cancel_button:SetPosition(SPACER, row * row_height)
    self.cancel_button:SetText(L.cancel)
    self.cancel_button:SetVisible(true)
    self.cancel_button.MouseClick = function()
        self.parent:GetParent():ConfirmationWindow_Close()
    end

    self.create_button = Turbine.UI.Lotro.Button()
    self.create_button:SetParent(self)
    self.create_button:SetSize(100,20)
    self.create_button:SetPosition(self.background:GetWidth() - SPACER - 92, row * row_height)
    self.create_button:SetText(L.delete)
    self.create_button:SetVisible(true)
    self.create_button.MouseClick = function()
        self:DeleteClicked()
        self.parent:GetParent():ConfirmationWindow_Close()
    end

end