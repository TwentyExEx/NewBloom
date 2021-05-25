#==========================================================================
# Egg Roulette - PokeNV
#==========================================================================
# Generates a Pokemon egg based on rarity tier groups
# that can be easily swapped out.
#==========================================================================
# Define each tier with the names of each Pokemon

COMMON = [:CHEWTLE, :DWEBBLE, :SMEARGLE, :ZUBAT, :NICKIT, :CACNEA, :GRUBBIN, :SKWOVET, :BLIPBUG, :PICHU, :SCATTERBUG, :ODDISH, :ROOKIDEE, :WOOLOO, :TAILLOW, :MEOWTH, :STARLY, :BUNEARY, :DEDENNE, :MACHOP, :GRIMER, :MAGNEMITE, :TIMBURR, :SNOM, :AZURILL, :MAGIKARP, :BUIZEL, :REMORAID, :SEEL, :RATTATA, :WEEDLE, :ZIGZAGOON]
UNCOMMON = [:SANDYGAST, :BINACLE, :SKRELP, :PYUKUMUKU, :MAKUHITA, :ONIX, :DRILBUR, :MIENFOO, :STUNFISK, :IMPIDIMP, :SHUPPET, :DUSKULL, :GASTLY, :ABRA, :CUFANT, :SIZZLIPEDE, :CUBONE, :SANDSHREW, :CUTIEFLY, :MORELULL, :HATENNA, :SNUBBULL, :FLABEBE, :MIMEJR, :MUNNA, :STUFFUL, :GOSSIFLEUR, :SHROOMISH, :TEDDIURSA, :STUNKY, :JOLTIK, :DUNSPARCE, :YAMPER, :TOGEPI, :MAREEP, :MILTANK, :FLETCHLING, :EEVEE, :PONYTA, :PACHIRISU, :TOGEDEMARU, :KLINK, :WIMPOD, :WOOPER, :SNOVER, :DRAMPA, :ROLYCOLY, :VULPIX, :CLOBBOPUS, :CHINCHOU, :BERGMITE, :SHELLOS, :CRAMORANT, :GEODUDE, :EXEGGCUTE, :KOFFING, :CORSOLA, :DIGLETT]
RARE = [:CRABRAWLER, :NOIBAT, :CARBINK, :YAMASK, :FERROSEED, :PUMPKABOO, :PHANTUMP, :DRIFLOON, :LITWICK, :CROAGUNK, :SKORUPI, :SANDILE, :SCRAGGY, :COMFEY, :RALTS, :GOTHITA, :SOLOSIS, :PANCHAM, :SCYTHER, :VENIPEDE, :HONEDGE, :KLEFKI, :SHINX, :DEWPIDER, :FEEBAS, :SALANDIT, :SWABLU, :NUMEL, :HOUNDOUR, :SWINUB, :SKARMORY, :GROWLITHE, :KANGASKHAN, :DHELMISE, :CARVANHA, :SPIRITOMB, :MIMIKYU, :KOMALA, :MILCERY, :AMAURA, :SINISTEA]
SUPERRARE = [:LARVITAR, :PAWNIARD, :TRAPINCH, :DARUMAKA, :RIOLU, :GOOMY, :JANGMOO, :GIBLE , :LARVESTA, :DRATINI, :LAPRAS, :PINSIR, :HERACROSS, :ABSOL, :MAWILE]

def pbEggShiny
  pkmn = $Trainer.lastParty.species
  if $shinyset && $shinyset.include?(pkmn) == true # If Pokemon already has increased shiny rate in the wild
    shinyrate = 100 - 1 # Set shiny rate for event Pokemon that also have increased shiny rate in the wild
    shinychance = 1 + rand(shinyrate-1)
  elsif $shinyset && $shinyset.include?(pkmn) == false # Shiny state is applied based on shiny rate
    shinyrate = 200 - 1
    shinychance = 1 + rand(shinyrate-1)
  else
  end
  if shinychance == 1
    pkmn=$Trainer.lastParty
    return pkmn.makeShiny
  else
    return false
  end
end

