--[[
Title: 
Author(s):  
Date: 
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/HTML5Monitor/main.lua");
local FirstApp = commonlib.gettable("Mod.HTML5Monitor");
------------------------------------------------------------
]]
NPL.load("(gl)Mod/HTML5Monitor/Helper.lua");
local Helper = commonlib.gettable("Mod.HTML5Monitor.Helper");
local HTML5Monitor = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.HTML5Monitor"));

function HTML5Monitor:ctor()
	
end

-- virtual function get mod name
function HTML5Monitor:GetName()
	return "HTML5Monitor"
end

-- virtual function get mod description 

function HTML5Monitor:GetDesc()
	return "HTML5Monitor is a plugin in paracraft"
end

function HTML5Monitor:init()
	LOG.std(nil, "info", "HTML5Monitor", "plugin initialized");
end

function HTML5Monitor:OnLogin()
end
-- called when a new world is loaded. 

function HTML5Monitor:OnWorldLoad() 
    Helper:Hello();
end

-- called when a world is unloaded. 
function HTML5Monitor:OnLeaveWorld()
end

function HTML5Monitor:OnDestroy()
end
