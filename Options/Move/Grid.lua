--[[
    Background Grid for Window Moving
]]


Grid = class( Turbine.UI.Window )

function Grid:Constructor()
    Turbine.UI.Window.Constructor( self )

    self:Draw()
end

function Grid:Draw()

    local parts = 100

    local left_space = SCREEN_WIDTH / parts
    local top_space = SCREEN_HEIGHT / parts

    self:SetSize(SCREEN_WIDTH, SCREEN_HEIGHT)
    self:SetPosition(0,0)
    self:SetMouseVisible(false)
    self:SetBackColor(Turbine.UI.Color.White)
    self:SetOpacity(0.1)

    self.vertical_lines = {}

    self.horizontal_lines = {}

    for i=1, parts-1, 1 do

        self.horizontal_lines[i] = self:GetLine()
        self.horizontal_lines[i]:SetPosition(0, (top_space * i) - 1)
        self.horizontal_lines[i]:SetSize(SCREEN_WIDTH, 2)

        self.vertical_lines[i] = self:GetLine()
        self.vertical_lines[i]:SetPosition((left_space * i) - 1, 0)
        self.vertical_lines[i]:SetSize(2, SCREEN_HEIGHT)

    end

    local quater = parts/4
    self.horizontal_lines[quater]:SetHeight(6)
    self.horizontal_lines[quater]:SetTop(self.horizontal_lines[quater]:GetTop() - 2)

    self.horizontal_lines[2 * quater]:SetHeight(6)
    self.horizontal_lines[2 * quater]:SetTop(self.horizontal_lines[2 * quater]:GetTop() - 2)

    self.horizontal_lines[3 * quater]:SetHeight(6)
    self.horizontal_lines[3 * quater]:SetTop(self.horizontal_lines[3 * quater]:GetTop() - 2)

    self.vertical_lines[quater]:SetWidth(6)
    self.vertical_lines[quater]:SetLeft(self.vertical_lines[quater]:GetLeft() - 2)

    self.vertical_lines[2 * quater]:SetWidth(6)
    self.vertical_lines[2 * quater]:SetLeft(self.vertical_lines[2 * quater]:GetLeft() - 2)

    self.vertical_lines[3 * quater]:SetWidth(6)
    self.vertical_lines[3 * quater]:SetLeft(self.vertical_lines[3 * quater]:GetLeft() - 2)

    self:SetVisible(true)

end

function Grid:GetLine()

    local item = Turbine.UI.Control()
    item:SetParent(self)
    item:SetBackColor(Turbine.UI.Color.Black)    
    item:SetMouseVisible(false)

    return item
    
end