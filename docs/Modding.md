# How to make an FNF Mod in Collector Engine

## DISCLAIMER
Modding may be primitive as I have yet to softcode some things, I'll improve this in the future though!

## Setting up the mod
First, you'll want to open the `mods/` folder and create a new folder. This folder can be named anything! After that you'll want to create the metadata file called `meta.json`. Once you do that, it should look somewhat like this: 
```
{
    "name": "Intro Mod",
    "id": "introMod",
    "api_version": "0.1.0",
    "mod_version": "1.0.0"
}
```
You can have `name`, `id`, and `mod_version` be whatever you want, but we recommend the `api_version` to be the same version as the version of Collector Engine you are using to prevent issues.

## Adding Intro Text
If you want to add intro texts, you'll want to create a new folder called `_append/`, and inside that folder add another folder called `data/`, and inside that folder create a file called `introText.txt`. Inside this file, you can add any texts you want as long as it follows this format:
```
line one--line two
line three--line four
```
One other rule you must follow to prevent issues is that you DON'T add numbers, the font used doesn't support numbers just yet!