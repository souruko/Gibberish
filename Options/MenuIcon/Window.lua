--[[
    Main MenuIcon Window
]]


Window = class( Turbine.UI.Window )

function Window:Constructor()
    Turbine.UI.Window.Constructor( self )

    self:Draw()
    self:Move()

end

---------------------------------------------------------------------------------------------------------
--public

function Window:Move()

    if optionsdata.menuicon.moving == true then

        self.MouseDown = function( sender, args )
            if args.Button == Turbine.UI.MouseButton.Left then
                self.dragging = true	
                self.dragStartX = args.X
                self.dragStartY = args.Y
            end
        end
        
        self.MouseMove = function( sender, args )
            if self.dragging then
                local x,y = self:GetPosition()	
                x = x + ( args.X - self.dragStartX )
                y = y + ( args.Y - self.dragStartY )
                
                self:SetPosition( Utils.CheckPositionStillOnScreen(x,y,self:GetWidth(), self:GetHeight()) )	
            end
        end
        
        self.MouseUp = function( sender, args )
            if args.Button == Turbine.UI.MouseButton.Left then
                self.dragging = false
                optionsdata.menuicon.left, optionsdata.menuicon.top = self:GetPosition()
                    
                SaveOptions()
            end
        end

    else

        self.MouseDown = function( sender, args )

        end
        
        self.MouseMove = function( sender, args )

        end
        
        self.MouseUp = function( sender, args )

        end

    end

end

---------------------------------------------------------------------------------------------------------
--private

function Window:ShowMenu()

    local offset = 42
    local left, top
    local s_left, s_top = self:GetPosition()
    local menu_width = 145
    local menu_height = 120

    if s_left < (SCREEN_WIDTH/2) then
        left = s_left + offset
    else
        left = s_left - menu_width 
    end

    if s_top < (SCREEN_HEIGHT/2) then
        top = s_top + offset
    else
        top = s_top - menu_height
    end

    self.menu:ShowMenuAt(left, top)

end


function Window:DrawMenu()

    self.item_options = Turbine.UI.MenuItem(  L.optionsNameHeader, true )
    self.item_reset = Turbine.UI.MenuItem( L.reset, true )
    self.item_reload = Turbine.UI.MenuItem( L.reload, true)
    self.item_collection = Turbine.UI.MenuItem( L.collectionNameHeader, true)
    self.item_movewindows = Turbine.UI.MenuItem( L.move_windows, true, optionsdata.moving )
    self.item_movemenuicon = Turbine.UI.MenuItem( L.move_menuicon, true, optionsdata.menuicon.moving )
    self.item_auto_reload = Turbine.UI.MenuItem( L.autoReload, true, savedata.automatic_reload )

    self.menu = Turbine.UI.ContextMenu()
    self.items = self.menu:GetItems()

    self.items:Add(self.item_reset)
    self.items:Add(self.item_options)
    self.items:Add(self.item_reload)
    self.items:Add(self.item_collection)
    self.items:Add(self.item_movewindows)
    self.items:Add(self.item_movemenuicon)
    self.items:Add(self.item_auto_reload)

    self.item_reset.Click = function(sender, args)
        Windows.ResetAll()
    end

    self.item_reload.Click = function(sender, args)
        Reload()
    end

    self.item_options.Click = function(sender, args)
        Options.OptionsWindow.OptionsWindowChanged()
    end

    self.item_collection.Click = function(sender, args)
        Options.Collection.CollectionStateChanged()
    end

    self.item_movewindows.Click = function(sender, args)
        Options.Move.MoveChanged(not(optionsdata.moving), nil, nil)
    end

    self.item_movemenuicon.Click = function(sender, args)
        optionsdata.menuicon.moving = not(optionsdata.menuicon.moving)
        self.item_movemenuicon:SetChecked(optionsdata.menuicon.moving)
        self:Move()
    end

    self.item_auto_reload.Click = function(sender, args)
        Options.OptionsWindow.AutoReloadChanged( not(self.item_auto_reload:IsChecked()))
    end



    self.MouseClick = function(sender, args)

        if args.Button == Turbine.UI.MouseButton.Right then
            self:ShowMenu()
        end

    end

    self.MouseEnter = function(sender, args)
        self:SetOpacity(1)
    end

    self.MouseLeave = function(sender, args)
       self:SetOpacity(0.7)
    end 

end

function Window:AutoReloadChanged()
Turbine.Shell.WriteLine(tostring(savedata.automatic_reload))
    self.item_auto_reload:SetChecked(savedata.automatic_reload)
 
end

function Window:SetIconFromTrackInformation()

    if savedata.track_target_effects == true and savedata.track_group_effects == true then
        self:SetBackground("Gibberish/Resources/g_blau_gelb.tga")

    elseif savedata.track_group_effects == true then
        self:SetBackground("Gibberish/Resources/g_blau.tga")

    elseif savedata.track_target_effects == true then
        self:SetBackground("Gibberish/Resources/g_gelb.tga")

    else
        self:SetBackground("Gibberish/Resources/g.tga")

    end

end


function Window:Draw()

    self:SetSize(50, 50)
    self:SetPosition(optionsdata.menuicon.left, optionsdata.menuicon.top)
    self:SetOpacity(0.7)
    self:SetZOrder(20)

    self:SetIconFromTrackInformation()

    self:DrawMenu()

    self:SetVisible(true)

end