################################################################################
#  PokéFile by TastyRedTomato
#---------------------------------------
# based very loosely on the PVP script by Hansiec
# minor additions by Xeevee10
# please credit when used
# 
# To use:
#   * Create a folder in your game's folder called "Transfer" (otherwise there
#       WILL be errors)
#   * Paste this script above Main
#   * Call "POKEFILE.open" in a script (add to pokegear or NPC)
#
# There are two options when calling the script. 
#  - Create Pokemon Data exports the data of a chosen pokemon to a .poke file and
#    removes the Pokémon from your party.
#  - Load Pokemon Data imports the data from the .poke file and adds it to your
#    party when possible and deletes the specific .poke file.
#
#-------------------------------------------------------------------------------
# Compatibility options
#-------------------------------------------------------------------------------
#
BIRTHSIGNS_SCRIPT = false #set to true when using birthsigns by Lucidious89
SHINYLEAF = false #set to true when using the shinyleaf either independently or in birthsigns
#
#-------------------------------------------------------------------------------
# Other options
#-------------------------------------------------------------------------------
#
GAMECODE_USE = false #set to true when using a game code
GAMECODE = "gamecode" #change this when using the game code to trade between different fangames
TRADEEVOLUTION = true #set to true if you want trade evolutions
#
#------------------------------------------------------------------------------------
# How to add new values (new stats, attributes, however you changed the way mons work
#------------------------------------------------------------------------------------
#
# 1) In class PokemonPackage, add "attr_accessor :nameofyourvalue"
# 2) In module POKEFILECore, go to the comment "#Generate new package".
#    There you add tp.nameofyourvalue = the getter of your value
# 3  Go to def self.loadPokemon(file), at the point where it returns an array with all the data,
#    add your tp.nameofyourvalue after the last one. Note the index in the array.
# 4) Scroll towards the bottom of the script at the comment "#generate pokemon from file",
#    Where the pokemon is generated, add the setter for your new value and use the 
#    pokemon[index]. Take a look at how the existing data is handled if you need examples.
#
#
#------------------------------------------------------------------------------------
# How to make the system cross-fangame 
#(note: only use between fangames that use the same version of this script)
#------------------------------------------------------------------------------------
#
# Set GAMECODE_USE to true.
# Fill out a game code of your choice (preferably one that's hard to guess)
# Do the same for your other game.
# If there are mismatches in the PBS files of both games it will give errors.
#
################################################################################



class PokemonPackage
  attr_accessor :pokemon
  attr_accessor :game_code
  attr_accessor :poke
  #------------------------
  attr_accessor :species
  attr_accessor :ability
  attr_accessor :ballused
  attr_accessor :EV
  attr_accessor :form
  attr_accessor :gender
  attr_accessor :happiness
  attr_accessor :helditem
  attr_accessor :IV
  attr_accessor :language
  attr_accessor :level
  attr_accessor :moveset
  attr_accessor :nature
  attr_accessor :nickname
  attr_accessor :obtaintext
  attr_accessor :pokerus
  attr_accessor :ribbons
  attr_accessor :shadow
  attr_accessor :shiny
  attr_accessor :beauty
  attr_accessor :cool
  attr_accessor :cute
  attr_accessor :smart
  attr_accessor :tough
  attr_accessor :sheen
  attr_accessor :curhp
  attr_accessor :eggsteps
  attr_accessor :exp
  attr_accessor :fused
  attr_accessor :hatchmap
  attr_accessor :hatchtime
  attr_accessor :markings
  attr_accessor :obtainlvl
  attr_accessor :obtainmap
  attr_accessor :obtainmethod
  attr_accessor :trainergender
  attr_accessor :trainerid
  attr_accessor :trainername
  attr_accessor :pokemonid
  attr_accessor :status
  attr_accessor :mail
  #--------------------------
  #compatibilities
  #--------------------------
  #birthsigns/shinyleaf by Lucidious89
  attr_accessor :birthsign 
  attr_accessor :celestial
  attr_accessor :blessed
  attr_accessor :shinyleaf
end

