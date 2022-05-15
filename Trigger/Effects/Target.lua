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
                if name == timer_data.token or (timer_data.use_regex == true and string.find(name, timer_data.token)) then
                    if timer_data.use_regex == false or timer_data.icon == nil or timer_data.icon == icon then -- for no regex: if icon is in timer_data then it checks for it

                        if Utils.CheckTargetNames(target:GetName(), timer_data.target_list)  then

                            local key
                            if timer_data.unique == true then
                                key = "3_"..window_index.."w_"..timer_index.."t_"..target:GetName().."p"
                            else
                                key = "3_"..window_index.."w_"..timer_index.."t_"..target:GetName().."p_"..effect:GetID().."id"
                            end

                            local start_time = effect:GetStartTime()
                            
                            local duration
                            if timer_data.custom_timer == true then
                                duration = timer_data.timer
                            else
                                duration = effect:GetDuration()
                            end

                            local text = Utils.ParseWindowTimerText(name, timer_data, window_data, target:GetName())
                            windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Target][timer_index], target)
                            
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

        for window_index, window_data in ipairs(savedata) do
            if window_data.load and window_data.reset_on_target_change == true then
                windows[window_index]:ResetAll()
            end
        end

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
