
if G.language == 1 then
    import "Souru.Gibberish.Utils.Localisation.en"
elseif G.language == 2 then
    import "Souru.Gibberish.Utils.Localisation.de"
elseif G.language == 3 then
    import "Souru.Gibberish.Utils.Localisation.fr"
else
    Turbine.Shell.WriteLine("ERROR: Client G.language not found!")
end