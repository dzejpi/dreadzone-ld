# dreadzone
My videogame for Ludum Dare #56, with theme of "Tiny creatures."

You were called for a cleanup of tiny creatures in the castle walls. Are you up to the task? 

# How to play

Walk into arena and survive! Collect health bonuses and more guns in order to defend against more and more aggressive tiny creatures!

Web version is available, but I highly recommend downloading a Windows version and playing that instead. I assumed that Godot 4.3 would be as web capable as 3.6, where I never ran into any issues, but it seems like this is not the case. 

I spent a non-significant amount of Sunday trying to find every possible way how to optimise the game for web and sacrificed a very big chunk of plans, but no matter what I tried, I didn't get rid of the issue where after around 3 or 4 minutes of playing in areana, all 3D objects visually disappear. 

Therefore, if you want to get a taste of this game, go ahead, but if you want to give creatures a proper hell, local version got your back. :smile: 

![2024-10-07_00-16-41](https://github.com/user-attachments/assets/d5e22537-b56e-4995-af43-78b699c7a39d)

# Controls

* WSAD: Move like in all 3D first person games.
* Left click: Interaction with items.
* Middle mouse button scroll: circle between weapons.
* 1-5: Switching between weapons.
* Escape: Toggle pause menu. Focus on HTML5 on Itchio is not perfect, so if you’re playing HTML5 version, press Esc twice and click on the Continue button with your mouse to focus it back properly.
* Shift (hold): Sprint.
* Space: Jump.

# Tools used

* Game engine: Godot 4.3.
* Aseprite
* Blender
* Ableton Live 11 Standard
* Audacity

![2024-10-07_00-16-09](https://github.com/user-attachments/assets/5cb3b9e2-d590-4c7b-a18a-003ec8c3fcfd)

# Commentary

This is the first time I used Godot 4+ for the game jam, I was always using 3.X before due to better web exporters. This project went amazing all the way to the first web export, which I did way too late. Would there be no web issues, this game would be much bigger - I had 4 different arenas planned with dynamic doors and endless mode at the end. 
However, once I exported this to web, then I ran into the first issue - I couldn't see anything. This got thankfully resolved by the different compression method, but the other issue I couldn't resolve - when there are too many nodes, all 3D objects just disappear. I cut the scope massively due to this in a futile effort to optimise it so that there are as few nodes as possible. I implemented the enemy limit so that spawners do not spawn over the certain number creatures, I optimised ground and walls massively, but nothing helped. Due to this, I am kinda disappointed, because this could have been much bigger. That said, it's still fun, but I recommend downloading a local version.
