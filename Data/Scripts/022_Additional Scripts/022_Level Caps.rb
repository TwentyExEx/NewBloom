#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                        Simple Customizable Level Caps                        #
#                                     v1.0                                     #
#                               By Golisopod User                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
# Implements very simple level caps feature in Pokemon Essentials. The script  #
# not only blocks gaining experience in battle. It also prevents any level     #
# up attempts outside battles. It also blocks any attempts to use Rare Candies #
# and EXP Candies. There are 2 main Level Cap methods in this script.          #
#                                                                              #
# Hard Cap: Similar to Pokemon Reborn, the Pokemon will not gain any exp       #
#           once it has reached the Level Cap. It will block usage of all      #
#           items as well.                                                     #
#                                                                              #
# Soft Cap: Similar to Pokemon Clover, the Pokemon will only gain a fraction   #
#           exp it would gain once it has reached the Level Cap. It will block #
#           usage of all items as well.                                        #
#                                                                              #
# This Script is meant for the default Essentials v18. I have no plan for      #
# supporting older versions.                                                   #
#                                                                              #
#==============================================================================#
#                              INSTRUCTIONS                                    #
#------------------------------------------------------------------------------#
# 1. Place this in a New Script Section above Main                             #
# 2. Edit the Customizable Options                                             #
# 3. Start a new save (Not nescessary, but just to be on the safe side)        #
#                                                                              #
# Note that the level caps aren't applied when in Debug Mode.                  #
#------------------------------------------------------------------------------#
#                          CUSTOMIZABLE OPTIONS                                #
#==============================================================================#
GYM_BASED = true # Set this to true if you want the Lv Caps to use the number of
                 # badges as the factor to decide the level cap

HARD_CAP = false # Set this to true if you want the Lv Caps to use the number of
                 # badges as the factor to decide the level cap

VARIABLE_USED = 0 # Set this to a game variable number if you want the Lv Caps
                  # to use a value other than game variables. If this is set
                  # then GYM_BASED must be set to false.

LEVEL_CAPS = [10,20,30,40,50,60,70,80,100] # Array to store the level caps.
                                           # The cap is determined by Array
                                           # Index. So if tour variable is value
                                           # 4 or you are at the 4th Gym, then the
                                           # cap will be the the (4+1)th value
                                           # in the array. (In this case 50)
#==============================================================================#
#//////////////////////////////////////////////////////////////////////////////#
#==============================================================================#

