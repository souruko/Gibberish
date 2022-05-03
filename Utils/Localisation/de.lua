
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

LANGUAGE[1] = "Englisch"
LANGUAGE[2] = "Deutsch"
LANGUAGE[3] = "Französisch"

TEXTMODIFIER[1] = "Kein Text"
TEXTMODIFIER[2] = "Token"
TEXTMODIFIER[3] = "Benutzerdefinierter Text"
TEXTMODIFIER[4] = "Zielname"

WINDOW_TYPE[1] = "Leistenfeld"
WINDOW_TYPE[2] = "Leistenfenster"
WINDOW_TYPE[3] = "Symbolfeld"
WINDOW_TYPE[4] = "Symbolfenster"
WINDOW_TYPE[5] = "Add Anzahl"


TRIGGER_TYPE[1] = "Effekt Selbst"
TRIGGER_TYPE[2] = "Effekt Gruppe"
TRIGGER_TYPE[3] = "Effekt Ziel"
TRIGGER_TYPE[4] = "Chat"
TRIGGER_TYPE[5] = "Fertigkeiten"
TRIGGER_TYPE[6] = "Timer Ende"
TRIGGER_TYPE[7] = "Timer Start"
TRIGGER_TYPE[8] = "Timer Übergang"

TRIGGER_TYPE.short[1] = "ES"
TRIGGER_TYPE.short[2] = "EG"
TRIGGER_TYPE.short[3] = "EZ"
TRIGGER_TYPE.short[4] = "C"
TRIGGER_TYPE.short[5] = "F"
TRIGGER_TYPE.short[6] = "TE"
TRIGGER_TYPE.short[7] = "TS"
TRIGGER_TYPE.short[8] = "TÜ"

L.reset = "Reset"
L.reload = "Neu Laden"
L.move_windows = "Fenster Bewegen"
L.move_menuicon = "Icon Bewegen"
L.search = "Suchen ..."
L.effects = "Effekte"
L.chat = "Chat"
L.skills = "Fertigkeiten"
L.timer = "Timer"
L.create = "Erstellen"
L.cancel = "Abbrechen"

L.collectionNameHeader = "Sammlung"
L.ChatItemTokenText = "ChatTyp: "
L.libraryHeader = "- Dauerhafte Bibliothek -"
L.collectionHeader = "- Temporäre Sammlung -"
L.track = "Sammeln"
L.stop = "Stop"
L.fillCollectionHeader = "- Sammlung Füllen -"
L.effects = "Effekte"
L.onlyDebuffs = "Nur Debuffs"
L.chat = "Chat"
L.onlySay = "Nur Sagen"
L.effects = "Effekte"

L.import = "- Importieren -"
L.export = "- Exportieren -"
L.buttonText = "Importieren"


L.left2 = "Links: "
L.top2 = "Oben: "
L.width2 = "Breite: "
L.height2 = "Höhe: "
L.update = "Übernehmen"
L.show_groups = "Gruppen Anzeigen"
L.show_grid = "Grid Anzeigen"
L.done = "Beenden"

