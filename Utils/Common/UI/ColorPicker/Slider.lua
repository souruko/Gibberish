Slider = class(Turbine.UI.Control);

local importPath = getfenv(1)._.Name;
local imagePath = string.gsub(string.gsub(importPath, "%.Slider$", ""), "%.", "/");

function Slider:Constructor(parent, dimension, color)
    Turbine.UI.Control.Constructor(self);

    self:SetParent(parent);
    
    self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self:SetBackground(imagePath .. "/B_grad.tga");
    self:SetStretchMode(2);
    self.width, self.height = self:GetSize();

    self.overlay = Turbine.UI.Window();
    self.overlay:SetBackground(imagePath .. "/B_grad.tga");
    self.overlay:SetStretchMode(2);
    self.overlay:SetVisible(true);
    self.overlay:SetSize(self.width, self.height);
   
    self.pointer = Turbine.UI.Window();
    self.pointer:SetVisible(true);    
    self.pointer:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.pointer:SetBackground(0x41000290);
    self.pointer:SetSize(10, 10);
    self.pointer:SetStretchMode(2);
    self.pointer.MouseDown = function()
        self.pointer.mouseDown = true;
        self.pointer:MouseMove();
    end
    self.pointer.MouseUp = function()
        self.pointer.mouseDown = false;
    end
    self.pointer.MouseMove = function()
        if (self.pointer.mouseDown) then
            local _, newPosition = self:PointToClient(0, Turbine.UI.Display.GetMouseY());
            self.value = 1 - newPosition / self.height;
            if (self.value < 0.001) then
                self.value = 0.001;
            elseif (self.value > 0.999) then
                self.value = 0.999;
            end
            self:SetPointerPosition();
            if (self.ColorChanged) then
                self:ColorChanged();
            end
        end
    end
    self.overlay:SetMouseVisible(false);
    self.MouseDown = self.pointer.MouseDown;
    self.MouseUp = self.pointer.MouseUp;
    self.MouseMove = self.pointer.MouseMove;

    self:SetZOrder(self:GetZOrder());
    self:SetDimension(dimension);
    self:SetColor(color);
end

function Slider:SetZOrder(z)
    Turbine.UI.Control.SetZOrder(self, z);
    self.overlay:SetZOrder(z + 1);
    self.pointer:SetZOrder(z + 2);
end

function Slider:SetPosition(left, top)
    Turbine.UI.Control.SetPosition(self, left, top);
    local screen_left, screen_top = self:PointToScreen(0, 0);
    self.overlay:SetPosition(screen_left, screen_top);
end

function Slider:SetPointerPosition()
    local left, top = self.width - 6, math.floor(self.height * (1 - self.value) + 0.5) - 4;
    local l, t = self:PointToScreen(left, top);
    self:SetZOrder(self:GetZOrder());
    self.pointer:SetPosition(l, t);
end

function Slider:SetGamut(color)
    if (string.find("RGB", self.dimension)) then
        local backColor = Thurallor.Utils.Color(1, color.R, color.G, color.B);
        backColor[self.dimension] = 0;
        self.overlay:SetBackColor(backColor);
    elseif (self.dimension == "H") then
        local H, S, V = color:GetHSV();
        self:SetBackColor(Thurallor.Utils.Color(1 - S, 1, 1, 1));
        self.overlay:SetBackColor(Thurallor.Utils.Color(1 - V, 0, 0, 0));
    elseif (self.dimension == "V") then
        self.overlay:SetBackColor(color);
    else -- (self.dimension == "S") then
        local H, S, V = color:GetHSV();
        local backColor = Thurallor.Utils.Color(1, 0, 0, 0);
        backColor:SetHSV(H, 1, 1);
        self:SetBackColor(backColor);
        self.overlay:SetBackColor(Thurallor.Utils.Color(1 - V, 0, 0, 0));
    end
end

function Slider:SetSize(width, height)
    self.width, self.height = width, height;
    Turbine.UI.Control.SetSize(self, width, height);
    self:SetStretchMode(1);
    self.overlay:SetSize(width, height);
    self.overlay:SetStretchMode(1);
    self:SetPointerPosition();
end

function Slider:SetColor(color)
    self.value = color:Get(self.dimension);
    self:SetPointerPosition();
end

function Slider:GetColor(color)
    color:Set(self.dimension, self.value);
end

function Slider:GetValue()
    return self.value;
end

function Slider:SetDimension(dimension)
    self.dimension = dimension;
    self.overlay:SetBackground(imagePath .. "/" .. dimension .. "_grad.tga");
    if (string.find("RGB", self.dimension)) then
        self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Screen);
    elseif (self.dimension == "H") then
        self:SetBackground(imagePath .. "/H_grad.tga");
        self:SetBackColorBlendMode(Turbine.UI.BlendMode.Grayscale);
        self.overlay:SetBackground(nil);
        self.overlay:SetBackColorBlendMode(Turbine.UI.AlphaBlend);
    elseif (self.dimension == "V") then
        self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);
    else -- (self.dimension == "S") then
        self:SetBackground(imagePath .. "/S_grad.tga");
        self:SetBackColorBlendMode(Turbine.UI.BlendMode.Screen);
        self.overlay:SetBackground(nil);
        self.overlay:SetBackColorBlendMode(Turbine.UI.AlphaBlend);
    end
end

function Slider:GetDimension(dimension)
    return self.dimension;
end

function Slider:Close()
    self.overlay:Close();
    self.pointer:Close();
end
