-- help function to fine some number / tier in a skill name
function CheckingSkillNameForNumber(skillName)

    local start_tier, end_tier = string.find(skillName, "%d+")
    
    if start_tier ~= nil then
        return string.sub(skillName, start_tier, end_tier)
    else
        return ""
    end

end

-- help function to get target name from a combat chat message
function GetTargetNameFromCombatChat(message, chatType)

    local updateType,initiatorName,targetName,skillName,var1,var2,var3,var4 =  Utils.ParseCombatChat(string.gsub(string.gsub(message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"))
    local text = CheckingSkillNameForNumber(skillName)
    local target = nil

    if chatType == Turbine.ChatType.PlayerCombat then
        target = targetName
    elseif chatType == Turbine.ChatType.EnemyCombat then
        target = initiatorName
    end

    return text, target

end


-- processing a found trigger
function ChatTriggerFound(message, chatType, window_index, timer_index)

    local start_time = Turbine.Engine.GetGameTime()

    -- key is to seperate diffrent timers from the same trigger
    local key
    if savedata[window_index][TRIGGER_TYPE.Chat][timer_index].unique == true then
        key = "4_"..window_index.."w_"..timer_index.."t"
    else
        key = "4_"..window_index.."w_"..timer_index.."t_"..chatcount.."c"
        chatcount = chatcount + 1
    end

    local text
    local target = ""
    local text_modifier = savedata[window_index][TRIGGER_TYPE.Chat][timer_index].text_modifier
    if text_modifier == TEXTMODIFIER.Let_the_plugin_decide then

        if chatType == Turbine.ChatType.PlayerCombat or chatType == Turbine.ChatType.EnemyCombat then
            text, target = GetTargetNameFromCombatChat(message, chatType)

            if Utils.CheckTargetNames(target, savedata[window_index][TRIGGER_TYPE.Chat][timer_index].target_list) == false  then
                return
            end

            key = key .. target .. "p"

            if savedata[window_index].type == WINDOW_TYPE.Bar_ListBox or savedata[window_index].type == WINDOW_TYPE.Bar_Window then -- add name for bars

                if text ~= "" then

                    text = text .. " - " .. target

                else
                    text = target
                end

            end

        else

            text = message

        end

    elseif text_modifier == TEXTMODIFIER.Token then
        text = message

    elseif text_modifier == TEXTMODIFIER.Custom_Text then
        text = savedata[window_index][TRIGGER_TYPE.Chat][timer_index].text

    end

    local duration
    if savedata[window_index][TRIGGER_TYPE.Chat][timer_index].custom_timer == true then
        duration = savedata[window_index][TRIGGER_TYPE.Chat][timer_index].timer
    else
        duration = 1
    end

    windows[window_index]:Add(savedata[window_index][TRIGGER_TYPE.Chat][timer_index].token, key, start_time, duration, savedata[window_index][TRIGGER_TYPE.Chat][timer_index].icon, text, savedata[window_index][TRIGGER_TYPE.Chat][timer_index])

end


-- will be run for every line in chat
function Turbine.Chat.Received(sender, args)

    if savedata.automatic_reload == true then

        if (args.ChatType == Turbine.ChatType.Standard) then

            for k, text in pairs(L.ReloadMessages) do

                if string.find(args.Message, text) then
                    
                    Reload()
                    return
                end

            end

        end

    end

    --filtered channel 
    if  (args.ChatType == Turbine.ChatType.Tell) or 
        (args.ChatType == Turbine.ChatType.FellowLoot) or 
        (args.ChatType == Turbine.ChatType.SelfLoot) or 
        (args.ChatType == Turbine.ChatType.World) or 
        (args.ChatType == Turbine.ChatType.Trade) or 
        (args.ChatType == Turbine.ChatType.Standard) or 
        (args.ChatType == Turbine.ChatType.Unfiltered) or 
        (args.ChatType == Turbine.ChatType.LFF) then

        return
    end

    -- nil is bad :D
    if args.Message == nil then
        return
    end

    Options.Collection.checkChatForCollection(args)

    for window_index, window_data in ipairs(savedata) do --iterating all windows

        if window_data.load == true then --only continues if windows is loaded
        
            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Chat]) do --iterating all chat timers of the "window_data"

                if timer_data.use_regex ~= true then -- string compare

                    if args.Message == timer_data.token then

                        ChatTriggerFound(args.Message, args.ChatType, window_index, timer_index)

                    end

                else -- string.find

                    if string.find( args.Message, timer_data.token ) then

                        ChatTriggerFound(args.Message, args.ChatType, window_index, timer_index)

                    end

                end

            end

        end

    end

    if args.ChatType == Turbine.ChatType.Advancement then

        local message_begin = string.find(args.Message, "You have acquired the Class Specialization Bonus Trait:");
        
        if message_begin ~= nil then
                          
            skill_tree_changed_control:Go()
            
        end
        
    end

end