######################################################
#
#  ____                _   _             
# |  _ \              | \ | |            
# | |_) |_   _ _______|  \| | __ ___   __
# |  _ <| | | |_  /_  / . ` |/ _` \ \ / /
# | |_) | |_| |/ / / /| |\  | (_| |\ V / 
# |____/ \__,_/___/___|_| \_|\__,_| \_/  
#                                        
#               By Henry
#        Credit henrythefiend if used.
#
#
######################################################
#  _____        __      
# |_   _|      / _|     
#   | |  _ __ | |_ ___  
#   | | | '_ \|  _/ _ \ 
#  _| |_| | | | || (_) |
# |_____|_| |_|_| \___/ 
#                       
#
#        To call the BuzzNav, use pbBuzzNav
#
#  To add a new Buzz, add one in the "BUZZ" list.
#
#       !!!NO BUZZ SHOULD SHARE IDS!!!
#
#   Buzz.new(ID, Text, Icon, Speaker, Active)
#
#  Icon can be found in Graphics/Pictures/BuzzNav/Icons
#  Presenters can be found in Graphics/Pictures/BuzzNav/Presenters
#
#  Active has to be true or false. To turn a Buzz on or off,
#               use pbSetBuzz(ID, Active).
#
#
#  To change an existing Buzz's text without going into this menu,
#               use pbSetBuzzTxt(ID, "Buzz Text")
#
######################################################
#   _____      _   _   _                 
#  / ____|    | | | | (_)                
# | (___   ___| |_| |_ _ _ __   __ _ ___ 
#  \___ \ / _ \ __| __| | '_ \ / _` / __|
#  ____) |  __/ |_| |_| | | | | (_| \__ \
# |_____/ \___|\__|\__|_|_| |_|\__, |___/
#                               __/ |    
#                              |___/     
#
# USE_BGM should be on if you want to use BGM.
# BGM should be the name of your BGM. Only works
# if USE_BGM is on.
# When REPEAT is false, a Buzz won't appear after that
# same buzz appears. Example: If REPEAT is false, and you've
# got Buzz 1, 2, and 3 active, 1 will only happen after 2 or 3,
# never after another 1. Same goes with 2 only happening after
# 1 and 3, and 3 happening after 1 and 2.
USE_BGM = false
BGM = "Bgm1"
REPEAT = false
#
######################################################

PluginManager.register({
  :name => "BuzzNav",
  :version => "1.0",
  :credits => ["henrythefiend"],
  :link => "https://reliccastle.com/resources/447/"
})

class Buzz
  attr_accessor :id
  attr_accessor :buzztxt
  attr_accessor :icon
  attr_accessor :presenter
  attr_accessor :active
  def initialize(id, buzztxt, icon, presenter, active)
    self.id = id
    self.buzztxt = buzztxt
    self.icon = icon
    self.presenter = presenter
    self.active = active
  end
end



class PokeBattle_Trainer
  attr_accessor :buzz
  def buzz
    if !@BUZZ
      @BUZZ = [
         Buzz.new(1,"People are doing things!","iconchatter","ann1",false),
         Buzz.new(2,"I like Pokémon!","iconcatch","ann2",false),
         Buzz.new(3,"I found a Pokémon.","iconexplore","ann3",false),
         Buzz.new(4,"I'm a shopaholic.","iconmart","ann4",false),
         Buzz.new(5,"I like to battle.","icontrainer","ann5",false),
         Buzz.new(6,"Our region is great.","iconregion","ann1",true),
         Buzz.new(7,"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","icontrainer","ann2",true)
      ]
    end
    return @BUZZ
  end
end

def pbBuzzNav
  Buzznav.new
end

def pbSetBuzz(id, active)
  $Trainer.buzz.each{|b|
    if b.id==id
      b.active=active
      break
    end
  }
end

def pbSetBuzzTxt(id, buzztxt)
  $Trainer.buzz.each{|b|
    if b.id==id
      b.buzztxt=buzztxt
      break
    end
  }
end

class BuzzSprite < IconSprite
  attr_accessor :buzz
end

