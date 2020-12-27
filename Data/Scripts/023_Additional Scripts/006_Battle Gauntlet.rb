#==========================================================================
# Battle Gauntlet - PokeNV
#==========================================================================
# Scripts for Battle Gauntlet
#==========================================================================

def pbGauntletLevel
  tempParty = []
  for i in $Trainer.party
    clonepoke = i.clone
    clonepoke.ev = i.ev.clone
    clonepoke.iv = i.iv.clone
    for j in 0...6
      clonepoke.ev[j] = i.ev[j]
      clonepoke.iv[j] = i.iv[j]
    end
    clonepoke.level = 50 # Set this to whatever preset level you want
    clonepoke.calcStats
    tempParty.push(clonepoke)
  end
  $game_variables[32] = $Trainer.party
  $Trainer.party = tempParty
  $game_variables[35] = tempParty
end

def pbGauntletRefresh
  $Trainer.party = $game_variables[35]
end

def pbGauntletRestore
  $Trainer.party = $game_variables[32]
end

def pbGauntletBagSave
  $game_variables[33] = $PokemonBag
  $PokemonBag = PokemonBag.new
end
  
def pbGauntletBagRestore
  $PokemonBag = $game_variables[33]
end