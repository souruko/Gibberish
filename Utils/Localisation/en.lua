
-- for automatic reload detection
resetPhrases = {}

resetPhrases[1] = "You have joined a Fellowship."
resetPhrases[2] = "You have joined a Raid."

resetPhrases[3] = "has joined your Fellowship."
resetPhrases[4] = "has joined your Raid."

resetPhrases[5] = "You dismiss "
resetPhrases[6] = "You dismiss "

resetPhrases[7] = " been dismissed from your Fellowship."
resetPhrases[8] = " been dismissed from your Raid."

resetPhrases[9]  = "has left your Fellowship."
resetPhrases[10] = "has left your Raid."

resetPhrases[11] = "You leave your Fellowship."
resetPhrases[12] = "You leave your Raid."

LANGUAGE[1] = "English"
LANGUAGE[2] = "German"
LANGUAGE[3] = "French"

TEXTMODIFIER[1] = "No Text"
TEXTMODIFIER[2] = "Token"
TEXTMODIFIER[3] = "Custom Text"
TEXTMODIFIER[4] = "Let the plugin decide"

WINDOW_TYPE[1] = "Bar ListBox"
WINDOW_TYPE[2] = "Bar Window"
WINDOW_TYPE[3] = "Icon ListBox"
WINDOW_TYPE[4] = "Icon Window"
WINDOW_TYPE[5] = "Count Down"

TRIGGER_TYPE[1] = "Effect Self"
TRIGGER_TYPE[2] = "Effect Group"
TRIGGER_TYPE[3] = "Effect Target"
TRIGGER_TYPE[4] = "Chat"
TRIGGER_TYPE[5] = "Skill"
TRIGGER_TYPE[6] = "Timer End"
TRIGGER_TYPE[7] = "Timer Start"
TRIGGER_TYPE[8] = "Timer Threshold"

TRIGGER_TYPE.short[1] = "ES"
TRIGGER_TYPE.short[2] = "EG"
TRIGGER_TYPE.short[3] = "ET"
TRIGGER_TYPE.short[4] = "C"
TRIGGER_TYPE.short[5] = "S"
TRIGGER_TYPE.short[6] = "TE"
TRIGGER_TYPE.short[7] = "TS"
TRIGGER_TYPE.short[8] = "TT"

L.reset = "Reset"
L.reload = "Reload"
L.move_windows = "Move Windows"
L.move_menuicon = "Move MenuIcon"
L.search = "Search ..."
L.effects = "effects"
L.chat = "chat"
L.skills = "skills"
L.timer = "timer"
L.create = "Create"
L.cancel = "Cancel"
L.delete = "Delete"

L.collectionNameHeader = "Collection"
L.ChatItemTokenText = "ChatType: "
L.libraryHeader = "- Permanent Library -"
L.collectionHeader = "- Temporary Collection -"
L.track = "Track"
L.stop = "Stop"
L.fillCollectionHeader = "- Fill Collection -"
L.effects = "Effects"
L.onlyDebuffs = "Only Debuffs"
L.chat = "Chat"
L.onlySay = "Only Say"
L.effects = "Effects"

L.import = "- Import -"
L.export = "- Export -"
L.buttonText = "Import"


L.left2 = "Left: "
L.top2 = "Top: "
L.width2 = "Width: "
L.height2 = "Height: "
L.update = "Update"
L.show_groups = "Show Groups"
L.show_grid = "Show Grid"
L.done = "Done"

L.optionsNameHeader = "Options"
L.addGroupHeader = "- Add New Group -"
L.newGroup = "New Group "
L.editGroupHeader = "- Edit Group -"
L.change = "Change"
L.name = "Name"
L.color = "Color"
L.newWindow = "New Window "
L.addNewWiindow = "- Add New Window -"
L.windowType = "Window Type"
L.deleteConfirmationHeader = "- Delete Confirmation -"
L.GeneralOptionsHeader = "- General Options -"
L.import = "Import"
L.export = "Export"
L.trackTarget = "Track Target"
L.trackGroup = "Track Group"
L.autoReload = "Auto Reload"
L.reload = "Reload"
L.gibberish = "Gibberish"
L.defaultEditMode =  "<Default Edit Mode> : "
L.leaveDefaultEditMode = "Leave Edit Mode"
L.editDefault = "Edit Default"
L.windowOptionsHeader = "- Window Options -"
L.width = "Width"
L.height =  "Height"
L.spacing = "Spacing"
L.frame = "Frame"
L.frame_color = "Frame Color"
L.back_color = "Back Color"
L.bar_color = "Bar Color"
L.timer_color = "Timer Color"
L.text_color = "Text Color"
L.font = "Font"
L.number_format = "Number Format"
L.transparency1 = "Transparency (activ)"
L.transparency2 = "Transparency (passiv)"
L.ascending = "Ascending"
L.orientation = "Orientation"
L.overlay = "Overlay"
L.resetToDefault = "Reset to Default"
L.save = "Save"
L.description = "Description"
L.token = "Token"
L.text = "Text"
L.icon = "Icon"
L.custom_timer = "Custom Timer"
L.threshold = "Threshold"
L.flashing = "Flashing"
L.unique = "Unique"
L.reset = "Reset"
L.loop = "Loop"
L.use_regex = "Use Regex"
L.removable = "Removable"
L.hide_timer = "Hide Timer"
L.close = "Close"
L.resetChanges  = "Reset Changes"
L.timerHeader  = "- Timer -"
L.add  = "Add"
L.load  = "- loaded -"
L.not_load  = "- not loaded -"
L.windowHeader  = "- Window -"
L.window  = "Window"
L.group  = "Group"

L.confirmationText = "Are you sure, you want to delete:\n\n<rgb=#FF0000>"

L.clearButtonText = "Clear"

L.counter_start = "Counter Start"
L.trigger_id = "Trigger"


L.ReloadMessages = {

    [ "raid_convert" ] = "You have joined the chat room for your raid, raid chat is now available.",
    [ "fellowship_join" ] = " has joined your Fellowship.",
    [ "raid_join" ] = " has joined your Raid.",
    [ "fellowship_join_self" ] = "You have joined a Fellowship.",
    [ "raid_join_self" ] = "You have joined a Raid.",
    [ "fellowship_leave" ] = " has left your Fellowship.",
    [ "raid_leave" ] = " has left your Raid.",
    [ "fellowship_leave_self" ] = "You leave your Fellowship.",
    [ "raid_leave_self" ] = "You leave your Raid.",
    [ "self_dismiss_start" ] = "You dismiss ",
    [ "fellowship_dismiss_end" ] = " from the fellowship.",
    [ "raid_dismiss_end" ] = " from the Raid.",
    [ "fellowship_dismiss" ] = " has been dismissed from your Fellowship.",
    [ "raid_dismiss" ] = " has been dismissed from your Raid.",
    [ "fellowship_dismiss_self" ] = "You have been dismissed from your Fellowship.",
    [ "raid_dismiss_self" ] = "You have been dismissed from your Raid.",
    [ "fellowship_disband" ] = "Your Fellowship has been disbanded.",
    [ "raid_disband" ] = "Your Raid has been disbanded."
}
