--[[
    OptionsWindow child for adding new window
]]

AddWindow = class( Turbine.UI.Window )

function AddWindow:Constructor(parent)
    Turbine.UI.Window.Constructor( self )

    self.parent = parent

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public



---------------------------------------------------------------------------------------------------------
--private

function AddWindow:ResetContent()

    self.name_tb:SetText(L.newWindow..savedata.next_window_id)
    self.window_type_cb:SetSelection(1)

end

ADDWINDOW_WIDTH = 250
ADDWINDOW_HEIGHT = 215

function AddWindow:Build()

    self:SetParent(self.parent)
    self:SetSize(ADDWINDOW_WIDTH, ADDWINDOW_HEIGHT)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self:SetLeft((self.parent:GetWidth() / 2) - (ADDWINDOW_WIDTH / 2))
    self:SetTop((self.parent:GetHeight() / 2) - (ADDWINDOW_HEIGHT / 2))


    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.addNewWiindow )
    self.header:SetMouseVisible(false)
    self.header:SetWidth(ADDWINDOW_WIDTH)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, TOP_BAR + FRAME)
    self.background:SetSize(ADDWINDOW_WIDTH - (2*FRAME), ADDWINDOW_HEIGHT - TOP_BAR - (2*FRAME))

    function self.background:FillSelected()

    end

    local row = 1
    local row_height = 20

    self.name_lb = Turbine.UI.Label()
    self.name_lb:SetParent(self.background)
    self.name_lb:SetFont(OPTIONS_FONT)
    self.name_lb:SetSize(self.background:GetWidth(), row_height)
    self.name_lb:SetTop(row*row_height)
    self.name_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.name_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.name_lb:SetText(L.name)

    row = row + 1

    self.name_tb = Turbine.UI.Lotro.TextBox()
    self.name_tb:SetSize(self.background:GetWidth() - 2*SPACER , row_height)
    self.name_tb:SetPosition(SPACER, row*row_height)
    self.name_tb:SetParent(self.background)
    self.name_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.name_tb:SetFont(OPTIONS_FONT)

    row = row + 2

    self.window_type_lb = Turbine.UI.Label()
    self.window_type_lb:SetParent(self.background)
    self.window_type_lb:SetFont(OPTIONS_FONT)
    self.window_type_lb:SetSize(self.background:GetWidth(), row_height)
    self.window_type_lb:SetTop(row*row_height)
    self.window_type_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.window_type_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.window_type_lb:SetText(L.windowType)

    row = row + 1

    self.window_type_cb = LabelledComboBox(nil, nil, 160)
	self.window_type_cb:SetParent(self.background)
    self.window_type_cb:SetPosition((self.background:GetWidth() / 2) - 80, row * row_height)
    for k,v in ipairs(WINDOW_TYPE) do
        self.window_type_cb:AddItem(v, k)
    end

    row = row + 4

    self.cancel_button = Turbine.UI.Lotro.Button()
    self.cancel_button:SetParent(self)
    self.cancel_button:SetSize(100,20)
    self.cancel_button:SetPosition(SPACER, row * row_height)
    self.cancel_button:SetText(L.cancel)
    self.cancel_button:SetVisible(true)
    self.cancel_button.MouseClick = function()
        self.parent:GetParent():AddNewWindow_Close()
    end

    self.create_button = Turbine.UI.Lotro.Button()
    self.create_button:SetParent(self)
    self.create_button:SetSize(100,20)
    self.create_button:SetPosition(self.background:GetWidth() - SPACER - 92, row * row_height)
    self.create_button:SetText(L.create)
    self.create_button:SetVisible(true)
    self.create_button.MouseClick = function()
        local name = self.name_tb:GetText()
        if name == "" then
            name = L.newWindow..savedata.next_window_id
        end
        local index = DataFunctions.AddWindow(name, self.window_type_cb:GetSelection())
         Options.WindowAdded(index)
         self.parent:GetParent():AddNewWindow_Close()
    end

    self:ResetContent()

end