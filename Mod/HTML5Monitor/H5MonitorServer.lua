--[[
Title: H5MonitorServer
Author(s): leio  
Date: 2016/7/20
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
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
local rts_name = "h5monitor_worker";
local nid = "stu1";
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";
H5MonitorServer.handle_msgs = nil;
function H5MonitorServer.AddPublicFiles()
    NPL.AddPublicFile(client_file, 7001);
    NPL.AddPublicFile(server_file, 7002);
end
function H5MonitorServer.Start(host,port)
    H5MonitorServer.AddPublicFiles();
	
	host= host or "127.0.0.1";
	port = port or "60001";
	
	host = tostring(host);
	port = tostring(port);

	local params = {host = host, port = port, nid = nid};
	-- add the server address
	NPL.AddNPLRuntimeAddress(params);
	H5MonitorServer.Send({},true)
	LOG.std(nil, "info", "H5MonitorServer", "Connect host:%s port:%s",host,port);

	H5MonitorServer.handle_msgs = { server_started = true };
end
function H5MonitorServer.Stop()

end
function H5MonitorServer.Send(msg)
	local nid = msg.nid or msg.tid or last_client_nid;
	local res = NPL.activate(string.format("%s:%s", nid, client_file), msg);
	LOG.std(nil, "info", "H5MonitorServer", "res:%s",tostring(res));
	return res;
end

function H5MonitorServer.GetHandleMsg()
	return H5MonitorServer.handle_msgs;
end

local function activate()
	if(not msg.nid)then
		LOG.std(nil, "info", "H5MonitorServer", "accept");
		NPL.accept(msg.tid, nid);
		H5MonitorServer.Send({login = true});	
	end
	LOG.std(nil, "info", "H5MonitorServer", "got a message");
	H5MonitorServer.handle_msgs = msg;
end
function H5MonitorServer.StartLocalWebServer(host,port)
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", (host or "0.0.0.0"), port or 8092);
end
NPL.this(activate)