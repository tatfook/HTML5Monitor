[![Join the chat at https://gitter.im/tatfook/SummerOfCode](https://badges.gitter.im/tatfook/SummerOfCode.svg)](https://gitter.im/tatfook/SummerOfCode?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# HTML5Monitor
This is the NPL project to help teachers monitor the students activity in paracraft.  
[html5monitor on sketchboard](https://sketchboard.me/JzZsvxMgocVo#)

# Start Server 
'''
NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.StartLocalWebServer();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.Start();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorServer.lua");
local H5MonitorServer = commonlib.gettable("Mod.HTML5Monitor.H5MonitorServer");
H5MonitorServer.Send({"hello world 111"});
'''
# Start Client
'''
NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.StartLocalWebServer();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.Start();

NPL.load("(gl)Mod/HTML5Monitor/H5MonitorClient.lua");
local H5MonitorClient = commonlib.gettable("Mod.HTML5Monitor.H5MonitorClient");
H5MonitorClient.Send({"hello world"});
'''

