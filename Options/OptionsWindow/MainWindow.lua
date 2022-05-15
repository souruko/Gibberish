--[[
    Main OptionsWindow
]]

MainWindow = class( Turbine.UI.Lotro.Window )

function MainWindow:Constructor()
    Turbine.UI.Lotro.Window.Constructor( self )

    self:Build()

    self:WindowSelectionChanged()

end

---------------------------------------------------------------------------------------------------------
--public

function MainWindow:CollectionChanged()

    if self.timeredit_window ~= nil then
        self.timeredit_window:CollectionChanged()
    end

end

function MainWindow:OptionsWindowTimerEditClose()

    if self.timeredit_window ~= nil then
        self.timeredit_window:Close()
        self.timeredit_window = nil
    end


end

function MainWindow:TimerDeleted()

    self.timer_selection:TimerDeleted()

end

function MainWindow:OpenTimerEdit(window_index, timer_type, timer_index)

    if self.timeredit_window == nil then
        self.timeredit_window = TimerEdit.Window(self)
    end

    self.timeredit_window:SetContent(window_index, timer_type, timer_index)

    optionsdata.timer_edit.window_index = window_index
    optionsdata.timer_edit.timer_type = timer_type
    optionsdata.timer_edit.timer_index = timer_index

    optionsdata.timer_edit.open = true

    SaveOptions()

end

function MainWindow:TimerEditClicked(timer_type, timer_index)

    self:OpenTimerEdit(G.selected_index_window, timer_type, timer_index)

end

function MainWindow:DeleteTimerClicked(timer_type, timer_index)

    local text = L.confirmationText..savedata[G.selected_index_window][timer_type][timer_index].token.."</rgb>"
    self.confirmation_window:SetContent(3, text, timer_index, timer_type)
    self.confirmation_window:SetVisible(true)
    self.veil:SetVisible(true)

end

function MainWindow:DeleteWindowClicked(index)

    local text = L.confirmationText..savedata[index].name.."</rgb>"
    self.confirmation_window:SetContent(1, text, index, nil)
    self.confirmation_window:SetVisible(true)
    self.veil:SetVisible(true)

end

function MainWindow:DeleteGroupClicked(index)

    local text = L.confirmationText..savedata.groups[index].name.."</rgb>"
    self.confirmation_window:SetContent(2, text, index, nil)
    self.confirmation_window:SetVisible(true)
    self.veil:SetVisible(true)

end

function MainWindow:ConfirmationWindow_Close()

    self.confirmation_window:SetVisible(false)
    self.veil:SetVisible(false)

end


function MainWindow:WindowSelectionChanged()

    self.window_selection:WindowSelectionChanged()
    self.timer_selection:WindowSelectionChanged()

    self.window_settings:WindowSelectionChanged()

end

function MainWindow:GroupLoadStatusChanged(index)

    self.window_selection:GroupLoadStatusChanged(index)

end

function MainWindow:AddNewWindow()

    self.add_window:ResetContent()
    self.add_window:SetVisible(true)
    self.veil:SetVisible(true)

end

function MainWindow:AddNewWindow_Close()

    self.add_window:SetVisible(false)
    self.veil:SetVisible(false)

end



function MainWindow:AddNewGroup()

    self.add_group:ResetContent()
    self.add_group:SetVisible(true)
    self.veil:SetVisible(true)

end

function MainWindow:EditGroup(index)

    self.add_group:EditWindowState(index)
    self.add_group:SetVisible(true)
    self.veil:SetVisible(true)

end


function MainWindow:AddNewGroup_Close()

    self.add_group:SetVisible(false)
    self.veil:SetVisible(false)

end


function MainWindow:WindowAdded()

    self.window_selection:CreateListControls()

end

function MainWindow:GroupAdded(index)

    self.window_selection:CreateListControls()

end

function MainWindow:GroupEdited(index)

    self.window_selection:GroupEdited(index)

end

function MainWindow:GroupSetupChanged()

    self.window_selection:CreateListControls()

end

function MainWindow:UpdateTimerItem(window_index, timer_type, timer_index)

    self.timer_selection:UpdateTimerItem(window_index, timer_type, timer_index)

end

---------------------------------------------------------------------------------------------------------
--private



function MainWindow:Build()

    local window_selection_width = 200
    local spacer = 10

    local width = math.max(optionsdata.options_window.width, OPTIONS_MAINWINDOW_WIDTH)
    local height = math.max(optionsdata.options_window.height, OPTIONS_MAINWINDOW_HEIGHT)

    self.veil = Turbine.UI.Window()
    self.veil:SetParent(self)
    self.veil:SetPosition(SPACER, TOP_SPACER)
    self.veil:SetSize(width - (2* SPACER), height - SPACER - TOP_SPACER)
    self.veil:SetBackColor(Turbine.UI.Color.Black)
    self.veil:SetOpacity(0.7)
    self.veil:SetZOrder(10)
    
    self:SetPosition(optionsdata.options_window.left, optionsdata.options_window.top)
    self:SetText(L.gibberish)
    self:SetResizable(true)
    self:SetMinimumSize(OPTIONS_MAINWINDOW_WIDTH, OPTIONS_MAINWINDOW_HEIGHT)
    self:SetMaximumWidth(OPTIONS_MAINWINDOW_WIDTH)
    self:SetZOrder(13)
    
    self.add_window = AddWindow(self.veil)
    self.add_group = AddGroup(self.veil)
    self.confirmation_window = ConfirmationWindow(self.veil)
    
    self.timeredit_window = nil
    
    self.window_selection = WindowSelection.Window(self)
    self.timer_selection = TimerSelection.Window(self)
    
    self.window_settings = WindowSettings(self)
    self.general_options = GeneralOptions(self)
    
    self:SetWantsKeyEvents(true)
    self:SetSize(width, height)
    self:SetVisible(true)

end

function MainWindow.KeyDown(sender, args)

    if optionsWindow ~= nil then
        if args.Action == 145 then
            OptionsWindowChanged()
        end
    end

end

function MainWindow:SizeChanged()

    width, height = self:GetSize()

    self.veil:SetSize(width - (2* SPACER), height - SPACER - TOP_SPACER)

    self.window_selection:Resize()
    self.timer_selection:Resize()
    self.window_settings:Resize()
    self.general_options:Resize()

    optionsdata.options_window.width, optionsdata.options_window.height = self:GetSize()
    SaveOptions()

end

function MainWindow:PositionChanged()

    optionsdata.options_window.left, optionsdata.options_window.top = self:GetPosition()
    SaveOptions()

end

function MainWindow:Closed()

    if self.timeredit_window ~= nil then
        self.timeredit_window:Close()
    end
    Options.Import.WindowStateChanged(false)
    OptionsWindowCloseFix()
    optionsdata.timer_edit.open = false
    SaveOptions()

end
