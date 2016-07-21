### connector.page & imageReceiver.lua Usage

>Test environment is two paraengineclients in the same computer but with different ports.

First, download [connector.page](https://github.com/tatfook/HTML5Monitor/blob/master/script/connector.page) to your path `script/apps/WebServer/admin/wp-content/pages` and download [imageReceiver.lua](https://github.com/tatfook/HTML5Monitor/blob/master/script/imageReceiver.lua) to your path `script/`
start your paraengineclient, and randomly enter a world.    
`Press F12` to start debug mode. Enter the following code in the input filed
    
	NPL.load("(gl)script/apps/WebServer/WebServer.lua");
	WebServer:Start("script/apps/WebServer/admin", "0.0.0.0", "8090")

And then `Run Code`.    
You can visit `localhost:8090/connector` at your broswer.   

And then start another paraengineclient and randomly enter a world.   
Just press `f11`, you will visit `localhost:8099/console` at your broswer. And enter the following code in the input field.  
	
	NPL.AddPublicFile("script/imageReceiver.lua", 11);

And then you can input something in the former `localhost:8090/connector` web page.   
server ip: `127.0.0.1:8099`
username: pick what you like. 
Do the input twice and see the return code from `2` two `0`. You can get a `autoReceived.jpg` in your `redist` folder.