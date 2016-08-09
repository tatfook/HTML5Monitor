--[[
Title: H5MonitorServer
Author(s): leio  
Date: 2016/7/20
Revised: MarxWolf 2016/07/23
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.StartLocalWebServer();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.Start();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.Send({"hello world 111"});
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/commonlib.lua"); 
NPL.load("(gl)script/ide/timer.lua");

local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
local rts_name = "h5monitor_worker";
-- local nid = H5MonitorServer.GetNid();
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";
local table_insert = table.insert;
H5MonitorServer.handle_msgs = nil;
H5MonitorServer.handle_msgsIP = nil;
H5MonitorServer.msgQueue = {};
H5MonitorServer.IPQueue = {};
H5MonitorServer.nidQueue = {};

function H5MonitorServer.AddPublicFiles()
    NPL.AddPublicFile(client_file, 7001);
    NPL.AddPublicFile(server_file, 7002);
end

-- clousre to make an unique nid
function H5MonitorServer.GetNid()
	local i = 0
	return function()
		i = i + 1;
		local nid = "student" .. i
		return nid;
	end
end

local getnid = H5MonitorServer.GetNid();
local nid;

function H5MonitorServer.Start(host,port)
    H5MonitorServer.AddPublicFiles();
	host= host or "127.0.0.1";
	port = port or "60001";
	
	host = tostring(host);
	port = tostring(port);
	nid = getnid();
	H5MonitorServer.GetIPQueue(host);
	H5MonitorServer.GetNidQueue(nid);
	local params = {host = host, port = port, nid = nid};
	-- add the server address
	NPL.AddNPLRuntimeAddress(params);
	H5MonitorServer.Send({},true)
	LOG.std(nil, "info", "H5MonitorServer", "Connect host:%s port:%s",host,port);

	H5MonitorServer.handle_msgs = { server_started = true };
end
function H5MonitorServer.Stop()

end
function H5MonitorServer.Send(msg, usernid)
	local nid = usernid or msg.nid or msg.tid or nid;
	local res = NPL.activate(string.format("%s:%s", nid, client_file), msg);
	LOG.std(nil, "info", "H5MonitorServer", "res:%s",tostring(res));
	return res;
end

function H5MonitorServer.GetHandleMsg()
	return H5MonitorServer.handle_msgs, H5MonitorServer.handle_msgsIP;
end

function H5MonitorServer.GetIP()
	local remoteIP = NPL.GetIP(msg.nid or msg.tid or nid);
	if(remoteIP ~= "") then
		return remoteIP;
	else
		return nil;
	end
end

-- @param: is_large, to save bandwidth and time, usually set small size image(nil parameter), when necessary, set large size
function H5MonitorServer.SetScreenShotInfo(is_large, usernid)
	local width, height = 256, 256;
	if (is_large) then
		width = 400;  -- need to be replaced by the screen info
		height = 400; 
	end
	local imageInfo = {width = width, height = height};
	LOG.std(nil, "info", "server SetScreenShotInfo" ,"width:%s, height: %s", width, height);
	H5MonitorServer.Send(imageInfo, usernid);
end

-- server side, when receive image info request from client, send image info to client
function H5MonitorServer.Response()
	
end

function H5MonitorServer.GetIPQueue(ip)
	table_insert(H5MonitorServer.IPQueue, ip);
end

function H5MonitorServer.GetNidQueue(nid)
	table_insert(H5MonitorServer.nidQueue, nid);
end

-- get msg queue every specific time interval(now is 100ms) and index the imageData using IP
function H5MonitorServer.GetMsgQueue()
	local getMsgQueueTimer;
	getMsgQueueTimer = commonlib.Timer:new({callbackFunc = function(timer)
		local msgs, msgsIP = H5MonitorServer.GetHandleMsg();
		local contain = H5MonitorServer.msgQueue[msgsIP];
		if(not contatin and msgs.imageData) then
			H5MonitorServer.msgQueue[msgsIP] = msgs.imageData;
		end
	end})
	-- time interval need to be thought again.
	getMsgQueueTimer:Change(0,100);
end

-- sort msg queue according to their connection order using IP queue
function H5MonitorServer.SortMsgQueue()
	local msgQueue = {};
	local iplength = #(H5MonitorServer.IPQueue);
	for i = 1,iplength do
		local msgData = H5MonitorServer.msgQueue[H5MonitorServer.IPQueue[i]];
		if(msgData) then 
			table_insert(msgQueue, msgData);
		end
	end
	H5MonitorServer.msgQueue = msgQueue;
	return H5MonitorServer.msgQueue;
end

-- clear msg queue every specific time interval(now is 3000ms)
function H5MonitorServer.ClearMsgQueue()
	local clearMsgQueueTimer;
	clearMsgQueueTimer = commonlib.Timer:new({callbackFunc = function(timer)
		H5MonitorServer.msgQueue = {};
	end})

	-- time interval need to be thought again
	clearMsgQueueTimer:Change(3000, 3000);
end

-- test if connected after connecting before sending
function H5MonitorServer.Ping()
	local serverPingTimer; 
	serverPingTimer = commonlib.Timer:new({callbackFunc = function(timer)
		local serverStatus = H5MonitorServer.GetHandleMsg();
		H5MonitorServer.Send({ping = true});
		LOG.std(nil, "info","server status", "server ping status: %s" ,tostring(serverStatus.pingSuccess));
		if(serverStatus.pingSuccess) then
			serverPingTimer:Change();
		end
	end})
	serverPingTimer:Change(0, 100);
end


local function activate()
	if(msg) then
		-- LOG.std(nil, "info", "H5MonitorServer", "accept");
		LOG.std(nil, "info", "H5MonitorServer", "got a message");
		if(msg.tid) then
			nid = getnid();
			LOG.std(nil, "info", "H5MonitorServer nid:%s", nid);
			NPL.accept(msg.tid, nid);
			local iP = H5MonitorServer.GetIP();
			H5MonitorServer.GetIPQueue(ip);
			H5MonitorServer.GetNidQueue(nid);
		end
		H5MonitorServer.handle_msgs = msg;
		H5MonitorServer.handle_msgsIP = H5MonitorServer.GetIP();
		if(msg.ping) then
			H5MonitorServer.Send({pingSuccess = true});
			LOG.std(nil, "info","server", "client ping status: %s" ,tostring(msg.ping));
		elseif(tonumber(msg.pingSuccess) == 0) then
			H5MonitorServer.SetScreenShotInfo();
			LOG.std(nil, "info"," server ", "client pingSuccess status: %s" ,tostring(msg.pingSuccess));
		end
		H5MonitorServer.GetMsgQueue();
		H5MonitorServer.ClearMsgQueue();
	end	
end

function H5MonitorServer.StartLocalWebServer(host,port)
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", (host or "0.0.0.0"), port or 8092);
end
NPL.this(activate)