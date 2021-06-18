# Silk Road
**a strategy game inspired by KOSMOS' game [Jambo](https://boardgamegeek.com/boardgame/12002/jambo)**

#### Video Demo:  https://youtu.be/RbCdqzf0ry4

#### Description:
Silk Road is a trade route connecting East Asia and Southern Europe. You and you opponent are traders in China who compete to become the greatest merchant at that time. By doing so, players should gain at much money as they can in 5 turns by fullfilling contracts trading supplies, generates money using infrastructure, etc.

2 Player is required in this hot heated game. Each player shall receive 5 card and 20 coins at the start of the game. Each Player have 5 action points to perform any of the action below:
1. Draw Card (optional, but it must be the first action of the turn)
2. Play Card (Contract/ Tool/ Event)

There are 6 supplies which you can found in the game:
1. silk
2. porcelain
3. tea
4. honey
5. cotton
6. spice

#### File included:
#### Folder:
- background: static image of the game, which includes the bazaar and the background image used in game
- card: all image of cards
- icon: small image used in games which includes coin and supplies
- toolicon: image used in the tool space in player in order to indicate the current tool the player have

#### lua file:
1. bazaar.lua: 
    - bazaar object and functions, manipulate the appearence of bazaar
2. cardEffect.lua:
    - stored all card effect used in games
    - stored the directory of card image
3. changePlayer.lua
    - button to change player
    - when clicked, state change to waitingRoom
4. classic.lua
    - library used to create objects
5. conf.lua
    - config file to control the window size and the game title
6. deck.lua
    - deck object and functions, storing the card list
7. endScreen.lua
    - shows the winner of the game
8. errorChecking.lua
    - all function that used to check if an action can be successfully perform
    - which includes check if there is enough space when buying supplies
    - storing error message when error is occured
9. main.lua
    - main scene of the game
    - stored init. variables
10. selector.lua
    - selector object and functions
    - pops up when certain card is played
    - used to select wares and cards
11. stateswicher.lua
    - library used to change scene from main to waitingRoom and endScreen
12. tool.lua
    - tool object and function
13. waitingRoom.lua
    - buffer scene for player change physically
    - swap all variable for each player


#### credit
- Font used in game: Ray Larabie's Joystix
- State switcher Author: Daniel Duris, (CC-BY) 2014
- classic Copyright (c) 2014, rxi
- Image by https://pixabay.com/users/a_different_perspective-2135817/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;- utm_content=4500910



## How to play:
###  Objective: 
Gaining most coins in 5 turns of game.

### turn:
each turn the player can play 5 actions.

The first action point can be used to draw 2 cards from deck.

When turn ends, if the player have 2 action points left,

one can gain 3 coins.

### Contract Card:
Left click contact card to buy supplies

Right click contact card to sell supplies

### Tool Card:
Reusable, can activate once per turn.

Can be activated the same turn as the card plays.

### Event Card:
One time use action card.