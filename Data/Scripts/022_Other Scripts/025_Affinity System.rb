# Define reaction pool for gifts for each NPC
LOVE = [:CHERIBERRY,:CHESTOBERRY,:PECHABERRY,:RAWSTBERRY,:POTION]
LIKE = [:ASPEARBERRY,:LEPPABERRY,:ORANBERRY,:PERSIMBERRY]
NEUTRAL = [:LUMBERRY,:SITRUSBERRY,:FIGYBERRY,:WIKIBERRY]
DISLIKE = [:MAGOBERRY,:AGUAVBERRY,:IAPAPABERRY,:POMEGBERRY]
HATE = [:KELPSYBERRY,:QUALOTBERRY,:HONDEWBERRY,:GREPABERRY,:TAMATOBERRY]
TIERS = [LOVE, LIKE, NEUTRAL, DISLIKE, HATE]

def pbGiftItem
  pbChooseItem(1)
  item = $game_variables[1]
  if canReceive?(item)
    pbMessage(_INTL("thank u for this wonderful {1}. i owe u my life and my firstborn child.",PBItems.getName(item)))
    $PokemonBag.pbDeleteItem(item)
  else
    pbMessage("idk wtf u expect me to do with this. keep it. *spits*")
  end
end

def canReceive?(item)
  gifts = Array.new
  for i in TIERS
    gifts.concat(i)
  end
  for i in gifts
    giftid = PBItems.getID(PBItems,i)
    return true if giftid == item
  end 
  return false
end