--[[
    CollectionList is the baselist that is used for temporary collection and permanent library
]]

CollectionList = class( Turbine.UI.Control )

function CollectionList:Constructor(parent, name, width)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent

    self.name = name
    self.width = width

    self.controls = {}
    self.collapsed = false

    self:Build()

end


---------------------------------------------------------------------------------------------------------
--public

function CollectionList:Sort(sort_func)

    self.list:Sort(sort_func)

end


function CollectionList:AddItem(item)
    self.list:AddItem(item)
end

function CollectionList:ClearItems()
    self.list:ClearItems()
end

function CollectionList:Resize()

    if self.collapsed == true then
        self.collapse:SetText("+")
        self.collapse:SetBackColor(COLOR_GRAY)
        self.header:SetBackColor(COLOR_VERY_DARK_GRAY)
        self:SetHeight(20)
    else
        self.collapse:SetText("-")
        self.collapse:SetBackColor(COLOR_DARK_GRAY)
        self.header:SetBackColor(Turbine.UI.Color.Black)

        local height = 0
        for i=1, self.list:GetItemCount(), 1 do
    
            height = height + self.list:GetItem(i):GetHeight()
    
        end
        self:SetHeight(20 + height)
        self.list:SetHeight(height)
    end

end


---------------------------------------------------------------------------------------------------------
--private

function CollectionList:CreateControls()

    self.controls = nil
    self.controls = {}

end

function CollectionList:Build()

    self:SetWidth(self.width)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetWidth(self.width)
    self.header:SetHeight(20)
    self.header:SetText("- "..self.name.." -")

    self.collapse = Turbine.UI.Button()
    self.collapse:SetParent(self.header)
    self.collapse:SetPosition(2,2)
    self.collapse:SetSize(COLLAPSE_SIZE, COLLAPSE_SIZE)
    self.collapse:SetBackColor(COLOR_GRAY)
    self.collapse:SetText("-")
    self.collapse:SetVisible(true)
    self.collapse.MouseClick = function()
        self.collapsed = not(self.collapsed)
        self:Resize()
    end

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetPosition(0, 20)
    self.list:SetWidth(self.width)

    self:Resize()

end
