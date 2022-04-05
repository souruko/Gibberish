import "Turbine";
import "Turbine.UI.Lotro";

-- Missing enumeration values
Turbine.UI.Lotro.Action.EnterKey = 162;
Turbine.UI.Lotro.Action.ToggleHUD = 268435635;
Turbine.UI.Lotro.Font.TimesRoman12 = 0x42000021;
Turbine.UI.Lotro.Font.TimesRoman20 = 0x4200000e;
Turbine.UI.Lotro.Font.TimesRoman22 = 0x4200000f;
Turbine.UI.Lotro.Font.TimesRoman24 = 0x42000010;
--Turbine.UI.Lotro.Font.Calibri14 = 0x4200002b; -- doesn't seem to work fully
Turbine.Gameplay.EffectCategory.Tactical = 256;

-- Add the Turbine.UI.Display.SizeChanged event.
displaySizeListener = Turbine.UI.Window();
displaySizeListener:SetVisible(true);
displaySizeListener:SetStretchMode(0);
displaySizeListener:SetSize(1, 1);
displaySizeListener:SetWantsUpdates(true);
displaySizeListener:SetStretchMode(1);
displaySizeListener:SetWantsUpdates(true);
function displaySizeListener:Update()
    displaySizeListener:SetSize(2, 2);
    self.ignoreSizeChangedEvents = 0;
    self:SetWantsUpdates(false);
    self.Update = self._Update;
    self.SizeChanged = self._SizeChanged;
end
function displaySizeListener:_Update()
    self:SetWantsUpdates(false);
    local sizeChangedFunc = Turbine.UI.Display.SizeChanged;
    if (type(sizeChangedFunc) == "function") then
        sizeChangedFunc(Turbine.UI.Display);
    elseif (type(sizeChangedFunc) == "table") then
        for f = 1, #sizeChangedFunc, 1 do
            sizeChangedFunc[f](Turbine.UI.Display);
        end
    end
end
function displaySizeListener:_SizeChanged()
    if (self.ignoreSizeChangedEvents > 0) then
        self.ignoreSizeChangedEvents = self.ignoreSizeChangedEvents - 1;
        return;
    end
    self:SetSize(2, 2);
    self.ignoreSizeChangedEvents = 1;
    -- Need to wait until the next Update() cycle before reporting.
    self:SetWantsUpdates(true);
end

-- Copies the source table into the destination table (or a new table, if 'destTable' is absent).
-- Subtables are duplicated.
-- Returns the destination table.
function _G.DeepTableCopy(sourceTable, destTable)
    if (destTable == nil) then
        destTable = {};
    end
    if (type(sourceTable) ~= "table") then
        return error("DeepTableCopy(): sourceTable is " .. type(sourceTable), 2);
    elseif (type(destTable) ~= "table") then
        return error("DeepTableCopy(): destTable is " .. type(destTable), 2);
    end
    for k, v in pairs(sourceTable) do
        if (type(v) == "table") then
            destTable[k] = { };
            DeepTableCopy(v, destTable[k]);
        else
            destTable[k] = v;
        end
    end
    return destTable;
end

-- Copies the source table into the destination table (or a new table, if 'destTable' is absent).
-- Subtables are shared (not duplicated).
-- Returns the destination table.
function _G.ShallowTableCopy(sourceTable, destTable)
    if (destTable == nil) then
        destTable = {};
    end
    if (type(sourceTable) ~= "table") then
        return error("ShallowTableCopy(): sourceTable is " .. type(sourceTable), 2);
    elseif (type(destTable) ~= "table") then
        return error("ShallowTableCopy(): destTable is " .. type(destTable), 2);
    end
    for k, v in pairs(sourceTable) do
        destTable[k] = v;
    end
    return destTable;
end

function _G.Puts(str)
    local prefix = "";
    if (_G.PutsPrefix) then
        prefix = _G.PutsPrefix;
    end
    Turbine.Shell.WriteLine(prefix .. tostring(str));
end

