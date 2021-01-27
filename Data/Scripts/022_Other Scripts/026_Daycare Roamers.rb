# Settings

$DAYCARE_ID_0 = 19 # Event ID of Daycare Pokemon 0
$DAYCARE_ID_1 = 20 # Event ID of Daycare Pokemon 1

class Game_Map
  def spawnEventDaycare(x,y,spec,gender = nil,form = nil, isShiny = nil)
    #------------------------------------------------------------------
    # remaking the event
    event = RPG::Event.new(x,y)
    event.name = "daycareRoamer"
    #setting the nessassary properties
    key_id = $last_id
    event.id = key_id
    event.x = x
    event.y = y
    #event.pages[0].graphic.tile_id = 0
    if spec[0] < 10
      character_name = "00"+spec[0].to_s
    elsif spec[0] < 100
      character_name = "0"+spec[0].to_s
    else
      character_name = spec[0].to_s
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
    event.pages[0].move_type = 1
    event.pages[0].move_speed = 3
    event.pages[0].move_frequency = 3
    event.pages[0].step_anime = true
    event.pages[0].trigger = 0
    if !$MapFactory
      parameter = "$game_map.removeThisEventfromMap(#{@event_id})"
    else
      eventID = $game_map.map_id
      parameter = "pbDaycareInteract"
    end
    pbPushScript(event.pages[0].list,sprintf(parameter))
    pbPushEnd(event.pages[0].list)
    #------------------------------------------------------------------
    # creating and adding the Game_Event
    gameEvent = Game_Event.new(@map_id, event, self)
    key_id = $last_id
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    @events[key_id] = gameEvent
    #-------------------------------------------------------------------------
    #updating the sprites
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
  end
end

def pbDaycareRoam(num)
  thisevent = $game_map.events[@event_id]
  x = thisevent.x
  y = thisevent.y
  $last_id = @event_id
  $game_map.removeThisEventfromMap(@event_id)
  if $PokemonGlobal.daycare[num][0]
    pokemon = $PokemonGlobal.daycare[num][0]
    spec = [pokemon.species,pokemon.level]
    gender = pokemon.gender if USEFEMALESPRITES == true
    form = pokemon.form if USEALTFORMS == true
    isShiny = pokemon.isShiny?
    pbPlaceDaycare(x,y,spec,gender,form,isShiny)
  end
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

def pbDaycareInteract
  if @event_id == $DAYCARE_ID_0
    daycarenum = 0
  elsif @event_id == $DAYCARE_ID_1
    daycarenum = 1
  end
  pokemon = $PokemonGlobal.daycare[daycarenum][0]
  pbPlayCry(pokemon.species)
end