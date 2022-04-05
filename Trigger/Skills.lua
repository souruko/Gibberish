-- checks if skill is used for a timer and adds the callback
function addSkillCallback(skill)

    local name = skill:GetSkillInfo():GetName()

    for window_index, window_data in ipairs(savedata) do

        if window_data.load == true then

            for timer_index, timer_data in ipairs(window_data[TRIGGER_TYPE.Skill]) do

                if name == timer_data.token then
                    
                    function skill:ResetTimeChanged(sender, args)

                        local start_time = Turbine.Engine.GetGameTime()

                        local key
                        if timer_data.unique == true then
                            key = "5_"..window_index.."w_"..timer_index.."t"
                        else
                            key = "5_"..window_index.."w_"..timer_index.."t_"..start_time.."s"
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

                        local start_time = skill:GetResetTime() - skill:GetCooldown()

                        local duration
                        if timer_data.custom_timer == true then
                            duration = timer_data.timer
                        else
                            duration = skill:GetResetTime() - start_time
                        end
                        
                        local icon = timer_data.icon
                        if icon == nil then
                            icon = skill:GetSkillInfo():GetIconImageID()
                        end

                        windows[window_index]:Add(timer_data.token, key, start_time, duration, icon, text, savedata[window_index][TRIGGER_TYPE.Skill][timer_index])
          
                    end

                    
                    if skill:GetResetTime() > 0 then

                        skill:ResetTimeChanged()

                    end

                end

            end

        end

    end

end


-- check if the skill is in the activ skill list
function checkIfSkillIsActiv(name)

    for index=1, list_of_skills:GetCount(), 1 do

        local skill = list_of_skills:GetItem(index)

        if skill:GetSkillInfo():GetName() == name then
            return true
        end

    end

    return false

end

-- iterate all skills and and kall addSkillCallback function for it
-- then check if skill is on cooldown > call function
function refreshAllSkillCallbacks()

    list_of_skills = LOCALPLAYER:GetTrainedSkills()

    for index=1, list_of_skills:GetCount(), 1 do

        local skill = list_of_skills:GetItem(index)

        addSkillCallback(skill)

    end

end


-- all only to have a 3 second pause before calling refreshAllSkillCallbacks()
skill_tree_changed = class( Turbine.UI.Window )

function skill_tree_changed:Constructor(parent, data)
	Turbine.UI.Window.Constructor( self )

    self.sleepEnd = 0

end

function skill_tree_changed:Go()
    self.sleepEnd = Turbine.Engine.GetGameTime() + 3
    self:SetWantsUpdates(true)
end

function skill_tree_changed:Update()

    if Turbine.Engine.GetGameTime() > self.sleepEnd then
        self:SetWantsUpdates(false)
        Windows.SkillTreeChanged()
		refreshAllSkillCallbacks()
    end

end


skill_tree_changed_control = skill_tree_changed()
