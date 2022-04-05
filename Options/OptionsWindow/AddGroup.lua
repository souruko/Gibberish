--[[
    OptionsWindow child for adding new group
]]

AddGroup = class( Turbine.UI.Window )

function AddGroup:Constructor(parent)
    Turbine.UI.Window.Constructor( self )

    self.parent = parent

    self.index = nil

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public



---------------------------------------------------------------------------------------------------------
--private


function AddGroup:ResetContent()

    self.index = nil
    self.header:SetText(L.addGroupHeader)
    self.create_button:SetText(L.create)
    self.name_tb:SetText(L.newGroup..savedata.next_group_id)
    self.color_control:SetBackColor(Turbine.UI.Color.Black)
    self.color_tb:SetText("0, 0, 0")

end

function AddGroup:EditWindowState(index)

    self.index = index
    self.header:SetText(L.editGroupHeader)
    self.create_button:SetText(L.change)
    self.name_tb:SetText(savedata.groups[index].name)

    local color = Turbine.UI.Color(savedata.groups[index].color.R, savedata.groups[index].color.G, savedata.groups[index].color.B)
    self.color_control:SetBackColor(color)
    self.color_tb:SetText(Utils.ColorToString(color))

end


ADDWINDOW_WIDTH = 250
ADDWINDOW_HEIGHT = 215

function AddGroup:Build()

    self:SetParent(self.parent)
    self:SetSize(ADDWINDOW_WIDTH, ADDWINDOW_HEIGHT)
    self:SetBackColor(COLOR_LIGHT_GRAY)
    self:SetOpacity(1)

    self:SetLeft((self.parent:GetWidth() / 2) - (ADDWINDOW_WIDTH / 2))
    self:SetTop((self.parent:GetHeight() / 2) - (ADDWINDOW_HEIGHT / 2))


    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
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
    self.window_type_lb:SetText(L.color)

    row = row + 1

    self.color_for_frames = Turbine.UI.Control()
    self.color_for_frames:SetParent(self.background)
    self.color_for_frames:SetSize(row_height, row_height)
    self.color_for_frames:SetPosition( (ADDWINDOW_WIDTH / 2) - 50 - row_height - 10, row*row_height)
    self.color_for_frames:SetBackColor(COLOR_DARK_GRAY)
    self.color_for_frames:SetMouseVisible(true)

    self.color_control = Turbine.UI.Control()
    self.color_control:SetParent(self.color_for_frames)
    self.color_control:SetSize(row_height -2, row_height - 2)
    self.color_control:SetPosition(1,1)
    self.color_control:SetBackColor(Turbine.UI.Color.Black)
    self.color_control:SetMouseVisible(true)
    self.color_control.MouseClick = function()

        if color_picker ~= nil then
            color_picker:Close()
        end

        color_picker = Utils.Thurallor.UI.ColorPicker(self.color_control:GetBackColor())

        color_picker.ColorChanged = function(picker)
            local newColor = picker:GetColor()
            self.color_control:SetBackColor(newColor)
            self.color_tb:SetText(Utils.ColorToString(newColor))
        end

    end

    self.color_tb = Turbine.UI.Lotro.TextBox()
    self.color_tb:SetSize(100 , row_height)
    self.color_tb:SetPosition((ADDWINDOW_WIDTH / 2) - 50 , row*row_height)
    self.color_tb:SetParent(self.background)
    self.color_tb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.color_tb:SetFont(OPTIONS_FONT)
    self.color_tb.TextChanged = function()

        local r, g, b = Utils.StringToColor(self.color_tb:GetText())

        if r ~= nil then
            self.color_control:SetBackColor(Turbine.UI.Color(r,g,b))
        end

    end

    row = row + 4

    self.cancel_button = Turbine.UI.Lotro.Button()
    self.cancel_button:SetParent(self)
    self.cancel_button:SetSize(100,20)
    self.cancel_button:SetPosition(SPACER, row * row_height)
    self.cancel_button:SetText(L.cancel)
    self.cancel_button:SetVisible(true)
    self.cancel_button.MouseClick = function()
        self.parent:GetParent():AddNewGroup_Close()
    end

    self.create_button = Turbine.UI.Lotro.Button()
    self.create_button:SetParent(self)
    self.create_button:SetSize(100,20)
    self.create_button:SetPosition(self.background:GetWidth() - SPACER - 92, row * row_height)
    self.create_button:SetText(L.create )
    self.create_button:SetVisible(true)
    self.create_button.MouseClick = function()
        if self.index == nil then

            local name = self.name_tb:GetText()
            if name == "" then
                name = L.newGroup..savedata.next_group_id
            end
            local index = DataFunctions.AddGroup(name, self.color_control:GetBackColor())
            Options.GroupAdded(index)

        else

            local name = self.name_tb:GetText()
            if name ~= "" then
                savedata.groups[self.index].name = name
            end

            local r, g, b = Utils.StringToColor(self.color_tb:GetText())
            if r ~= nil then
                savedata.groups[self.index].color.R = r
                savedata.groups[self.index].color.G = g
                savedata.groups[self.index].color.B = b
            end
            
            Options.GroupEdited(self.index)
        
        end
        
        self.parent:GetParent():AddNewGroup_Close()
    end

    self:ResetContent()

end