module POKEFILE
  def self.open
    loop do
      commands = []
      commands[cmdDump=commands.length] = "Create Pokémon Data"
      commands[cmdBattle=commands.length] = "Load Pokémon Data"
      commands[cmdExit=commands.length] = "Exit"
      choice = Kernel.pbMessage(_INTL("Welcome to the Transfer station, how may I help you?"),
      commands, 0, nil, 0)
      if choice == cmdDump
        if $Trainer.ablePokemonParty.length > 1 #stops players from export if they have only 1 able pokemon
          Kernel.pbMessage(_INTL("Warning, exporting your Pokémon will overwrite any existing savegames.")) 
          Kernel.pbMessage(_INTL("Warning, this may overwrite existing Pokémon Data for this trainer. Press action to continue.")) 
          if POKEFILECore.createPokeFile
            Kernel.pbMessage(_INTL("Pokémon Data was created in the Transfer folder."))
            Kernel.pbMessage(_INTL("Your game has been saved."))
          else
              Kernel.pbMessage(_INTL("Could not make pokémon data or no pokémon was selected."))
          end
        else
        Kernel.pbMessage(_INTL("You don't have enough able Pokémon in your party right now. A minimum of 2 Pokémon is required.")) 
        end
      elsif choice == cmdBattle
        files = ["Cancel"]
        Dir.chdir("Transfer"){
          Dir.glob("*.poke"){|f|
            files.push(f)
          }
        }
        choice = Kernel.pbMessage(_INTL("select a pokémon file"), files, -1, nil, 0)
        if choice >= 1
          Kernel.pbMessage(_INTL("Warning, importing a Pokémon will overwrite any existing savegames.")) 
          Kernel.pbMessage(_INTL("Warning, this will delete the Pokémon Data for this trainer. Press action to continue.")) 
          file = "Transfer/" + files[choice]
          pokemon = POKEFILECore.loadPokemon(file)
          if pokemon
            if POKEFILECore.addpoke(pokemon)
               File.delete("Transfer/" + files[choice]) if File.exist?("Transfer/" + files[choice])
            end
          else
            Kernel.pbMessage(_INTL("Cannot load pokémon file..."))
          end
        end
      elsif choice == cmdExit
        break
      end
    end
  end


