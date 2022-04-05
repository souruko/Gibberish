G = {}

-- find used client G.language
G.language = 1
if Turbine.Shell.IsCommand("hilfe") then
    G.language = 2
elseif Turbine.Shell.IsCommand("aide") then
    G.language = 3
end


SCREEN_WIDTH , SCREEN_HEIGHT = Turbine.UI.Display:GetSize()


-- so i can use G.language as a number
LANGUAGE = {}
LANGUAGE.English = 1
LANGUAGE.German  = 2
LANGUAGE.French  = 3


-- localisation variable
L = {}


-- table with all save information (windows ...)
savedata = {}
savedata.groups = {}
savedata.deletedWindows = {}
savedata.deletedGroups = {}

optionsdata = {}
optionsdata.menuicon = {}
optionsdata.move = {}
optionsdata.options_window = {}
optionsdata.timer_edit = {}
optionsdata.collection = {}
optionsdata.import = {}

-- table with all build / activ windows
windows = {}


-- number to seperate different timers from the same trigger in chat
chatcount = 1


-- timer text modifier
TEXTMODIFIER = {}
TEXTMODIFIER.No_Text = 1
TEXTMODIFIER.Token = 2
TEXTMODIFIER.Custom_Text = 3
TEXTMODIFIER.Let_the_plugin_decide = 4


-- window typs
WINDOW_TYPE = {}

WINDOW_TYPE.Bar_ListBox = 1
WINDOW_TYPE.Bar_Window = 2
WINDOW_TYPE.Icon_ListBox = 3
WINDOW_TYPE.Icon_Window = 4
WINDOW_TYPE.Count_Down = 5

-- trigger type
TRIGGER_TYPE = {}

TRIGGER_TYPE.Effect_Self = 1
TRIGGER_TYPE.Effect_Group = 2
TRIGGER_TYPE.Effect_Target = 3
TRIGGER_TYPE.Chat = 4
TRIGGER_TYPE.Skill = 5
TRIGGER_TYPE.Timer_End = 6
TRIGGER_TYPE.Timer_Start = 7
TRIGGER_TYPE.Timer_Threshold = 8
TRIGGER_TYPE.short = {}

ORIENTATION = {}
ORIENTATION.Horizontal = true
ORIENTATION.Vertical = false

ASCENDING = {}
ASCENDING.Ascending = true
ASCENDING.Descending = false

NUMBER_FORMAT = {}
NUMBER_FORMAT[1] = "0"
NUMBER_FORMAT[2] = "00:00"

NUMBER_FORMAT.Seconds = 1
NUMBER_FORMAT.Minutes = 2

--Localplayer
LOCALPLAYER = Turbine.Gameplay.LocalPlayer:GetInstance()

--Options
optionsWindow = nil

moveWindow = nil

menuicon = nil

collectionWindow = nil

importWindow = nil

--OPTONS CONSTS

OPTIONS_FONT = Turbine.UI.Lotro.Font.Verdana14
COLOR_DARK_GRAY = Turbine.UI.Color(0.15, 0.15, 0.15)
COLOR_VERY_DARK_GRAY = Turbine.UI.Color(0.1,0.1,0.1)
COLOR_GRAY = Turbine.UI.Color(0.3, 0.3, 0.3)
COLOR_LIGHT_GRAY = Turbine.UI.Color(0.4, 0.4, 0.4)
COLOR_VERY_LIGHT_GRAY = Turbine.UI.Color(0.5, 0.5, 0.5)
OPTIONS_MAINWINDOW_WIDTH = 910
OPTIONS_MAINWINDOW_HEIGHT = 750
OPTIONS_TIMEREDIT_HEIGHT = 460

WINDOWSELECTION_WIDTH = 250
TIMERSELECTION_WIDTH = 250
WINDOW_SETTINGS_HEIGHT = 550
FRAME = 5
SPACER = 10
TOP_SPACER = 40
TOP_BAR = 25
SEARCH_HEIGHT = 25
COLLAPSE_SIZE = 15


--COLLECTION
collectEffects = false
collectChat = false
only_debuffs = false
only_say = false

collectiondata = {}
collectiontemp = {}
collectiontemp.effects = {}
collectiontemp.chat = {}

G.selected_index_window = nil

list_of_skills = LOCALPLAYER:GetTrainedSkills()

color_picker = nil