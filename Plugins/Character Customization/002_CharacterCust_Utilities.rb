#===============================================================================
# * Character Costumization by Wolf Heretic
# * Based Heavily on a script by shiney570
#   Version: 2.0.0
#===============================================================================
# This part of the script focuses mostly on how outfits customized are saved as 
# well as various functions used throughout the script. Includes (In Order):
# - Utility methods
# - Initial saving of outfit
# - Permanent Save of outfit when player saves game
# - Edits how metadata is called to help distinguish between saved and non-saved
#   outfits.
# - Edits png extention
#
#
#==================================================================================
# *Utility Methods used throughout this script
#==================================================================================

# Given a string and a bool, returns an array and a var representing the array number.
# accessory: A string representing an item in the array that the user wants to access.
# convertation: A Bool which determines whether or not the names specific to a 
#  players gender are returned (true), or the entire array (false).
def retArrayAndNumber(accessory,convertation=true)
  (bodypart=HAIR_ITEMS; var=1) if cnvrtStrArr(HAIR_ITEMS).include?(accessory)
  (bodypart=TOP_ITEMS; var=2) if cnvrtStrArr(TOP_ITEMS).include?(accessory)
  (bodypart=BOTTOM_ITEMS; var=3) if cnvrtStrArr(BOTTOM_ITEMS).include?(accessory)
  (bodypart=HEADGEAR_ITEMS; var=4) if cnvrtStrArr(HEADGEAR_ITEMS).include?(accessory)
  (bodypart=ACCESSORY_ITEMS; var=5) if cnvrtStrArr(ACCESSORY_ITEMS).include?(accessory)
  return [cnvrtStrArr(bodypart),var] if convertation
  return [bodypart,var]
end

# Returns a boolean indicating if the character can be customized given settings 
#  set by the creator and the player's current state.
def characterizationException
  return true if CHARACTER_CUSTOMIZATION==false
  return true if UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT==false &&
                 $Trainer.character_customization==false
  return true if !$Trainer
  return true if !$Trainer.hair
  return false
end

# Creates a new array from the items specific to the player's gender.
# array: An array representing the options for a specific component of the outfit
#  characterization of the character (ie. HAIR_ITEMS)
def cnvrtStrArr(array)
  ret=[]
  for i in 0...array.length
    ret.push(array[i][0][$Trainer.character_ID])
  end
  return ret
end

#cnvrtBoolArr: Creates a new array with only the booleans which define the items within the array.
#array: An array representing the options for a specific component of the outfit characterization of the character (ie. HAIR_ITEMS)
#output: A boolean array representing which items within the component array are locked and unlocked; represented by booleans.
def cnvrtBoolArr(array)
  ret=[]
  for i in 0...array.length
    if ((array[i][1] == true) || (array[i][1] == false))
      ret.push(array[i][1])
    else
      ret[i]=[]
      for j in 0...array[i][1].length
        ret[i].push(array[i][1][j][1])
      end
    end
  end
  return ret
end

#Creates a new array with only the unlocked elements of the given array.
#clothes: One of the arrays defining the gendered items and properties for 
# a specific attribute (ie. cnvrtStrArr(HEADGEAR_ITEMS))
def retUnlockedAccessoryArray(clothes)
  arr=retArrayAndNumber(clothes[0])
  var=arr[1]
  ret=[]
  for i in 0...clothes.length
    if ($Trainer.clothesUnlocking[var-1][i]==false || $Trainer.clothesUnlocking[var-1][i]==true)
      ret.push clothes[i] if $Trainer.clothesUnlocking[var-1][i]==true
    else
      check=false
      for j in 0...$Trainer.clothesUnlocking[var-1][i].length
        check=(check||$Trainer.clothesUnlocking[var-1][i][j])
      end
      ret.push clothes[i] if check
    end
  end
  return ret
end

#Creates a new array with only the unlocked elements of the given array.
#clothes: One of the arrays defining the gendered items and properties for 
# a specific attribute (ie. cnvrtStrArr(HEADGEAR_ITEMS))
def retUnlockedAccessoryArray2(clothes,itemnum)
  arr=retArrayAndNumber(clothes[0],false)
  var=arr[1]
  ret=[]
  for i in 0...arr[0][itemnum][1].length
    if $Trainer.clothesUnlocking[var-1][itemnum][i]
      ret.push arr[0][itemnum][1][i][0]
    end
  end
  return ret
end

#Fetches the file names corresponding to a given array.
#files: An array where all the file names will be stored. Should be the empty array initially
#array: An array of clothing items (ie. HAIR_ITEMS)
#folder: The folder from which these file names will correspond to.
def individualArrayFiles(files,array,folder)
  for i in 0...array.length
    if ((array[i][1] == true) || (array[i][1] == false))
      files.push(folder+"/#{i}"+($Trainer.character_ID+65).chr)
    else
      for j in 0...array[i][1].length
        files.push(folder+"/#{i}/#{j}"+($Trainer.character_ID+65).chr)
      end
    end
  end
