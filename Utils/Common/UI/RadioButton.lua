RadioButton = class(Turbine.UI.Control);

function RadioButton:Constructor(parent, text, checked, disabled)
    Turbine.UI.Control.Constructor(self);

    self:SetParent(parent);

    self.icon = Turbine.UI.Control();
    self.icon:SetParent(self);
    self.icon:SetSize(10, 10);
    self.icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    self.icon.MouseClick = function()
        self:MouseClick();
    end
    
    self.text = Turbine.UI.Label();
    self.text:SetParent(self);
    self.text:SetText(text);
    self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.text.MouseClick = function()
        self:MouseClick();
    end
    
    self:SetForeColor(Turbine.UI.Color(1, 1, 1, 1));
    self:SetChecked(checked);
    self:SetEnabled(not disabled);
end

-- This is a static function (not associated with a specific instance).
function RadioButton.LinkPeers(peers)
    for p = 1, #peers, 1 do
        peers[p].peerGroup = peers;
    end
end

function RadioButton:SetSize(width, height)
    Turbine.UI.Control.SetSize(self, width, height);
    self.icon:SetTop(math.floor((height - self.icon:GetHeight()) / 2));
    self.text:SetLeft(self.icon:GetWidth() + 1);
    self.text:SetHeight(height);
    self.text:SetWidth(width - self.text:GetLeft());
end

function RadioButton:SetText(text)
    self.text:SetText(text);
end

function RadioButton:SetForeColor(color)
    self.foreColor = color;
    self.text:SetForeColor(color);
end

function RadioButton:SetFont(font)
    self.text:SetFont(font);
    self.text:SetText(self.text:GetText());
end

function RadioButton:MouseClick()
    if (self.enabled) then
        for p = 1, #self.peerGroup, 1 do
            self.peerGroup[p]:SetChecked(false);
        end
        self:SetChecked(true);
        if (self.Clicked ~= nil) then
            self:Clicked();
        end
    end
end

function RadioButton:SetChecked(checked)
    self.checked = checked;
    if (checked) then
        self.icon:SetBackground(0x41000199);
    else
        self.icon:SetBackground(0x4100019A);
    end
end

function RadioButton:IsChecked()
    return self.checked;
end

function RadioButton:SetEnabled(enabled)
    self.enabled = enabled;
    if (enabled) then
        self.text:SetForeColor(self.foreColor);
    else
        self.text:SetForeColor(Turbine.UI.Color(1, 0.25, 0.25, 0.25));
    end
end

function RadioButton:IsEnabled()
    return self.enabled;
end


if (not Thurallor.UI) then
    Thurallor.UI = {};
end
Thurallor.UI.RadioButton = RadioButton;
