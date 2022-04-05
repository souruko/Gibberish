SwatchBar = class(Turbine.UI.ListBox);

function SwatchBar:Constructor(parent, label)
    Turbine.UI.ListBox.Constructor(self);
    self:SetParent(parent);
    self:SetBackColor(Turbine.UI.Color(1, 0, 0, 0));

    self.borderOutside = Turbine.UI.Control();
    self.borderOutside:SetParent(parent);
    self.borderOutside:SetZOrder(self:GetZOrder() - 1);
    self.borderOutside:SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));

    self.borderInside = Turbine.UI.Control();
    self.borderInside:SetParent(parent);
    self.borderInside:SetZOrder(self:GetZOrder() - 1);
    self.borderInside:SetBackColor(Turbine.UI.Color.Black);

    self.interior = Turbine.UI.Control();
    self.interior:SetParent(self);
    self:AddItem(self.interior);

    self.label = Turbine.UI.Label();
    self.label:SetParent(self.interior);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.label:SetForeColor(Turbine.UI.Color(1, 1, 1, 1));
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.label:SetSize(80, 30);
    self.label:SetPosition(0, 3);
    self.label:SetText(label);
    self.nextSwatchLeft = self.label:GetWidth() + 2;

    self.scrollBar = Turbine.UI.Lotro.ScrollBar();
    self.scrollBar:SetParent(parent);
    self.scrollBar:SetBackColor(Turbine.UI.Color.Black);
    self.scrollBar:SetOrientation(Turbine.UI.Orientation.Horizontal);
    self:SetHorizontalScrollBar(self.scrollBar);
end

function SwatchBar:AddSwatch(color)
    local swatchSpacing = 2;
    local swatch = Turbine.UI.Control();
    swatch:SetParent(self.interior);
    swatch:SetSize(30, 30);
    swatch:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    swatch:SetBackColor(color);
    swatch:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
    swatch:SetPosition(self.nextSwatchLeft, 0);
    self.nextSwatchLeft = self.nextSwatchLeft + swatch:GetWidth() + swatchSpacing;
    self.interior:SetSize(self.nextSwatchLeft, 30);
    swatch.color = color;
    swatch.colorName = colorName;
    swatch.MouseClick = function(sender, args)
        self:GetParent():SetColor(sender.color);
    end
    swatch.MouseEnter = function(sender)
        local cursor = Turbine.UI.Control();
        cursor:SetParent(sender:GetParent());
        cursor:SetBackground(0x4112E573);
        cursor:SetBlendMode(Turbine.UI.BlendMode.Overlay);
        cursor:SetSize(30, 30);
        cursor:SetPosition(sender:GetPosition());
        cursor:SetZOrder(sender:GetZOrder() + 1);
        cursor:SetMouseVisible(false);
        sender.cursor = cursor;
    end
    swatch.MouseLeave = function(sender)
        if (sender.cursor) then
            sender.cursor:SetVisible(false);
            sender.cursor = nil;
        end
    end
end

function SwatchBar:SetPosition(left, top)
    Turbine.UI.ListBox.SetPosition(self, left, top);
    local borderSize = 3;
    self.borderOutside:SetPosition(left - borderSize, top - borderSize);
    self.borderInside:SetPosition(left - borderSize + 1, top - borderSize + 1);
    self.scrollBar:SetPosition(left, top + 31);
end

function SwatchBar:SetSize(width, height)
    local borderSize = 3;
    local scrollBarSize = 10;
    Turbine.UI.ListBox.SetSize(self, width, height - scrollBarSize);
    self.scrollBar:SetSize(width, 10);
    self.borderOutside:SetSize(width + (2 * borderSize), height + (2 * borderSize));
    self.borderInside:SetSize(self.borderOutside:GetWidth() - 2, self.borderOutside:GetHeight() - 2);
end
