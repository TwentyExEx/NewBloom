def pbItemPool(npc)
  # Define item pools for gifts
  if npc == "Rotom"
    $ADORE = []
    $LOVE = [:CHERIBERRY,:CHESTOBERRY,:PECHABERRY,:RAWSTBERRY,:POTION]
    $LIKE = [:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY]
    $NEUTRAL = [:LUMBERRY,:SITRUSBERRY,:FIGYBERRY,:WIKIBERRY,:ANTIDOTE]
    $DISLIKE = [:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:POMEGBERRY]
    $HATE = [:KELPSYBERRY,:QUALOTBERRY,:HONDEWBERRY,:GREPABERRY,:TAMATOBERRY,:PARALYZEHEAL]
    $AWKWARD = []
  elsif npc == "Bob"
    $LOVE = []
    $LOVE = [:POKEBALL]
    $LIKE = [:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY]
    $NEUTRAL = [:PARALYZEHEAL]
    $DISLIKE = [:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:POMEGBERRY]
    $HATE = [:POTION]
    $AWKWARD = []
  end
end

def pbAffinityVar(npc)
  # Define variables for affinity
  if npc == "Rotom"
    @affinityvariable = 101
  elsif npc == "Bob"
    @affinityvariable = 102
  end
end

def pbGiftItem(npc)
  pbChooseItem(1)
  @item = $game_variables[1]
  if @item != 0
    pbGiftReact(@item,npc)
    if canReceive?(@item,npc)
      $PokemonBag.pbDeleteItem(@item)
    else
      return true
    end
  else
    return false
  end
end

def canReceive?(item,npc)
  pbItemPool(@npc)
  @tiers = [$LOVE, $LIKE, $NEUTRAL, $DISLIKE, $HATE]
  gifts = Array.new
  for i in @tiers
    gifts.concat(i)
  end
  for i in gifts
    giftid = PBItems.getID(PBItems,i)
    return true if giftid == @item
  end 
  return false
end


def pbReactTier(tier,item)
  for i in tier
    giftid = PBItems.getID(PBItems,i)
    return true if giftid == @item
  end
  return false
end

def pbGiftReact(item,npc)
  pbItemPool(npc)
  pbAffinityVar(npc)
  if pbReactTier($ADORE,item)
    $giftreact = "adore"
    $game_variables[@affinityvariable] += 12
  elsif pbReactTier($LOVE,item)
    $giftreact = "love"
    $game_variables[@affinityvariable] += 8
  elsif pbReactTier($LIKE,item)
    $giftreact = "like"
    $game_variables[@affinityvariable] += 4
  elsif pbReactTier($NEUTRAL,item)
    $giftreact = "neutral"
    $game_variables[@affinityvariable] += 2
  elsif pbReactTier($DISLIKE,item)
    $giftreact = "dislike"
    $game_variables[@affinityvariable] -= 2
  elsif pbReactTier($HATE,item)
    $giftreact = "hate"
    $game_variables[@affinityvariable] -= 4
  elsif pbReactTier($AWKWARD,item)
    $giftreact = "love"
    $game_variables[@affinityvariable] -= 8
  else
    $giftreact = "reject"
  end
end

def pbAffinityCheck(npc)
  pbAffinityVar(npc)
  if $game_variables[@affinityvariable] == 0 || $game_variables[@affinityvariable] == nil
    $affinitylevel = "neutral"
  elsif $game_variables[@affinityvariable] < 1 
    $affinitylevel = "bad"
  elsif $game_variables[@affinityvariable] <= 8 && $game_variables[@affinityvariable] >= 1 
    $affinitylevel = "good"
  elsif $game_variables[@affinityvariable] > 8
    $affinitylevel = "great"
  end
  return true
end