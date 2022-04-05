--[[
    OptionsWindow child for general settings (bottom right)
]]

GeneralOptions = class( Turbine.UI.Control )

function GeneralOptions:Constructor(parent)
    Turbine.UI.Control.Constructor( self )

    self.parent = parent

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function GeneralOptions:Resize()

    self:SetPosition(SPACER + WINDOWSELECTION_WIDTH + SPACER + WINDOWSELECTION_WIDTH + SPACER, optionsdata.options_window.height - SPACER - 100)

end

---------------------------------------------------------------------------------------------------------
--private

function GeneralOptions:Build()

    local width = optionsdata.options_window.width - (SPACER + WINDOWSELECTION_WIDTH + SPACER + WINDOWSELECTION_WIDTH + SPACER + SPACER)


    self:SetParent(self.parent)
    self:SetSize(width, 100)
    self:SetBackColor(COLOR_LIGHT_GRAY)

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetFont(OPTIONS_FONT)
    self.header:SetHeight(TOP_BAR + FRAME)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.header:SetText(L.GeneralOptionsHeader)
    self.header:SetMouseVisible(false)
    self.header:SetWidth(width)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Turbine.UI.Color.Black)
    self.background:SetPosition(FRAME, TOP_BAR + FRAME)
    self.background:SetSize(width - (2*FRAME), 100 - TOP_BAR - (2*FRAME))

    local row1 = 2*FRAME
    local row2 = 2*FRAME + 25

    local collumn1 = FRAME
    local collumn2 = 110
    local collumn3 = 230

    self.import_button = Turbine.UI.Lotro.Button()
    self.import_button:SetParent(self.background)
    self.import_button:SetSize(80,20)
    self.import_button:SetPosition(collumn1, row1)
    self.import_button:SetText(L.import)
    self.import_button:SetVisible(true)
    self.import_button.MouseClick = function()
        Options.Import.WindowStateChanged(true)
        Options.Import.Import()
    end

    self.export_button = Turbine.UI.Lotro.Button()
    self.export_button:SetParent(self.background)
    self.export_button:SetSize(80,20)
    self.export_button:SetPosition(collumn1, row2)
    self.export_button:SetText(L.export)
    self.export_button:SetVisible(true)
    self.export_button.MouseClick = function()
        if G.selected_index_window ~= nil then
            Options.Import.WindowStateChanged(true)
            Options.Import.ExportWindow(savedata[G.selected_index_window])
        end
    end

    self.track_group_lb = Turbine.UI.Label()
    self.track_group_lb:SetParent(self.background)
    self.track_group_lb:SetFont(OPTIONS_FONT)
    self.track_group_lb:SetSize(100, 20)
    self.track_group_lb:SetPosition(collumn2, row1)
    self.track_group_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.track_group_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.track_group_lb:SetText(L.trackGroup)

    self.track_group_cb =  Turbine.UI.Lotro.CheckBox()
	self.track_group_cb:SetParent(self.background)
    self.track_group_cb:SetSize(120, 20)
    self.track_group_cb:SetFont(OPTIONS_FONT)
    self.track_group_cb:SetText("")
    self.track_group_cb:SetPosition(collumn2 + 90, row1)
    self.track_group_cb:SetChecked(savedata.track_group_effects)
    self.track_group_cb.CheckedChanged = function()
        
        TrackGroupChanged(self.track_group_cb:IsChecked())
        SaveWindowData()

    end



    self.track_target_lb = Turbine.UI.Label()
    self.track_target_lb:SetParent(self.background)
    self.track_target_lb:SetFont(OPTIONS_FONT)
    self.track_target_lb:SetSize(100, 20)
    self.track_target_lb:SetPosition(collumn2, row2)
    self.track_target_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.track_target_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.track_target_lb:SetText(L.trackTarget)


    self.track_target_cb =  Turbine.UI.Lotro.CheckBox()
	self.track_target_cb:SetParent(self.background)
    self.track_target_cb:SetSize(120, 20)
    self.track_target_cb:SetFont(OPTIONS_FONT)
    self.track_target_cb:SetText("")
    self.track_target_cb:SetPosition(collumn2 + 90, row2)
    self.track_target_cb:SetChecked(savedata.track_target_effects)
    self.track_target_cb.CheckedChanged = function()

        TrackTargetChanged(self.track_target_cb:IsChecked())
        SaveWindowData()

    end


    self.auto_reload_lb = Turbine.UI.Label()
    self.auto_reload_lb:SetParent(self.background)
    self.auto_reload_lb:SetFont(OPTIONS_FONT)
    self.auto_reload_lb:SetSize(100, 20)
    self.auto_reload_lb:SetPosition(collumn3, row1)
    self.auto_reload_lb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.auto_reload_lb:SetFontStyle(Turbine.UI.FontStyle.Outline)
    self.auto_reload_lb:SetText(L.autoReload)


    self.auto_reload_cb =  Turbine.UI.Lotro.CheckBox()
	self.auto_reload_cb:SetParent(self.background)
    self.auto_reload_cb:SetSize(20, 20)
    self.auto_reload_cb:SetFont(OPTIONS_FONT)
    self.auto_reload_cb:SetText("")
    self.auto_reload_cb:SetPosition(collumn3 + 100, row1)
    self.auto_reload_cb:SetChecked(savedata.automatic_reload)
    self.auto_reload_cb.CheckedChanged = function()

        AutoReloadChanged(self.auto_reload_cb:IsChecked())

    end


    self.reload_button = Turbine.UI.Lotro.Button()
    self.reload_button:SetParent(self.background)
    self.reload_button:SetSize(80,20)
    self.reload_button:SetPosition(collumn3 + 40, row2)
    self.reload_button:SetText(L.reload)
    self.reload_button:SetVisible(true)
    self.reload_button.MouseClick = function()

        Reload()

    end

    self:Resize()

    self:SetVisible(true)

end