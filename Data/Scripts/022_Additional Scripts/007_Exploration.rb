#===============================================================================
# Pokemon Exploration - By Vendily [v17]
#===============================================================================
# This script adds in Pokemon Exploration, where you send off your pokemon to
#  find items. It's loosely based off one of the Poke Pelago Islands.
# Each pokemon in an exploration team has a TREASURERATE% chance of finding an
#  item. The Treasure pool is defined before the expedition begins.
#===============================================================================
# To use it, you must create an event that takes the pokemon, using 
#  pbChooseNonEggPokemon to select the pokemon and pbExplorationDeposit to
#  to deposit them, taking the party index as an argument. The script has no
#  restriction on the length of the exploration team, but only 8 pokemon fit on
#  the included display screen. 9 pokemon causes them to get cut in half.
# Next, you must call pbExplorationItemPool with an array of item ids or symbols
#  to define the possible treasure that a pokemon can find. The script picks one
#  at random, so just include duplicate entries to weigh items more or less
#  commonly.
# To start an exploration, call pbExplorationState.pbStart(steps), where steps
#  is the number of steps required to complete the expedition.
# To check if an expedition is complete after starting it, call 
#  pbExplorationState.inProgress?, which returns true if there are still more 
#  steps remaining.
# After an expedition, call pbRecieveExplorationItems to receive any items found.
#  If the player does not have room, the excess items are lost. To return the
#  pokemon, call pbExplorationChoose, which takes the text to say and the variable
#  to save the selected index, and give the resulting index to
#  pbExplorationWithdraw, which actually returns the pokemon. Neither method 
#  checks if there is space in the party, and the latter will raise an error if
#  you give an index that does not exist.
# Included is a display that shows the current party, the remaining steps and the
#  the last item found. call it with
#   pbFadeOutIn(99999){ 
#     scene =PokemonExploration_Scene.new
#     screen=PokemonExplorationScreen.new(scene)
#     screen.pbStartScreen
#   }
#===============================================================================
# * The percent chance a pokemon will find an item each step. This is per
#    pokemon, not per team, so lower values are recommended. (Default 1)
#===============================================================================

# Item Pools
$CAVEPOOL = [:FIRESTONE,:THUNDERSTONE,:WATERSTONE,:LEAFSTONE,:MOONSTONE,:SUNSTONE,:DUSKSTONE,:DAWNSTONE,:SHINYSTONE,:ICESTONE,:HEATROCK,:DAMPROCK,:SMOOTHROCK,:ICYROCK,:LIGHTCLAY,:NUGGET,:BIGNUGGET,:RAREBONE,:PEARLSTRING,:STARPIECE]
$FORESTPOOL = [:FIRESTONE,:THUNDERSTONE,:WATERSTONE,:LEAFSTONE,:MOONSTONE,:SUNSTONE,:DUSKSTONE,:DAWNSTONE,:SHINYSTONE,:ICESTONE,:SWEETAPPLE,:TARTAPPLE,:CRACKEDPOT,:GROWTHMULCH,:DAMPMULCH,:STABLEMULCH,:GOOEYMULCH,:BIGMUSHROOM,:BALMMUSHROOM,:PEARL,:BIGPEARL,:TINYMUSHROOM,:NUGGET,:BIGNUGGET,:PEARLSTRING,:STARPIECE]


TREASURERATE  = 1

class ExplorationState
  attr_accessor :party
  attr_accessor :steps
  attr_accessor :startingSteps
  attr_accessor :treasure
  attr_accessor :treasurePool
  
  def initialize
    @party=[]
    @steps=0
    @startingSteps=0
    @inProgress=false
    @treasure=[]
    @treasurePool=[]
  end
  
  def partyCount
    return @party.length
  end
  
  def inProgress?
    return @inProgress
  end
  
  def pbStart(steps)
    @steps=steps
    @startingSteps=steps
    @treasure=[]
    @inProgress=true
  end

  def pbEnd
    @steps=0
    @inProgress=false
    @treasurePool=[]
  end
  
  def findTreasure
    randnum = rand(200) # edit here, original 100
    if randnum<TREASURERATE
      index=rand(@treasurePool.length)
      @treasure.push(@treasurePool[index])
    end
  end
  
end

class PokemonGlobalMetadata
  attr_accessor :explorationState
end

def pbExplorationState
  if !$PokemonGlobal.explorationState
    $PokemonGlobal.explorationState=ExplorationState.new
  end
  return $PokemonGlobal.explorationState
end

def pbExplorationDeposit(index)
  pbExplorationState.party.push($Trainer.party[index])
  pbExplorationState.party[-1].heal
  $Trainer.party[index]=nil
  $Trainer.party.compact!
  $PokemonTemp.dependentEvents.refresh_sprite # edit here
