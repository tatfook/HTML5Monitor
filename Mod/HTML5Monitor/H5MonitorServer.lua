--[[
Title: H5MonitorServer
Author(s): leio  
Date: 2016/7/20
Revised: MarxWolf 2016/07/23
Desc: 
use the lib:
------------------------------------------------------------
This is a program not a library.
It should be used with H5MonitorClient together.
User can self define the size of large screen shot image in H5MonitorServer.SetScreenShotInfo();
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/commonlib.lua"); 
NPL.load("(gl)script/ide/timer.lua");

local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";
local table_insert = table.insert;


-- handle_msgs: the msg received each time
-- handle_msgsIP: the ip address of msg sender corresponding to handle_msgs
-- msgQueue: msg queue in a specific time interval
-- tempIPQueue: ip queue corresponding to msgQueue
-- ipQueue: ip queue record the connected client ip address arrange by their connection time
-- nidQueue: nide queue corresponding to ipQueue
H5MonitorServer.handle_msgs = nil;
H5MonitorServer.handle_msgsIP = nil;
H5MonitorServer.msgQueue = {};
H5MonitorServer.tempIPQueue = {};
H5MonitorServer.ipQueue = {};
H5MonitorServer.nidQueue = {};

function H5MonitorServer.AddPublicFiles()
    NPL.AddPublicFile(client_file, 7001);
    NPL.AddPublicFile(server_file, 7002);
end

-- clousre to make an unique nid for each connected client
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

-- connect a client 
function H5MonitorServer.Start(host,port)
    H5MonitorServer.AddPublicFiles();
	host= host or "127.0.0.1";
	port = port or "60001";
	
	host = tostring(host);
	port = tostring(port);
	nid = getnid();
	H5MonitorServer.GetClientIP(host);
	H5MonitorServer.GetIPQueue(host);
	H5MonitorServer.GetNidQueue(host, nid);
	local params = {host = host, port = port, nid = nid};
	-- add the server address
	NPL.AddNPLRuntimeAddress(params);
	H5MonitorServer.Send({},true)
	LOG.std(nil, "info", "H5MonitorServer", "Connect host:%s port:%s",host,port);
	H5MonitorServer.handle_msgs = { server_started = true };
end

function H5MonitorServer.Stop()

end

-- send msg to specific client
function H5MonitorServer.Send(msg, usernid)
	local nid = usernid or msg.nid or msg.tid or nid;
	local res = NPL.activate(string.format("%s:%s", nid, client_file), msg);
	--LOG.std(nil, "info", "H5MonitorServer", "res:%s",tostring(res));
	return res;
end

function H5MonitorServer.GetHandleMsg()
	return H5MonitorServer.handle_msgs, H5MonitorServer.handle_msgsIP;
end

function H5MonitorServer.GetIP()
	local remoteIP = NPL.GetIP(msg.tid or msg.nid or nid);
	return remoteIP;
end

function H5MonitorServer.GetClientIP(ip)
	H5MonitorServer.clientIP = ip;
end

-- @param: is_large, to save bandwidth and time, usually set small size screenShot(nil parameter), when necessary, set large size
function H5MonitorServer.SetScreenShotInfo(is_large, usernid)
	local width, height = 256, 256;
	if (is_large) then
		width = 400;  -- need to be replaced by the screen info
		height = 400; 
	end
	local screenShotInfo = {width = width, height = height};
	--LOG.std(nil, "info", "server SetScreenShotInfo" ,"width:%s, height: %s", width, height);
	H5MonitorServer.Send(screenShotInfo, usernid);
end

-- server side, when receive screenShot info request from client, send screenShot info to client
function H5MonitorServer.Response()
	
end

-- temp ip array for one time interval
function H5MonitorServer.GetTempIPQueue(ip)
	table_insert(H5MonitorServer.tempIPQueue, ip);
end

-- the ip array that arrange by the connection order,
function H5MonitorServer.GetIPQueue(ip)
	table_insert(H5MonitorServer.ipQueue, ip);
end

-- the nid table, such as {'127.0.0.1': "student1"}
function H5MonitorServer.GetNidQueue(ip, nid)
	H5MonitorServer.nidQueue[ip] = nid;
end

-- get msg queue and index the screenShotData using IP
function H5MonitorServer.GetMsgQueue(msg, msgIP)	
	local contain = H5MonitorServer.msgQueue[msgIP];
	if(not contain) then
		H5MonitorServer.msgQueue[msgIP] = msg.screenShotData;
		H5MonitorServer.GetTempIPQueue(msgIP);
	end
end

-- sort tempIPQueue according to ipQueue
function H5MonitorServer.SortTempIPQueue()
	local temp = {}
	for key, value in ipairs(H5MonitorServer.ipQueue) do
		temp[value] = key;
	end
	table.sort(H5MonitorServer.tempIPQueue, function(v1, v2)
		local k1 = assert(temp[v1]);
		local k2 = assert(temp[v2]);
		return k1 < k2;
	end)
	return H5MonitorServer.tempIPQueue;
end

-- sort msg queue according to their connection order using IP queue
function H5MonitorServer.SortMsgQueue()
	local msgQueue = {};
	local iplength = #(H5MonitorServer.tempIPQueue);
	--LOG.std(nil, "info", "H5MonitorServer iplength", tostring(iplength));
	for i = 1,iplength do
		local msgData = H5MonitorServer.msgQueue[H5MonitorServer.SortTempIPQueue()[i]];
		--LOG.std(nil, "info", "H5MonitorServer msgData", tostring(msgData));
		if(msgData) then 
			table_insert(msgQueue, msgData);
		end
	end
	return msgQueue;
end

-- clear msg queue every specific time interval(now is 3000ms)
function H5MonitorServer.ClearMsgQueue()
		H5MonitorServer.msgQueue = {};
		H5MonitorServer.tempIPQueue = {};
		--LOG.std(nil, "info", "H5MonitorServer", "clear msgsQueue");
end

-- test if connected after connecting before sending
function H5MonitorServer.Ping()
	local serverPingTimer; 
	serverPingTimer = commonlib.Timer:new({callbackFunc = function(timer)
		local serverStatus = H5MonitorServer.GetHandleMsg();
		H5MonitorServer.Send({ping = true});
		--LOG.std(nil, "info","server status", "server ping status: %s" ,tostring(serverStatus.pingSuccess));
		if(serverStatus.pingSuccess) then
			serverPingTimer:Change();
		end
	end})
	serverPingTimer:Change(0, 100);
end

-- main function
local function activate()
	if(msg) then
		--LOG.std(nil, "info", "H5MonitorServer", "got a message");
		H5MonitorServer.handle_msgs = msg;
		H5MonitorServer.handle_msgsIP = H5MonitorServer.GetIP();
		if(msg.tid) then
			nid = getnid();
			--LOG.std(nil, "info", "H5MonitorServer nid: ", nid);
			local ip = H5MonitorServer.GetIP();
			NPL.accept(msg.tid, nid);
			--LOG.std(nil, "info", "H5MonitorServer local ip", tostring(ip));
			if(not H5MonitorServer.nidQueue[ip]) then
				H5MonitorServer.GetIPQueue(ip);
			end
			H5MonitorServer.GetNidQueue(ip, nid);
		end
		if(msg.screenShotData) then
			local msgIP = H5MonitorServer.GetIP() or H5MonitorServer.clientIP;
			H5MonitorServer.GetMsgQueue(msg, msgIP);
		elseif(msg.ping) then
			H5MonitorServer.Send({pingSuccess = true});
			LOG.std(nil, "info","server", "client ping status: %s" ,tostring(msg.ping));
		elseif(msg.pingSuccess) then
			H5MonitorServer.SetScreenShotInfo();
			--LOG.std(nil, "info"," server ", "client pingSuccess status: %s" ,tostring(msg.pingSuccess));
		end
	end	
end

function H5MonitorServer.StartLocalWebServer(host,port)
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", (host or "0.0.0.0"), port or 8092);
end
NPL.this(activate)