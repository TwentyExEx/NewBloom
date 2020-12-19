################################################################################
# This section was created solely for you to put various bits of code that
# modify various wild Pokémon and trainers immediately prior to battling them.
# Be sure that any code you use here ONLY applies to the Pokémon/trainers you
# want it to apply to!
################################################################################

# # Modified shiny rates for events
# # Remove/comment out what isn't needed for the event

# # Shiny based on array
# # Shiny set needs to include all evolutions
# $shinyset = [129,130,179,180,181,228,229,307,308,309,310,459,460,13,14,15,16,17,18,95,208,333,334,361,362,478,568,569,10,11,12,66,67,68,98,99,446,143,821,822,823,824,825,826,833,834,837,838,839,859,860,861,63,64,65,92,93,94,123,212,280,281,282,475,304,305,306,353,354,79,80,199,318,319,322,323,427,428,531,840,841,842,843,844,848,849,850,851,856,857,858,868,869,115,127,142,214,447,448,302,131,878,879,246,247,248,303,359,443,444,445,371,372,373,374,375,376,884]
# Events.onWildPokemonCreateForSpawning+=proc {|sender,e|
#    pokemon=e[0]
#    # SET SHINY RATE HERE: one out of how many
#    shinyrate = 1000 - 1
#    shinychance = 1 + rand(shinyrate-1)
#     if $shinyset.include?(pokemon.species)
#      if shinychance == 1
#        pokemon.makeShiny
#      end
#    else
#    end 
# }

# # Shiny based on generation
# Events.onWildPokemonCreateForSpawning+=proc {|sender,e|
#    pokemon=e[0]
#    # SET SHINY RATE HERE: one out of how many - 1
#    shinyrate = 1500 - 1
#    shinychance = 1 + rand(shinyrate-1)
# # Range is the dex numbers of first and last Pokemon in generation
#    if pokemon.species.between?(1,890)
#      if shinychance == 1
#        pokemon.makeShiny
#      end
#    else
#    end 
# }

# Hard code Neberian Cutiefly
Events.onWildPokemonCreateForSpawning+=proc {|sender,e|
   pokemon=e[0]
   maps=[8] # Lakeside
   if $game_map && maps.include?($game_map.map_id)
     if pokemon.species == 742
      pokemon.form = 1
     else
     end
   end 
}



# This is the basis of a trainer modifier.  It works both for trainers loaded
# when you battle them, and for partner trainers when they are registered.
# Note that you can only modify a partner trainer's Pokémon, and not the trainer
# themselves nor their items this way, as those are generated from scratch
# before each battle.
#Events.onTrainerPartyLoad+=proc {|sender,e|
#   if e[0] # Trainer data should exist to be loaded, but may not exist somehow
#     trainer=e[0][0] # A PokeBattle_Trainer object of the loaded trainer
#     items=e[0][1]   # An array of the trainer's items they can use
#     party=e[0][2]   # An array of the trainer's Pokémon
#     YOUR CODE HERE
#   end
#}