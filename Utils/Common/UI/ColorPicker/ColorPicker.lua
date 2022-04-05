ColorPicker = class(Turbine.UI.Lotro.Window);

-- Default settings
ColorPicker.settings = {};
ColorPicker.settings.recentColors = {};

Turbine.PluginData.Load(Turbine.DataScope.Account, "ColorPicker", function(loadStr)
    if (loadStr) then
        -- Workaround for Turbine localization bug -- Thanks, Lynx3d!
        ColorPicker.settings = ImportTable(loadStr);
        if (not ColorPicker.settings) then
            Turbine.Shell.WriteLine("Failed to parse ColorPicker.plugindata file!");
            return;
        end
    end
end);

function ColorPicker:Constructor(color, dimension)
    Turbine.UI.Lotro.Window.Constructor(self);

    if (color) then
        color = Thurallor.Utils.Color(color.R, color.G, color.B);
    else
        color = Thurallor.Utils.Color(0.5, 1.0, 1.0);
    end
    if (not dimension) then
        dimension = "V";
    end
    
    self:SetSize(407, 316);
    self.displayWidth = Turbine.UI.Display:GetWidth();
    self.displayHeight = Turbine.UI.Display:GetHeight();
    local left =  math.floor(self.displayWidth / 2) - 203;
    local top = math.floor(Turbine.UI.Display:GetHeight() / 2 ) - 158;
    self:SetPosition(left, top);
    self:SetVisible(true);
    P:SetContext("/ColorPicker");
    self:SetText(P:GetText("DefaultTitle"));
    self:SetResizable(true);

    self.color = Thurallor.Utils.Color(1, 0.5, 0.5, 0.5);
    self.originalColor = Thurallor.Utils.Color(color.R, color.G, color.B);

    self.topBorderOutside = Turbine.UI.Control();
    self.topBorderOutside:SetParent(self);
    self.topBorderOutside:SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));
    self.topBorderInside = Turbine.UI.Control();
    self.topBorderInside:SetParent(self);
    self.topBorderInside:SetBackColor(Turbine.UI.Color.Black);
    
    self.palette = Palette(self, "G", "B", self.color);
    self.palette.ColorChanged = function()
        self:PaletteChanged();
    end

    self.slider = Slider(self, "R", self.color);
    self.slider.ColorChanged = function()
        self:SliderChanged();
    end

    local radioButtonWidth, radioButtonHeight = 127, 20;
    self.radioContainer = Turbine.UI.Control();
    self.radioContainer:SetParent(self);
    self.radioContainer:SetWidth(radioButtonWidth);
    self.radioButtons = {};
    
    self.radioButtons["R"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Red"), true);
    self.radioButtons["R"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["R"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["R"].Clicked = function()
        self:SelectDimension("R");
    end
    local top = radioButtonHeight;

    self.radioButtons["G"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Green"), false);
    self.radioButtons["G"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["G"]:SetTop(top);
    self.radioButtons["G"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["G"].Clicked = function()
        self:SelectDimension("G");
    end
    top = top + radioButtonHeight;

    self.radioButtons["B"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Blue"), false);
    self.radioButtons["B"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["B"]:SetTop(top);
    self.radioButtons["B"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["B"].Clicked = function()
        self:SelectDimension("B");
    end
    top = top + 30;

    self.radioButtons["H"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Hue"), false);
    self.radioButtons["H"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["H"]:SetTop(top);
    self.radioButtons["H"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["H"].Clicked = function()
        self:SelectDimension("H");
    end
    top = top + radioButtonHeight;

    self.radioButtons["S"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Saturation"), false);
    self.radioButtons["S"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["S"]:SetTop(top);
    self.radioButtons["S"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["S"].Clicked = function()
        self:SelectDimension("S");
    end
    top = top + radioButtonHeight;

    self.radioButtons["V"] = Thurallor.UI.RadioButton(self.radioContainer, P:GetText("Value"), false);
    self.radioButtons["V"]:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.radioButtons["V"]:SetTop(top);
    self.radioButtons["V"]:SetSize(radioButtonWidth, radioButtonHeight);
    self.radioButtons["V"].Clicked = function()
        self:SelectDimension("V");
    end
    top = top + 34;
    
    Thurallor.UI.RadioButton.LinkPeers({self.radioButtons["R"], self.radioButtons["G"], self.radioButtons["B"], self.radioButtons["H"], self.radioButtons["S"], self.radioButtons["V"]});
    self.radioContainer:SetHeight(top);
    
    self.hex = Turbine.UI.Lotro.TextBox();
    self.hex:SetParent(self);
    self.hex:SetSize(math.floor(radioButtonWidth * 2 / 3 + 0.5), radioButtonHeight);
    self.hex:SetFont(Turbine.UI.Lotro.Font.Verdana14);
    self.hex:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.hex:SetWantsUpdates(true);
    self.hex.Update = function()
        local hexText = self.hex:GetText();
        if (self.hex.prevText ~= hexText) then
            self.hex.prevText = hexText;
            self:HexChanged();
        end
    end
    
    self.okButton = Turbine.UI.Lotro.Button();
    self.okButton:SetParent(self);
    self.okButton:SetSize(math.floor(radioButtonWidth / 2 + 0.5), radioButtonHeight);
    self.okButton:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.okButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.okButton:SetText(P:GetText("Ok"));
    self.okButton.Click = function()
        self.okButtonClicked = true;
        if (self.Accepted) then
            self:Accepted();
        end
        self:AddRecentColor(self.color);
        self:Close();
    end
    
    self:SetWantsKeyEvents();
    self.KeyDown = function(sender, args)
        if (args.Action == Turbine.UI.Lotro.Action.EnterKey) then
            self.okButton:Click();
        end
    end

    self.presets = SwatchBar(self, P:GetText("StandardColors"));
    self.colorNames = {};
    P:SetContext("/ColorPicker/Colors");
    for colorName, color in pairs(Turbine.UI.Color) do
        if (Turbine.UI.Color:IsA(color) and (color.A == 1)) then
            color = Thurallor.Utils.Color(color.A, color.R, color.G, color.B);
            self.colorNames[color:GetHex()] = P:GetText(colorName);
            self.presets:AddSwatch(color);
        end
    end
    P:SetContext("/ColorPicker");

    local recentColors = ColorPicker.settings.recentColors;
    if (#recentColors > 0) then
        self.recent = SwatchBar(self, P:GetText("RecentColors"));
        for r = 1, #recentColors, 1 do
            local color = recentColors[r];
            color = Thurallor.Utils.Color(color.A, color.R, color.G, color.B);
            self.recent:AddSwatch(color);
        end
    end
    
    self.changingSize = false;
    self:DoLayout();
    self:SetColor(color);
    self.radioButtons[dimension]:MouseClick();
    
    self:SetZOrder(self:GetZOrder());

    -- If the display size changes, images will unstretch, so we need to redraw.
    AddCallback(Turbine.UI.Display, "SizeChanged", function()
        self:DoLayout();
    end);

    
    self:SetZOrder(50)

end

function ColorPicker:SaveSettings()
    -- Workaround for Turbine localization bug -- Thanks, Lynx3d!
    local saveData = ExportTable(ColorPicker.settings);
    Turbine.PluginData.Save(Turbine.DataScope.Account, "ColorPicker", saveData, function()
--Puts("Save complete.");
    end);
end

function ColorPicker:AddRecentColor(newColor)
    local recentColors = ColorPicker.settings.recentColors;
    
    -- Remove duplicates.
    local oldColorIndex = nil;
    for r = 1, #recentColors, 1 do
        local oldColor = recentColors[r];
        oldColor = Thurallor.Utils.Color(oldColor.A, oldColor.R, oldColor.G, oldColor.B);
        if (oldColor:GetHex() == newColor:GetHex()) then
            oldColorIndex = r;
            break;
        end
    end
    if (oldColorIndex) then
        table.remove(recentColors, oldColorIndex);
    end
            
    -- Add the new color.
    table.insert(recentColors, 1, newColor);
    self:SaveSettings();
end

function ColorPicker:DoLayout()
    local titleHeight = 16;
    local marginSize = 23;
    local spacing = 10;
    local sliderWidth = 20;
    local borderSize = 3;
    
    local top = titleHeight + marginSize;
    local left = marginSize;
    local radioContainerWidth, radioContainerHeight = self.radioContainer:GetSize();
    local minPaletteSize = radioContainerHeight + 50;
    local paletteSize = self:GetWidth() - (marginSize * 2) - (spacing * 2) - self.radioContainer:GetWidth() - sliderWidth;
    if (paletteSize < minPaletteSize) then
        self:SetWidth(self:GetWidth() + (minPaletteSize - paletteSize));
        paletteSize = minPaletteSize;
    end
    self.palette:SetPosition(left, top);
    self.palette:SetSize(paletteSize, paletteSize);
    self.palette:SetStretchMode(1);

    left = left + paletteSize + spacing;
    self.slider:SetPosition(left, top);
    self.slider:SetSize(sliderWidth, paletteSize);
    self.slider:SetStretchMode(1);

    left = left + sliderWidth + spacing;
    top = top + math.floor(((paletteSize - 50 - radioContainerHeight) / 2) + 0.5);
    self.radioContainer:SetZOrder(self:GetZOrder() + 2);
    self.radioContainer:SetPosition(left, top);
    local right = left + self.radioContainer:GetWidth();
    
    top = titleHeight + marginSize + paletteSize - self.okButton:GetHeight();
    self.okButton:SetPosition(left + math.floor(radioContainerWidth / 4 + 0.5), top - 3);
    local bottom = top + self.okButton:GetHeight();

    self.topBorderOutside:SetPosition(marginSize - borderSize, titleHeight + marginSize - borderSize);
    self.topBorderOutside:SetSize(right - marginSize + (2 * borderSize), bottom - (titleHeight + marginSize) + (2 * borderSize));
    self.topBorderInside:SetPosition(self.topBorderOutside:GetLeft() + 1, self.topBorderOutside:GetTop() + 1);
    self.topBorderInside:SetSize(self.topBorderOutside:GetWidth() - 2, self.topBorderOutside:GetHeight() - 2);

    top = top - 8 - self.hex:GetHeight();
    self.hex:SetPosition(left + math.floor(radioContainerWidth / 6 + 0.5), top);

    spacing = spacing + 2;    
    left = marginSize;
    top = titleHeight + marginSize + paletteSize + spacing;
    self.presets:SetPosition(left, top);
    local width = right - left;
    
    if (#ColorPicker.settings.recentColors > 0) then
        local halfWidth = math.floor(0.5 + (width - spacing) / 2)
        self.presets:SetSize(halfWidth, 40);
        left = left + halfWidth + spacing;
        self.recent:SetPosition(left, top);
        self.recent:SetSize(width - (halfWidth + spacing), 40);
    else
        self.presets:SetSize(width, 40);
    end
    top = top + 40;

    self:SetHeight(top + marginSize + 2);
end

function ColorPicker:SetZOrder(z)
    if (z > 2147483647 - 4) then
        -- Need room for four layers of stuff
        z = 2147483647 - 4;
    end
    Turbine.UI.Lotro.Window.SetZOrder(self, z);
    self.radioContainer:SetZOrder(z + 2);
    self.palette:SetZOrder(z + 1);
    self.slider:SetZOrder(z + 1);
end

function ColorPicker:SelectDimension(sliderDimension)
    local paletteXDimension, paletteYDimension = Thurallor.Utils.Color.GetOtherDimensions(sliderDimension);
    self.slider:SetDimension(sliderDimension);
    self.palette:SetDimensions(paletteXDimension, paletteYDimension);
    
    -- Update display
    self:SetColor(self.color);
end

function ColorPicker:HexChanged()
    local R, G, B = string.match(self.hex:GetText(), "^(%x%x)(%x%x)(%x%x)$");
    if (R and G and B) then
        self.hex:SetBackColor(Thurallor.Utils.Color(1, 1, 1, 1));
        if (not self.updatingHex) then
            self.color:SetHex(self.hex:GetText());
            self:SetColor(self.color);
            if (self.ColorChanged) then
                self:ColorChanged();
            end
        end
    else
        self.hex:SetBackColor(Thurallor.Utils.Color(1, 1, 0, 0));
    end
end

function ColorPicker:SetColor(color)
    self.slider:SetColor(color);
    self.palette:SetColor(color);
    self:PaletteChanged();
    self:SliderChanged();
end

function ColorPicker:GetColor()
    return self.color;
end

function ColorPicker:UpdateHex()
    local R, G, B, H, S, V;
    self.updatingHex = true;
    self.hex:SetText(self.color:GetHex());
    self.hex:Focus();
    self:Activate();
    self.hex.prevText = self.hex:GetText();
    self.updatingHex = false;
    R = math.floor(self.color.R * 100 + 0.5);
    G = math.floor(self.color.G * 100 + 0.5);
    B = math.floor(self.color.B * 100 + 0.5);
    H, S, V = self.color:GetHSV();
    H = math.floor(H * 360 + 0.5);
    S = math.floor(S * 100 + 0.5);
    V = math.floor(V * 100 + 0.5);
    P:SetContext("/ColorPicker");
    self.radioButtons["R"]:SetText(P:GetText("Red") .. ": " .. tostring(R) .. "%");
    self.radioButtons["G"]:SetText(P:GetText("Green") .. ": " .. tostring(G) .. "%");
    self.radioButtons["B"]:SetText(P:GetText("Blue") .. ": " .. tostring(B) .. "%");
    self.radioButtons["H"]:SetText(P:GetText("Hue") .. ": " .. tostring(H) .. "°");
    self.radioButtons["S"]:SetText(P:GetText("Saturation") .. ": " .. tostring(S) .. "%");
    self.radioButtons["V"]:SetText(P:GetText("Value") .. ": " .. tostring(V) .. "%");
    local colorName = self.colorNames[self.color:GetHex()];
    self.palette:ShowColorName(colorName);
end

function ColorPicker:SliderChanged()
    self.slider:GetColor(self.color);
    self:UpdateHex();
    self.palette:SetGamut(self.color);
    self.palette:SetSpotColor(self.color);
    if (self.ColorChanged) then
        self:ColorChanged();
    end
end

function ColorPicker:PaletteChanged()
    self.palette:GetColor(self.color);
    self:UpdateHex();
    self.palette:SetSpotColor(self.color);
    self.slider:SetGamut(self.color);
    if (self.ColorChanged) then
        self:ColorChanged();
    end
end

function ColorPicker:SizeChanged()
    if (not self.changingSize) then
        self.changingSize = true;
        self:DoLayout();
        self.changingSize = false;
    end
end

function ColorPicker:PositionChanged()
    self:DoLayout();
end

function ColorPicker:Closing()
    self:SaveSettings();
    if (not self.okButtonClicked) then
        -- User closed the window.  Revert to original color.
        self.color = self.originalColor;
        if (self.ColorChanged) then
            self:ColorChanged();
        end
        if (self.Canceled) then
            self:Canceled();
        end
    end
    self.palette:Close();
    self.slider:Close();
    self:SetWantsKeyEvents(false);
end