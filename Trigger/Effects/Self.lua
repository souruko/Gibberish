
--check if effect is in a timer
function checkSelfEffect(effect)

    local name = effect:GetName()
    local icon = effect:GetIcon()

    for window_index, window_data in ipairs(savedata) do --iterating all windows

        if window_data.load == true then --only continues if windows is loaded
        
            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Effect_Self]) do --iterating all chat timers of the "window_data"

                if timer_data.use_regex == true then

                    if string.find(name, timer_data.token) then -- check if token is found within the name

                        local key
                        if timer_data.unique == true then
                            key = "1_"..window_index.."w_"..timer_index.."t"
                        else
                            key = "1_"..window_index.."w_"..timer_index.."t_"..effect:GetID().."id"
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

                            local start_tier, end_tier = string.find(name, "%d+") -- check if name has some sort of number / tier
                            if start_tier ~= nil then
                                text = string.sub(name, start_tier, end_tier) 

                            else
                                text = name
                            end

                        elseif text_modifier == TEXTMODIFIER.Token then
                            text = timer_data.token

                        elseif text_modifier == TEXTMODIFIER.Custom_Text then
                            text = timer_data.text

                        end

                        windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Self][timer_index], LOCALPLAYER)

                    end

                else

                    if name == timer_data.token then -- checks if name exactly the token

                        if timer_data.icon == nil or timer_data.icon == icon then -- if icon is in timer_data then it checks for it

                            local key
                            if timer_data.unique == true then
                                key = "1_"..window_index.."w_"..timer_index.."t"
                            else
                                key = "1_"..window_index.."w_"..timer_index.."t_"..effect:GetID().."id"
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
                                text = name

                            elseif text_modifier == TEXTMODIFIER.Token then
                                text = timer_data.token

                            elseif text_modifier == TEXTMODIFIER.Custom_Text then
                                text = timer_data.text

                            end

                            windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Self][timer_index], LOCALPLAYER)

                        end

                    end

                end

            end

        end

    end

end

-- checks if effect has a timer and removes it
function checkRemoveSelfEffect(effect)

    local name = effect:GetName()
    local icon = effect:GetIcon()

    for window_index, window_data in ipairs(savedata) do

        if window_data.load == true then

            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Effect_Self]) do

                if timer_data.removable == true then

                    if timer_data.use_regex == true then

                        if string.find(name, timer_data.token) then

                            local key
                            if timer_data.unique == false then
                                key = "1_"..window_index.."w_"..timer_index.."t_"..effect:GetID().."id"
                            else
                                local effects = LOCALPLAYER:GetEffects()

                                for index=1, effects:GetCount(), 1 do

                                    local e = effects:Get(index)

                                    if e:GetName() == name and e:GetIcon() == icon then
                                        return
                                    end
     
                                end

                                key =  "1_"..window_index.."w_"..timer_index.."t"
                            end

                            windows[window_index]:Remove(key)

                        end

                    else

                        if name == timer_data.token then

                            if timer_data.icon == nil or timer_data.icon == icon then

                                local key
                                if timer_data.unique == false then
                                    key = "1_"..window_index.."w_"..timer_index.."t_"..effect:GetID().."id"
                                else
                                    local effects = LOCALPLAYER:GetEffects()

                                for index=1, effects:GetCount(), 1 do

                                    local e = effects:Get(index)

                                    if e:GetName() == name and e:GetIcon() == icon then
                                        return
                                    end
     
                                end

                                    key =  "1_"..window_index.."w_"..timer_index.."t"
                                end

                                windows[window_index]:Remove(key)

                            end

                        end

                    end

                end

            end

        end

    end

end

-- check all activ effects only called once at the startup
function checkAllActivSelfEffects()

    local effects = LOCALPLAYER:GetEffects()

    for index=1, effects:GetCount(), 1 do

        local effect = effects:Get(index)

        checkSelfEffect(effect)
        checkGroupEffect(effect, LOCALPLAYER)

        Options.Collection.checkEffectForCollection(effect)

    end

end

-- add callbacks for EffectAdded and EffectRemoved also call checkAllActivSelfEffects()
function AddSelfEffectCallbacks()

    local effects = LOCALPLAYER:GetEffects()

    effects.EffectRemoved = function(sender, args)

        local name = args.Effect:GetName()
        local icon = args.Effect:GetIcon()

        checkRemoveSelfEffect(args.Effect)

    end

    effects.EffectAdded = function(sender, args)

        local effect = effects:Get(args.Index)

        checkSelfEffect(effect)
        checkGroupEffect(effect, LOCALPLAYER)
        Options.Collection.checkEffectForCollection(effect)

    end

    checkAllActivSelfEffects()

end
