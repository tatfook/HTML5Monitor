--[[
Title: 
Author(s):  
Date: 
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/HTML5Monitor/Helper.lua");
local Helper = commonlib.gettable("Mod.HTML5Monitor.Helper");
------------------------------------------------------------
]]
local Helper = commonlib.gettable("Mod.HTML5Monitor.Helper")

function Helper:Hello()
	_guihelper.MessageBox("hello from helper class")
end

