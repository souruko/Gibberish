--[[
    CollectionLists child for SkillItems
]]


SkillControl = class( Turbine.UI.Control )

function SkillControl:Constructor(parent, width, data)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent

    self.index = index
    self.token = data:GetSkillInfo():GetName()
    self.data = data
    self.width = width

    self:Build()

end


---------------------------------------------------------------------------------------------------------
--public

---------------------------------------------------------------------------------------------------------
--private

local COL_ITEM_HEIGHT = 42


function SkillControl:Build()

    self:SetWidth(self.width)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetBackColor(Turbine.UI.Color.Back)
    self.frame:SetWidth(self.width)
    self.frame:SetMouseVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self.frame)
    self.background:SetPosition(1,1)
    self.background:SetBackColor(COLOR_DARK_GRAY)
    self.background:SetWidth(self.width - 2)
    self.background:SetMouseVisible(false)

    self.icon_control = Turbine.UI.Control()
    self.icon_control:SetParent(self.background)
    self.icon_control:SetPosition(4,4)
    self.icon_control:SetSize(32, 32)
    self.icon_control:SetMouseVisible(false)
    self.icon_control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
    self.icon = self.data:GetSkillInfo():GetIconImageID()
    if self.icon ~= nil then
        self.icon_control:SetBackground(self.icon)
    else
        self.icon_control:SetBackColor(COLOR_VERY_DARK_GRAY)
    end


    self.token_l = Turbine.UI.Label()
    self.token_l:SetParent(self.background)
    self.token_l:SetFont(OPTIONS_FONT)
    self.token_l:SetLeft(36)
    self.token_l:SetSize(self.background:GetWidth() - 36, COL_ITEM_HEIGHT)
    self.token_l:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.token_l:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.token_l:SetText(self.data:GetSkillInfo():GetName())
    self.token_l:SetMouseVisible(false)


    self.description_l = Turbine.UI.Label()
    self.description_l:SetParent(self.background)
    self.description_l:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.description_l:SetTop(COL_ITEM_HEIGHT)
    self.description_l:SetSize(self.background:GetWidth(), COL_ITEM_HEIGHT)
    self.description_l:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter)
    self.description_l:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.description_l:SetForeColor(COLOR_LIGHT_GRAY)
    self.description_l:SetMarkupEnabled(true)
    self.description_l:SetText(self.data:GetSkillInfo():GetDescription())
    self.description_l:SetMouseVisible(false)

    if self.description_l:GetText() == "" or self.description_l:GetText() == nil then
        self:SetHeight(COL_ITEM_HEIGHT + 2)
        self.frame:SetHeight(COL_ITEM_HEIGHT)
        self.background:SetHeight(COL_ITEM_HEIGHT - 2)
    else
        self:SetHeight(2*COL_ITEM_HEIGHT + 2)
        self.frame:SetHeight(2*COL_ITEM_HEIGHT)
        self.background:SetHeight(2*COL_ITEM_HEIGHT - 2)
    end

    self.MouseEnter = function()
        self.frame:SetBackColor(Turbine.UI.Color.White)
        self:SetZOrder(30)
    end

    self.MouseLeave = function()
        self.frame:SetBackColor(Turbine.UI.Color.Back)
        self:SetZOrder(nil)
    end

    self.MouseClick = function()
        self.parent:SkillControlClicked(self.token, self.icon, self.data:GetCooldown())
    end

end
