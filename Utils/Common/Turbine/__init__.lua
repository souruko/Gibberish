local importPath = getfenv(1)._.Name;
local commonPath = string.gsub(importPath, "%.Turbine$", "");

import (commonPath .. ".Turbine.Type");
import (commonPath .. ".Turbine.Class");