class PokeBattle_Battle
  def pbGainExpOne(idxParty,defeatedBattler,numPartic,expShare,expAll,showMessages=true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
    growthRate = pkmn.growthrate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp>=PBExperience.pbGetMaxExperience(growthRate)
      pkmn.calcStats   # To ensure new EVs still have an effect
      return
    end
    isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level*defeatedBattler.pokemon.baseExp
    if expShare.length>0 && (isPartic || hasExpShare)
      if numPartic==0   # No participants, all Exp goes to Exp Share holders
        exp = a/(SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a/(2*numPartic) if isPartic
        exp += a/(2*expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a/2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a/(SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a/2
    end
    return if exp<=0
    # Pokémon gain more Exp from trainer battles
    exp = (exp*1.5).floor if trainerBattle?
    # Scale the gained Exp based on the gainer's level (or not)
    if SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = (2*level+10.0)/(pkmn.level+level+10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.trainerID!=pbPlayer.id ||
                 (pkmn.language!=0 && pkmn.language!=pbPlayer.language))
    if isOutsider
      if pkmn.language!=0 && pkmn.language!=pbPlayer.language
        exp = (exp*1.7).floor
      else
        exp = (exp*1.5).floor
      end
    end
    # Modify Exp gain based on pkmn's held item
    i = BattleHandlers.triggerExpGainModifierItem(pkmn.item,pkmn,exp)
    if i<0
      i = BattleHandlers.triggerExpGainModifierItem(@initialItems[0][idxParty],pkmn,exp)
    end
    exp = (exp*1.5).floor if hasConst?(PBItems,:EXPCHARM) && $PokemonBag.pbHasItem?(:EXPCHARM)
    exp = i if i>=0
    # Make sure Exp doesn't exceed the maximum
    if GYM_BASED
      levelCap=LEVEL_CAPS[$Trainer.numbadges]
    else
      if $game_variables[VARIABLE_USED].is_a(Numeric)
        levelCap=LEVEL_CAPS[$game_variables[VARIABLE_USED]]
      else
        levelCap = PBExperience.maxLevel
      end
    end
    levelCap = PBExperience.maxLevel if !levelCap.is_a?(Numeric)
    return if pkmn.level>levelCap && !$DEBUG && HARD_CAP
    if pkmn.level>levelCap && !$DEBUG
      if pkmn.level>levelCap+10
        exp = 2
      else
        exp = (exp/100).floor
      end
      exp = 2 if exp < 2
      expFinal=PBExperience.pbAddExperience(pkmn.exp,2,growthRate)
    else
      expFinal=PBExperience.pbAddExperience(pkmn.exp,exp,growthRate)
    end
  #  expFinal=PBExperience.pbAddExperience(pkmn.exp,exp,growthRate)
    expGained = expFinal-pkmn.exp
    return if expGained<=0
    # "Exp gained" message
    if showMessages
      if pkmn.level>levelCap && !$DEBUG
        pbDisplayPaused(_INTL("{1} gained a meager {2} Exp. Points.",pkmn.name,expGained))
      elsif isOutsider
        pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!",pkmn.name,expGained))
      else
        pbDisplayPaused(_INTL("{1} got {2} Exp. Points!",pkmn.name,expGained))
      end
    end
    curLevel = pkmn.level
    newLevel = PBExperience.pbGetLevelFromExperience(expFinal,growthRate)
    if newLevel<curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise RuntimeError.new(
         _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
         pkmn.name,debugInfo))
    end
    # Give Exp
    if pkmn.shadowPokemon?
      pkmn.exp += expGained
      return
    end
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = PBExperience.pbGetStartExperience(curLevel,growthRate)
      levelMaxExp = PBExperience.pbGetStartExperience(curLevel+1,growthRate)
      tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      @scene.pbEXPBar(battler,levelMinExp,levelMaxExp,tempExp1,tempExp2)
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel>newLevel
        # Gained all the Exp now, end the animation
        pkmn.calcStats
        battler.pbUpdate(false) if battler
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
      # Levelled up
      pbCommonAnimation("LevelUp",battler) if battler
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
      if battler && battler.pokemon
        battler.pokemon.changeHappiness("levelup")
      end
      pkmn.calcStats
      battler.pbUpdate(false) if battler
      @scene.pbRefreshOne(battler.index) if battler
      pbDisplayPaused(_INTL("{1} grew to Lv. {2}!",pkmn.name,curLevel))
      @scene.pbLevelUp(pkmn,battler,oldTotalHP,oldAttack,oldDefense,
                                    oldSpAtk,oldSpDef,oldSpeed)
      # Learn all moves learned at this level
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(idxParty,m[1]) if m[0]==curLevel }
    end
  end
end

def pbChangeLevel(pkmn,newlevel,scene)
  newlevel = 1 if newlevel<1
  mLevel = PBExperience.maxLevel
  newlevel = mLevel if newlevel>mLevel
  levelCap=mLevel
  if GYM_BASED
    levelCap=LEVEL_CAPS[$Trainer.numbadges]
  else
    levelCap=LEVEL_CAPS[$game_variables[VARIABLE_USED]]
  end
  levelCap = PBExperience.maxLevel if !levelCap.is_a?(Numeric)
  if newlevel > levelCap && !$DEBUG
    pbMessage(_INTL("{1}'s level remained unchanged.",pkmn.name))
    return false
  elsif pkmn.level==newlevel
    pbMessage(_INTL("{1}'s level remained unchanged.",pkmn.name))
  elsif pkmn.level>newlevel
    attackdiff  = pkmn.attack
    defensediff = pkmn.defense
    speeddiff   = pkmn.speed
    spatkdiff   = pkmn.spatk
    spdefdiff   = pkmn.spdef
    totalhpdiff = pkmn.totalhp
    pkmn.level = newlevel
    pkmn.calcStats
    scene.pbRefresh
    pbMessage(_INTL("{1} dropped to Lv. {2}!",pkmn.name,pkmn.level))
    attackdiff  = pkmn.attack-attackdiff
    defensediff = pkmn.defense-defensediff
    speeddiff   = pkmn.speed-speeddiff
    spatkdiff   = pkmn.spatk-spatkdiff
    spdefdiff   = pkmn.spdef-spdefdiff
    totalhpdiff = pkmn.totalhp-totalhpdiff
    pbTopRightWindow(_INTL("Max. HP<r>{1}\r\nAttack<r>{2}\r\nDefense<r>{3}\r\nSp. Atk<r>{4}\r\nSp. Def<r>{5}\r\nSpeed<r>{6}",
       totalhpdiff,attackdiff,defensediff,spatkdiff,spdefdiff,speeddiff))
    pbTopRightWindow(_INTL("Max. HP<r>{1}\r\nAttack<r>{2}\r\nDefense<r>{3}\r\nSp. Atk<r>{4}\r\nSp. Def<r>{5}\r\nSpeed<r>{6}",
       pkmn.totalhp,pkmn.attack,pkmn.defense,pkmn.spatk,pkmn.spdef,pkmn.speed))
  else
    attackdiff  = pkmn.attack
    defensediff = pkmn.defense
    speeddiff   = pkmn.speed
    spatkdiff   = pkmn.spatk
    spdefdiff   = pkmn.spdef
    totalhpdiff = pkmn.totalhp
    pkmn.level = newlevel
    pkmn.changeHappiness("vitamin")
    pkmn.calcStats
    scene.pbRefresh
    if scene.is_a?(PokemonPartyScreen)
      scene.pbDisplay(_INTL("{1} grew to Lv. {2}!",pkmn.name,pkmn.level))
    else
      pbMessage(_INTL("{1} grew to Lv. {2}!",pkmn.name,pkmn.level))
    end
    attackdiff  = pkmn.attack-attackdiff
    defensediff = pkmn.defense-defensediff
    speeddiff   = pkmn.speed-speeddiff
    spatkdiff   = pkmn.spatk-spatkdiff
    spdefdiff   = pkmn.spdef-spdefdiff
    totalhpdiff = pkmn.totalhp-totalhpdiff
    pbTopRightWindow(_INTL("Max. HP<r>+{1}\r\nAttack<r>+{2}\r\nDefense<r>+{3}\r\nSp. Atk<r>+{4}\r\nSp. Def<r>+{5}\r\nSpeed<r>+{6}",
       totalhpdiff,attackdiff,defensediff,spatkdiff,spdefdiff,speeddiff),scene)
    pbTopRightWindow(_INTL("Max. HP<r>{1}\r\nAttack<r>{2}\r\nDefense<r>{3}\r\nSp. Atk<r>{4}\r\nSp. Def<r>{5}\r\nSpeed<r>{6}",
       pkmn.totalhp,pkmn.attack,pkmn.defense,pkmn.spatk,pkmn.spdef,pkmn.speed),scene)
    # Learn new moves upon level up
    movelist = pkmn.getMoveList
    for i in movelist
      next if i[0]!=pkmn.level
      pbLearnMove(pkmn,i[1],true) { scene.pbUpdate }
    end
    # Check for evolution
    newspecies = pbCheckEvolution(pkmn)
    if newspecies>0
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn,newspecies)
        evo.pbEvolution
        evo.pbEndScreen
        scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
      }
    end
  end
