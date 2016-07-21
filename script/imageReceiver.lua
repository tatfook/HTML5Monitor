--[[
Title: imageReceiver.lua
Author: marxwolfs@gmail.com
Date: 2017/07/18
Desc: neuron file remote called by client to receive paracraft screenshot  
Use Lib:
------------------------------------------------------------------------

------------------------------------------------------------------------
]]

NPL.load("(gl)script/ide/System/Encoding/base64.lua");
local Encoding = commonlib.gettable("System.Encoding");

local imageReceiver = commonlib.gettable("WebServer.imageReceiver");
--[[
local function AddPublicFiles()
	NPL.AddPublicFile("script/apps/WebServer/admin/wp-content/pages/imageReceiver.lua", 233);
end

local function InitServer(host, port)
	AddPublicFiles();
	NPL.StartNetServer(host, port);
end
]]
local function imageReceiver.imageSave(imageData, imageSize, imageName)
	imageName = imageName or "autoReceived.jpg";
	imageObj = ParaIO.open(imageName, "w");
	imageObj:write(imageData, imageSize);
	imageObj:close();
end

local function activate()
	--InitServer("0.0.0.0", 8099);
	if(msg) then
		imageData = Encoding.unbase64(msg.data);
		imageReceiver.imageSave(imageData, msg.imageSize ,"autoReceived.jpg");
	end
end

NPL.this(activate)