end

# checks whether or not an inputed array is multi-dimensional at a given index.
# arr: An array of clothing items (ie. HAIR_ITEMS)
# num: The index numberof a specific item in the array.
# single(optional): if true, checks if index at given array is singular, otherwise
#  checks if not singular.
def checkAccessory(arr,num,single=true)
  if (arr[num][1]==true)||(arr[num][1]==false)
    return (false^single)
  else
    return (true^single)
  end
end

# helperfunction for randomizing outfit.
# bodypart: number corresponding to the specific bodypart array desired.
def randomizeOutfitHelper(bodypart)
  arr=HAIR_ITEMS if bodypart==0
  arr=TOP_ITEMS if bodypart==1
  arr=BOTTOM_ITEMS if bodypart==2
  arr=HEADGEAR_ITEMS if bodypart==3
  arr=ACCESSORY_ITEMS if bodypart==4
  fv=rand(arr.length)
  if checkAccessory(arr,fv)
    case bodypart
    when 0
      $Trainer.hair=[fv, -1]
    when 1
      $Trainer.top=[fv, -1]
    when 2
      $Trainer.bottom=[fv, -1]
    when 3
      $Trainer.headgear=[fv, -1]
    when 4
      $Trainer.accessory=[fv, -1]
    end
  else
    case bodypart
    when 0
      $Trainer.hair=[fv, rand(arr[fv][1].length)]
    when 1
      $Trainer.top=[fv, rand(arr[fv][1].length)]
    when 2
      $Trainer.bottom=[fv, rand(arr[fv][1].length)]
    when 3
      $Trainer.headgear=[fv, rand(arr[fv][1].length)]
    when 4
      $Trainer.accessory=[fv, rand(arr[fv][1].length)]
    end
  end
end

#===============================================================================
# * Drawing the customized Bitmap
#===============================================================================

# Method to add an additional bitmap to another bitmap.
def addAdditionalBitmap(filepath,formerBitmap)
  if File.exists?(filepath)
     formerBitmap.blt(0,0,Bitmap.new(filepath),Rect.new(0,0,Graphics.width,Graphics.height))
  end
end

#Draws a specific bitmap for the player sprite.
def drawCharacterCustomizedBitmap(folder,bmp,trainerClass=$Trainer)
  return nil if !folder.is_a?(String)
  return bitmap if !trainerClass
  return bitmap if CHARACTER_CUSTOMIZATION==false 
  return bitmap if UNLOCK_CHARACTER_CUSTOMIZATION_BY_DEFAULT==false &&
                   trainerClass.character_customization==false
  oldfilepath = "Graphics/Characters/"+folder+"/"
  # Adding Bottom Bitmap
  if trainerClass.bottom[1] == -1
    addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
      ($Trainer.character_ID+65).chr+".png",bmp)
  else
    addAdditionalBitmap(oldfilepath+"bottoms/"+(trainerClass.bottom[0]).to_s+
      "/"+(trainerClass.bottom[1]).to_s+($Trainer.character_ID+65).chr+".png",bmp)
  end
  # Adding Top Bitmap
  if trainerClass.top[1] == -1
    addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
      ($Trainer.character_ID+65).chr+".png",bmp)
  else
    addAdditionalBitmap(oldfilepath+"tops/"+(trainerClass.top[0]).to_s+
      "/"+(trainerClass.top[1]).to_s+($Trainer.character_ID+65).chr+".png",bmp)
  end
  # Adding Accessory Bitmap
  if trainerClass.accessory[1] == -1
    addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
      ($Trainer.character_ID+65).chr+".png",bmp)
  else
    addAdditionalBitmap(oldfilepath+"accessories/"+(trainerClass.accessory[0]).to_s+
      "/"+(trainerClass.accessory[1]).to_s+($Trainer.character_ID+65).chr+".png",bmp)
  end
  # Adding Hair Bitmap
  if trainerClass.hair[1] == -1
    addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
      ($Trainer.character_ID+65).chr+".png",bmp)
  else
    addAdditionalBitmap(oldfilepath+"hair/"+(trainerClass.hair[0]).to_s+
      "/"+(trainerClass.hair[1]).to_s+($Trainer.character_ID+65).chr+".png",bmp)
  end
  # Adding Headgear Bitmap
  if trainerClass.headgear[1] == -1
    addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
      ($Trainer.character_ID+65).chr+".png",bmp)
  else
    addAdditionalBitmap(oldfilepath+"headgear/"+(trainerClass.headgear[0]).to_s+
      "/"+(trainerClass.headgear[1]).to_s+($Trainer.character_ID+65).chr+".png",bmp)
  end
end

