################################################################################
# Advanced Pokemon Level Balancing
# By Joltik
#Inspired by Umbreon's code
################################################################################
################################################################################


module LevelBalance
  
  Light = 10                 #from 1 to 10
  Easy = 15                  #from 11 to 20
  Medium = 30                #from 21 to 30
  Hard = 35                  #from 31 to 40
  Insane = 45                #from 41 to 55
  Extreme = 60               #from 56 to MAXIMUM_LEVEL
  Switch = 100               #Switch that turns on Trainer Difficulty Control
  Trainer_dif = 78           #Variable that controls trainer battle's difficulty
  
  # Calculates the difficulty based on your party pokemon's level and badges
    def self.calcDifficulty
    lv=[Light,Easy,Medium,Hard,Insane,Extreme]
    badges = $Trainer.numbadges
    balance = pbBalancedLevel($Trainer.party)
    mlv=0
     for poke in $Trainer.pokemonParty
      mlv=poke.level if poke.level>mlv
     end
    average = (badges*30+3*balance+4*mlv)/10
      for i in 0...lv.length
        if average <= lv[i]
          break
        end
      end
     return i
   end
end

Events.onWildPokemonCreateForSpawning+=proc {|sender,e|
    pokemon=e[0]
    difficulty= LevelBalance::calcDifficulty
    badges = $Trainer.numbadges
    balance = pbBalancedLevel($Trainer.party)
    mlv=0
     for poke in $Trainer.pokemonParty
      mlv=poke.level if poke.level>mlv
     end
     case difficulty
       when 0 #Light
        l = balance/3 - 2 + rand(5)
       when 1 #Easy
        l = 2*balance/3  - 4 + rand(8)
       when 2 #Medium
        l = 3*(balance + 4*mlv)/20 - 4 + rand(8)
       when 3 #Hard
        l = 4*(balance + 4*mlv)/25 - 2 + rand(8)
       when 4 #Insane
        l = (balance + 4*mlv)/6 - 4 + rand(4+balance/10)
       else #Extreme
        l = 9*(balance + 4*mlv)/50 - 4 + rand(4+balance/10)
     end
     newlevel=l
     newlevel=1 if newlevel<1
     newlevel=PBExperience.maxLevel if newlevel>PBExperience.maxLevel
     pokemon.level=newlevel
     #now we evolve the pokémon, if applicable
     species = pokemon.species
     newspecies = pbGetBabySpecies(species) # revert to the first evolution
     evoflag=0 #used to track multiple evos not done by lvl
     endevo=false
     loop do #beginning of loop to evolve species
      nl = newlevel + 5
      nl = MAXIMUM_LEVEL if nl > MAXIMUM_LEVEL
      pkmn = PokeBattle_Pokemon.new(newspecies, nl)
      cevo = Kernel.pbCheckEvolution(pkmn)
      evo = pbGetEvolvedFormData(newspecies)
      if evo
        evo = evo[rand(evo.length - 1)]
        # here we evolve things that don't evolve through level
        # that's what we check with evo[0]!=4
        #notice that such species have cevo==-1 and wouldn't pass the last check
        #to avoid it we set evoflag to 1 (with some randomness) so that
        #pokemon may have its second evolution (Raichu, for example)
        if evo && cevo > 1 && rand(50) <= newlevel
          if evo[0] != 4 && rand(50) <= newlevel
          newspecies = evo[2] 
             if evoflag == 0 && rand(50) <= newlevel 
               evoflag=1
             else
               evoflag=0
             end
           end
        else
        endevo=true   
        end
      end
      if evoflag==0 || endevo
      if  cevo == -1 || rand(50) > newlevel
        # Breaks if there no more evolutions or randomnly
        # Randomness applies only if the level is under 50 
        break
      else
        newspecies = evo[2]
      end
      end
    end
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo=pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
      if evo.length<1 && couldevo.length<1
      else
         species=newspecies
      end
     pokemon.name=PBSpecies.getName(species)
     pokemon.species=species
     pokemon.calcStats
     pokemon.resetMoves
     }
     
Events.onTrainerPartyLoad+=proc {|sender,e|
   if e[0] # Trainer data should exist to be loaded, but may not exist somehow
     trainer=e[0][0] # A PokeBattle_Trainer object of the loaded trainer
     items=e[0][1]   # An array of the trainer's items they can use
     party=e[0][2]   # An array of the trainer's Pokémon

    if $game_switches && $game_switches[LevelBalance::Switch] && $Trainer &&
      $Trainer.party.length > 0
       badges = $Trainer.numbadges
       balance = pbBalancedLevel($Trainer.party)
       mlv=0
       for poke in $Trainer.pokemonParty
        mlv=poke.level if poke.level>mlv
       end
      for i in 0...party.length
      #sets difficulty based on variable
      case $game_variables[LevelBalance::Trainer_dif]
       when 0 #Light
        l = balance/2 - 2 + rand(5)
       when 1 #Easy
        l = 3*balance/4  - 4 + rand(8)
       when 2 #Medium
        l = 18*(balance + 4*mlv)/100 - 4 + (balance/20) + rand(4 + balance/10)
       when 3 #Hard
        l = 11*(balance + 4*mlv)/50  - 4 + rand(4 + balance/10)
       when 4 #Insane
        l = 5*(balance + 4*mlv)/20 - 4 + rand(4+balance/10)
       else #Extreme
        l = 7*(balance + 4*mlv)/25 - 4+ rand(4+balance/10)
       end
      level = l  
      level=3 if level<3
      level=PBExperience.maxLevel if level>PBExperience.maxLevel
      party[i].level = level
      #now we evolve the pokémon, if applicable
      species = party[i].species
      newspecies = pbGetBabySpecies(species) # revert to the first evolution
      evoflag=0 #used to track multiple evos not done by lvl
      endevo=false      
      loop do #beginning of loop to evolve species
      nl = level + 5
      nl = MAXIMUM_LEVEL if nl > MAXIMUM_LEVEL
      pkmn = PokeBattle_Pokemon.new(newspecies, nl)
      cevo = Kernel.pbCheckEvolution(pkmn)
      evo = pbGetEvolvedFormData(newspecies)
      if evo
        evo = evo[rand(evo.length - 1)]
        # here we evolve things that don't evolve through level
        # that's what we check with evo[0]!=4
        #notice that such species have cevo==-1 and wouldn't pass the last check
        #to avoid it we set evoflag to 1 (with some randomness) so that
        #pokemon may have its second evolution (Raichu, for example)
        if evo && cevo > 1 && rand(50) <= level
          if evo[0] != 4 && rand(50) <= level
          newspecies = evo[2] 
             if evoflag == 0 && rand(50) <= level 
               evoflag=1
             else
               evoflag=0
             end
           end
        else
        endevo=true   
        end
      end
      if evoflag==0 || endevo
      if  cevo == -1 || rand(2) > level
        # Breaks if there no more evolutions or randomnly
        # Randomness applies only if the level is under 50 
        break
      else
        newspecies = evo[2]
      end
      end
    end #end of loop do
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo=pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
      if evo.length<1 && couldevo.length<1
      else
         species=newspecies
      end #end of evolving script
      party[i].name=PBSpecies.getName(species)
      party[i].species=species
      party[i].calcStats
      party[i].resetMoves
      end #end of for
     end
     end
     }