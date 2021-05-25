#===============================================================================
# * Character Costumization by Wolf Heretic
# * Based Heavily on a script by shiney570
#   Version: 2.0.0
#===============================================================================
#
# NOTES:
# - Do not name two different items the same name. (Ie. If I have a headgear item
# called Ring and an accessory called Ring, this will lead to undefined behavior
# and could make your game crash)
# - You cannot lock all of the items for some bodypart. This will cause the game
# to crash in the characterization screen.
# - This script alters how a character's metadata is called and how the game loads
# and saves data. Be aware of this ifyou're using other scripts which edit these
# aspects of default essentials.
# - pbChooseBaseGraphic should only be called after the player's character (In 
# default essentials gender) and name are defined.
#
# Set to false to disable the Character Customization.
CHARACTER_CUSTOMIZATION                   = true
# Set to false to lock the Character Customization to unlock it manually at a
# point later in the game.
UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT = true
# whether to also fusion the base graphic or not. Remember:
USE_BASE_GRAPHIC                          = true

=begin
ROUGH EXPLANATION FOR CLOTHING ARRAYS:
When setting up the arrays below, its important to note the following structure
of the arrays representing the possible costumes a player can equip.

1. The initial array describes the Bodypart (ie. Hair, Top, Accessories).
It is an array which is made up of multiple "Items", or subarrays representing
each item that can be equipped by the player.

2. The second layer describes each item (Ie. For Headgear, the items could be
glasses, a tophat, and a helmet). Each item is an array with two entries, the
"Names" of the item for each character(in default essentials each gender) and
either a "Variant" array representing the different types/colors of the item the
player can equip or a boolean representing whether the item is unlocked by default.
  a. Names: An array of strings representing the names of an item for different
  characters. The number of names in this array should equal the number
  of characters your game has. In default essentials, there are two characters (Male character
  & female), so if you haven't changed that there should be two names in this array.
  b. Variant: Is optional. If the player only wants one version of the item, instead
  of writing an array they should write either true or false for whether they want
  the item initially unlocked. Variant is explained in more detail next.
  
3. The third layer describes each variant of the previous item, if there is more
than one (Ie. If the item selected was a T-shirt, then the variants could be Blue,
Red, Yellow, etc. for each color of the T-shirt). Each variant array consists of 
the name of the variant and a boolean representing whether the variant of that 
item is unlocked by default.
  a. Name: The name of the variant (ie. "Orange"). Should be a string.
  b. Unlocked?: A true or false value representing whether or not this specific
  variant should be unlocked initially.

Also here's a diagram for what everything all of the items consist of

    [ Bodypart ]
        ||
        \/
[Item[0], Item[1],...]
           ||
           \/
    [Names, Variants(Optional)]
       ||                 ||
       \/                 \/
[BoyName,GirlName]  [Variant[0], Variant[1],...]
(Default Essentials)  ||
                      \/
                [Name, Unlocked?]

Hope this helped! If not then maybe you can get something from the initial
arrays down below.

=end


