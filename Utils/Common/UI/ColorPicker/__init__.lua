import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

local importPath = getfenv(1)._.Name;
local commonPath = string.gsub(importPath, "%.UI%.ColorPicker$", "");

import (commonPath .. ".Turbine");
import (commonPath .. ".Utils");
import (commonPath .. ".UI.RadioButton");
import (commonPath .. ".UI.ColorPicker.Locale");
import (commonPath .. ".UI.ColorPicker.Slider");
import (commonPath .. ".UI.ColorPicker.Palette");
import (commonPath .. ".UI.ColorPicker.SwatchBar");
import (commonPath .. ".UI.ColorPicker.ColorPicker");

if (not Thurallor.UI) then
    Thurallor.UI = {};
end
Thurallor.UI.ColorPicker = ColorPicker;