-- Returns a compact Lua representation of a table.  Has optional 'maxdepth' arg to prevent runaway recursion.
function _G.Serialize(obj, maxdepth)
    if (type(maxdepth) == "number") then
        maxdepth = maxdepth - 1;
    end
    if (type(obj) == "boolean") then
        if (obj) then
            return "true";
        else
            return "false";
        end
    elseif (type(obj) == "number") then
        local text = tostring(obj);
        -- Change floating-point numbers to English format
        return string.gsub(text, ",", ".");
    elseif (type(obj) == "string") then
        return string.format("%q", obj);
    elseif (type(obj) == "table") then
        if ((type(maxdepth) == "number") and (maxdepth < 0)) then
            return tostring(obj);
        else
            local text = "{";
            local i = 1;
            for key in sorted_keys(obj) do
                local value = Serialize(obj[key], maxdepth);
                if (value ~= nil) then
                    local item = value .. ",";
                    if (key ~= i) then
                        local index = Serialize(key, maxdepth);
                        item = "[" .. index .. "]=" .. item;
                    else
                        i = i + 1;
                    end
                    text = text .. item;
                end
            end
            text = string.gsub(text, ",$", "");
            text = text .. "}";
--text = tostring(obj) .. ":" .. text;
            return text;
        end
    else
--Turbine.Shell.WriteLine("unknown type " .. tostring(type));
        return tostring(obj);
    end
end

-- Returns a multi-line Lua representation of a table.  Has optional 'maxdepth' arg to prevent runaway recursion.
function _G.PrettyPrint(obj, prefix, maxdepth)
    if (type(maxdepth) == "number") then
        maxdepth = maxdepth - 1;
    end
    if (type(obj) == "boolean") then
        if (obj) then
            return "true";
        else
            return "false";
        end
    elseif (type(obj) == "number") then
        local text = tostring(obj);
        -- Change floating-point numbers to English format
        return string.gsub(text, ",", ".");
    elseif (type(obj) == "string") then
        return string.format("%q", obj);
    elseif (type(obj) == "table") then
        if ((type(maxdepth) == "number") and (maxdepth < 0)) then
            return tostring(obj);
        else
            local text = "{\n";
            local newPrefix = prefix .. "   ";
            local i = 1;
            local count = 0;
            for key in sorted_keys(obj) do
                local value = PrettyPrint(obj[key], newPrefix, maxdepth);
                if (value ~= nil) then
                    local item = value .. ";";
                    if (key ~= i) then
                        local index = Serialize(key, maxdepth);
                        item = "[" .. index .. "] = " .. item;
                    else
                        i = i + 1;
                    end
                    text = text .. newPrefix .. item .. "\n";
                    count = count + 1;
                end
            end
            if (count == 0) then
                text = "{}";
            else
                text = string.gsub(text, ",$", "");
                text = text .. prefix .. "}";
            end
--text = tostring(obj) .. ":" .. text;
            return text;
        end
    else
--Turbine.Shell.WriteLine("unknown type " .. tostring(type));
        return tostring(obj);
    end
end

-- Prepares a table for saving.  Workaround for Turbine.PluginData.Save() bug.
function _G.ExportTable(obj)
    if (type(obj) == "number") then
        local text = tostring(obj);
        -- Change floating-point numbers to English format
        return "#" .. string.gsub(text, ",", ".");
    elseif (type(obj) == "string") then
        return "$" .. obj;
    elseif (type(obj) == "table") then
        local newTable = {};
        for i, v in pairs(obj) do
            newTable[ExportTable(i)] = ExportTable(v);
        end
        return newTable;
    else
        return obj;
    end
end

-- Prepares a loaded table for use.  Workaround for Turbine.PluginData.Save() bug.
function _G.ImportTable(obj)
    if (type(obj) == "string") then
        local prefix = string.sub(obj, 1, 1);
        if (prefix == "$") then
            return string.sub(obj, 2);
        elseif (prefix == "#") then
			-- need to run it through interpreter, since tonumber() may only accept ","
			return loadstring("return " .. string.sub(obj, 2))();
        else -- shouldn't happen
            return obj;
        end
    elseif (type(obj) == "table") then
        local newTable = {};
        for i, v in pairs(obj) do
            newTable[ImportTable(i)] = ImportTable(v);
        end
        return newTable;
    else
        return obj;
    end
end

function _G.GetAssetSize(id)
    local temp = Turbine.UI.Control();
    temp:SetBackground(id);
    temp:SetStretchMode(2);
    return temp:GetWidth(), temp:GetHeight();
end

function _G.AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function _G.RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

function _G.DoCallbacks(object, event, args)
    if (type(object[event]) == "table") then
        for i = 1, #object[event] do
            object[event][i](object, args);
        end
    elseif (type(object[event]) == "function") then
        object[event](object, args);
    end
end

