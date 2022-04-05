-- save callbacks
function AddCallback(object, event, callback)
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

function RemoveCallback(object, event, callback)
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


--check if effect is in a timer
function checkTargetEffect(effect, target)

    
    local name = effect:GetName()
    local icon = effect:GetIcon()

    for window_index, window_data in ipairs(savedata) do --iterating all windows

        if window_data.load == true then --only continues if windows is loaded
        
            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Effect_Target]) do --iterating all chat timers of the "window_data"

                if timer_data.use_regex == true then

                    if string.find(name, timer_data.token) then -- check if token is found within the name

                        local key
                        if timer_data.unique == true then
                            key = "2_"..window_index.."w_"..timer_index.."t_"..target:GetName().."p"
                        else
                            key = "2_"..window_index.."w_"..timer_index.."t_"..target:GetName().."p_"..effect:GetID().."id"
                        end

                        local start_time = effect:GetStartTime()
                        
                        local duration
                        if timer_data.custom_timer == true then
                            duration = timer_data.timer
                        else
                            duration = effect:GetDuration()
                        end

                        local text = ""
                        local text_modifier = timer_data.text_modifier
                        if text_modifier == TEXTMODIFIER.Let_the_plugin_decide then

                            local has_number = false
                            local start_tier, end_tier = string.find(name, "%d+") -- check if name has some sort of number / tier
                            if start_tier ~= nil then
                                text = string.sub(name, start_tier, end_tier) 
                                has_number = true
                            end
                            
                            if window_data.type == WINDOW_TYPE.Bar_ListBox or window_data.type == WINDOW_TYPE.Bar_Window then -- add name for bars

                                if has_number == true then
                                    text = text .. " - "
                                
                                end

                                text = text .. target:GetName()

                            end

                        elseif text_modifier == TEXTMODIFIER.Token then
                            text = timer_data.token

                        elseif text_modifier == TEXTMODIFIER.Custom_Text then
                            text = timer_data.text

                        end

                        windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Target][timer_index])


                    end

                else

                    if name == timer_data.token then -- checks if name exactly the token

                        if timer_data.icon == nil or timer_data.icon == icon then -- if icon is in timer_data then it checks for it

                            local key
                            if timer_data.unique == true then
                                key = window_index.."w_"..timer_index.."t"
                            else
                                key = window_index.."w_"..timer_index.."t_"..effect:GetID().."id"
                            end

                            local start_time = effect:GetStartTime()
                            
                            local duration
                            if timer_data.custom_timer == true then
                                duration = timer_data.timer
                            else
                                duration = effect:GetDuration()
                            end

                            local text = ""
                            local text_modifier = timer_data.text_modifier
                            if text_modifier == TEXTMODIFIER.Let_the_plugin_decide then
                                text = target:GetName()

                            elseif text_modifier == TEXTMODIFIER.Token then
                                text = timer_data.token

                            elseif text_modifier == TEXTMODIFIER.Custom_Text then
                                text = timer_data.text

                            end

                            windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Target][timer_index], true)

                        end

                    end

                end

            end

        end

    end


end

-- on load up check all activ effects
function checkAllActivTargetEffects()

    local target = LOCALPLAYER:GetTarget()

        if target ~= nil and target.GetEffects ~= nil then

            local effects = target:GetEffects()

            for index=1, effects:GetCount(), 1 do

                local effect = effects:Get(index)

                checkTargetEffect(effect, target)

                Options.Collection.checkEffectForCollection(effect)

            end

        end

end

--add effect add / remove callbacks
trackingCallbacks = {}

--add effect add / remove callbacks
function AddTargetEffectCallbacks()

    LOCALPLAYER.TargetChanged = function(sender, args)

        local target = LOCALPLAYER:GetTarget()
        
        if target ~= nil and not(target:IsLocalPlayer()) and target.GetEffects ~= nil then

            for key, value in pairs(trackingCallbacks) do
                RemoveCallback(key, "EffectAdded", value)
            end

            local effects = target:GetEffects()
    
            trackingCallbacks[effects] = AddCallback(effects, "EffectAdded", function(sender, args)
                local effect = effects:Get(args.Index)
                checkTargetEffect(effect, target)
                Options.Collection.checkEffectForCollection(effect)
            end)

        end

        checkAllActivTargetEffects()

    end

    checkAllActivTargetEffects()

end

-- setting for track target got changed
function TrackTargetChanged(bool)

    savedata.track_target_effects = bool

    AddTargetEffectCallbacks()

end
