
command = Turbine.ShellCommand()

function command:Execute( _, str )
    if str == nil or string.len( str ) == 0 then
        Turbine.Shell.WriteLine( "Missing Argument (reset | reload | move).")
        return
    end

    local list  = { }
    local index = 1

    for word in str:gmatch( "%w+" ) do
        list[ index ] = word
        index = index + 1
    end

    local cmd = string.lower( list[ 1 ] )

    if cmd == "options" then
        Options.OptionsWindow.OptionsWindowChanged()
    elseif cmd == "reload" then
        Reload()
    elseif cmd == "reset" then
        Windows.ResetAll()
    elseif cmd == "collection" then
        Options.Collection.CollectionStateChanged()
    elseif cmd == "move" then
        Options.Move.MoveChanged(not(optionsdata.moving), nil, nil)
    end

end


Turbine.Shell.AddCommand( "gibberish", command )
Turbine.Shell.AddCommand( "g", command )