# Names of the hairstyles in order. (true= unlocked by default, false=locked by default)
HAIR_ITEMS=[
[["Bald", "Bald"], true],
[["Spikey", "Long"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
  ["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
  ["Red",false], ["White",true]]],
[["Short", "Short"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
  ["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
  ["Red",false], ["White",true]]],
[["Medium", "Medium"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
  ["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
  ["Red",false], ["White",true]]],
[["Slicked Back", "Ponytail"], [["Black",true],["Cyan",false],["Blonde",true],["Blue",false],
  ["Brown",true],["Ginger",true],["Green",false],["Pink",false],["Violet",false],
  ["Red",false], ["White",true]]]
]

# Names of the top items in order. (true= unlocked by default, false=locked by default)
TOP_ITEMS=[
[["No Top","No Top"],true],
[["Beach Top","Beach Top"], [["Black",false],["Blue",false],["Green",false],["Pink",false],
  ["Red",false]]],
[["Classy Top","Classy Top"], [["Beige",false],["Black",false],["Grey",false],
  ["Navy",false], ["Wine",false]]],
[["Collared Shirt","Collared Shirt"], [["Black",true], ["Light Blue",true], ["Navy",true],
  ["White",true], ["Wine",true]]],
[["Formal Top","Formal Top"], [["Black",true], ["Beige",true], ["Blue",true],
  ["Pink",true], ["Red",true]]],
[["Hoodie","Hoodie"], [["Black",true], ["Blue",true], ["Green",true], ["Purple",true], 
  ["Red",true]]],
[["Jumpsuit Top","Jumpsuit Top"], [["Black",true], ["Blue",true], ["Green",true],
  ["Red",true], ["Yellow",true]]],
[["Alternate Jumpsuit Top","Alternate Jumpsuit Top"], [["Blue",false],["Green",false],
  ["Red",false], ["Black",false], ["Yellow",false]]],
[["Lord Suit Top","Lord Suit Top"], [["Purple",false],["Red",false]]],
[["Open Jacket","Open Jacket"], [["Blue",true], ["Green",true], ["Orange",true],
  ["Pink",true], ["Red",true]]],
[["Scarf Shirt","Scarf Shirt"], [["Black",true], ["Blue",true], ["Brown",true],
  ["Red",true], ["Yellow",true]]],
[["School Top","School Top"], [["Light",false],["Dark",false]]],
[["Shirt Combo","Shirt Combo"], [["Black",true], ["Blue",true], ["Red",true],
  ["White",true], ["Wine",true]]],
[["Tank Top","Tank Top"], [["Black",true], ["Green",true], ["Navy",true],
  ["Pink",true], ["Red",true]]],
[["Trenchcoat","Trenchcoat"], [["Beige",true], ["Black",true], ["Navy",true],
  ["Purple",true], ["Red",true]]],
[["T-Shirt","T-Shirt"], [["Black",true], ["Blue",true], ["Green",true], ["Red",true], 
  ["White",true]]],
[["Turtleneck","Turtleneck"], [["Beige",false], ["Black",false], ["Green",false],
  ["White",false], ["Wine",false]]],
[["Vest","Vest"], [["Black",false], ["Blue",false], ["Brown",false], ["Grey",false], 
  ["Wine",false]]],
[["V-Neck","V-Neck"], [["Black",true], ["Green",true], ["Orange",true], ["Purple",true], 
  ["Yellow",true]]]
]

# Names of the bottoms in order. (true= unlocked by default, false=locked by default)
BOTTOM_ITEMS=[
[["No Bottom","No Bottom"],true],
[["Beach Bottom","Beach Bottom"], [["Black",false],["Blue",false],["Green",false],
  ["Pink",false], ["Red",false]]],
[["Capris","Capris"], [["Aqua",true], ["Beige",true], ["Black",true], ["Green",true], 
  ["Navy",true]]],
[["Classy Bottom","Classy Bottom"], [["Beige",false],["Black",false],["Grey",false],
  ["Navy",false], ["Wine",false]]],
[["Formal Bottom","Formal Bottom"], [["Black",true], ["Blue",true], ["Brown",true],
  ["Grey",true], ["Pink",true]]],
[["Jeans","Jeans"], [["Aqua",true], ["Black",true], ["Grey",true], ["Light Blue",true], 
  ["Navy",true]]],
[["Jumpsuit Pants","Jumpsuit Pants"], [["Black",true], ["Blue",true], ["Green",true],
  ["Red",true], ["Yellow",true]]],
[["Alternate Jumpsuit Pants","Alternate Jumpsuit Pants"], [["Blue",false],
  ["Green",false], ["Red",false], ["Black",false], ["Yellow",false]]],
[["Lord Suit Pants","Lord Suit Pants"], false],
[["Long Skirt","Long Skirt"], [["Black",true], ["Blue",true], ["Green",true],
  ["Pink",true], ["Purple",true]]],
[["Pants & Boots","Pants & Boots"], [["Beige",true], ["Black",true], ["Grey",true], 
  ["Light Blue",true], ["Navy",true]]],
[["Pencil Skirt","Pencil Skirt"], [["Black",true], ["Green",true], ["Grey",true],
  ["Navy",true], ["Wine",true]]],
[["Ribbon Skirt","Ribbon Skirt"], [["Blue",false], ["Green",false], ["Pink",false],
  ["Red",false], ["Black",false]]],
[["School Pants","School Skirt"], [["Light",false],["Dark",false]]],
[["Shorts","Shorts"], [["Black",true], ["Blue",true], ["Green",true],
  ["Red",true], ["White",true]]],
]

# Names of the headgear in order. (true= unlocked by default, false=locked by default)
HEADGEAR_ITEMS=[
[["No Headgear", "No Headgear"], true],
[["Beanie","Beanie"], [["Black",true],["Purple",true]]],
[["Glasses","Glasses"],[["Blue",true],["Red",true]]],
[["Youngster Cap","Youngster Cap"],[["Yellow",true],["Blue",true]]],
[["Bonnet","Bonnet"],true],
[["Feather Hat","Feather Hat"],true],
[["Fedora","Fedora"],true],
[["Ribbon","Ribbon"],true],
[["Straw Hat","Straw Hat"],true],
[["Sun Hat","Sun Hat"],true],
[["Crown","Crown"], [["Gold",false],["Silver",false]]],
[["Flower","Flower"], [["Blue",false],["Red",false]]],
[["Beret","Beret"],false],
[["Cat","Cat"],false],
[["Devil","Devil"],false],
[["Hair Band","Hair Band"],false],
[["Head Band","Head Band"],false],
[["Miner Helmet","Miner Helmet"],false],
[["Poop","Poop"],false]
]

# Names of the accessories in order. (true= unlocked by default, false=locked by default)
ACCESSORY_ITEMS=[
[["No Accessory", "No Accessory"],true],
[["Bag","Bag"], [["Black",true], ["Blue",true], ["Green",true], ["Magenta",true],
  ["Orange",true], ["Purple",true], ["Red",true], ["White",true], ["Yellow",true]]],
[["Rucksack","Rucksack"], [["Black",true], ["Blue",true], ["Green",true], ["Magenta",true],
  ["Orange",true], ["Purple",true], ["Red",true], ["White",true], ["Yellow",true]]],
[["Sporty Backpack","Sporty Backpack"], [["Black",true], ["Blue",true], ["Green",true],  
  ["Magenta",true], ["Orange",true], ["Purple",true], ["Red",true], ["White",true],
  ["Yellow",true]]]
]

#==================================================================================
#This section defines the Base graphic names with a double array. Each item in the
#  initial array represents each base, while the number of items in those base arrays
#  is the base name for each character (In default essentials, for boy and girl).
BASE_GRAPHICS=[
["Pale","Pale"],
["Fair","Fair"],
["Tanned","Tanned"],
["Dark","Dark"]
]

#==================================================================================

#This hash specifies which folders certain character sprites will be retrieved from
#  when making new character sprites.
#Update this whenever the player has added another sprite sheet for a character
#  (ie. if a player had a specific swimming sprite sheet)
SPRITE_CONVERT_HASH = { "trchar000" => "overworld walk", 
"boy_bike" => "overworld bike",
"boy_surf" => "overworld surf",  #changed for V17.2
"boy_run" => "overworld run", 
"boy_dive_offset" => "overworld dive", 
"boy_fish_offset" => "overworld fish",
"boy_fishsurf_offset" => "overworld fishsurf", 
"trback000" => "trainer back",
"introBoy" => "trainer front", 
"mapPlayer000" => "trainer map",
"trchar001" => "overworld walk", 
"girl_bike" => "overworld bike",
"girl_surf" => "overworld surf", #changed for V17.2
"girl_run" => "overworld run",
"girl_dive_offset" => "overworld dive", 
"girl_fish_offset" => "overworld fish",
"girl_fishsurf_offset" => "overworld fishsurf", 
"trback001" => "trainer back",
"introGirl" => "trainer front", 
"mapPlayer001" => "trainer map"}

WALK_FOLDER = SPRITE_CONVERT_HASH["trchar000"]

#==================================================================================
# * Useful methods that the Game Designer can call
#==================================================================================

#Checks whether or not a trainer has been defined.
def pbTrainerNotDefined
  if !defined?($Trainer)
    if $DEBUG
      Kernel.pbMessage("The player is not a Trainer at this point. Implement the script into your game after you call the script pbTrainerName in your intro event.")
    end
    return true
  else 
    return false
  end
end

#Character Customization Script game designer can use
def pbCustomizeCharacter
  CharacterCustomizationScene.new
end

#Script in which the player can choose the base graphic they will use for their
#  character.
#Can be used to choose your player's skin tone. 
#Should be used after the player selects their name and gender (or character).
def pbChooseBaseGraphic
  ChooseBase.new
end

# Method for changing a certain item. Used by game designer
# item: String representing item player will put on.
# variant (Use when accessory has variants): The variant of the item to be put on.
def pbDressAccessory(item,variant=nil)
  dressAccessory(item,variant)
end

# Gives the player randomized clothes (e.g good thing for randomizer challenges)
def pbRandomizeOutfit
  return false if pbTrainerNotDefined
  for i in 0...5 #0 to Number of bodyparts (change if adding/deleting bodyparts)
    randomizeOutfitHelper(i)
  end
  saveAllCustomizedBitmapsToFolder
  updateTrainerOutfit
  $PokemonTemp.savedoutfit = false
end

# Method for checking whether the player wears a certain item.
# item: String representing the item that the player will be checked for.
# variant (Use when accessory has variants): The variant of the item checked for.
def pbWearingItem?(item,variant=nil)
  wearingAccessory?(item,variant)
end

# Method for unlocking clothes.
# item: String representing item player will unlock.
# variant (Use when accessory has variants): The variant unlocked for the item.
def pbUnlockItem(item,variant=nil)
  unlockAccessory(item,variant)
end

# Unlocks all the variants of a specific item.
# Only use for accessories with variants.
# item: String representing item player will unlock all the variants of.
def pbUnlockEntireItem(item)
  return false if pbTrainerNotDefined
  return false if !item.is_a?(String)
  arr=retArrayAndNumber(item,false)
  return false if !(arr[0])
  bodypart=arr[1]-1
  for i in 0...arr[0].length
    index=i if arr[0][i][0][$Trainer.character_ID]==item
  end
  (if $DEBUG; p "There was an issue unlocking the item."; end; return) if !index
  return false if checkAccessory(arr[0],index)
  for i in 0...arr[0][index][1].length
    $Trainer.clothesUnlocking[bodypart][index][i]=true
  end
end

# Method for locking clothes.
# Only use for accessories with variants.
# variant (Use when accessory has variants): The variant unlocked for the item.
def pbLockItem(item,variant=nil)
  lockAccessory(item,variant)
end

# Locks all the variants of a specific item.
# Only use for accessories with variants
# item: String representing item player will lock all the variants of.
def pbLockEntireItem(item)
  return false if pbTrainerNotDefined
  return false if !item.is_a?(String)
  arr=retArrayAndNumber(item,false)
  bodypart=arr[1]
  (if $DEBUG; p "There was an issue locking the item."; end; return) if !(arr[0])
  for i in 0...arr[0].length
    index=i if arr[0][i][0][$Trainer.character_ID]==item
  end
  if checkAccessory(arr[0],index)
    (if $DEBUG; p "There was an issue locking the item."; end; return)
  end
  for i in 0...arr[0][index][1].length
    lockAccessory(item,arr[0][index][1][i][0])
  end
end

#==================================================================================
# * Complete code of methods game designer calls
#==================================================================================

# This method updates the trainer outfit
def updateTrainerOutfit
  next_id=($Trainer.character_ID==1 ? 0 : 1)
  id=$Trainer.character_ID
  pbChangePlayer(next_id)
  pbWait(1)
  pbChangePlayer(id)
end

# Method for changing a certain accessory. 
def dressAccessory(accessory,variant=nil)
  return false if pbTrainerNotDefined
  return false if characterizationException
  return false if !accessory.is_a?(String)
  return false if !variant.is_a?(String) && !(variant.nil?)
  arr=retArrayAndNumber(accessory,false)
  (if $DEBUG; p "Could not find entered accessory."; end; return false) if !arr[0]
  bodypart=arr[0]; var=arr[1]
  for i in 0...bodypart.length
    if bodypart[i][0][$Trainer.character_ID]==accessory
      if variant.nil?
        if checkAccessory(bodypart,i)
          $Trainer.hair=[i,-1] if var==1
          $Trainer.top=[i,-1] if var==2
          $Trainer.bottom=[i,-1] if var==3
          $Trainer.headgear=[i,-1] if var==4
          $Trainer.accessory=[i,-1] if var==5
          saveAllCustomizedBitmapsToFolder
          updateTrainerOutfit
          return
        elsif $DEBUG
          p "Cannot dress accessory. Array is multidimensional, entered single value."
        end
        return
      else
        if !checkAccessory(bodypart,i,false)
          if $DEBUG
            p "Cannot dress accessory. Array is singledimensional, entered multiple values."
          end
          return
        end
        secondvalue=nil
        for j in 0...bodypart[i][1].length
          if bodypart[i][1][j][0]==variant
            secondvalue=j
          end
        end
        if secondvalue.nil?
          if $DEBUG
            p "Could not find variant specified."
          end
          return
        else
          $Trainer.hair=[i,secondvalue] if var==1
          $Trainer.top=[i,secondvalue] if var==2
          $Trainer.bottom=[i,secondvalue] if var==3
          $Trainer.headgear=[i,secondvalue] if var==4
          $Trainer.accessory=[i,secondvalue] if var==5
          saveAllCustomizedBitmapsToFolder
          updateTrainerOutfit
          $PokemonTemp.savedoutfit = false
          return
        end
      end
    end
  end
  return
end

def wearingAccessory?(accessory,variant=nil)
  return false if pbTrainerNotDefined
  return false if characterizationException
  arr=retArrayAndNumber(accessory,false)
  clothes=arr[0]; bodypart=arr[1]
  current=$Trainer.hair if bodypart==1
  current=$Trainer.top if bodypart==2
  current=$Trainer.bottom if bodypart==3
  current=$Trainer.headgear if bodypart==4
  current=$Trainer.accessory if bodypart==5
  return false if !clothes || !current
  if accessory.is_a?(String)
    for i in 0...clothes.length
      if clothes[i][0][$Trainer.character_ID]==accessory
        if variant.nil?
          return (accessory==clothes[current[0]][0][$Trainer.character_ID])
        elsif variant.is_a?(String) && accessory==clothes[current[0]][0][$Trainer.character_ID]
          return false if checkAccessory(clothes,i)
          for j in 0...clothes[i][1].length
            if clothes[i][1][j][0]==variant
              return (variant==clothes[i][1][current[0]][0])
            end
          end
        else
          return false
        end
      end
    end
  end
  return false
end

def unlockAccessory(accessory,variant=nil)
  return false if pbTrainerNotDefined
  return false if !accessory.is_a?(String)
  arr=retArrayAndNumber(accessory,false)
  return false if !(arr[0])
  bodypart=arr[1]-1
  for i in 0...arr[0].length
    index=i if arr[0][i][0][$Trainer.character_ID]==accessory
  end
  (if $DEBUG; p "There was an issue unlocking the accessory."; end; return) if !index
  if !variant.nil?
    return false if !variant.is_a?(String)
    return false if checkAccessory(arr[0],index)
    for j in 0...arr[0][index][1].length
      index2=j if arr[0][index][1][j][0]==variant
    end
    (if $DEBUG; p "There was an issue unlocking the accessory."; end; return) if !index2
    $Trainer.clothesUnlocking[bodypart][index][index2]=true
  else
    return false if checkAccessory(arr[0],index,false)
    $Trainer.clothesUnlocking[bodypart][index]=true
  end
end

# Method for locking clothes
def lockAccessory(accessory,variant=nil)
  return false if pbTrainerNotDefined
  return false if !accessory.is_a?(String)
  arr=retArrayAndNumber(accessory,false)
  bodypart=arr[1]
  (current=$Trainer.hair; name="Hair") if bodypart==1
  (current=$Trainer.top; name="Top") if bodypart==2
  (current=$Trainer.bottom; name="Bottom") if bodypart==3
  (current=$Trainer.headgear; name="Headgear")if bodypart==4
  (current=$Trainer.accessory; name="Accessory")if bodypart==5
  # Checking if player wears the accessory to lock
  (if $DEBUG; p "There was an issue locking the accessory"; end; return) if !(arr[0])
  for i in 0...arr[0].length
    if arr[0][i][0][$Trainer.character_ID]==accessory
      index=i
      if variant.nil?
        if checkAccessory(arr[0],index,false)
          (if $DEBUG; p "There was an issue locking the accessory"; end; return)
        end
        #p i; p current
        if i==current[0]
          if checkAccessory(arr[0],0)
            sv=-1
          else
            sv=0
          end
          Kernel.pbMessage("#{$Trainer.name} misses the #{accessory} #{name} and puts on the #{arr[0][0][0][$Trainer.character_ID]} one instead.")
          $Trainer.hair=[0,sv] if bodypart==1
          $Trainer.top=[0,sv] if bodypart==2
          $Trainer.bottom=[0,sv] if bodypart==3
          $Trainer.headgear=[0,sv] if bodypart==4
          $Trainer.accessory=[0,sv] if bodypart==5
        end
      else
        if checkAccessory(arr[0],index) || !variant.is_a?(String)
          (if $DEBUG; p "There was an issue locking the accessory"; end; return) 
        end
        for j in 0...arr[0][i][1].length
          if arr[0][i][1][j][0]==variant
            index2=j
          end
          if i==current[0] && j==current[1]
            if checkAccessory(arr[0],0)
              sv=-1
            else
              sv=0
            end
            Kernel.pbMessage("#{$Trainer.name} misses the #{accessory} #{name} and puts on the #{arr[0][0][0][$Trainer.character_ID]} one instead.")
            $Trainer.hair=[0,sv] if bodypart==1
            $Trainer.top=[0,sv] if bodypart==2
            $Trainer.bottom=[0,sv] if bodypart==3
            $Trainer.headgear=[0,sv] if bodypart==4
            $Trainer.accessory=[0,sv] if bodypart==5
          end
        end
      end
    end
  end
  (if $DEBUG; p "There was an issue locking the accessory"; end; return) if !index
  if !variant.nil? && !index2
    (if $DEBUG; p "There was an issue locking the accessory"; end; return)
  elsif !variant.nil?
    $Trainer.clothesUnlocking[bodypart-1][index][index2]=false
  else
    $Trainer.clothesUnlocking[bodypart-1][index]=false
  end
  saveAllCustomizedBitmapsToFolder
  updateTrainerOutfit
  $PokemonTemp.savedoutfit = false
end

#==================================================================================
# * Initializing class PokeBattle_Trainer objects.
#==================================================================================

class PokeBattle_Trainer
  attr_accessor :character_customization
  attr_accessor :hair
  attr_accessor :top
  attr_accessor :bottom
  attr_accessor :headgear
  attr_accessor :accessory
  attr_accessor :clothesUnlocking

  def character_customization
    if !@character_customization
      @character_customization=UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT
    end
    return @character_customization
  end
  
  def character_customization=(boolean)
    if boolean != true && boolean != false # Determining if object is a boolean
      if $DEBUG
        p "only $Trainer.character_customization = true/false is valid!"
      end
      return
    end
    @character_customization=boolean
  end

  def hair
    if !@hair
      if ((HAIR_ITEMS[0][1] == true) || (HAIR_ITEMS[0][1] == false))
        @hair=[0,-1]
      else
        @hair=[0,0]
      end
    end
    return @hair
  end

  def hair=(values)
    fvalue=values[0]; svalue=values[1]
    if fvalue<0 || fvalue>(HAIR_ITEMS.length-1)
      if $DEBUG
        p "the first value for $Trainer.hair is out of range!"
      end
      return
    end
    if ((HAIR_ITEMS[fvalue][1] == true) || (HAIR_ITEMS[fvalue][1] == false))
    	@hair=[fvalue, -1]
    else
      if svalue<0 || svalue>(HAIR_ITEMS[fvalue][1].length-1)
        if $DEBUG
          p "the second value for $Trainer.hair is out of range!"
         end
        return
      end
      @hair=[fvalue, svalue]
    end
  end

  def top
    if !@top
      if ((TOP_ITEMS[0][1] == true) || (TOP_ITEMS[0][1] == false))
        @top=[0,-1]
      else
        @top=[0,0]
      end
    end
    return @top
  end

  def top=(values)
    fvalue=values[0]; svalue=values[1]
    if fvalue<0 || fvalue>(TOP_ITEMS.length-1)
      if $DEBUG
        p "the first value for $Trainer.top is out of range!"
      end
      return
    end
    if ((TOP_ITEMS[fvalue][1] == true) || (TOP_ITEMS[fvalue][1] == false))
    	@top=[fvalue, -1]
    else
      if svalue<0 || svalue>(TOP_ITEMS[fvalue][1].length-1)
        if $DEBUG
          p "the second value for $Trainer.top is out of range!"
         end
        return
      end
      @top=[fvalue, svalue]
    end
  end

  def bottom
    if !@bottom
      if ((BOTTOM_ITEMS[0][1] == true) || (BOTTOM_ITEMS[0][1] == false))
        @bottom=[0,-1]
      else
        @bottom=[0,0]
      end
    end
    return @bottom
  end

  def bottom=(values)
    fvalue=values[0]; svalue=values[1]
    if fvalue<0 || fvalue>(BOTTOM_ITEMS.length-1)
      if $DEBUG
        p "the first value for $Trainer.bottom is out of range!"
      end
      return
    end
    if ((BOTTOM_ITEMS[fvalue][1] == true) || (BOTTOM_ITEMS[fvalue][1] == false))
    	@bottom=[fvalue, -1]
    else
      if svalue<0 || svalue>(BOTTOM_ITEMS[fvalue][1].length-1)
        if $DEBUG
          p "the second value for $Trainer.bottom is out of range!"
         end
        return
      end
      @bottom=[fvalue, svalue]
    end
  end
 
  def headgear
    if !@headgear
      if ((HEADGEAR_ITEMS[0][1] == true) || (HEADGEAR_ITEMS[0][1] == false))
        @headgear=[0,-1]
      else
        @headgear=[0,0]
      end
    end
    return @headgear
  end

  def headgear=(values)
    fvalue=values[0]; svalue=values[1]
    if fvalue<0 || fvalue>(HEADGEAR_ITEMS.length-1)
      if $DEBUG
        p "the first value for $Trainer.headgear is out of range!"
      end
      return
    end
    if ((HEADGEAR_ITEMS[fvalue][1] == true) || (HEADGEAR_ITEMS[fvalue][1] == false))
    	@headgear=[fvalue, -1]
    else
      if svalue<0 || svalue>(HEADGEAR_ITEMS[fvalue][1].length-1)
        if $DEBUG
          p "the second value for $Trainer.headgear is out of range!"
         end
        return
      end
      @headgear=[fvalue, svalue]
    end
  end
  
  def accessory
    if !@accessory
      if ((ACCESSORY_ITEMS[0][1] == true) || (ACCESSORY_ITEMS[0][1] == false))
        @accessory=[0,-1]
      else
        @accessory=[0,0]
      end
    end
    return @accessory
  end

  def accessory=(values)
    fvalue=values[0]; svalue=values[1]
    if fvalue<0 || fvalue>(ACCESSORY_ITEMS.length-1)
      if $DEBUG
        p "the first value for $Trainer.accessory is out of range!"
      end
      return
    end
    if ((ACCESSORY_ITEMS[fvalue][1] == true) || (ACCESSORY_ITEMS[fvalue][1] == false))
    	@accessory=[fvalue, -1]
    else
      if svalue<0 || svalue>(ACCESSORY_ITEMS[fvalue][1].length-1)
        if $DEBUG
          p "the second value for $Trainer.accessory is out of range!"
         end
        return
      end
      @accessory=[fvalue, svalue]
    end
  end
  
  def clothesUnlocking
    if !@clothesUnlocking
      p hi
      @clothesUnlocking=[]
      @clothesUnlocking.push cnvrtBoolArr(HAIR_ITEMS)
      @clothesUnlocking.push cnvrtBoolArr(TOP_ITEMS)
      @clothesUnlocking.push cnvrtBoolArr(BOTTOM_ITEMS)
      @clothesUnlocking.push cnvrtBoolArr(HEADGEAR_ITEMS)
      @clothesUnlocking.push cnvrtBoolArr(ACCESSORY_ITEMS)
    end
    return @clothesUnlocking
  end
  
end

#==================================================================================
# * Character Customization Scene
#==================================================================================

class CharacterCustomizationScene
  
  def initialize
    @savegetup = true
    if !defined?($Trainer.clothesUnlocking)    # Checks if the Script is functional.
      Kernel.pbMessage("Your game is missing some Variables of the Character Costumization Script. In order to fix this you'll need to save the game.")
      if Kernel.pbConfirmMessage("Would you like to save the game now?")
        if !$Trainer
          Kernel.pbMessage("Unable to save the game since the player is not a trainer at this point. Do not use the CharacterCustomization Script before you call the script pbTrainerName in your intro event.")
        else
          pbSave
          Kernel.pbMessage("The game was saved, try again now.")
        end
      end
      return
    end
    if $PokemonTemp.savedoutfit == false
      $PokemonTemp.savedoutfit = true
      @savegetup = false
    end
    return if !addNecessaryFiles
    if @savegetup == false
      $PokemonTemp.savedoutfit = false
    end
    @index=0
    @index2=0
    @indexR=-1
    @new_val=2
    @firstSelection=true
    @secondSelection=true
    @selectionChange=false
    @sprites={}
    @accessoryNames=["hair","tops","bottoms","headgear","accessories"]
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["window"]=SpriteWindow_Base.new(Graphics.width/2-64,Graphics.height/2-128,128,128)
    @sprites["window2"]=SpriteWindow_Base.new(Graphics.width/2-64,Graphics.height/2,128,128)
    @sprites["window2"].visible=false
    @sprites["player"]=TrainerWalkingCharSprite.new($game_player.character_name,@viewport)
    @sprites["player"].x=Graphics.width/2-@sprites["player"].bitmap.width/8
    @sprites["player"].y=Graphics.height/2-@sprites["player"].bitmap.height/8 -64
    @sprites["player"].z=9999999
    $PokemonTemp.savedoutfit = true
    temp="/"+WALK_FOLDER+"/"+@accessoryNames[1]+"/"+"0A"
    @sprites["playerAccessory"]=TrainerWalkingCharSprite.new(temp,@viewport)
    @sprites["playerAccessory"].x=Graphics.width/2-@sprites["playerAccessory"].bitmap.width/8
    @sprites["playerAccessory"].y=Graphics.height/2-@sprites["playerAccessory"].bitmap.height/8 +64
    @sprites["playerAccessory"].z=9999999
    @sprites["playerAccessory"].ox+=@sprites["playerAccessory"].bitmap.width/16
    @sprites["playerAccessory"].oy+=@sprites["playerAccessory"].bitmap.height/16    
    @sprites["playerAccessory"].zoom_x=2
    @sprites["playerAccessory"].zoom_y=2
    @sprites["playerAccessory"].visible=false
    @playerAccessory=@sprites["playerAccessory"]
    charheight=@sprites["player"].bitmap.height
    @y=[charheight/4*2,0,charheight/4,charheight/4*3]
    @sprites["heading1"]=Window_CommandPokemonEx.new(["BODYPART"])
    @sprites["heading1"].viewport=@viewport
    @sprites["heading1"].index=1    
    @sprites["heading2"]=Window_CommandPokemonEx.new(["HAIR"])
    @sprites["heading2"].viewport=@viewport
    @sprites["heading2"].index=1
    @sprites["heading2"].x=Graphics.width-@sprites["heading2"].width
    #Version 17.2 Difference Below
    @commands=CommandMenuList.new
    @commands.add("main","hair",_INTL("Hair"))
    @commands.add("main","tops",_INTL("Tops"))
    @commands.add("main","bottoms",_INTL("Bottoms"))
    @commands.add("main","headgear",_INTL("Headgear"))
    @commands.add("main","accessories",_INTL("Accessories"))
    #Version 17.2 Difference Above
    @sprites["cmdwindow"]=Window_CommandPokemonEx.new(@commands.list)
    @sprites["cmdwindow"].viewport=@viewport
    @sprites["cmdwindow"].y=@sprites["heading1"].height
    @sprites["cmdwindow2"]=Window_CommandPokemonEx.new(retListCmdBox2)
    @sprites["cmdwindow2"].viewport=@viewport
    @sprites["cmdwindow2"].y=@sprites["heading2"].height
    @sprites["cmdwindow2"].x=Graphics.width-@sprites["cmdwindow2"].width
    @sprites["cmdwindow2"].z-=1
    @sprites["cmdwindow2"].index=-1
    @cmdwindow2=@sprites["cmdwindow2"]
    @selectionMade=false
    update
  end

  def addNecessaryFiles
    files=[]
    basefiles=[]
    # Pushing all files that could possibly be missing into the files array.
    individualArrayFiles(files,HAIR_ITEMS,"hair")
    individualArrayFiles(files,BOTTOM_ITEMS,"bottoms")
    individualArrayFiles(files,TOP_ITEMS,"tops")
    individualArrayFiles(files,HEADGEAR_ITEMS,"headgear")
    individualArrayFiles(files,ACCESSORY_ITEMS,"accessories")
    if USE_BASE_GRAPHIC
      metadata=pbLoadMetadata
      filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
      for i in 0...filenames.length
        if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
          basefiles.push("Graphics/Characters/"+filenames[i]+"_base")
        end
      end
      # Trainer backsprite
      basefiles.push("Graphics/Trainers/trback00#{$Trainer.character_ID}_base")
      # Intro Image/Trainercard Image
      filepath="Graphics/Pictures/"
      filepath+= $Trainer.isFemale? ? "introGirl" : "introBoy"
      basefiles.push(filepath+"_base")
      # Map Player
      basefiles.push("Graphics/Pictures/mapPlayer00#{$Trainer.character_ID}_base")
    end
    # Creating a blank bitmap
    files_to_add=[]
    for i in 0...basefiles.length
      if !File.exists?(basefiles[i]+".png")
        files_to_add.push(basefiles[i]+".png")
      end
    end
    size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
    blank_bitmap=Bitmap.new(size_check.width,size_check.height)
    # Pushing non existent files into the files_to_add array.
    for i in 0...files.length
      if !File.exists?("Graphics/Characters/overworld walk/#{files[i]}"+".png")
        files_to_add.push("Graphics/Characters/overworld walk/#{files[i]}"+".png")
      end
    end
    if !files_to_add.empty?
      Kernel.pbMessage("The game is missing one or more graphic files for the Character Customization.")
      ret=Kernel.pbConfirmMessage("Would you like to add these files as blank placeholder sprites in order to let this Script work properly?")
      if ret
        files_to_add.length.times {|i| blank_bitmap.saveToPng(files_to_add[i])} 
        Kernel.pbMessage("The missing files were added to the Graphics/Characters/ folder. The script will continue working as supposed now.")
      else
        Kernel.pbMessage("The script stopped running until these neccessary files were added:")
        files_to_add.length.times{|i| Kernel.pbMessage(files_to_add[i])}
      end
      return ret
    end
    return true
  end
  

  # returns the index of the item in the actual list.
  def getAccessoryIndex(index)
    if @secondSelection
      item=@list[index]
    else
      item=@list2[index]
    end
    arr=HAIR_ITEMS if @accessoryNames[@index]=="hair"
    arr=TOP_ITEMS if @accessoryNames[@index]=="tops"
    arr=BOTTOM_ITEMS if @accessoryNames[@index]=="bottoms"
    arr=HEADGEAR_ITEMS if @accessoryNames[@index]=="headgear"
    arr=ACCESSORY_ITEMS if @accessoryNames[@index]=="accessories"
    arr=cnvrtStrArr(arr)
    for i in 0...arr.length
      return i if arr[i]==item 
    end
  end
  
  # updates the Accessory bitmap
  def updateAccessoryBitmap 
    @sprites["playerAccessory"].bitmap.clear
    endname=(getAccessoryIndex(@cmdwindow2.index)).to_s+($Trainer.character_ID+65).chr
    name="overworld walk/"+@accessoryNames[@index]+"/"+endname
    if File.exists?("Graphics/Characters/"+name+".png")
      @sprites["playerAccessory"].charset=name
    end
  end
  
    # returns the index of the variant in the actual list.
  def getAccessoryIndex2
    item=@list[@cmdwindow2.index]
    arr=HAIR_ITEMS if @accessoryNames[@index]=="hair"
    arr=TOP_ITEMS if @accessoryNames[@index]=="tops"
    arr=BOTTOM_ITEMS if @accessoryNames[@index]=="bottoms"
    arr=HEADGEAR_ITEMS if @accessoryNames[@index]=="headgear"
    arr=ACCESSORY_ITEMS if @accessoryNames[@index]=="accessories"
    arr2=arr[getAccessoryIndex(@indexR)][1]
    for i in 0...arr2.length
      return i if arr2[i][0]==item
    end
  end
  
  # Another method for updating the Accessory bitmap
  def updateAccessoryBitmap2
    @sprites["playerAccessory"].bitmap.clear
    frontname="overworld walk/"+@accessoryNames[@index]+"/"+(getAccessoryIndex(@indexR)).to_s
    name=frontname+"/"+(getAccessoryIndex2).to_s+($Trainer.character_ID+65).chr
    if File.exists?("Graphics/Characters/"+name+".png")
      @sprites["playerAccessory"].charset=name
    end
  end
  
  # returns the list of the right hand command box.
  def retListCmdBox2
    @list=HAIR_ITEMS if @index==0
    @list=TOP_ITEMS if @index==1
    @list=BOTTOM_ITEMS if @index==2
    @list=HEADGEAR_ITEMS if @index==3
    @list=ACCESSORY_ITEMS if @index==4
    if @secondSelection==true
      @list=retUnlockedAccessoryArray(cnvrtStrArr(@list))
      @list=["---NONE---"] if !@list
      @list.push("Back") if !@list.include?("Back")
    else
      @list2=retUnlockedAccessoryArray(cnvrtStrArr(@list))
      @list2=["---NONE---"] if !@list2
      @list2.push("Back") if !@list2.include?("Back")
      @list=retUnlockedAccessoryArray2(cnvrtStrArr(@list),getAccessoryIndex(@indexR))
      @list=["---NONE---"] if !@list
      @list.push("Back") if !@list.include?("Back")
    end
    return @list
  end
 
  #checks whether or not the currently selected item within the list has any variants
  def hasVariants
    ret=false
    name=@list[@cmdwindow2.index]
    #Get name of item that is current hovered over
    arr=retArrayAndNumber(name,false)
    bodypart=arr[0]
    #Access original array to check whether or not item has variants.
    for i in 0...bodypart.length
      if bodypart[i][0][$Trainer.character_ID]==name
        ret=((bodypart[i][1] == true) || (bodypart[i][1] == false))
      end
    end
    return !ret
  end
  
  # this updates the heading. since there is no command for updating 
  # command boxes it'll always create a new fresh command box sprite.
  def updateHeading2
    @sprites["heading#{@new_val}"].dispose
    @sprites["cmdwindow#{@new_val}"].dispose
    @new_val+=1
    @sprites["heading#{@new_val}"]=Window_CommandPokemonEx.new([@commands.list[@index].upcase])
    @sprites["heading#{@new_val}"].viewport=@viewport
    @sprites["heading#{@new_val}"].index=1
    @sprites["heading#{@new_val}"].x=Graphics.width-@sprites["heading#{@new_val}"].width
    @sprites["heading#{@new_val}"].z-=1
    @sprites["cmdwindow#{@new_val}"]=Window_CommandPokemonEx.new(retListCmdBox2)
    @cmdwindow2=@sprites["cmdwindow#{@new_val}"]
    @cmdwindow2.viewport=@viewport
    @cmdwindow2.y=@sprites["heading#{@new_val}"].height
    @cmdwindow2.x=Graphics.width-@sprites["cmdwindow#{@new_val}"].width
    @cmdwindow2.index= -1
  end
  
  # checks whether the index of the left command box has changed or not.
  def indexChanged
    if @index2 != @index
      @index2=@index
      return true
    end
    return false
  end
  
  # checks whether the index or the right command box has changed or not.
  def cmdWindow2IndexChanged
    if !@cmdWindow2Index
      @cmdWindow2Index=@cmdwindow2.index
      return false
    elsif @cmdWindow2Index != @cmdwindow2.index
      @cmdWindow2Index=@cmdwindow2.index
      return true
    end
    return false
  end
  
  # updates the scene.
  def update
    frame=0
    @dir=0
    loop do
      frame+=1
      pos=0
      Graphics.update
      Input.update
      @sprites["player"].update
      @sprites["playerAccessory"].update
      if @firstSelection
        @sprites["cmdwindow"].update
        @index=@sprites["cmdwindow"].index
      else
        @cmdwindow2.update
      end
      if indexChanged
        updateHeading2
      end
      if @selectionChange
        updateHeading2
        if @secondSelection
          @cmdwindow2.index=@indexR
        else
          @cmdwindow2.index=0
        end
        @selectionChange=false
      end
      if @secondSelection
        if cmdWindow2IndexChanged && @cmdwindow2.index != -1 
          if !(@cmdwindow2.index==(@cmdwindow2.itemCount-1)) && !hasVariants
            @sprites["window2"].visible=true
            @sprites["playerAccessory"].visible=true
            $PokemonTemp.savedoutfit = true
            updateAccessoryBitmap #if @cmdwindow2.index != @cmdwindow2.
            $PokemonTemp.savedoutfit = false
          else
            @sprites["window2"].visible=false
            @sprites["playerAccessory"].visible=false
          end
        end
      elsif cmdWindow2IndexChanged && @cmdwindow2.index != -1
        if !(@cmdwindow2.index==(@cmdwindow2.itemCount-1))
          @sprites["window2"].visible=true
          @sprites["playerAccessory"].visible=true
          $PokemonTemp.savedoutfit = true
          updateAccessoryBitmap2 #if @cmdwindow2.index != @cmdwindow2.
          $PokemonTemp.savedoutfit = false
        else
          @sprites["window2"].visible=false
          @sprites["playerAccessory"].visible=false
        end
      end
      if Input.trigger?(Input::C)
        # Pressing C on the left command box.
        if @firstSelection
          @cmdwindow2.index=0
          @firstSelection=false
          if !hasVariants
            @sprites["window2"].visible=true
            @sprites["playerAccessory"].visible=true
          end
        elsif @secondSelection
        # Pressing C on the right command box, first choice
          if @cmdwindow2.index==(@cmdwindow2.itemCount-1) # Cancel
            @cmdwindow2.index=-1; @cmdwindow2.update
            @firstSelection=true
            @sprites["window2"].visible=false
            @sprites["playerAccessory"].visible=false
          elsif !hasVariants
            $PokemonTemp.savedoutfit = true
            changeClothes
            $PokemonTemp.savedoutfit = false
            @sprites["player"].bitmap.clear
            @sprites["player"].charset=$game_player.character_name
            @selectionMade=true
          else
            @indexR=@cmdwindow2.index
            @secondSelection=false
            @selectionChange=true
            @sprites["window2"].visible=true
            @sprites["playerAccessory"].visible=true
          end
        # Pressing C on the left command box, second choice
        else
          if @cmdwindow2.index==(@cmdwindow2.itemCount-1) # Cancel
            @cmdwindow2.index=@indexR; @cmdwindow2.update
            @secondSelection=true
            @selectionChange=true
            @sprites["window2"].visible=false
            @sprites["playerAccessory"].visible=false
          else
            $PokemonTemp.savedoutfit = true
            changeClothes
            $PokemonTemp.savedoutfit = false
            @sprites["player"].bitmap.clear
            @sprites["player"].charset=$game_player.character_name
            @selectionMade=true
          end
        end
      end

      if Input.trigger?(Input::B)
        # cancels the scene.
        if @firstSelection && Kernel.pbConfirmMessage("Have you finished?")
          updateTrainerOutfit
          if @savegetup == true && @selectionMade == false
            $PokemonTemp.savedoutfit = true
          else
            $PokemonTemp.savedoutfit = false
          end
          pbDisposeSpriteHash(@sprites)
          break
        # goes back to the left command box.
        elsif !@firstSelection && @secondSelection
          @cmdwindow2.index=-1; @cmdwindow2.update
          @firstSelection=true
          @sprites["window2"].visible=false
          @sprites["playerAccessory"].visible=false
        elsif !@firstSelection && !@secondSelection
          @cmdwindow2.index=@indexR; @cmdwindow2.update
          @secondSelection=true
          @selectionChange=true
          @sprites["window2"].visible=false
          @sprites["playerAccessory"].visible=false
        end
      end
      # updates the walking sprite.
      if frame%120==0
        @dir+=1
        @sprites["player"].src_rect.y=@y[@dir%4]
        @sprites["playerAccessory"].src_rect.y=@sprites["player"].src_rect.y
      end      
    end
  end
  
  # updates the outfit as well as the variables which are responsable for it.
  def changeClothes
    if @secondSelection
      dressAccessory(@list[@cmdwindow2.index])
    else
      dressAccessory(@list2[@indexR],@list[@cmdwindow2.index])
    end
    #done
    case @sprites["cmdwindow"].index
    when 0
      if @secondSelection
        $Trainer.hair=[getAccessoryIndex(@cmdwindow2.index), -1]
      else
        $Trainer.hair=[getAccessoryIndex(@indexR), getAccessoryIndex2]
      end
    when 1
      if @secondSelection
        $Trainer.top=[getAccessoryIndex(@cmdwindow2.index), -1]
      else
        $Trainer.top=[getAccessoryIndex(@indexR), getAccessoryIndex2]
      end
    when 2
      if @secondSelection
        $Trainer.bottom=[getAccessoryIndex(@cmdwindow2.index), -1]
      else
        $Trainer.bottom=[getAccessoryIndex(@indexR), getAccessoryIndex2]
      end
    when 3
      if @secondSelection
        $Trainer.headgear=[getAccessoryIndex(@cmdwindow2.index), -1]
      else
        $Trainer.headgear=[getAccessoryIndex(@indexR), getAccessoryIndex2]
      end
    when 4
      if @secondSelection
        $Trainer.accessory=[getAccessoryIndex(@cmdwindow2.index), -1]
      else
        $Trainer.accessory=[getAccessoryIndex(@indexR), getAccessoryIndex2]
      end
    end
  end
  
end

#===============================================================================
# Creates a method which chooses which Base Graphic to build their character on top of
#===============================================================================

class ChooseBase
  
  def initialize
    if !$PokemonTemp.savedoutfit
      (if $DEBUG; p "Cannot pick base if outfit has already been edited"; end; return)
    end
    #Version 17.2 Difference Below
    @commands=CommandMenuList.new
    for i in 0...BASE_GRAPHICS.length
      temp=BASE_GRAPHICS[i][$Trainer.character_ID]
      @commands.add("main",temp.downcase,_INTL(temp))
    end
    #Version 17.2 Difference Above
    return false if !addBaseFiles
    @index=0
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["window"]=SpriteWindow_Base.new(8,8,128,192)
    @sprites["window2"]=SpriteWindow_Base.new(8,208,128,128)
    @sprites["window"].z=1000
    @sprites["window2"].z=1000
    temp="/examples/0"+($Trainer.character_ID+65).chr
    @sprites["baseRep"]= IconSprite.new(0,0,@viewport)
    @sprites["baseRep"].setBitmap("Graphics/Characters/base graphics"+temp)
    @sprites["baseRep"].x=@sprites["window"].width/2-@sprites["baseRep"].bitmap.width/2 +8
    @sprites["baseRep"].y=@sprites["window"].height/2-@sprites["baseRep"].bitmap.height/2 +8
    @sprites["baseRep"].z=9999999
    temp="/"+WALK_FOLDER+"/0"+($Trainer.character_ID+65).chr
    @sprites["walkSprite"]=TrainerWalkingCharSprite.new("base graphics"+temp,@viewport)
    @sprites["walkSprite"].x=@sprites["window2"].width/2-@sprites["walkSprite"].bitmap.width/2 +8
    @sprites["walkSprite"].y=@sprites["window2"].height/2-@sprites["walkSprite"].bitmap.height/2 +208
    @sprites["walkSprite"].ox-=@sprites["walkSprite"].bitmap.width/8
    @sprites["walkSprite"].oy-=@sprites["walkSprite"].bitmap.height/8
    @sprites["walkSprite"].z=9999999
    @sprites["walkSprite"].zoom_x=2
    @sprites["walkSprite"].zoom_y=2
    @sprites["heading"]=Window_CommandPokemonEx.new(["SKIN TONES"])
    @sprites["heading"].viewport=@viewport
    @sprites["heading"].index=1
    @sprites["heading"].x=Graphics.width-@sprites["heading"].width-8
    charheight=@sprites["walkSprite"].bitmap.height
    @y=[charheight/4*2,0,charheight/4,charheight/4*3]
    @sprites["cmdwindow"]=Window_CommandPokemonEx.new(@commands.list)
    @sprites["cmdwindow"].viewport=@viewport
    @sprites["cmdwindow"].x=Graphics.width-@sprites["cmdwindow"].width
    @sprites["cmdwindow"].y=@sprites["heading"].height+8
    @sprites["cmdwindow"].z=999999
    @sprites["cmdwindow"].index=0
    looping
  end
  
  def addBaseFiles
    files=[]
    metadata=pbLoadMetadata
    filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
    root="Graphics/Characters/base graphics/"
    # Trainer backsprite
    for j in 0...@commands.list.length
      name=SPRITE_CONVERT_HASH["#{$game_player.character_name}"]
      files.push(root+name+"/#{j}"+($Trainer.character_ID+65).chr)
    end
    # Creating a blank bitmap
    size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
    blank_bitmap=Bitmap.new(size_check.width,size_check.height)
    # Pushing non existent files into the files_to_add array.
    files_to_add=[]
    for i in 0...files.length
      if !File.exists?(files[i]+".png")
        files_to_add.push(files[i]+".png")
      end
    end
    if !files_to_add.empty?
      Kernel.pbMessage("The game is missing one or more graphic files for the Character Customization.")
      ret=Kernel.pbConfirmMessage("Would you like to add these files as blank placeholder sprites in order to let this Script work properly?")
      if ret
        files_to_add.length.times {|i| blank_bitmap.saveToPng(files_to_add[i])} 
        Kernel.pbMessage("The missing files were added to the Graphics/Characters/base graphics/ folder. The script will continue working as supposed now.")
      else
        Kernel.pbMessage("The script stopped running until these neccessary files were added:")
        files_to_add.length.times{|i| Kernel.pbMessage(files_to_add[i])}
      end
      return ret
    end
    return true
  end

  def saveBase(filepath,folder)
    return if !$Trainer
    return if !filepath.is_a?(String) || !folder.is_a?(String)
    name="Graphics/Characters/base graphics/"+folder+"/"+(@sprites["cmdwindow"].index).to_s
    if File.exists?(name+($Trainer.character_ID+65).chr+".png")
      bmp=Bitmap.new(name+($Trainer.character_ID+65).chr)
    else
      # Creating a blank bitmap
      size_check=Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
      bmp=Bitmap.new(size_check.width,size_check.height)
    end
    # Safety Copy
    if !File.exists?(filepath+"_safetyCopy"+".png") && $DEBUG
      safetyCopy=Bitmap.new(filepath)
      safetyCopy.saveToPng(filepath+"_safetyCopy"+".png")
    end
    bmp.saveToPng(filepath+".png")
    bmp.saveToPng(filepath+"_base.png")
  end
  
  def saveAllBases
    return if !$Trainer
    # Trainer charsets
    metadata=pbLoadMetadata
    filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
    for i in 0...filenames.length
      if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
        filepath="Graphics/Characters/#{filenames[i]}"
        folder=SPRITE_CONVERT_HASH[filenames[i]]
        saveBase(filepath,folder)
      end
    end
    # Trainer backsprite
    helpr="trback00#{$Trainer.character_ID}"
    filepath="Graphics/Trainers/"
    folder=SPRITE_CONVERT_HASH[helpr]
    saveBase(filepath+helpr,folder)
    # Intro Image/Trainercard Image
    filepath="Graphics/Pictures/"
    helpr=$Trainer.isFemale? ? "introGirl" : "introBoy"  #Modify this line if you want more than two characters.
    folder=SPRITE_CONVERT_HASH[helpr]
    saveBase(filepath+helpr,folder)
    # Map Player
    helpr="mapPlayer00#{$Trainer.character_ID}"
    folder=SPRITE_CONVERT_HASH[helpr]
    saveBase(filepath+helpr,folder)
  end
  
  def looping
    frame=0
    @dir=0
    loop do
      frame+=1
      pos=0
      Graphics.update
      Input.update
      @sprites["baseRep"].update
      @sprites["walkSprite"].update
      @sprites["cmdwindow"].update
      if @sprites["cmdwindow"].index != @index
        @index=@sprites["cmdwindow"].index
        newname="examples/"+(@sprites["cmdwindow"].index).to_s+($Trainer.character_ID+65).chr
        if File.exists?("Graphics/Characters/base graphics/"+newname+".png")
          @sprites["baseRep"].name=("Graphics/Characters/base graphics/"+newname)
        end
        newname=WALK_FOLDER+"/"+(@sprites["cmdwindow"].index).to_s+($Trainer.character_ID+65).chr
        if File.exists?("Graphics/Characters/base graphics/"+newname+".png")
          @sprites["walkSprite"].charset=("base graphics/"+newname)
        end
      end
      if Input.trigger?(Input::C) && Kernel.pbConfirmMessage("So you're choosing #{@commands.list[@index]}?")
        $game_variables[84] = @index
        saveAllBases
        pbDisposeSpriteHash(@sprites)
        updateTrainerOutfit
        break
      end
      if frame%120==0
        @dir+=1
        @sprites["walkSprite"].src_rect.y=@y[@dir%4]
      end
    end     
  end
end