L.optionsNameHeader = "Optionen"
L.addGroupHeader = "- Neue Gruppe Hinzufügen -"
L.newGroup = "Neue Gruppe "
L.editGroupHeader = "- Gruppe Bearbeiten -"
L.change = "Ändern"
L.name = "Name"
L.color = "Farbe"
L.newWindow = "Neues Fenster "
L.addNewWiindow = "- Neues Fenster Hinzufügen -"
L.windowType = "Fenster Typ"
L.deleteConfirmationHeader = "- Löschbestätigung -"
L.GeneralOptionsHeader = "- Allgemeine Optionen -"
L.import = "Importieren"
L.export = "Exportieren"
L.trackTarget = "Ziel Verfolgen"
L.trackGroup = "Gruppe Verfolgen"
L.autoReload = "Auto Reload"
L.reload = "Neu Laden"
L.gibberish = "Gibberish"
L.defaultEditMode =  "<Standardbearbeitungsmodus> : "
L.leaveDefaultEditMode = "Bearbeitungsmodus Verlassen"
L.editDefault = "Standard bearbeiten"
L.windowOptionsHeader = "- Fenster Optionen -"
L.width = "Breite"
L.height =  "Höhe"
L.spacing = "Abstand"
L.frame = "Rahmen"
L.frame_color = "Rahmenfarbe"
L.back_color = "Hintergrundfarbe"
L.bar_color = "Balkenfarbe"
L.timer_color = "Timerfarbe"
L.text_color = "Textfarbe"
L.font = "Schriftart"
L.number_format = "Zahlenformat"
L.transparency1 = "Transparenz (aktiv)"
L.transparency2 = "Transparenz (passiv)"
L.ascending = "Aufsteigend"
L.orientation = "Orientierung"
L.overlay = "Abdeckend"
L.resetToDefault = "Auf Standard Zurücksetzten"
L.save = "Speichern"
L.description = "Beschreibung"
L.token = "Token"
L.text = "Text"
L.icon = "Icon"
L.custom_timer = "Custom Timer"
L.threshold = "Übergang"
L.flashing = "Blinkend"
L.unique = "Einzigartig"
L.reset = "Reset"
L.loop = "Wiederholen"
L.use_regex = "Regex benutzen"
L.removable = "Entfernbar"
L.hide_timer = "Timer verstecken"
L.close = "Schließen"
L.resetChanges  = "Änderungen Zurücksetzten"
L.timerHeader  = "- Timer -"
L.add  = "Hinzufügen"
L.load  = "- geladen -"
L.not_load  = "- nicht geladen -"
L.windowHeader  = "- Fenster -"
L.window  = "Fenster"
L.group  = "Gruppe"

L.confirmationText = "Are you sure, you want to delete:\n\n<rgb=#FF0000>"

L.clearButtonText = "Clear"

L.trigger_id = "Trigger"

L.ReloadMessages = {

    [ "raid_convert" ] = "Ihr habt den Chat-Raum Eurer Gefährtengruppe betreten. Der Gefährten-Chat ist jetzt verfügbar.",
    [ "fellowship_join" ] = " hat sich Eurer Gruppe von Gefährten angeschlossen.",
    [ "raid_join" ] = " hat sich Eurem Schlachtzug angeschlossen.",
    [ "fellowship_join_self" ] = "Ihr habt Euch einer Gruppe von Gefährten angeschlossen.",
    [ "raid_join_self" ] = "Ihr habt Euch einem Schlachtzug angeschlossen.",
    [ "fellowship_leave" ] = " hat Eure Gruppe von Gefährten verlassen.",
    [ "raid_leave" ] = " hat Euren Schlachtzug verlassen.",
    [ "fellowship_leave_self" ] = "Ihr verlasst Eure Gruppe von Gefährten.",
    [ "raid_leave_self" ] = "Ihr verlasst den Schlachtzug.",
    [ "self_dismiss_start" ] = "Ihr schließt ",
    [ "fellowship_dismiss_end" ] = " aus der Gruppe von Gefährten aus.",
    [ "raid_dismiss_end" ] = " aus dem Schlachtzug aus.",
    [ "fellowship_dismiss" ] = " wurde aus Eurer Gruppe von Gefährten ausgeschlossen.",
    [ "raid_dismiss" ] = " wurde aus Eurem Schlachtzug ausgeschlossen.",
    [ "fellowship_dismiss_self" ] = "Ihr wurdet aus Eurer Gruppe von Gefährten ausgeschlossen.",
    [ "raid_dismiss_self" ] = "Ihr wurdet aus Eurem Schlachtzug ausgeschlossen.",
    [ "fellowship_disband" ] = "Eure Gruppe von Gefährten wurde aufgelöst.",
    [ "raid_disband" ] = "Euer Schlachtzug wurde aufgelöst."
}

L.use_target_entity = "Use Target Entity"
L.increment = "Increment"
L.target_list = "List of Targets"
L.counter_start = "Counter Value"

L.global_pos = "Position Global speichern"