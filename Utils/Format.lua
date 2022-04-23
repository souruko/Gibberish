
-- convert true/fals string to bool
function StringToBool(text)

    if text == "true" then
        return true

    elseif text == "false" then
        return false

    else
        return nil

    end

end

-- get chattype string
function ChatTypeToString(chattype)

	if chattype == Turbine.ChatType.PlayerCombat then
		return "PlayerCombat"
	elseif chattype == Turbine.ChatType.EnemyCombat then
		return "EnemyCombat"
	elseif chattype == Turbine.ChatType.Say then
		return "Say"
	elseif chattype == Turbine.ChatType.Advancement then
		return "Advancement"
	elseif chattype == Turbine.ChatType.Emote then
		return "Emote"
	elseif chattype == Turbine.ChatType.Fellowship then
		return "Fellowship"
	elseif chattype == Turbine.ChatType.Kinship then
		return "Kinship"
	elseif chattype == Turbine.ChatType.Raid then
		return "Raid"
	elseif chattype == Turbine.ChatType.LFF then
		return "LFF"
	elseif chattype == Turbine.ChatType.World then
		return "World"
	elseif chattype == Turbine.ChatType.SelfLoot then
		return "SelfLoot"
	elseif chattype == Turbine.ChatType.FellowLoot then
		return "FellowLoot"
	elseif chattype == Turbine.ChatType.OOC then
		return "OOC"
	elseif chattype == Turbine.ChatType.Regional then
		return "Regional"
	elseif chattype == Turbine.ChatType.Raid then
		return "Raid"
	elseif chattype == Turbine.ChatType.Trade then
		return "Trade"
	elseif chattype == Turbine.ChatType.Tribe then
		return "Tribe"
	elseif chattype == Turbine.ChatType.Officer then
		return "Officer"
	elseif chattype == Turbine.ChatType.UserChat1 then
		return "UserChat1"
	elseif chattype == Turbine.ChatType.UserChat2 then
		return "UserChat2"
	elseif chattype == Turbine.ChatType.UserChat3 then
		return "UserChat3"
	elseif chattype == Turbine.ChatType.UserChat4 then
		return "UserChat4"
    elseif chattype == Turbine.ChatType.UserChat5 then
		return "UserChat5"
	elseif chattype == Turbine.ChatType.UserChat6 then
		return "UserChat6"
	elseif chattype == Turbine.ChatType.UserChat7 then
		return "UserChat7"
	elseif chattype == Turbine.ChatType.UserChat8 then
		return "UserChat8"
    elseif chattype == Turbine.ChatType.Undef then
		return "Undef"
    elseif chattype == Turbine.ChatType.Narration then
		return "Narration"
    elseif chattype == Turbine.ChatType.Localized1 then
		return "Localized1"
    elseif chattype == Turbine.ChatType.Localized2 then
		return "Localized2"
    elseif chattype == Turbine.ChatType.Death then
		return "Death"
    elseif chattype == Turbine.ChatType.Error then
		return "Error"
    elseif chattype == Turbine.ChatType.Quest then
		return "Quest"
    elseif chattype == Turbine.ChatType.Tell then
		return "Tell"
    elseif chattype == Turbine.ChatType.Unfiltered then
		return "Unfiltered"
    elseif chattype == Turbine.ChatType.Admin then
		return "Admin"
    elseif chattype == Turbine.ChatType.Roleplay then
		return "Roleplay"
    elseif chattype == Turbine.ChatType.Standard then
		return "Standard"
	else
		return chattype
	end
	

end

-- fix color from savefile to Turbine.UI.Color
function ColorFix(color)
	return Turbine.UI.Color(color.R, color.G, color.B)
end


-- Turbine.UI.Color to string ("255, 255, 255")
function ColorToString(color)
    return math.floor(255*color.R)..", "..math.floor(255*color.G)..", "..math.floor(255*color.B)
end


-- color string ("255, 255, 255") to Turbine.UI.Color
function StringToColor(text)

    text = string.gsub(text, "\n", "")
    text = string.gsub(text, " ", "")

    local color_list = split(text, ",")

    
    if table.getn(color_list) ~= 3 then -- return if not 3 values
        return nil
    end
    if color_list[1] == "" or color_list[2] == "" or color_list[3] == "" then  -- return if any value is nil
        return nil
    end

    if tonumber(color_list[1]) > 255 or tonumber(color_list[1]) < 0 then
        return nil
    end
    if tonumber(color_list[2]) > 255 or tonumber(color_list[2]) < 0 then
        return nil
    end
    if tonumber(color_list[3]) > 255 or tonumber(color_list[3]) < 0 then
        return nil
    end

    return tonumber(color_list[1])/255, tonumber(color_list[2])/255, tonumber(color_list[3])/255


end

-- math.round
_G.math.round = function( value )
	return math.floor( value + 0.5 );
end