end

ItemHandlers::UseOnPokemon.add(:RARECANDY,proc { |item,pkmn,scene|
  levelCap=PBExperience.maxLevel
  if GYM_BASED
    levelCap=LEVEL_CAPS[$Trainer.numbadges]
  else
    levelCap=LEVEL_CAPS[$game_variables[VARIABLE_USED]]
  end
    levelCap = PBExperience.maxLevel if !levelCap.is_a?(Numeric)
  if pkmn.level>=PBExperience.maxLevel || pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif pkmn.level>levelCap && !$DEBUG
    scene.pbDisplay(_INTL("{1} refuses to eat the Rare Candy.",pkmn.name))
    next false
  end
  pbChangeLevel(pkmn,pkmn.level+1,scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:EXPCANDYXS,proc { |item,pkmn,scene|
   if pkmn.level>=PBExperience::maxLevel || (pokemon.isShadow? rescue false)
     scene.pbDisplay(_INTL("It won't have any effect."))
     next false
   else
     experience=100   if isConst?(item,PBItems,:EXPCANDYXS)
     experience=800   if isConst?(item,PBItems,:EXPCANDYS)
     experience=3000  if isConst?(item,PBItems,:EXPCANDYM)
     experience=10000 if isConst?(item,PBItems,:EXPCANDYL)
     experience=30000 if isConst?(item,PBItems,:EXPCANDYXL)
     newexp=PBExperience.pbAddExperience(pkmn.exp,experience,pkmn.growthrate)
     newlevel=PBExperience.pbGetLevelFromExperience(newexp,pkmn.growthrate)
     curlevel=pkmn.level
     leveldif = newlevel - curlevel
     levelCap=PBExperience.maxLevel
     if GYM_BASED
       levelCap=LEVEL_CAPS[$Trainer.numbadges]
     else
       levelCap=LEVEL_CAPS[$game_variables[VARIABLE_USED]]
     end
     levelCap = PBExperience.maxLevel if !levelCap.is_a?(Numeric)
     if leveldif>1 && newlevel > levelCap && !$DEBUG
       scene.pbDisplay(_INTL("{1} refuses to eat the Candy.",pkmn.name))
       next false
     end
     if PBExperience.pbGetMaxExperience(pkmn.growthrate) < (pkmn.exp + experience)
       scene.pbDisplay(_INTL("Your Pokémon gained {1} Exp. Points!",(PBExperience.pbGetMaxExperience(pkmn.growthrate)-pkmn.exp)))
     else
       scene.pbDisplay(_INTL("Your Pokémon gained {1} Exp. Points!",experience))
     end
     if newlevel==curlevel
       pkmn.exp=newexp
       pkmn.calcStats
       scene.pbRefresh
     else
       leveldif.times do
         pbChangeLevel(pkmn,pkmn.level+1,scene)
         scene.pbHardRefresh
       end
       next true
     end
   end
})

ItemHandlers::UseOnPokemon.copy(:EXPCANDYXS,:EXPCANDYS,:EXPCANDYM,:EXPCANDYL,:EXPCANDYXL)