# saves a specific bitmap to a given folder.
def saveCustomizedBitmapToFolder(filepath,folder)
  return if !$Trainer
  return if !filepath.is_a?(String) || !folder.is_a?(String)
  if !USE_BASE_GRAPHIC
    bmp=Bitmap.new(filepath)
  else
    bmp=Bitmap.new(filepath+"_base")
  end
  # Safety Copy
  if !File.exists?(filepath+"_safetyCopy"+".png") && $DEBUG
    safetyCopy=Bitmap.new(filepath)
    safetyCopy.saveToPng(filepath+"_safetyCopy"+".png")
  end
  # Deleting old file
  if !USE_BASE_GRAPHIC
    bmp.clear
  end
  drawCharacterCustomizedBitmap(folder,bmp)
  bmp.saveToPng(filepath+"_curr.png")
end

# saves the costumized bitmaps to the actual game folders.
def saveAllCustomizedBitmapsToFolder
  return if !$Trainer
  # Trainer charsets
  metadata=pbLoadMetadata
  filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
  for i in 0...filenames.length
    if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
      filepath="Graphics/Characters/#{filenames[i]}"
      folder=SPRITE_CONVERT_HASH[filenames[i]]
      saveCustomizedBitmapToFolder(filepath,folder)
    end
  end
  # Trainer backsprite
  helpr="trback00#{$Trainer.character_ID}"
  filepath="Graphics/Trainers/"
  folder=SPRITE_CONVERT_HASH[helpr]
  saveCustomizedBitmapToFolder(filepath+helpr,folder)
  # Intro Image/Trainercard Image
  filepath="Graphics/Pictures/"
  helpr=$Trainer.isFemale? ? "introGirl" : "introBoy"  #Modify this line if you want more than two characters.
  folder=SPRITE_CONVERT_HASH[helpr]
  saveCustomizedBitmapToFolder(filepath+helpr,folder)
  # Map Player
  helpr="mapPlayer00#{$Trainer.character_ID}"
  folder=SPRITE_CONVERT_HASH[helpr]
  saveCustomizedBitmapToFolder(filepath+helpr,folder)
end

#===============================================================================
# Creates a method which saves a character's outfit permanently when the game is saved.
#===============================================================================

#Saves a specific outfit when pbSave is called.
def saveOutfit(filepath)
  if (File.exists?(filepath+".png") && File.exists?(filepath+"_curr.png"))
    File.delete(filepath+".png")
    bmp=Bitmap.new(filepath+"_curr.png")
    bmp.saveToPng(filepath+".png")
  else
    if $DEBUG
      p "ERROR: Unable to save file at #{filepath}"
    end
  end
  return
end

#Saves all of the outfits when pbSave is called.
def saveAllOutfits
  return if !$Trainer
  $PokemonTemp.savedoutfit = true
  if !reqFilesExist
    if $DEBUG
      p "Unable to replace files. One of the neccessary files does not exist"
    end
    $PokemonTemp.savedoutfit = false
    return
  end
  metadata=pbLoadMetadata
  filepath="Graphics/Characters/"
  filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
  for i in 0...filenames.length
    if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
      saveOutfit(filepath+filenames[i])
    end
  end
  # Trainer backsprite
  saveOutfit("Graphics/Trainers/trback00#{$Trainer.character_ID}")
  # Intro Image/Trainercard Image
  filepath="Graphics/Pictures/"
  filepath+= $Trainer.isFemale? ? "introGirl" : "introBoy"
  saveOutfit(filepath)
  # Map Player
  saveOutfit("Graphics/Pictures/mapPlayer00#{$Trainer.character_ID}")
  return
end
  
#Checks to see if all of the required files exist before trying to save all of the outfits.
def reqFilesExist
  # Trainer charsets
  metadata=pbLoadMetadata
  filenames=metadata[0][MetadataPlayerA+$Trainer.character_ID]
  for i in 0...filenames.length
    if filenames[i].is_a?(String) && !(filenames[i]=="xxx")
      if !File.exists?("Graphics/Characters/#{filenames[i]}.png")
        return false
      end
      if !File.exists?("Graphics/Characters/#{filenames[i]}"+"_curr.png")
        return false
      end
    end
  end
  # Trainer backsprite
  filepath="Graphics/Trainers/trback00#{$Trainer.character_ID}"
  if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
    return false
  end
  # Intro Image/Trainercard Image
  filepath="Graphics/Pictures/"
  filepath+= $Trainer.isFemale? ? "introGirl" : "introBoy"
  if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
    return false
  end
  # Map Player
  filepath="Graphics/Pictures/mapPlayer00#{$Trainer.character_ID}"
  if (!File.exists?(filepath+".png") || !File.exists?(filepath+"_curr.png"))
    return false
  end
  return true
end


