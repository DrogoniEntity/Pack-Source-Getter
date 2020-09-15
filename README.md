# Pack Source Getter

This pack is usefull if you want to create modified Minecraft clients.

This pack contains an set of tools and a script that will decompile Minecraft client.

## How to use :
Firstly, place your mapping file and client file into "input" directory named as :
* "client.txt": mapping file (The Proguard file downloaded from Minecraft launcher)
* "client.jar": game file

Next, simply run the script :

Windows users :
```cmd
> get-source.bat
```

Linux users :
```bash
$ bash get-source.sh
```

When script finished, you can find sources files into "output/client-src.jar".

If you need to test your new sources, you can use the modified client located into "output" directory.
This client have different classes name according to "deobfuscated" name.

## Disclaimer
This script will no longer purpose to download Minecraft clients. You need to have your own files.

Minecraft is a trademark of Mojang AB. Do not distribute.

---
## Used tool :
* SpecialSource
* Fernflower

## Special thanks to...
 - @md_5 to create SpecialSource
 - IntelliJ community to create Fernflower.