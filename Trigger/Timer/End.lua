
-- every timer will call this function when it ends
function CheckForWaitingTimerEnd(key, data)

    for window_index, window_data in ipairs(savedata) do 

        if (window_data.load) then

            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Timer_End]) do 

                if timer_data.token ~= "" and timer_data.token ~= nil then

                    if (string.find(key, timer_data.token)) then
                        
                        local start_time = Turbine.Engine.GetGameTime()

                        --key
                        local out_key
                        if timer_data.unique == true then
                            out_key = "6_"..window_index.."w_"..timer_index.."t"
                        else
                            out_key = "6_"..window_index.."w_"..timer_index.."t_"..start_time
                        end

                        --text
                        local text = ""
                        local text_modifier = timer_data.text_modifier
                        if text_modifier == TEXTMODIFIER.Let_the_plugin_decide then
                            text = data.text

                        elseif text_modifier == TEXTMODIFIER.Token then
                            text = timer_data.token

                        elseif text_modifier == TEXTMODIFIER.Custom_Text then
                            text = timer_data.text

                        end

                        --icon
                        local icon
                        if timer_data.icon == nil or timer_data.icon == "" then
                            icon = data.icon
                        else
                            icon = timer_data.icon
                        end

                        --duration
                        local duration
                        if timer_data.custom_timer == true then
                            duration = timer_data.timer
                        else
                            duration = 1
                        end

                        windows[window_index]:Add(timer_data.token, out_key, start_time, duration, icon, text, timer_data)
                    end
                end
            end
        end

    end

end