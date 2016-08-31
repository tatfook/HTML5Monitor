[![Join the chat at https://gitter.im/tatfook/SummerOfCode](https://badges.gitter.im/tatfook/SummerOfCode.svg)](https://gitter.im/tatfook/SummerOfCode?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# HTML5Monitor
This is the NPL project to help teachers monitor the students activity in paracraft.  
[html5monitor on sketchboard](https://sketchboard.me/JzZsvxMgocVo#)

## Before First       

Because this app involves localhost communication with other computers using socket, so you should close your `firewall` in `control panel` in windows.

## First Step      

When you using this App, first press `F11` and enter the web page `http://localhost:8099/console` in the broswer. And then copy the following code to the text area:      

```lua
local client_file = "Mod/HTML5Monitor/H5MonitorClient.lua";                   
local server_file = "Mod/HTML5Monitor/H5MonitorServer.lua";       
NPL.AddPublicFile(client_file, 7001);    
NPL.AddPublicFile(server_file, 7002);          
```

like this    
![Code](https://github.com/tatfook/HTML5Monitor/raw/master/Image/code.png)    
Then press `Run as code` button, if code run successfully, it will return a green `success` like above.     

## Work as Server