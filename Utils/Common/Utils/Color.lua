Color = class(Turbine.UI.Color);

function Color:Constructor(A, R, G, B)
    if (B) then
        Turbine.UI.Color.Constructor(self, A, R, G, B);
    else
        Turbine.UI.Color.Constructor(self, 1, A, R, G);
    end
end

-- Derived from http://en.literateprograms.org/RGB_to_HSV_color_space_conversion_(C)?oldid=17206
function Color:GetHSV()
    local R, G, B, H, S, V = self.R, self.G, self.B, 0, 0, 0;
    
    local rgb_min = math.min(R, G, B);
    local rgb_max = math.max(R, G, B);
    V = rgb_max;
    if (V == 0) then
        return H, S, V;
    end
    
    R = R / V;
    G = G / V;
    B = B / V;
    rgb_min = math.min(R, G, B);
    rgb_max = math.max(R, G, B);
    
    S = rgb_max - rgb_min;
    if (S == 0) then
        return H, S, V;
    end
    
    R = (R - rgb_min) / S;
    G = (G - rgb_min) / S;
    B = (B - rgb_min) / S;
    rgb_min = math.min(R, G, B);
    rgb_max = math.max(R, G, B);

    if (rgb_max == R) then
        H = 0.0 + 60 * (G - B);
        if (H < 0) then
            H = H + 360;
        end
    elseif (rgb_max == G) then
        H = 120 + 60 * (B - R);
    else -- rgb_max == B
        H = 240 + 60 * (R - G);
    end
    
    return H / 360, S, V;
end

function Color:Get(dimension)
    if (string.find("RGB", dimension)) then
        return self[dimension];
    end
    local dims = {};
    dims.H, dims.S, dims.V = self:GetHSV();
    return dims[dimension];
end

-- Derived from http://www.cs.rit.edu/~ncs/color/t_convert.html
function Color:SetHSV(H, S, V)
    local i, f, p, q, t;
    
	if (S == 0) then
        self.R, self.G, self.B = V, V, V;
		return;
	end

    H = H * 360 / 60;
    i = math.floor(H);
    f = H - i;
    p = V * (1 - S);
    q = V * (1 - S * f);
    t = V * (1 - S * (1 - f));
    
    if (i == 0) then
        self.R, self.G, self.B = V, t, p;
    elseif (i == 1) then
        self.R, self.G, self.B = q, V, p;
    elseif (i == 2) then
        self.R, self.G, self.B = p, V, t;
    elseif (i == 3) then
        self.R, self.G, self.B = p, q, V;
    elseif (i == 4) then
        self.R, self.G, self.B = t, p, V;
    else -- (i == 5)
        self.R, self.G, self.B = V, p, q;
    end        
end

function Color:Set(dimension, value)
    if (string.find("RGB", dimension)) then
        self[dimension] = value;
        return;
    end
    local dims = {};
    dims.H, dims.S, dims.V = self:GetHSV();
    dims[dimension] = value;
    self:SetHSV(dims.H, dims.S, dims.V);
end

function Color.GetOtherDimensions(dim)
    local dimTable = {["R"] = "GB"; ["G"] = "BR"; ["B"] = "RG"; ["H"] = "SV"; ["S"] = "VH"; ["V"] = "HS"};
    return string.sub(dimTable[dim], 1, 1), string.sub(dimTable[dim], 2, 2);
end

function Color:GetHex()
    local R_hex = math.floor(self.R * 255 + 0.5);
    local G_hex = math.floor(self.G * 255 + 0.5);
    local B_hex = math.floor(self.B * 255 + 0.5);
    return string.format("%2.2X%2.2X%2.2X", R_hex, G_hex, B_hex);
end

function Color:SetHex(hexStr)
    local R, G, B = string.match(hexStr, "^(%x%x)(%x%x)(%x%x)$");
    if (R and G and B) then
        self.R = tonumber('0x' .. R) / 255;
        self.G = tonumber('0x' .. G) / 255;
        self.B = tonumber('0x' .. B) / 255;
        return true;
    else
        return false;
    end
end

function Color:GetComplement()
    return Color(self.A, 1 - self.R, 1 - self.G, 1 - self.B);
end