class Buzznav
  def initialize
    @scene = 0
    @mode = 0
    @anim = 0
    @scene = 0
    @lastbuzz = []
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["main"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["main"].z = 5
    @sprites["main"].opacity = 0
    @main = @sprites["main"].bitmap
    pbSetSystemFont(@main)
    
    @sprites["bg"] = IconSprite.new(0, 0, @viewport)
    @sprites["bg"].setBitmap("Graphics/Pictures/BuzzNav/bg")
    @sprites["bg"].opacity = 0
    
    @sprites["txtbox"] = IconSprite.new(0, 0, @viewport)
    @sprites["txtbox"].setBitmap("Graphics/Pictures/BuzzNav/txtbox")
    @sprites["txtbox"].z = 2
    @sprites["txtbox"].opacity = 0
    $game_system.bgm_memorize if USE_BGM==true
    pbBGMPlay(BGM) if USE_BGM==true
    12.times do
      Graphics.update
      @sprites["txtbox"].opacity += 32
      @sprites["bg"].opacity += 32
      @sprites["main"].opacity += 64
    end
    pbLoad
  end
  
  def pbLoad
    if @scene==0
      @frame = 0
      currentbuzz=[]
      loop do
        currentbuzz = $Trainer.buzz[rand($Trainer.buzz.length)]
        if currentbuzz.active 
          if currentbuzz.id != @lastbuzz || REPEAT==true
            break
          end
        end
      end
      @sprites["ann"] = IconSprite.new(300, 100, @viewport)
      @sprites["ann"].setBitmap("Graphics/Pictures/BuzzNav/Presenters/"+currentbuzz.presenter)
      @sprites["ann"].opacity = 0
      @sprites["icon"] = IconSprite.new(50, 50, @viewport)
      @sprites["icon"].setBitmap("Graphics/Pictures/BuzzNav/Icons/"+currentbuzz.icon)
      @sprites["icon"].opacity = 0
      @sprites["text"] = IconSprite.new(@viewport)
      @sprites["text"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
      @text = @sprites["text"].bitmap
      pbSetSystemFont(@text)
      drawTextExMulti(@main,10,260,500,3,currentbuzz.buzztxt,Color.new(255,255,255),Color.new(0,0,0))
      10.times do
        Graphics.update
        @sprites["main"].opacity += 32
        @sprites["text"].opacity += 32
        @sprites["icon"].opacity += 32
        @sprites["ann"].opacity += 32
      end
      150.times do
        pbWait(1)
        @frame += 1
        Graphics.update
        Input.update
        if Input.trigger?(Input::B)
          @scene=1
          pbEnd
          pbDisposeSpriteHash(@sprites)
          @viewport.dispose
          pbBGMStop(1.0) if USE_BGM==true
          $game_system.bgm_restore if USE_BGM==true
          pbWait(1)
          break
        end
        if @frame==3
          if @anim==0
            @sprites["ann"].y += 3
            @anim=1
          elsif @anim==1
            @sprites["ann"].y -= 3
            @anim=0
          end
        end
        @frame = 0 if @frame == 18
      end
      20.times do  
        @sprites["ann"].opacity -= 16 if @sprites["ann"]
        @sprites["icon"].opacity -= 16 if @sprites["icon"]
        @sprites["text"].opacity -= 16 if @sprites["text"]
        @sprites["main"].opacity -= 16 if @sprites["main"]
        @main.clear if @sprites["main"]
        pbWait(1)
      end
      @lastbuzz=currentbuzz.id
      pbLoad
    else
      return
    end
  end
  
  def pbEnd
    12.times do
      Graphics.update
      @sprites["bg"].opacity -= 32
      @sprites["main"].opacity -= 32
      @sprites["ann"].opacity -= 40
      @sprites["icon"].opacity -= 40
      @sprites["text"].opacity -= 40
      @sprites["txtbox"].opacity -= 40
    end
  end
end

###############################################################
#   _____              _ _ _     _    _                       #
#  / ____|            | (_) |   | |  | |                      #
# | |     _ __ ___  __| |_| |_  | |__| | ___ _ __  _ __ _   _ #
# | |    | '__/ _ \/ _` | | __| |  __  |/ _ \ '_ \| '__| | | |#
# | |____| | |  __/ (_| | | |_  | |  | |  __/ | | | |  | |_| |#
#  \_____|_|  \___|\__,_|_|\__| |_|  |_|\___|_| |_|_|   \__, |#
#                                                        __/ |#
#                                                       |___/ #
###############################################################