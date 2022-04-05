import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

local importPath = getfenv(1)._.Name;
local commonPath = string.gsub(importPath, "%.Utils$", "");

import (commonPath .. ".Turbine");
import (commonPath .. ".Utils.Utils");
import (commonPath .. ".Utils.Locale");
import (commonPath .. ".Utils.Color");

Thurallor.Utils = {};
Thurallor.Utils.Locale = Locale;
Thurallor.Utils.Color = Color;
