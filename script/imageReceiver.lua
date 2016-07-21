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


local function imageSave(imageData, imageSize, imageName)
	imageName = imageName or "autoReceived.jpg";
	imageObj = ParaIO.open(imageName, "w");
	imageObj:write(imageData,imageSize);
	imageObj:close();
end

function activate()
	local msg = msg
	--InitServer("0.0.0.0", 8099);
	if(msg) then
		imageData = Encoding.unbase64(msg.data);
		LOG.std(nil, "info", "Msg", "msg.dataLength: %d", string.len(imageData));
		LOG.std(nil, "info", "Msg", "msg.dataType: %s", type(imageData));
		LOG.std(nil, "info", "Msg", "msg.imageSize: %d", msg.fileSize);
		imageSave(imageData, msg.fileSize,"autoReceived.jpg");
	end
end

NPL.this(activate)
