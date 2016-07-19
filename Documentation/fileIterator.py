import os 
import os.path
import re

rootdir = r'D:\NPL\src\script'
savefile = 'luafile.txt'


#rootdir = r'D:\NPL\src\script\apps\WebServer\admin'
#savefile = 'pagefile.txt'


def fileIterator(filerootdir, savefile):
	f = open(savefile,'a')
	for parent,dir,file in os.walk(filerootdir):
		for filename in file:
			if (filename.endswith(".lua")):
				#filetotal = os.path.join(parent,filename)+"\n"
				luafile = os.path.join(parent,filename)[11:].replace("\\","/")+"\n"
				
				f.write(luafile)
	f.close()

	
fileIterator(rootdir, savefile)

abc = raw_input("enter to leave:")
print(abc)