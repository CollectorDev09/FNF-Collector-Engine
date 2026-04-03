# Building and Compiling the Collector Engine
In order to be able to use the Collector Engine's source code and see the changes you made, you're gonna have to install a couple things. 

## Installing and setting up HaxeFlixel
In order to install HaxeFlixel, you have to run the following commands:
```
haxelib install flixel
```
Running the command above should automatically install Lime and OpenFL (if you are using an up-to-date version), but if not, run this command:
```
haxelib install openfl
haxelib install lime
```
Now run this command to easily install the additional libraries such as `flixel-addons` and `flixel-tools`:
```
haxelib run lime setup flixel
```
Now that you did that, we need to run a couple more commands so we can run commands such as `lime test [platform]` or `flixel tpl -n "HelloWorld"`:
```
haxelib run lime setup
haxelib install flixel-tools
haxelib run flixel-tools setup
```
To make sure we have the latest version of HaxeFlixel installed, run this command:
```
haxelib update flixel
```