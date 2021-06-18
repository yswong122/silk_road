-- PseudoCode
-- Game Scene


-- preconfig

-- cardlist and decks
    -- class card (card.lua)
    -- set up cards effects (card.lua)
    -- contract card (contract.lua)
    -- event card (event.lua)
    -- tool card (tool.lua)
    -- create card objects
    -- deck = list of cards no. (init 1 - 50)
    -- no. of cards = #deck (CONST)
    

-- userdata (load + draw)
    -- set original supplies count (CONST: 4 each)
    -- setting up gameing zone (draw)
    -- displaying all sets of data (draw)
    -- turn count = 0 init (global)
    -- action count (global)
    -- coin1: 20
    -- coin2: 20


-- Init gameplay
    -- Shuffle deck
        -- randomised the desk
    -- Give each player 20 dollars
    -- Distribute 5 cards to player
        -- hand1 table of cards no.
        -- hand2 table of cards no.
        -- each player draw 5 cards (function)


-- Player turn
    -- increasee turn count (if player 1)
    -- reset action counts
    -- draw 2 cards (optional when action point = 5)
    -- User Interaction
    -- Card: hover: card description appears
    -- Card: click: generate effects
    -- End turn button: Click: to change player scene


-- Calculate end game
    -- When turn count = 5 and player 2 ends
    -- player having more coin = winner
    -- else tie


-- function drawCards(num)
    -- default 1
    -- check deck size if #deck - num < 0 end game
    -- loop num times
    -- deck pop 1
    -- player cardx insert 1
