--[[
Title: H5MonitorClient
Author(s): leio  
Date: 2016/7/20
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.StartLocalWebServer();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.Start();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.Send({"hello world"});
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/commonlib.lua"); 
NPL.load("(gl)script/ide/timer.lua");
NPL.load("(gl)script/ide/System/Encoding/base64.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
local Encoding = commonlib.gettable("System.Encoding");
local rts_name = "h5monitor_worker";
local nid = "h5monitorserver";
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";
H5MonitorClient.handle_msgs = nil;
local imageFile = "temp/monitor_screenshot.png";
local is_login = false;
function H5MonitorClient.AddPublicFiles()
    NPL.AddPublicFile(client_file, 7001);
    NPL.AddPublicFile(server_file, 7002);
end

function H5MonitorClient.Start(host,port)
    H5MonitorClient.AddPublicFiles();
   -- since this is a pure client, no need to listen to any port. 
   -- NPL.StartNetServer("0", "0");
   
	host= host or "127.0.0.1";
	port = port or "60001";
	
	host = tostring(host);
	port = tostring(port);

	local params = {host = host, port = port, nid = nid};
	-- add the server address
	NPL.AddNPLRuntimeAddress(params);
	H5MonitorClient.Send({},true)
	H5MonitorClient.handle_msgs = { client_connected = true };
    LOG.std(nil, "info", "H5MonitorClient", "Connect host:%s port: %s",host,port);
end
function H5MonitorClient.Stop()
end
function H5MonitorClient.Send(msg,is_first)
	if(not is_first)then
		msg.nid = nid;
	end
	local res = NPL.activate(string.format("(%s)%s:%s", "gl",nid,server_file), msg);
	LOG.std(nil, "info", "H5MonitorClient", "res:%s",tostring(res));
	return res;
end


function H5MonitorClient.GetHandleMsg()
	return H5MonitorClient.handle_msgs;
end


function H5MonitorClient.StartLocalWebServer(host,port)
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", (host or "0.0.0.0"), port or 8091);
end

function H5MonitorClient.TakeScreenShot(width,height)
	width = tonumber(width);
	height = tonumber(height);
	-- ParaEngine.ForceRender();ParaEngine.ForceRender();
	if(width and height)then
		ParaMovie.TakeScreenShot(imageFile,width,height);
	else
		ParaMovie.TakeScreenShot(imageFile);
	end
	local imageObj = ParaIO.open(imageFile, "r");
	local imageData = imageObj:GetText(0, -1);
	imageObj:close();
	return imageData
end

-- client side, to read image info from the msgs transmit by server
function H5MonitorClient.GetScreenShotInfo()
	local serverMsgs = H5MonitorClient.GetHandleMsg();
	local width, height = 256, 256;
	if(serverMsgs) then
		if(serverMsgs.width) then
			width = serverMsgs.width;
			height = serverMsgs.height;
		end
	end
	LOG.std(nil, "info", "GetScreenShotInfo", "width:%s, height:%s ", width, height);
	return width, height;
end

-- client side, to get image data, and it will return a table {"imageData":imageData}
function H5MonitorClient.GetScreenShot()
	local width, height = H5MonitorClient.GetScreenShotInfo();
	local imageData = H5MonitorClient.TakeScreenShot(width,height);
	local imageData = Encoding.base64(imageData);
	local image = {imageData = imageData};
	return image
end

-- client side, when get image info from server, send imageData to server
function H5MonitorClient.Response()
	local clientSendTimer = commonlib.Timer:new({callbackFunc = function(timer)
			local imageData = H5MonitorClient.GetScreenShot();
			H5MonitorClient.Send(imageData);
	end})
	clientSendTimer:Change(0,3000);
end

function H5MonitorClient.Ping() 
	local clientPingTimer;
	clientPingTimer = commonlib.Timer:new({callbackFunc = function(timer)
		local clientStatus = H5MonitorClient.GetHandleMsg();
		H5MonitorClient.Send({ping = true});
		LOG.std(nil, "info", "status","client ping status: %s" ,tostring(clientStatus.pingSuccess));
		if(clientStatus.pingSuccess) then
			clientPingTimer:Change();
		end
	end})
	clientPingTimer:Change(0, 500);
end

local function activate()
	if(msg)then
		H5MonitorClient.handle_msgs = msg;
		if(msg.width and msg.height) then
			H5MonitorClient.Response();
		elseif (msg.ping) then
			H5MonitorClient.Send({pingSuccess = true});
			LOG.std(nil, "info","client side", "server ping status: %s" , tostring(msg.ping));
		end
		LOG.std(nil, "info", "H5MonitorClient", "got a message");
	end
end
NPL.this(activate)