#==============================================================================================
# Influences how the metadata is called so that an outfit is temporarily stored when changed.
#==============================================================================================

def pbGetMetadata(mapid,metadataType)
  meta=pbLoadMetadata
  if (mapid == 0) && (metadataType >= MetadataPlayerA) && (metadataType < MetadataPlayerA+7) && ($PokemonTemp.savedoutfit == false)
    ret=[]
    ret.push(meta[mapid][metadataType][0])
    for i in 1...meta[mapid][metadataType].length
      ret.push(meta[mapid][metadataType][i]+"_curr")
    end
    return ret
  else
    return meta[mapid][metadataType] if meta[mapid]
    return nil
  end
end

def pbTrainerHeadFile(type)
  return nil if !type
  bitmapFileName = sprintf("Graphics/Pictures/mapPlayer%s",getConstantName(PBTrainers,type)) rescue nil
  if !pbResolveBitmap(bitmapFileName) && $PokemonTemp.savedoutfit
    bitmapFileName = sprintf("Graphics/Pictures/mapPlayer%03d",type)
  elsif !pbResolveBitmap(bitmapFileName)
    sprintf("Graphics/Pictures/mapPlayer%03d_curr",type)
  end
  return bitmapFileName
end

def pbTrainerSpriteFile(type)
  return nil if !type
  bitmapFileName = sprintf("Graphics/Characters/trainer%s",getConstantName(PBTrainers,type)) rescue nil
  if !pbResolveBitmap(bitmapFileName) && $PokemonTemp.savedoutfit
    bitmapFileName = sprintf("Graphics/Characters/trainer%03d",type)
  elsif !pbResolveBitmap(bitmapFileName)
    bitmapFileName = sprintf("Graphics/Characters/trainer%03d_curr",type)
  end
  return bitmapFileName
end

def pbTrainerSpriteBackFile(type)
  return nil if !type
  bitmapFileName = sprintf("Graphics/Trainers/trback%s",getConstantName(PBTrainers,type)) rescue nil
  if !pbResolveBitmap(bitmapFileName) && $PokemonTemp.savedoutfit
    bitmapFileName = sprintf("Graphics/Trainers/trback%03d",type)
  elsif !pbResolveBitmap(bitmapFileName)
    bitmapFileName = sprintf("Graphics/Trainers/trback%03d_curr",type)
  end
  return bitmapFileName
end

#===============================================================================
# * Edit to the pbSave function to make sure outfit is saved for future load.
#===============================================================================

def pbSave(safesave=false)
  if $PokemonTemp.savedoutfit == false     #ADDED CODE
    saveAllOutfits                         #ADDED CODE
  end
  begin
    File.open(RTP.getSaveFileName("Game.rxdata"),"wb"){|f|
       Marshal.dump($Trainer,f)
       Marshal.dump(Graphics.frame_count,f)
       if $data_system.respond_to?("magic_number")
         $game_system.magic_number = $data_system.magic_number
       else
         $game_system.magic_number = $data_system.version_id
       end
       $game_system.save_count+=1
       Marshal.dump($game_system,f)
       Marshal.dump($PokemonSystem,f)
       Marshal.dump($game_map.map_id,f)
       Marshal.dump($game_switches,f)
       Marshal.dump($game_variables,f)
       Marshal.dump($game_self_switches,f)
       Marshal.dump($game_screen,f)
       Marshal.dump($MapFactory,f)
       Marshal.dump($game_player,f)
       $PokemonGlobal.safesave=safesave
       Marshal.dump($PokemonGlobal,f)
       Marshal.dump($PokemonMap,f)
       Marshal.dump($PokemonBag,f)
       Marshal.dump($PokemonStorage,f)
    }
    Graphics.frame_reset
  rescue
    return false
  end
  return true
end

#===============================================================================
# * Edit to the class Game_Player to erase the .png extension in the name.
#===============================================================================
=begin
class Game_Player
  def character_name
    if !@defaultCharacterName
      @defaultCharacterName=""
    end
    if @defaultCharacterName!=""
      return @defaultCharacterName.gsub(/\0/,"v")#(/\.png/,"")
    end
    if !moving? && !@move_route_forcing && $PokemonGlobal
      meta=pbGetMetadata(0,MetadataPlayerA+$Trainer.character_ID)
      if $Trainer.character_ID>=0 && meta && 
         !$PokemonGlobal.bicycle && !$PokemonGlobal.diving && !$PokemonGlobal.surfing
        if meta[4] && meta[4]!="" && Input.dir4!=0 && passable?(@x,@y,Input.dir4) && pbCanRun?
          # Display running character sprite
          @character_name=pbGetPlayerCharset(meta,4)
        else
          # Display normal character sprite 
          @character_name=pbGetPlayerCharset(meta,1)
        end
      end
    end
    return @character_name.gsub(/\.png/,"")
  end
end
=end