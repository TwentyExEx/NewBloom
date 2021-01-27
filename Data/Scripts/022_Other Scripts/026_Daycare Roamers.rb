#===============================================================================
# new Method spawnEvent in Class Game_Map in Script Game_Map
#===============================================================================
class Game_Map
  def spawnEventDaycare(x,y,encounter,gender = nil,form = nil, isShiny = nil)
    #------------------------------------------------------------------
    # generating a new event
    event = RPG::Event.new(x,y)
    event.name = "daycareRoamer"
    #setting the nessassary properties
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    #event.pages[0].graphic.tile_id = 0
    if encounter[0] < 10
      character_name = "00"+encounter[0].to_s
    elsif encounter[0] < 100
      character_name = "0"+encounter[0].to_s
    else
      character_name = encounter[0].to_s
    end
    # use sprite of female pokemon
    character_name = character_name+"f" if USEFEMALESPRITES == true and gender==1 and pbResolveBitmap("Graphics/Characters/"+character_name+"f")
    # use shiny-sprite if probability & killcombo is high or shiny-switch is on
    shinysprite = nil
    if isShiny==true
      character_name = character_name+"s" if USESHINYSPRITES == true and pbResolveBitmap("Graphics/Characters/"+character_name+"s")
      shinysprite = true
      $scene.spriteset.addUserAnimation(SHINY_ANIMATION_ID,event.x,event.y,true,2)
    end
    # use sprite of alternative form
    if USEALTFORMS==true and form!=nil and form!=0
      character_name = character_name+"_"+form.to_s if pbResolveBitmap("Graphics/Characters/"+character_name+"_"+form.to_s)
    end
    event.pages[0].graphic.character_name = character_name
    # we configure the movement of the overworld encounter
    if rand(100) < AGGRESSIVEENCOUNTERPROBABILITY
      event.pages[0].move_type = 3
      event.pages[0].move_speed = AGGRENCMOVESPEED
      event.pages[0].move_frequency = AGGRENCMOVEFREQ
      event.pages[0].move_route.list[0].code = 10
      event.pages[0].move_route.list[1] = RPG::MoveCommand.new
    else
      event.pages[0].move_type = 1
      event.pages[0].move_speed = ENCMOVESPEED
      event.pages[0].move_frequency = ENCMOVEFREQ
    end
    event.pages[0].step_anime = true if USESTOPANIMATION
    # event.pages[0].trigger = 2
    # if !$MapFactory
    #   parameter = "$game_map.removeThisEventfromMap(#{key_id})"
    # else
    #   mapId = $game_map.map_id
    #   parameter = "$MapFactory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
    # end
    # pbPushScript(event.pages[0].list,sprintf(parameter))
    # pbPushEnd(event.pages[0].list)
    #------------------------------------------------------------------
    # creating and adding the Game_Event
    gameEvent = Game_Event.new(@map_id, event, self)
    key_id = (@events.keys.max || -1) + 1
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    @events[key_id] = gameEvent
    #-------------------------------------------------------------------------
    #updating the sprites
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
  end
end

def pbDaycareRoam(num,x,y)
  pokemon = $PokemonGlobal.daycare[num][0]
  spec = [pokemon.species,pokemon.level]
  gender = pokemon.gender if USEFEMALESPRITES == true
  form = pokemon.form if USEALTFORMS == true  
  isShiny = pokemon.isShiny?
  pbPlaceDaycare(x,y,spec,gender,form,isShiny)
end

def pbPlaceDaycare(x,y,spec,gender = nil,form = nil,isShiny = nil)
  if !$MapFactory
    $game_map.spawnEventDaycare(x,y,spec,gender,form,isShiny)
  else
    mapId = $game_map.map_id
    spawnMap = $MapFactory.getMap(mapId)
    spawnMap.spawnEventDaycare(x,y,spec,gender,form,isShiny)
  end
end