-- convert screenratio to pixel
function ScreenRatioToPixel(x, y)

    return math.round(x * SCREEN_WIDTH), math.round(y * SCREEN_HEIGHT)

end

-- convert left/top to screenratio
function PixelToScreenRatio(x, y)

    return (x / SCREEN_WIDTH), (y / SCREEN_HEIGHT)

end

-- check if positon is still on screen
function CheckPositionStillOnScreen(left, top, width, height)

    if left < 0 then
        left = 0
    elseif (left+width) > SCREEN_WIDTH then
        left = SCREEN_WIDTH - width
    end
    
    if top < 0 then
        top = 0
    elseif (top+height) > SCREEN_HEIGHT then
    top = SCREEN_HEIGHT - height
    end

    return left, top

end

-- timer visual
function SecondsToClock(seconds, format)

    if format == 1 then

        return math.floor(seconds)

    elseif format == 2 then

        local seconds = tonumber(seconds)

        if seconds <= 0 then
            return "00:00";
        else
        --  hours = string.format("%02.f", math.floor(seconds/3600));
            mins = string.format("%02.f", math.floor(seconds/60));
            secs = string.format("%02.f", math.floor(seconds - mins *60));
            return mins..":"..secs
        end

    end

end


-- split a string s at delimiter
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end



-- number to font
findfont = function(number)
    if number == 1 then
        return Turbine.UI.Lotro.Font.Arial12;
    elseif number == 2 then
        return Turbine.UI.Lotro.Font.TrajanPro13;
    elseif number == 3 then
        return Turbine.UI.Lotro.Font.TrajanPro14;
    elseif number == 4 then
        return Turbine.UI.Lotro.Font.TrajanPro15;
    elseif number == 5 then
        return Turbine.UI.Lotro.Font.TrajanPro16;
    elseif number == 6 then
        return Turbine.UI.Lotro.Font.TrajanPro18;
    elseif number == 7 then
        return Turbine.UI.Lotro.Font.TrajanPro19;
    elseif number == 8 then
        return Turbine.UI.Lotro.Font.TrajanPro20;
    elseif number == 9 then
        return Turbine.UI.Lotro.Font.TrajanPro21;
    elseif number == 10 then
        return Turbine.UI.Lotro.Font.TrajanPro23;
    elseif number == 11 then
        return Turbine.UI.Lotro.Font.TrajanPro24;
    elseif number == 12 then
        return Turbine.UI.Lotro.Font.TrajanPro25;
    elseif number == 13 then
        return Turbine.UI.Lotro.Font.TrajanPro26;
    elseif number == 14 then
        return Turbine.UI.Lotro.Font.TrajanPro28;
    elseif number == 15 then
        return Turbine.UI.Lotro.Font.TrajanProBold16;
    elseif number == 16 then
        return Turbine.UI.Lotro.Font.TrajanProBold22;
    elseif number == 17 then
        return Turbine.UI.Lotro.Font.TrajanProBold24;
    elseif number == 18 then
        return Turbine.UI.Lotro.Font.TrajanProBold25;
    elseif number == 19 then
        return Turbine.UI.Lotro.Font.TrajanProBold30;
    elseif number == 20 then
        return Turbine.UI.Lotro.Font.TrajanProBold36;
    elseif number == 21 then
        return Turbine.UI.Lotro.Font.Verdana10;
    elseif number == 22 then
        return Turbine.UI.Lotro.Font.Verdana12;
    elseif number == 23 then
        return Turbine.UI.Lotro.Font.Verdana14;
    elseif number == 24 then
        return Turbine.UI.Lotro.Font.Verdana16;
    elseif number == 25 then
        return Turbine.UI.Lotro.Font.Verdana18;
    elseif number == 26 then
        return Turbine.UI.Lotro.Font.Verdana20;
    elseif number == 27 then
        return Turbine.UI.Lotro.Font.Verdana22;
    elseif number == 28 then
        return Turbine.UI.Lotro.Font.Verdana23;
    end
end

local size_item = Turbine.UI.Control()
-- returning image size
function GetImageSize(image)

	size_item:SetBackground(image)
	size_item:SetStretchMode(2)

	return size_item:GetSize()
    
end

function TargetListToString(list)

    if list == nil then
        return ""
    end

    local text = ""

    for index, value in ipairs(list) do
        text = text .. value .. ";"
    end

    return text
    
end

function TargetStringToList(text)

    text = string.gsub(text, "%s*;%s*", ";")

    local list = split(text, ";")
    local return_list = {}

    for index, value in ipairs(list) do
        if value ~= "" then
            return_list[table.getn(return_list) + 1] = value
        end
    end

    if table.getn(return_list) == 0 then
        return nil
    end

    return return_list

end

-- check if targetname matches list
function CheckTargetNames(name, list)

    if list == nil then
        return true
    end

    for key, value in pairs(list) do

        if value == name then
            return true
        end
        
    end

    return false
    
end
