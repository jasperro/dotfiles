# Install python dmenu support with sudo pip install dmenu
import os, getpass, dmenu
sldir = ("/home/" + getpass.getuser() + "/.screenlayout")
dircont = (os.listdir(str(sldir)))
n=0
for i in dircont:
    dircont[n] = i.replace('.sh','')
    n += 1
sel = dmenu.show((dircont), "dmenu", None, None, None, None, None, "screenlayout")
os.system(sldir + "/" + sel + ".sh")
