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
OPTIONS_MAINWINDOW_HEIGHT = 800
OPTIONS_TIMEREDIT_HEIGHT = 640

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


GREY = {}

GREY[60] = 1090551408
GREY[59] = 1090551407
GREY[58] = 1090551406
GREY[57] = 1090551405
GREY[56] = 1090551404
GREY[55] = 1090551403
GREY[54] = 1090551402
GREY[53] = 1090551401
GREY[52] = 1090551400
GREY[51] = 1090551399
GREY[50] = 1090551398

GREY[49] = 1090551397
GREY[48] = 1090551396
GREY[47] = 1090551395
GREY[46] = 1090551394
GREY[45] = 1090551393
GREY[44] = 1090551392
GREY[43] = 1090551391
GREY[42] = 1090551390
GREY[41] = 1090551389
GREY[40] = 1090551388

GREY[39] = 1090551387
GREY[38] = 1090551386
GREY[37] = 1090551385
GREY[36] = 1090551384
GREY[35] = 1090551383
GREY[34] = 1090551382
GREY[33] = 1090551381
GREY[32] = 1090551380
GREY[31] = 1090551379
GREY[30] = 1090551378

GREY[29] = 1090551377
GREY[28] = 1090551376
GREY[27] = 1090551375
GREY[26] = 1090551374
GREY[25] = 1090551373
GREY[24] = 1090551372
GREY[23] = 1090551371
GREY[22] = 1090551370
GREY[21] = 1090551369
GREY[20] = 1090551368

GREY[19] = 1090551367
GREY[18] = 1090551366
GREY[17] = 1090551365
GREY[16] = 1090551364
GREY[15] = 1090551363
GREY[14] = 1090551362
GREY[13] = 1090551361
GREY[12] = 1090551360
GREY[11] = 1090551359
GREY[10] = 1090551358

GREY[9] = 1090551357
GREY[8] = 1090551356
GREY[7] = 1090551355
GREY[6] = 1090551354
GREY[5] = 1090551353
GREY[4] = 1090551352
GREY[3] = 1090551351
GREY[2] = 1090551350
GREY[1] = 1090551349
