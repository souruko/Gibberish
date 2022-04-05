--[[
    Collection Functions
]]



function EffectToLibrary(index)

    local temp = collectiontemp.effects[index]

    local maxindex = table.getn(collectiontemp.effects)
    collectiontemp.effects[index] = collectiontemp.effects[maxindex]
    collectiontemp.effects[maxindex] = nil

    collectiondata.effects[table.getn(collectiondata.effects) + 1] = temp

    SaveLibrary()

end

function EffectToCollection(index)

    local temp = collectiondata.effects[index]

    local maxindex = table.getn(collectiondata.effects)
    collectiondata.effects[index] = collectiondata.effects[maxindex]
    collectiondata.effects[maxindex] = nil

    collectiontemp.effects[table.getn(collectiontemp.effects) + 1] = temp

    SaveLibrary()

end

function ChatToLibrary(index)

    local temp = collectiontemp.chat[index]

    local maxindex = table.getn(collectiontemp.chat)
    collectiontemp.chat[index] = collectiontemp.chat[maxindex]
    collectiontemp.chat[maxindex] = nil

    collectiondata.chat[table.getn(collectiondata.chat) + 1] = temp

    SaveLibrary()

end

function ChatToCollection(index)

    local temp = collectiondata.chat[index]

    local maxindex = table.getn(collectiondata.chat)
    collectiondata.chat[index] = collectiondata.chat[maxindex]
    collectiondata.chat[maxindex] = nil

    collectiontemp.chat[table.getn(collectiontemp.chat) + 1] = temp

    SaveLibrary()

end

function CollectionCloseFix()
    collectionWindow = nil
end

function CollectionStateChanged()

    if collectionWindow == nil then
        collectionWindow = Window()
        optionsdata.collection.open = true
    else
        collectionWindow:Close()
        collectionWindow = nil
        optionsdata.collection.open = false
    end

end

function CollectionChanged()

    if collectionWindow ~= nil then

        collectionWindow:CollectionChanged()
        Options.OptionsWindow.CollectionChanged()

    end

end

function checkEffectForCollection(effect)

    if collectEffects == false then
        return
    end

    if only_debuffs == true and effect:IsDebuff() == false then
        return
    end

    local name = effect:GetName()
    local icon = effect:GetIcon()
    for i, item in ipairs(collectiontemp.effects) do
        if item.name == name and item.icon == icon then
                return
        end
    end

    local index = table.getn(collectiontemp.effects) + 1
    collectiontemp.effects[index] = {}
    collectiontemp.effects[index].name = name
    collectiontemp.effects[index].icon = icon
    collectiontemp.effects[index].duration = effect:GetDuration()
    collectiontemp.effects[index].description = effect:GetDescription()

    CollectionChanged()

end


function checkChatForCollection(chat)

    if collectChat == false then
        return
    end

    local chatType = chat.ChatType
    if only_say == true and chatType ~= Turbine.ChatType.Say then
        return
    end

    local message = chat.Message
    for i, item in ipairs(collectiontemp.chat) do
        if item.message == message and item.chatType == chatType then
                return
        end
    end

    local index = table.getn(collectiontemp.chat) + 1
    collectiontemp.chat[index] = {}
    collectiontemp.chat[index].message = message
    collectiontemp.chat[index].chatType = chatType

    CollectionChanged()

end