def pbEggIV
  pkmn = $Trainer.lastParty
  pkmn.iv[0] = 24 + rand(8) # HP
  pkmn.iv[1] = 24 + rand(8) # Speed
  pkmn.iv[2] = 24 + rand(8) # Attack
  pkmn.iv[3] = 24 + rand(8) # Defense
  pkmn.iv[4] = 24 + rand(8) # Sp Attack
  pkmn.iv[5] = 24 + rand(8) # Sp Defense
end

def pbEggRoulette
  tier = Array.new
  draw = 1 + rand(99)
  if draw.between?(1, 10)
    tier.concat(SUPERRARE)
  elsif draw.between?(11, 30)
    tier.concat(RARE)
  elsif draw.between?(31, 60)
    tier.concat(UNCOMMON)
  elsif draw.between?(61, 100)
    tier.concat(COMMON)
  end
  species = tier[rand(tier.length)]
  pbGenerateEgg(species) # Egg of selected species is generated
  pbEggShiny # Increased shiny rate is applied 
  pbEggIV # Randomized IV range is applied
  return true
end

def pbEggRouletteSpecial
  tier = Array.new
  draw = 1 + rand(99)
  if draw.between?(1, 25)
    tier.concat(SUPERRARE)
  elsif draw.between?(26, 60)
    tier.concat(RARE)
  elsif draw.between?(61, 100)
    tier.concat(UNCOMMON)
  end
    species = tier[rand(tier.length)]
    pbGenerateEgg(species) # Egg of selected species is generated
    pbEggShiny # Increased shiny rate is applied 
    pbEggIV # Randomized IV range is applied
  return true
end

# Event arrays and scripts

# EVENTCOMMON = [:MAGIKARP, :MAREEP, :HOUNDOUR, :MEDITITE, :EELEKTRIK, :SNOVER, :WEEDLE, :PIDGEY, :ONIX, :SWABLU, :SNORUNT, :TRUBBISH, :CATERPIE, :MACHOP, :KRABBY, :MUNCHLAX, :ROOKIDEE, :BLIPBUG, :CHEWTLE, :ROLYCOLY, :IMPIDIMP]
# EVENTUNCOMMON = [:BULBASAUR, :CHARMANDER, :SQUIRTLE, :ABRA, :GASTLY, :SCYTHER, :TORCHIC, :RALTS, :ARON, :SHUPPET, :SLOWPOKE, :TREECKO, :MUDKIP, :CARVANHA, :NUMEL, :BUNEARY, :AUDINO, :GROOKEY, :SOBBLE, :SCORBUNNY, :APPLIN, :SILICOBRA, :TOXEL, :SIZZLIPEDE, :HATENNA, :MILCERY]
# EVENTRARE = [:KANGASKHAN, :PINSIR, :AERODACTYL, :HERACROSS, :RIOLU, :SABLEYE, :LAPRAS, :CUFANT]
# EVENTSUPERRARE = [:LARVITAR, :MAWILE, :ABSOL, :GIBLE, :BAGON, :BELDUM, :DURALUDON]

def pbEventEggRoulette
  tier = Array.new
  draw = 1 + rand(99)
  if draw.between?(1, 10)
    tier.concat(EVENTSUPERRARE)
  elsif draw.between?(11, 30)
    tier.concat(EVENTRARE)
  elsif draw.between?(31, 60)
    tier.concat(EVENTUNCOMMON)
  elsif draw.between?(61, 100)
    tier.concat(EVENTCOMMON)
  end
  species = tier[rand(tier.length)]
  pbGenerateEgg(species) # Egg of selected species is generated
  pbEggShiny # Increased shiny rate is applied 
  pbEggIV # Randomized IV range is applied
  return true
end

def pbEventEggRouletteSpecial
  tier = Array.new
  draw = 1 + rand(99)
  if draw.between?(1, 25)
    tier.concat(EVENTSUPERRARE)
  elsif draw.between?(26, 60)
    tier.concat(EVENTRARE)
  elsif draw.between?(61, 100)
    tier.concat(EVENTUNCOMMON)
  end
    species = tier[rand(tier.length)]
    pbGenerateEgg(species) # Egg of selected species is generated
    pbEggShiny # Increased shiny rate is applied 
    pbEggIV # Randomized IV range is applied
  return true
end