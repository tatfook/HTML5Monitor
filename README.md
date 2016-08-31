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

## Second Step     

Enter the url into the web location `http://localhost:8099/h5monitor`, and you can see the image following    
![h5monitor](https://github.com/tatfook/HTML5Monitor/raw/master/Image/Original.png)

The `input field` in the `red area` is designed for `client`, and the `add button` in the `blue area` is designed for `server`.       

## Work as Server       
If you want to monitor other ParaCraft client, you should work as a server. You have two choices, first you can wait other clients to connect your server. And you have another choice, and you can connect the client by yourself. Press the `add button`, you can see dialog popup as following    

![h5monitorServer](https://github.com/tatfook/HTML5Monitor/raw/master/Image/Server.png) 

Enter client IP such as `192.168.0.110` in the local area, and then press `CONNECT` button. It will automatically connect to the specific ParaCraft client and take screen shot each second.      

## Work as Client       
If you want to show your behavior to the server, you must work as client. You can enter the remote server IP such as `192.168.0.2` in the `input filed` in the `red area` in the second figure. If you connect the server successfully, it will popup the following figure for 1.5 seconds and then it will close automatically     
![client feedback](https://github.com/tatfook/HTML5Monitor/raw/master/Image/ClientFeedback.png) 

`Attention`, if nothing happens, it shows that you do not connect to the server.    

## Congratulations       

If you see the figure below in server side, it means that you have used the App successfully.
![Success](https://github.com/tatfook/HTML5Monitor/raw/master/Image/Success.png)   

