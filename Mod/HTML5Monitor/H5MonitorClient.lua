--[[
Title: H5MonitorClient
Author(s): leio  
Date: 2016/7/20
Revised: MarxWolf 2016/07/23
Desc: 
use the lib:
------------------------------------------------------------
This is a program not a library. 
It should be used with H5MonitorServer together.
User can self define the size of the screenShot image in H5MonitorClient.GetScreenShotInfo().
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/commonlib.lua"); 
NPL.load("(gl)script/ide/timer.lua");

local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";
local filepath = "temp/monitor_screenshot.png";
H5MonitorClient.handle_msgs = nil;
local nid = "stu1";

function H5MonitorClient.AddPublicFiles()
    NPL.AddPublicFile(client_file, 7001);
    NPL.AddPublicFile(server_file, 7002);
end

-- connect a server
function H5MonitorClient.Start(host,port)
    H5MonitorClient.AddPublicFiles();
   
	host= host or "127.0.0.1";
	port = port or "60001";
	
	host = tostring(host);
	port = tostring(port);
	local params = {host = host, port = port, nid = nid};
	NPL.AddNPLRuntimeAddress(params);
	H5MonitorClient.Send({},true);
	--H5MonitorClient.handle_msgs = { client_connected = true };
    LOG.std(nil, "info", "H5MonitorClient", "Connect host:%s port: %s",host,port);
end

-- async get screenShot data encoded by base64
function H5MonitorClient.Callback()
	--commonlib.log("TestTakeScreenShot received a msg %s \n",commonlib.serialize(msg));
	local res = msg.res;
	local sequence = msg.s;
	local size = msg.size;
	H5MonitorClient.screenShotData = msg.base64;
end

function H5MonitorClient.Stop()
	
end

function H5MonitorClient.Send(msg,is_first)
	if(not is_first)then
		msg.nid = nid;
	end
	local res = NPL.activate(string.format("(%s)%s:%s", "gl",nid,server_file), msg);
	--LOG.std(nil, "info", "H5MonitorClient", "res:%s",tostring(res));
	return res;
end


function H5MonitorClient.GetHandleMsg()
	return H5MonitorClient.handle_msgs;
end


function H5MonitorClient.StartLocalWebServer(host,port)
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", (host or "0.0.0.0"), port or 8091);
end

-- get screenShot
function H5MonitorClient.TakeScreenShot(width,height)
	width = tonumber(width);
	height = tonumber(height);
	if(width and height)then
		ParaMovie.TakeScreenShot_Async(filepath ,true,  width, height, string.format("Mod.HTML5Monitor.H5MonitorClient.Callback();%d",1));
	else
		ParaMovie.TakeScreenShot_Async(filepath,true,  -1, -1, string.format("Mod.HTML5Monitor.H5MonitorClient.Callback();%d",1));
	end
end

-- client side, to read screenShot info from the msgs transmit by server, width & height can be user defined
function H5MonitorClient.GetScreenShotInfo()
	local serverMsgs = H5MonitorClient.GetHandleMsg();
	local width, height = 256, 256;
	if(serverMsgs) then
		if(serverMsgs.width) then
			width = serverMsgs.width;
			height = serverMsgs.height;
		end
	end
	LOG.std(nil, "info","client GetScreenShotInfo", "width:%s, height:%s ", width, height);
	return width, height;
end

-- client side, to get screenShot data, and it will return a table {"screenShotData":screenShotData}
function H5MonitorClient.GetScreenShot()
	local width, height = H5MonitorClient.GetScreenShotInfo();
	H5MonitorClient.TakeScreenShot(width,height);
	local screenShot = {screenShotData = H5MonitorClient.screenShotData};
	return screenShot;
end

-- client side, when get screenShot info from server, send screenShotData to server
-- now send msg timer is 750 ms, it can be reset.
-- connection test timer is set to 20000 ms
function H5MonitorClient.Response()
	if(H5MonitorClient.clientSendTimer) then return end;
	H5MonitorClient.clientSendTimer = commonlib.Timer:new({callbackFunc = function(timer)
			local screenShotData = H5MonitorClient.GetScreenShot();
			H5MonitorClient.sendStatus = H5MonitorClient.Send(screenShotData);
	end})
	H5MonitorClient.clientSendTimer:Change(0,750);
	H5MonitorClient.connectionTimer = commonlib.Timer:new({callbackFunc = function(timer)
		LOG.std(nil, "info", "H5MonitorClient", "ping connection");
		H5MonitorClient.handle_msgs = {};
		H5MonitorClient.Send({ping = true});
		commonlib.TimerManager.SetTimeout(function()
			local isConnection = H5MonitorClient.GetHandleMsg();
			if(isConnection.pingSuccess) then
			else
				H5MonitorClient.clientSendTimer:Change();
				H5MonitorClient.connectionTimer:Change();
			end
		end, 1000);
	end})
	H5MonitorClient.connectionTimer:Change(0, 20000);

end

-- test if connected after connecting before sending
function H5MonitorClient.Ping() 
	H5MonitorClient.clientPingTimer = commonlib.Timer:new({callbackFunc = function(timer)
		local clientStatus = H5MonitorClient.GetHandleMsg();
		H5MonitorClient.Send({ping = true});
		if(clientStatus) then
			if(clientStatus.pingSuccess) then
				H5MonitorClient.clientPingTimer:Change();
			end
		else
			commonlib.TimerManager.SetTimeout(function()
				H5MonitorClient.clientPingTimer:Change();
			end, 1000);
		end
	end})
	H5MonitorClient.clientPingTimer:Change(0, 100);
end

local function activate()
	if(msg)then
		--LOG.std(nil, "info", "H5MonitorClient", "got a message");
		NPL.accept(msg.tid, nid);
		H5MonitorClient.handle_msgs = msg;
		if(msg.pingSuccess or (msg.width and msg.height)) then
			H5MonitorClient.Response();
		elseif (msg.ping) then
			H5MonitorClient.Send({pingSuccess = true});
			--LOG.std(nil, "info","client", "server ping status: %s" , tostring(msg.ping));
		end
	end
end
NPL.this(activate)