-- For iterating over the keys of a hash table in a for loop
function _G.keys(tableVar)
    if (type(tableVar) ~= "table") then
        error("bad argument to 'keys' (table expected, got " .. type(tableVar) .. ")", 2);
    end
    local state = { ["tableVar"] = tableVar, ["index"] = nil };
    local function iterator(state)
        state.index = next(state.tableVar, state.index);
        return state.index;
    end
    return iterator, state, nil;
end

-- For iterating over the values of a hash table in a for loop
function _G.values(tableVar)
    if (type(tableVar) ~= "table") then
        error("bad argument to 'values' (table expected, got " .. type(tableVar) .. ")", 2);
    end
    local state = { ["tableVar"] = tableVar, ["index"] = nil };
    local function iterator(state)
        state.index, value = next(state.tableVar, state.index);
        return value;
    end
    return iterator, state, nil;
end

-- For iterating over the keys of a hash table in a for loop, after sorting the keys
function _G.sorted_keys(tableVar)
    if (type(tableVar) ~= "table") then
        error("bad argument to 'keys' (table expected, got " .. type(tableVar) .. ")", 2);
    end
    local state = { ["sortedKeys"] = {}, ["index"] = nil };
    for key in keys(tableVar) do
        table.insert(state.sortedKeys, key);
    end
    local sortFunc = function(a, b)
        if ((type(a) == type(b)) and ((type(a) == "number") or (type(a) == "string"))) then
            return a < b;
        else
            return tostring(a) < tostring(b);
        end
    end
    table.sort(state.sortedKeys, sortFunc);
    local function iterator(state)
        state.index, value = next(state.sortedKeys, state.index);
        return value;
    end
    return iterator, state, nil;
end

-- Searches the given table for the specified value, returning the corresponding key
function _G.Search(tableVar, value)
    if (type(tableVar) ~= "table") then
        error("bad argument to 'Search' (table expected, got " .. type(tableVar) .. ")", 2);
    end
    local i = nil;
    repeat
        i, v = next(tableVar, i);
        if (v == value) then
            return i;
        end
    until (not i);
    return nil;
end

-- Returns true if an item is equipped.
-- If 'itemSlot' is specified, the search is restricted to a single equipment slot.
-- If 'itemName' is not specified, any item will be accepted.
-- Note: There is currently no way to distinguish between items with the same
--       name..
function _G.IsEquipped(itemName, itemSlot)
    local slot, item = Thurallor.Utils.Watcher.GetEquippedItem(itemName, itemSlot);
    return (slot ~= nil);
end

function _G.Unequip(itemSlot, itemSlotName, targetBagSlot)
    if (not targetBagSlot) then
        targetBagSlot = 1;
    end
    local lp = Turbine.Gameplay.LocalPlayer:GetInstance();
    local bags = lp:GetBackpack();
    local equippedItems = lp:GetEquipment();
    local item = equippedItems:GetItem(itemSlot);
    if (item == nil) then
--        Turbine.Shell.WriteLine("You're not wearing a " .. itemSlotName .. ".");
        return false;
    end
    for index = targetBagSlot, bags:GetSize() do
        if (bags:GetItem(index) == nil) then
            bagSlot = index;
            break;
        end
    end
    if (not bagSlot) then
        for index = 1, (targetBagSlot - 1) do
            if (bags:GetItem(index) == nil) then
                bagSlot = index;
                break;
            end
        end
    end
    if (not bagSlot) then
--        Turbine.Shell.WriteLine("You do not have enough room in your bags to unequip your " .. itemSlotName .. ".");
        return false;
    else
        bags:PerformItemDrop(item, bagSlot, false);
--        Turbine.Shell.WriteLine("You unequip your " .. itemSlotName .. " into bag slot " .. tostring(bagSlot) .. ".");
        return true;
    end
end

function _G.CenterWindow(window)
    local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
    local windowWidth, windowHeight = window:GetSize();
    local left = math.floor((displayWidth - windowWidth) / 2);
    local top = math.floor((displayHeight - windowHeight) / 2);
    window:SetPosition(left, top);
end

