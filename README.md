
UBO (Unknown Bouncing Object) is a minimalist clone of Qix.

The idea comes from the Ludum Dare 26 (April 2013) where 'miniQix' was posted by Wiering.
MiniQix (http://www.wieringsoftware.nl/ld/miniqix/) is a javascript program, is simple and addictive to play, but have
issues when managing many enemies.

So I want to code the same in Löve, a lua game engine, as an exercice, so here it is.
I use middleclass and statefull to have a clear code. I use minimalist graphic and the grid size can be modified in code (main.lua).

To play : you must claimed 75% of the area. When building you are vulnerable. And you must not hit a wall in construction.
Each new level add another enemie or "UBO".