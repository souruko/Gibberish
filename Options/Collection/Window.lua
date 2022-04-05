--[[
    Main Collection Window
]]

Window = class( Turbine.UI.Lotro.Window )

function Window:Constructor(parent)
    Turbine.UI.Lotro.Window.Constructor( self )

    self.parent = parent

    self:Build()

end

---------------------------------------------------------------------------------------------------------
--public

function Window:SearchChanged(searchText)

    self.collection:SearchChanged(searchText)
    self.library:SearchChanged(searchText)

end

function Window:CollectionChanged()

    self.collection:CollectionChanged()

end

 function Window:LibraryChanged()

    self.library:LibraryChanged()

 end


---------------------------------------------------------------------------------------------------------
--private

function Window:Build()

    self:SetPosition(optionsdata.collection.left, optionsdata.collection.top)
    self:SetResizable(true)
    self:SetMinimumSize(optionsdata.collection.width, 295)
    self:SetMaximumWidth(optionsdata.collection.width)
    self:SetText(L.collectionNameHeader)
    self:SetZOrder(13)
    
    self.tracking_window = TrackingWindow(self)
    self.collection = Collection(self)
    self.library = Library(self)
    
    self:SetSize(optionsdata.collection.width, optionsdata.collection.height)
    self:SetVisible(true)
    
    self:SetWantsKeyEvents(true)


end

function Window:SizeChanged()

    self.tracking_window:Resize(self:GetHeight())
    self.collection:Resize(self:GetHeight())
    self.library:Resize(self:GetHeight())

    optionsdata.collection.width, optionsdata.collection.height = self:GetSize()
    SaveOptions()

end

function Window:PositionChanged()

    optionsdata.collection.left, optionsdata.collection.top = self:GetPosition()
    SaveOptions()

end

function Window:Closed()

    optionsdata.collection.open = false
    CollectionCloseFix()
    SaveOptions()

end


function Window.KeyDown(sender, args)

    if collectionWindow ~= nil then
        if args.Action == 145 then
            CollectionStateChanged()
            
        end
    end

end