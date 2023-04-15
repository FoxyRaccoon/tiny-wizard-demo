# Tiny Wizard: Room-Based Top-Down Shooter
An open source 2D Godot 4 game template in the style of *The Binding of Isaac*.
Created by [Quiver](https://quiver.dev).

## Trailer
[![Tiny Wizard Trailer](https://image.mux.com/cCIN6Sj1SURW00zjcZwTFjixhoChIrCMqaxzJwJDTFXY/animated.gif?start=19&end=26)](https://quiver.dev/assets/game-templates/tiny-wizard-top-down-shooter-binding-of-isaac-godot-4/#lg=1&slide=0)

(click to watch the full trailer!)

## Features
- Built on Quiver's [top-down shooter template](https://github.com/quiver-dev/top-down-shooter-godot4)
- 4-way character movement
- Room-based system with unlocking doors
- Multiple projectile weapons and bombs
- Multiple enemy types
- Customizable enemy behaviors
- Collectibles like weapon upgrades and keys
- Destructible environments

## Topics covered
- Tilemaps
- Inventory UI

## Requirements
* Godot 4.0 RC 6 or higher

## Installation Instructions
* Clone this repository from Github
* Run ```git submodule update --init``` to initialize the top-down shooter submodule
* Open the Godot project file and run it to play the *Tiny Wizard* demo!

## Questions/Bugs/Suggestions
For bugs and feature requests, feel free to file an issue here or comment on this template's [project page](https://quiver.dev/assets/game-templates/tiny-wizard-top-down-shooter-binding-of-isaac-godot-4/).

## Share with the community!
If you manage to incorporate this template into your next project, please share with the [Quiver community](https://quiver.dev/)!

## Fireye025 edit
I had time to implement:
- New rooms
- Procedural generation of the dungeon
- Progression save through levels
- A new type of floor : ice, you slide on it
- Change of behavior for the holes in the floor : if you fall in them you die
- When the character dies, he starts in a new level of the same difficulty, keeping the previous save
- There are upgrades buyable in a shop. The shop can be found in a room and give 3 different choices of upgrades. Be careful, you can buy one thing per shop and the shop disappear as you quit it.
- The following upgrades are available : bomb count, key count, bomb explosion size, damage of the magic bullet, speed of casting, maximum life increase and life regeneration

I wanted to implement (and I will if I find time):
- Controller support
- Sounds and music
- More player feedback from damages, explosions and shots
- Passive skills to choses
- Different saves
- Procedural generation inside the room
- Random loot in chests
- New ennemies types

Feel free to contribute and do whatever you want with the project, it is under MIT License.
