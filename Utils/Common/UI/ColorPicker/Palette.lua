Palette = class(Turbine.UI.Control);

local importPath = getfenv(1)._.Name;
local imagePath = string.gsub(string.gsub(importPath, "%.Palette$", ""), "%.", "/");

function Palette:Constructor(parent, dimensionX, dimensionY, color)
    Turbine.UI.Control.Constructor(self);

    self:SetParent(parent);
    self.valueX, self.valueY = 0.5, 0.5;

    self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self:SetBackground(imagePath .. "/V_x_H.tga");
    self:SetStretchMode(2);
    self.width, self.height = self:GetSize();
    
    self.overlay = Turbine.UI.Window();
    self.overlay:SetBackground(imagePath .. "/V_x_H.tga");
    self.overlay:SetStretchMode(2);
    self.overlay:SetVisible(true);
    self.overlay:SetSize(self.width, self.height);

    self.colorName = Turbine.UI.Window();
    self.colorName:SetVisible(true);
    self.colorName:SetMouseVisible(false);
    self.colorName.label = Turbine.UI.Label();
    self.colorName.label:SetMouseVisible(false);
    self.colorName.label:SetParent(self.colorName);
    self.colorName.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.colorName.label:SetForeColor(Turbine.UI.Color(1, 1, 1, 1));
    self.colorName.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.colorName.label:SetOutlineColor(Turbine.UI.Color(0.75, 0, 0, 0));
    self.colorName.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.colorName.label:SetText("temp");
    self.colorName.SetSize = function(sender, width, height)
        Turbine.UI.Window.SetSize(sender, width, height);
        sender.label:SetSize(width, height);
    end
    self.colorName:SetSize(self.width, 20);
    
    self.pointer = Turbine.UI.Window();
    self.pointer:SetVisible(true);   
    self.pointer:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.pointer:SetBackground(0x4112E573);
    self.pointer:SetSize(30, 30);
    self.pointer:SetStretchMode(2);
    self.spot = Turbine.UI.Window();
    self.spot:SetVisible(true); 
    self.spot:SetBackground(imagePath .. "/spot.tga");
    self.spot:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
    self.spot:SetSize(30, 30);
    self.spot:SetStretchMode(2);
    self.pointer.MouseDown = function()
        self.pointer.mouseDown = true;
        self.pointer:MouseMove();
    end
    self.pointer.MouseUp = function()
        self.pointer.mouseDown = false;
    end
    self.pointer.MouseMove = function()
        if (self.pointer.mouseDown) then
            local newX, newY = self:PointToClient(Turbine.UI.Display.GetMouseX(), Turbine.UI.Display.GetMouseY());
            self.valueX = newX / self.width;
            self.valueY = 1 - newY / self.height;
            if (self.valueX < 0.001) then
                self.valueX = 0.001;
            elseif (self.valueX > 0.999) then
                self.valueX = 0.999;
            end
            if (self.valueY < 0.001) then
                self.valueY = 0.001;
            elseif (self.valueY > 0.999) then
                self.valueY = 0.999;
            end
            self:SetPointerPosition();
            if (self.ColorChanged) then
                self:ColorChanged();
            end
        end
    end
    self.spot.MouseDown = self.pointer.MouseDown;
    self.spot.MouseUp = self.pointer.MouseUp;
    self.spot.MouseMove = self.pointer.MouseMove;
    self.overlay.MouseDown = self.pointer.MouseDown;
    self.overlay.MouseUp = self.pointer.MouseUp;
    self.overlay.MouseMove = self.pointer.MouseMove;
    self.MouseDown = self.pointer.MouseDown;
    self.MouseUp = self.pointer.MouseUp;
    self.MouseMove = self.pointer.MouseMove;

    self:SetZOrder(self:GetZOrder());
    self:SetDimensions(dimensionX, dimensionY);
    self:SetColor(color);
end

function Palette:SetZOrder(z)
    Turbine.UI.Control.SetZOrder(self, z);
    self.overlay:SetZOrder(z + 1);
    self.colorName:SetZOrder(z + 2);
    self.pointer:SetZOrder(z + 2);
    self.spot:SetZOrder(z + 3);
end