module POKEFILECore
   def self.createPokeFile
    pbChooseTradablePokemon(1,3)
    if $game_variables[1] == -1
      return
    end
    pokechoice = $Trainer.party[$game_variables[1]].clone
    pbRemovePokemonAt($game_variables[1])
    return dumpPokemon(pokechoice)
  end
    
  def self.dumpPokemon(pokechoice) #saves data into a poke file
    f = File.open("Game.ini")
    lines = f.readlines()
    s = lines[3]
    len = s.size
    title = (s[6,len - 7])
    f.close
    #Generate new package
    tp = PokemonPackage.new
    tp.pokemon = $Pokemon
    tp.game_code = title if GAMECODE_USE == false
    tp.game_code = GAMECODE if GAMECODE_USE == true
    tp.poke = pokechoice
    #----------------------------------
    tp.species = pokechoice.species
    tp.ability = pokechoice.ability
    tp.ballused = pokechoice.ballused
    tp.EV = [pokechoice.ev[0],pokechoice.ev[1],pokechoice.ev[2],pokechoice.ev[3],pokechoice.ev[4],pokechoice.ev[5]]
    tp.form = pokechoice.form
    tp.gender = pokechoice.gender
    tp.happiness = pokechoice.happiness
    tp.helditem = pokechoice.item
    tp.IV = [pokechoice.iv[0],pokechoice.iv[1],pokechoice.iv[2],pokechoice.iv[3],pokechoice.iv[4],pokechoice.iv[5]]
    tp.language = pokechoice.language
    tp.level = pokechoice.level
    tp.moveset = [pokechoice.moves[0],pokechoice.moves[1],pokechoice.moves[2],pokechoice.moves[3]]
    tp.nature = pokechoice.nature
    tp.nickname = pokechoice.name
    tp.obtaintext = pokechoice.obtainText
    tp.pokerus = pokechoice.pokerus
    tp.shiny = pokechoice.isShiny?
    tp.shadow = pokechoice.isShadow?
    tp.beauty = pokechoice.beauty
    tp.cool = pokechoice.cool
    tp.cute = pokechoice.cute
    tp.smart = pokechoice.smart
    tp.tough = pokechoice.tough
    tp.sheen = pokechoice.sheen
    tp.curhp = pokechoice.hp
    tp.eggsteps = pokechoice.eggsteps
    tp.exp = pokechoice.exp
    tp.fused = pokechoice.fused
    tp.hatchmap = pokechoice.hatchedMap
    tp.hatchtime = pokechoice.timeEggHatched
    tp.markings = pokechoice.markings
    tp.obtainlvl = pokechoice.level #sets the obtain level to the current level
    tp.obtainmap = $game_map.map_id #sets the obtain location to the current map
    tp.obtainmethod = 2 #sets the obtain mode to traded
    tp.trainergender = pokechoice.otgender
    tp.trainerid = pokechoice.trainerID
    tp.trainername = pokechoice.ot
    tp.pokemonid = pokechoice.personalID
    tp.status = pokechoice.status
    tp.ribbons = pokechoice.ribbons
    tp.mail = pokechoice.mail
    #birthsigns compatibility
    if BIRTHSIGNS_SCRIPT == true
      tp.birthsign = pokechoice.zodiacflag
      tp.celestial = pokechoice.celestial
      tp.blessed = pokechoice.blessed
    else
       tp.birthsign = nil
       tp.celestial = nil
       tp.blessed = nil
    end
    if SHINYLEAF == true
      tp.shinyleaf = pokechoice.leafflag
    else
      tp.shinyleaf = nil
    end
    
    save_data(tp, "Transfer/#{$Trainer.name}'s Lv.#{tp.level} #{pokechoice.name} (#{pokechoice.iv[0]}#{pokechoice.iv[1]}#{pokechoice.iv[2]}).poke")
    pbSave
    return true
  rescue
    return nil
  end
  
  def self.loadPokemon(file) #loads the data and puts it into an array
    f = File.open("Game.ini")
    lines = f.readlines()
    s = lines[3]
    len = s.size
    title = (s[6,len - 7])
    f.close
    tp = load_data(file)
    if GAMECODE_USE == false
      return false if tp.game_code != title #checks if the game is the same
    end
    if GAMECODE_USE == true
      return false if tp.game_code != GAMECODE #checks if the game code is the same
    end
    return [tp.pokemon, tp.game_code, tp.poke, #0-2    returns an array containing the file data
            tp.species, tp.ability, tp.ballused, tp.EV, tp.form, tp.gender, #3-8
            tp.happiness, tp.helditem, tp.IV, tp.language, tp.level, tp.moveset,#9-14
            tp.nature, tp.nickname, tp.obtaintext, tp.pokerus, tp.shiny, tp.shadow,#15-20
            tp.beauty, tp.cool, tp.cute, tp.smart, tp.tough, tp.sheen, tp.curhp,#21-27
            tp.eggsteps, tp.exp, tp.fused, tp.hatchmap, tp.hatchtime, tp.markings,#28-33
            tp.obtainlvl, tp.obtainmap, tp.obtainmethod, tp.trainergender,#34-37
            tp.trainerid, tp.trainername, tp.pokemonid, tp.status,tp.ribbons,tp.mail,#38-43
            #compatibilities
            tp.birthsign,tp.celestial,tp.blessed,tp.shinyleaf]#44-47 birthsign/shinyleaf compatibility
  rescue
    return nil
  end
  
  def self.addpoke(file)
    pokemon = file
    pokemon = loadPokemon(file) if !file.is_a?(Array)
   if !pokemon
     Kernel.pbMessage(_INTL("Could not add the Pokémon. Check file integrity."))
      return false 
    end
   #generate pokemon from file
   pkmn = pbGenPkmn(pokemon[3],pokemon[13]) #generate pokemon with species and level
   pkmn.ballused=pokemon[5] #sets the ball type
   pkmn.ev[0]=pokemon[6][0] #ev1
   pkmn.ev[1]=pokemon[6][1] #ev2
   pkmn.ev[2]=pokemon[6][2] #ev3
   pkmn.ev[3]=pokemon[6][3] #ev4
   pkmn.ev[4]=pokemon[6][4] #ev5
   pkmn.ev[5]=pokemon[6][5] #ev6
   pkmn.form = pokemon[7] #set pokemon form
   if pokemon[8] == 0 #male pokemon
     pkmn.makeMale
   elsif pokemon[8] == 1 #female pokemon
     pkmn.makeFemale
   else
     pkmn.setGender(nil) #other genders catchall (leges etc)
   end
   pkmn.happiness = pokemon[9] #set pokemon happiness
   pkmn.setItem(pokemon[10]) #set the item a pokemon holds
   pkmn.iv[0]=pokemon[11][0] #iv1
   pkmn.iv[1]=pokemon[11][1] #iv2
   pkmn.iv[2]=pokemon[11][2] #iv3
   pkmn.iv[3]=pokemon[11][3] #iv4
   pkmn.iv[4]=pokemon[11][4] #iv5
   pkmn.iv[5]=pokemon[11][5] #iv6
   pkmn.language = pokemon[12] #sets the language of the pokemon
   pkmn.moves[0] = pokemon[14][0] #sets the first move of the pokemon
   pkmn.moves[1] = pokemon[14][1] #sets the second move of the pokemon
   pkmn.moves[2] = pokemon[14][2] #sets the third move of the pokemon
   pkmn.moves[3] = pokemon[14][3] #sets the fourth move of the pokemon
   pkmn.setNature(pokemon[15]) #sets the pokemon's nature
   if pokemon[16] != pkmn.species && pokemon[16].is_a?(String) && pokemon[16].size > 0
      pkmn.name = pokemon[16]
   end
   pkmn.obtainText=_I("Pokémon Transfer") #sets pokemon source
   pkmn.pokerus = pokemon[18]
   if pokemon[19] == true #makes pokemon shiny if it should be
     pkmn.makeShiny
   end
   if pokemon[20] == true #makes pokemon shadow if it should be
     pkmn.makeShadow
   end
   pkmn.beauty = pokemon[21] #set pokemon beauty value
   pkmn.cool = pokemon[22] #set pokemon cool value
   pkmn.cute = pokemon[23] #set pokemon cute value
   pkmn.smart = pokemon[24] #set pokemon smart value
   pkmn.tough = pokemon[25] #set pokemon tough value
   pkmn.sheen = pokemon[26] #set pokemon sheen value
   pkmn.hp = pokemon[27] #sets the pokemon's current hp
   pkmn.eggsteps = pokemon[28] #sets the steps required to hatch, failsafe, unable to trade eggs normally
   pkmn.exp = pokemon[29] #sets current exp
   pkmn.fused = pokemon[30] #sets fused pokemon
   pkmn.hatchedMap = pokemon[31] #sets hatched map id if pokemon came from egg
   pkmn.timeEggHatched = pokemon[32] #time at which it hatched, will not be shown because method is traded
   pkmn.markings = pokemon[33] #markings of the pokemon
   pkmn.obtainMode=2 #method 2, traded
   pkmn.otgender= pokemon[37] #original trainer gender
   pkmn.trainerID = pokemon[38] #original trainer id
   pkmn.ot = pokemon[39] #original trainer name
   pkmn.personalID = pokemon[40] #sets the pokemon ID (used in calculation of ability, gender and nature)
   pkmn.status= pokemon[41] #sets pokemon status ailment
   pkmn.ribbons = pokemon[42] #sets pokemon ribbons
   pkmn.mail = pokemon[43] #sets mail items data
   if BIRTHSIGNS_SCRIPT == true
     pkmn.zodiacflag = pokemon[44] #sets the pokemon's birthsign/zodiac
     pkmn.celestial = pokemon[45] #sets whether a pokemon is celestial or not
     pkmn.blessed = pokemon[46] #sets whether a pokemon is blessed or not
   end
   if SHINYLEAF == true
     pkmn.leafflag = pokemon[47] #sets the pokemon shiny leaf value
   end
   pkmn.calcStats
   if pbAddToPartySilent(pkmn) #this checks if the pokemon can be added to the party and adds it if possible
     if TRADEEVOLUTION #plays the trade evolution scene when all conditions have been met
       newspecies = pbTradeCheckEvolution(pkmn, pkmn.item)
       if newspecies > 0
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn, newspecies)
        evo.pbEvolution
        evo.pbEndScreen
       end
     end
     pbSave
     Kernel.pbMessage(_INTL("The Pokémon was added to your party."))
     Kernel.pbMessage(_INTL("Your game has been saved."))
    return true
   else
    Kernel.pbMessage(_INTL("Could not add the pokémon to party. Make sure you have enough space."))
    return false
   end
 end
end
end