end

def pbExplorationWithdraw(index)
  if !pbExplorationState.party[index]
    raise _INTL("There's no Pokémon here...")
  elsif $Trainer.party.length>=6
    raise _INTL("Can't store the Pokémon...")
  else
    $Trainer.party[$Trainer.party.length]=pbExplorationState.party[index]
    pbExplorationState.party[index]=nil
    pbExplorationState.party.compact!
  end
end

def pbExplorationChoose(text,indexvariable,namevariable)
  count=pbExplorationState.partyCount
  if count==0
    raise _INTL("There's no Pokémon here...")
  else
    choices=[]
    for i in 0...count
      pokemon=pbExplorationState.party[i]
      if pokemon.isMale?
        choices.push(_ISPRINTF("{1:s} (♂, Lv{2:d})",pokemon.name,pokemon.level))
      elsif pokemon.isFemale?
        choices.push(_ISPRINTF("{1:s} (♀, Lv{2:d})",pokemon.name,pokemon.level))
      else
        choices.push(_ISPRINTF("{1:s} (Lv{2:d})",pokemon.name,pokemon.level))
      end
    end
    choices.push(_INTL("CANCEL"))
    command=pbMessage(text,choices,choices.length)
    $game_variables[indexvariable]=(command==(choices.length-1)) ? -1 : command
    $game_variables[namevariable]=(command==(choices.length-1)) ? -1 : 
                      pbExplorationState.party[command].name
  end
end

def pbRecieveExplorationItems
  treasure = []
  ret=false
  if pbExplorationState.treasure.length>0
    ret=true
    items=pbExplorationState.treasure
    items.each do |item|
      unless treasure.include?(item)
        treasure.push(item)
        treasure.push(1)   
      else
        temp = treasure.index(item)
        treasure[temp+1] +=1
      end
    end
    while treasure[0]
      item = treasure.shift
      qty = treasure.shift       
      pbReceiveItem(item,qty)
    end
  end
  pbExplorationState.treasure=[]
  return ret
end

def pbExplorationItemPool(items)
  for i in 0...items.length
     items[i]=getID(PBItems,items[i])
  end
  pbExplorationState.treasurePool=items
end

class PokemonExploration_Scene
  BACKCOLOUR=Color.new(255,255,162)
  FILLCOLOUR=Color.new(50,170,40)
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Pokegear/bg")
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["duration"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["elapsed"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["elapsed"].z=100
    @sprites["lastitem"] = ItemIconSprite.new(160,300,-1,@viewport)
    pbDrawExplorers
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawExplorers
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    for i in 0...pbExplorationState.partyCount
      x = 256 - (pbExplorationState.partyCount*32) + (i*64)
      @sprites["pokemon#{i}"]=PokemonIconSprite.new(pbExplorationState.party[i],@viewport)
      @sprites["pokemon#{i}"].x=x
      @sprites["pokemon#{i}"].y=(Graphics.height-96)/2
      @sprites["pokemon#{i}"].mirror=true
    end
    totalsteps=pbExplorationState.startingSteps
    stepstaken=pbExplorationState.steps
    timegauge = (totalsteps==0) ? 448 : stepstaken*448/totalsteps
    @sprites["duration"].bitmap.clear
    @sprites["duration"].bitmap.fill_rect(32,222,448,8,BACKCOLOUR)
    @sprites["elapsed"].bitmap.clear
    @sprites["elapsed"].bitmap.fill_rect(32,222,timegauge,8,FILLCOLOUR)
    lastitem=pbExplorationState.treasure[-1]
    @sprites["lastitem"].item=lastitem ? lastitem : -1
    textpos=[]
    if pbExplorationState.inProgress?
      textpos.push([_INTL("{1} steps remaining",stepstaken),256,236,2,Color.new(232,232,232),Color.new(136,136,136)])
    else
      textpos.push([_INTL("No Exploration"),256,236,2,Color.new(232,232,232),Color.new(136,136,136)])
    end
    if lastitem
      textpos.push([_INTL("Last Item: {1}",PBItems.getName(lastitem)),192,284,0,Color.new(232,232,232),Color.new(136,136,136)])
    end
    pbDrawTextPositions(overlay,textpos)
  end
  
  def pbMiddleScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::B)
        break
      end
    end 
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end



class PokemonExplorationScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbMiddleScene
    @scene.pbEndScene
  end
end

Events.onStepTaken+=proc {|sender,e|
  next if !pbExplorationState.inProgress?
  for i in 0...pbExplorationState.partyCount
    pbExplorationState.findTreasure
  end
  pbExplorationState.steps-=1
  if pbExplorationState.steps<=0
    pbExplorationState.pbEnd
  end
}