function Palette:SetPosition(left, top)
    Turbine.UI.Control.SetPosition(self, left, top);
    local screen_left, screen_top = self:PointToScreen(0, 0);
    self.overlay:SetPosition(screen_left, screen_top);
    self.colorName:SetLeft(screen_left);
    self:SetColorNamePosition();
end

function Palette:SetPointerPosition()
    local left = math.floor(self.width * self.valueX + 0.5) - 15;
    local top = math.floor(self.height * (1 - self.valueY) + 0.5) - 15;
    local l, t = self:PointToScreen(left, top);
    self:SetZOrder(self:GetZOrder());
    self.pointer:SetPosition(l, t);
    self.spot:SetPosition(l, t);
    self:SetColorNamePosition();
end

function Palette:SetColorNamePosition()
    -- Move color name to a good position within the overlay which is
    -- near the spot but not overlapping it.
    if (self.valueY < 0.5) then
        self.colorName:SetTop(self.pointer:GetTop() - 20);
    else
        self.colorName:SetTop(self.pointer:GetTop() + 30);
    end
    local center = self.pointer:GetLeft() + 15;
    self.colorName:SetLeft(center - math.floor(0.5 + self.width / 2));
end

function Palette:ShowColorName(nameStr)
    if (nameStr) then
        self.colorName:SetVisible(true);
        self.colorName.label:SetText(nameStr);
    else
        self.colorName:SetVisible(false);
    end
end

function Palette:SetGamut(color)
    local sliderDimension = Thurallor.Utils.Color.GetOtherDimensions(self.dimensionY);
    local sliderValue = color:Get(sliderDimension);
    if (string.find("RGB", sliderDimension)) then
        local backColor = Thurallor.Utils.Color(sliderValue, 0, 0, 0);
        backColor[sliderDimension] = 1;
        self.overlay:SetBackColor(backColor);
    elseif (sliderDimension == "S") then
        local backColor = Thurallor.Utils.Color(1 - sliderValue, 1, 1, 1);
        self.overlay:SetBackColor(backColor);
    elseif (sliderDimension == "H") then
        local backColor = Thurallor.Utils.Color(1, 0, 0, 0);
        backColor:SetHSV(sliderValue, 1, 1);
        self:SetBackColor(backColor);
    else -- (sliderDimension == "V")
        local backColor = Thurallor.Utils.Color(1 - sliderValue, 0, 0, 0);
        self.overlay:SetBackColor(backColor);
    end
end

function Palette:SetSpotColor(color)
    color.A = 1;
    self.spot:SetBackColor(color);
end

function Palette:SetSize(width, height)
    self.width, self.height = width, height;
    Turbine.UI.Control.SetSize(self, width, height);
    self:SetStretchMode(1);
    self.overlay:SetSize(width, height);
    self.overlay:SetStretchMode(1);
    self.colorName:SetSize(self.width, 20);
    self:SetPointerPosition();
end

function Palette:SetColor(color)
    self.valueX = color:Get(self.dimensionX);
    self.valueY = color:Get(self.dimensionY);
    self:SetPointerPosition();
end

function Palette:GetColor(color)
    color:Set(self.dimensionX, self.valueX);
    color:Set(self.dimensionY, self.valueY);
end

function Palette:SetDimensions(dimensionX, dimensionY)
    self.dimensionX, self.dimensionY = dimensionX, dimensionY
    self.overlay:SetBackground(imagePath .. "/" .. dimensionX .. "_x_" .. dimensionY .. ".tga");
    local sliderDimension = Thurallor.Utils.Color.GetOtherDimensions(dimensionY);
    if (string.find("RGB", sliderDimension)) then
        self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Screen);
    elseif (sliderDimension == "S") then
        self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Grayscale);
    elseif (sliderDimension == "H") then
        self:SetBackground(imagePath .. "/S_x_V_back.tga");
        self:SetBackColorBlendMode(Turbine.UI.BlendMode.Screen);
        self.overlay:SetBackColor(nil);
        self.overlay:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    else -- (sliderDimension == "V")
        self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    end
end

function Palette:GetDimensions()
    return self.dimensionX, self.dimensionY;
end

function Palette:Close()
    self.overlay:Close();
    self.pointer:Close();
    self.spot:Close();
    self.colorName:Close();
end