
--check if effect is in a timer
function checkGroupEffect(effect, player)

    local name = effect:GetName()
    local icon = effect:GetIcon()

    for window_index, window_data in ipairs(savedata) do --iterating all windows

        if window_data.load == true then --only continues if windows is loaded
        
            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Effect_Group]) do --iterating all chat timers of the "window_data"

                if timer_data.use_regex == true then

                    if string.find(name, timer_data.token) then -- check if token is found within the name

                        local key
                        if timer_data.unique == true then
                            key = "2_"..window_index.."w_"..timer_index.."t_"..player:GetName().."p"
                        else
                            key = "2_"..window_index.."w_"..timer_index.."t_"..player:GetName().."p_"..effect:GetID().."id"
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

                                text = text .. player:GetName()

                            end

                        elseif text_modifier == TEXTMODIFIER.Token then
                            text = timer_data.token

                        elseif text_modifier == TEXTMODIFIER.Custom_Text then
                            text = timer_data.text

                        end

                        windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Group][timer_index])


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
                                text = player:GetName()

                            elseif text_modifier == TEXTMODIFIER.Token then
                                text = timer_data.token

                            elseif text_modifier == TEXTMODIFIER.Custom_Text then
                                text = timer_data.text

                            end

                            windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Effect_Group][timer_index], true)

                        end

                    end

                end

            end

        end

    end

end

-- on load up check all activ effects
function checkAllActivGroupEffects()

    local self_name = LOCALPLAYER:GetName()

    local party = LOCALPLAYER:GetParty()

    if party ~= nil then

        for i=1, party:GetMemberCount(), 1 do

            local player = party:GetMember(i)

            if player:GetName() ~= self_name then

                local effects = player:GetEffects()

                for index=1, effects:GetCount(), 1 do

                    local effect = effects:Get(index)

                    checkGroupEffect(effect, player)

                    Options.Collection.checkEffectForCollection(effect)

                end

            end

        end

    end

end

--add effect add / remove callbacks
function AddGroupEffectCallbacks()

    local self_name = LOCALPLAYER:GetName()

    local party = LOCALPLAYER:GetParty()

    if party ~= nil and savedata.track_group_effects then

        for i=1, party:GetMemberCount(), 1 do

            local player = party:GetMember(i)

            if player:GetName() ~= self_name then


                local effects = player:GetEffects()

                -- effects.EffectRemoved = function(sender, args)

                -- end'

                effects.EffectAdded = function(sender, args)

                    local effect = effects:Get(args.Index)

                    checkGroupEffect(effect, player)

                    Options.Collection.checkEffectForCollection(effect)

                end

            end

        end

    end

    checkAllActivGroupEffects()

end

-- track group setting changed
function TrackGroupChanged(bool)

    savedata.track_group_effects = bool

    AddGroupEffectCallbacks()

end
