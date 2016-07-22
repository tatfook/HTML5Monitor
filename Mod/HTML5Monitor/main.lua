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
NPL.load("(gl)script/ide/commonlib.lua");
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

function HTML5Monitor:StartTestServer()
	NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
	local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
	H5MonitorServer.AddPublicFiles();

	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", "0.0.0.0", 8092);
	ParaGlobal.ShellExecute("open", "http://localhost:8092/H5MonitorServer", "", "", 1);
	LOG.std(nil, "info", "html5 monitor server started", "");
end

function HTML5Monitor:StartTestClient(nClientId)
	NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
	local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
	H5MonitorClient.AddPublicFiles();

	nClientId = nClientId or 0;
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	local port = 8099+nClientId;
	WebServer:Start("script/apps/WebServer/admin", "0.0.0.0", 8099+nClientId);
	ParaGlobal.ShellExecute("open", "http://localhost:"..port.."/H5MonitorClient", "", "", 1);
	LOG.std(nil, "info", "html5 monitor client started", "");
end

local isStarted;
NPL.this(function()
	if(isStarted) then
		return
	end
	isStarted = true;
	local type = ParaEngine.GetAppCommandLineByParam("type", "client");
	if(type == "server") then
		HTML5Monitor:StartTestServer();
	else
		local nClientId = tonumber(type:match("%d") or 0);
		HTML5Monitor:StartTestClient(nClientId);
	end
end);