-- Creates an alert window with a scrollable text box in it.
function _G.Alert(title, contents, okButton, font)
    local window = Turbine.UI.Lotro.Window();
    window:SetVisible(true);
    window:SetSize(400, 300);
    window:SetText(title);
    window:SetResizable(true);

    window.label = Turbine.UI.Label();
    window.label:SetParent(window);
    if (not font) then
        font = Turbine.UI.Lotro.Font.Verdana10;
    end
    window.label:SetFont(font);
    window.label:SetBackground(0x411348A7);
    window.label:SetPosition(14, 47);
    window.label:SetText(contents);
    window.label:SetSelectable(true);
    
    window.scrollBar = Turbine.UI.Lotro.ScrollBar();
    window.scrollBar:SetParent(window);
    window.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    window.scrollBar:SetWidth(10);
    window.scrollBar:SetTop(47);
    window.label:SetVerticalScrollBar(window.scrollBar);

    window.buttons = {};
    if (okButton) then
        local button = Turbine.UI.Lotro.Button();
        window.buttons[okButton] = button;
        button:SetText(okButton);
        button:SetParent(window);
        button:SetSize(100, 20);
        button.leftOffset = -50;
    end
    
    window.SizeChanged = function(w)
        width, height = w:GetSize();
        w.label:SetSize(width - 27, height - 80);
        w.scrollBar:SetHeight(height - 80);
        w.scrollBar:SetLeft(width - 14);
        for name, button in pairs(w.buttons) do
            local center = math.floor(0.5 + width / 2);
            button:SetPosition(center + button.leftOffset, height - 30);
        end
    end
    window:SizeChanged();
    
    if (not _G.alertWindows) then _G.alertWindows = {} end
    window.winIndex = #_G.alertWindows + 1;
    window:SetPosition(window.winIndex * 6, window.winIndex * 27);
    table.insert(_G.alertWindows, window.winIndex, window);

    window.Closing = function(sender)
        table.remove(_G.alertWindows, sender.winIndex);
    end
    
    return window;
end

-- Encodes binary into printable characters (using only ASCII codes 46-110).
-- Starting at 46 skips past the hyphen, which causes word-wrapping in TextBoxes.
function _G.Bin2Text(data)
    data = data .. string.rep(string.char(0), 2); -- pad with null characters, if needed
    local string_byte, string_char = string.byte, string.char; -- local is faster than global
    local minChar = 46;
    local result, j, X1, X2, X3, Y1, Y2, Y3, Y4 = "", 1;
    for i = 1, #data - 2, 3 do
        X1, X2, X3 = string_byte(data, i, i + 2);
        Y1 = bit.brshift(X1, 2) + minChar;
        Y2 = bit.blshift(bit.band(X1, 3), 4) + bit.brshift(X2, 4) + minChar;
        Y3 = bit.blshift(bit.band(X2, 15), 2) + bit.brshift(X3, 6) + minChar;
        Y4 = bit.band(X3, 63) + minChar;
        result = result .. string_char(Y1, Y2, Y3, Y4);
        j = j + 4;
    end
    return result;
end

-- Decodes a string encoded with Bin2Text() back into binary.
function _G.Text2Bin(data)
    local string_byte, string_char = string.byte, string.char; -- local is faster than global
    local minChar = 46;
    local result, j, X1, X2, X3, X4, Y1, Y2, Y3 = "", 1;
    for i = 1, #data - 3, 4 do
        X1, X2, X3, X4 = string_byte(data, i, i + 3);
        X1, X2, X3, X4 = X1 - minChar, X2 - minChar, X3 - minChar, X4 - minChar;
        Y1 = bit.blshift(X1, 2) + bit.brshift(X2, 4);
        Y2 = bit.blshift(bit.band(X2, 15), 4) + bit.brshift(X3, 2);
        Y3 = bit.blshift(bit.band(X3, 3), 6) + X4;
        result = result .. string_char(Y1, Y2, Y3);
        j = j + 3;
    end
    -- Remove up to two trailing null characters.
    return string.gsub(result, "%z$", "", 2);
end

-- Decodes a string encoded with Bin2Text() back into binary.
function _G.Text2Bin_old(data)
    local X = {string.byte(data, 1, -1)};
    local result, j, Y1, Y2, Y3 = "", 1;
    local minChar = 46;
    for i = 1, #X - 3, 4 do
        local X1, X2, X3, X4 = X[i] - minChar, X[i + 1] - minChar, X[i + 2] - minChar, X[i + 3] - minChar;
        Y1 = bit.blshift(X1, 2) + bit.brshift(X2, 4);
        Y2 = bit.blshift(bit.band(X2, 15), 4) + bit.brshift(X3, 2);
        Y3 = bit.blshift(bit.band(X3, 3), 6) + X4;
        result = result .. string.char(Y1, Y2, Y3);
        j = j + 3;
    end
    -- Remove up to two trailing null characters.
    return string.gsub(result, "%z$", "", 2);
end
