#===============================================================================
#  Easy Mouse System
#   by Luka S.J   
#
#  Enjoy the script, and make sure to give credit!
#===============================================================================  
# set up plugin metadata
if defined?(PluginManager)
  PluginManager.register({
    :name => "Easy Mouse System",
    :version => "1.4.1",
    :link => "https://luka-sj.com/res/esms",
    :credits => ["Luka S.J."]
  })
end
#-------------------------------------------------------------------------------
RNET = FileTest.exist?("Rpg.NET.dll") ? "Rpg.NET.dll" : false # Rpg.NET.dll reference

INACTIVITY_TIMER = -1 # The amount of time (in seconds) needed to pass before the
                      # mouse is considered as inactive. Set to a negative
                      # number to disable entirely.
CLICK_TIMEOUT = 1  # Amount of time (in seconds) before release of mouse click,
                   # until that mouse click becomes invalid
#===============================================================================
#  ** Class Mouse
#   by Luka S.J.
#-------------------------------------------------------------------------------
# Mouse input class to enable the usage of the module Mouse
#
#     * Requires module Mouse (by Peter O.)
#     * Requires module Input (by Peter O.)
#     * Requires Rpg.NET.dll for Mouse scrolling
#===============================================================================
class Game_Mouse
  #-----------------------------------------------------------------------------
  attr_reader :visible
  attr_reader :x
  attr_reader :y
  attr_reader :object_ox
  attr_reader :object_oy
  #-----------------------------------------------------------------------------
  # Requires the Rpg.NET.dll for mouse scrolling
  #-----------------------------------------------------------------------------
  if RNET
    Win32API.new(RNET, 'Initialize', 'i', '').call(1)
    WheelDelta = Win32API.new(RNET, 'InputGetWheelDelta', '', 'i')
  end
  #-----------------------------------------------------------------------------
  # starts up the mouse and determines initial co-ordinate
  #-----------------------------------------------------------------------------
  def initialize
    @position = Mouse.getMousePos
    @cursor = Win32API.new("user32", "ShowCursor", "i", "i" )
    @inactive_timer = 0
    @wheel = 0
    @delta = 0
    @drag = nil
    @hold = false
    @drag_object = nil
    @drag_buffer = 0
    @visible = false
    @long = 0
    @rect_x = nil
    @rect_y = nil
    if @position.nil?
      @x = -5000
      @y = -5000
    else
      @x = @position[0]
      @y = @position[1]
    end
    @static_x = @x
    @static_y = @y
    @moved_x = @x
    @moved_y = @y
    @x_offset = 0
    @y_offset = 0
    @object_ox = nil
    @object_oy = nil
  end
  #-----------------------------------------------------------------------------
  # updates the mouse (update placed in Input.update)
  #-----------------------------------------------------------------------------
  def update
    @position = Mouse.getMousePos
    @delta = WheelDelta.call / 120 if RNET
    if !@position.nil?
      @x = @position[0]
      @y = @position[1]
      @x -= $ResizeOffsetX if $ResizeOffsetX
      @y -= $ResizeOffsetY if $ResizeOffsetY
    end
    if INACTIVITY_TIMER >= 0 && self.notMoved?
      @inactive_timer += 1
    else
      @inactive_timer = 0
    end
  end
  #-----------------------------------------------------------------------------
  # manipulation of the visibility of the mouse sprite
  #-----------------------------------------------------------------------------
  def show
    @cursor.call(1)
    @visible=true
  end
  
  def hide
    @cursor.call(0)
    @visible=false
  end
  #-----------------------------------------------------------------------------
  # checks whether or not the mouse is active
  #-----------------------------------------------------------------------------
  def active?
    return false if @position.nil?
    return true if INACTIVITY_TIMER < 0
    return false if @inactive_timer > INACTIVITY_TIMER*Graphics.frame_rate
    return true
  end
  #-----------------------------------------------------------------------------
  # global method to retrieve input button
  #-----------------------------------------------------------------------------
  def button?(arg=0)
    input = [Input::Mouse_Left,Input::Mouse_Right,Input::Mouse_Middle]
    if arg.is_a?(Numeric)
      arg = 0 if arg < 0 || arg >= input.length
    elsif arg.is_a?(String)
      arg = 0 if arg=="left"
      arg = 1 if arg=="right"
      arg = 2 if arg=="middle"
    else
      arg = 0
    end
    return input[arg]
  end
  #-----------------------------------------------------------------------------
  # gets the necessary object parameters for mouse checks
  #-----------------------------------------------------------------------------
  def objectParams?(object=nil)
    return 0, 0, 0, 0 if object.nil?
    x, y, w, h = 0, 0, 0, 0
    if object.is_a?(Sprite)
      x = (object.x-object.ox)
      y = (object.y-object.oy)
      if object.respond_to?(:viewport) && object.viewport
        x+=object.viewport.rect.x
        y+=object.viewport.rect.y
      end
      w = (object.bitmap.width*object.zoom_x) if object.bitmap
      h = (object.bitmap.height*object.zoom_y) if object.bitmap
      if object.respond_to?(:src_rect)
        w = (object.src_rect.width*object.zoom_x) if object.bitmap && object.src_rect.width != object.bitmap.width
        h = (object.src_rect.height*object.zoom_y) if object.bitmap && object.src_rect.height != object.bitmap.height
      end
      w = (object.width*object.zoom_x) if object.respond_to?(:width)
      h = (object.height*object.zoom_y) if object.respond_to?(:height)
    elsif object.is_a?(Viewport)
      x, y, w, h = object.rect.x, object.rect.y, object.rect.width, object.rect.height
    else
      x = (object.x) if object.respond_to?(:x)
      y = (object.y) if object.respond_to?(:y)
      if object.respond_to?(:viewport) && object.viewport
        x+=object.viewport.rect.x
        y+=object.viewport.rect.y
      end
      w = (object.width) if object.respond_to?(:width)
      h = (object.height) if object.respond_to?(:height)
    end
    return x, y, w, h
  end
  #-----------------------------------------------------------------------------
  # checks if mouse is over a sprite (can define custom width and height)
  #-----------------------------------------------------------------------------
  def over?(*args)
    object, width, height, void = args
    return false if object.nil? || !self.active?
    x, y, w, h = self.objectParams?(object)
    w = width if !width.nil?; h = height if !height.nil?
    return true if @x >= x && @x <= (x + w) and @y >= y && @y <= (y + h)
    return false
  end
  #-----------------------------------------------------------------------------
  # special method to check whether the mouse is over sprites with special shapes
  #-----------------------------------------------------------------------------
  def overPixel?(*args)
    sprite, void = args
    return false if !sprite.respond_to?(:bitmap) || !self.active?
    bitmap = sprite.bitmap
    return false if !self.over?(sprite)
    x, y, w, h = self.objectParams?(sprite)
    bx = @x-x
    by = @y-y
    return true if bitmap.get_pixel(bx,by).alpha>0
    return false
  end
  #-----------------------------------------------------------------------------
  # checks if the mouse is being dragged
  #-----------------------------------------------------------------------------
  def dragging?(*args)
    object, input = args; dragging = false
    return false if (!object.nil? && !self.over?(object)) || !self.active?
    @drag = [@x,@y] if @drag.nil? && Input.pressex?(self.button?(input))
    if @drag.is_a?(Array) && (@drag[0]!=@x || @drag[1]!=@y) && Input.pressex?(self.button?(input))
      @drag = true
      if !object.nil?
        @drag_object = object
        @object_ox = @x - object.x
        @object_oy = @y - object.y
      end
    end
    dragging = true if @drag==true
    if !Input.pressex?(self.button?(input))
      @drag = nil 
      @drag_object = nil
    end
    return dragging
  end   
  #-----------------------------------------------------------------------------
  # returns the distance moved when dragging the mouse
  # relies on def dragging? / cannot be used standalone
  #-----------------------------------------------------------------------------
  def dragged_x?
    return @x - @x_offset
  end
  def dragged_y?
    return @y - @y_offset
  end
  #-----------------------------------------------------------------------------
  # method used for dragging objects with the mouse
  # can be confined to a Rect object
  #-----------------------------------------------------------------------------
  def drag_object?(*args)
    object, lock, rect, input = *args
    return false if !self.dragging?(object) || !self.active?
    ret = false
    if Input.pressex?(self.button?(input))
      object.x = @x - @object_ox if lock!="vertical"
      object.y = @y - @object_oy if lock!="horizontal"
      if !rect.nil?
        x, y, w, h = self.objectParams?(rect)
        object.x = x if object.x < x if lock!="vertical"
        object.y = y if object.y < y if lock!="horizontal"
        width = self.objectParams?(object)[2]
        height = self.objectParams?(object)[3]
        object.x = x+w-width if object.x > x+w-width if lock!="vertical"
        object.y = y+h-height if object.y > y+h-height if lock!="horizontal"
      end
      ret = true
    end
    return ret
  end  
  #-----------------------------------------------------------------------------
  # checks if mouse is being pressed and held down for a period of timme
  #-----------------------------------------------------------------------------
  def long?(*args)
    object, input = args
    return false if !self.active?
    if self.press?(object,input)
      @long+=1
    else
      @long = 0
    end
    return true if @long > Graphics.frame_rate*CLICK_TIMEOUT
    return false
  end
  #-----------------------------------------------------------------------------
  # creates a Rect object based on mouse dragging
  # takes an optional object parameter to specify a "viewport" of sorts
  #-----------------------------------------------------------------------------
  def createRect(*args)
    object, input = args
    return Rect.new(0,0,0,0) if (!object.nil? && !self.over?(object) && Input.pressex?(self.button?(input)) && @rect_x.nil?) || !self.active?
    if Input.pressex?(self.button?(input))
      @rect_x = @x if @rect_x.nil?
      @rect_y = @y if @rect_y.nil?
      x = (@x < @rect_x) ? @x : @rect_x
      y = (@y < @rect_y) ? @y : @rect_y
      w = (@x < @rect_x) ? (@rect_x-@x) : (@x-@rect_x)
      h = (@y < @rect_y) ? (@rect_y-@y) : (@y-@rect_y)
      if !object.nil?
        x2, y2, w2, h2 = self.objectParams?(object)
        x-=x2; y-=y2  
      end
      return Rect.new(x,y,w,h)
    else
      @rect_x = nil
      @rect_y = nil
      return Rect.new(0,0,0,0)
    end
  end
  #-----------------------------------------------------------------------------
  # checks if mouse is left clicking a sprite (can define custom width and height)  
  # (applies dragging) 
  #-----------------------------------------------------------------------------
  def click?(*args)
    object, input, width, height = args; ret = false
    return false if (!object.nil? && !self.over?(object,width,height)) || !self.active?
    @hold = true if Input.pressex?(self.button?(input))
    if @hold && Input.releaseex?(self.button?(input))
      @hold = false
      ret = !self.dragging?(nil,input) && !(@long > Graphics.frame_rate*CLICK_TIMEOUT)
    end
    self.long?(nil,input)
    return ret 
  end
  
  def click_old?(*args)
    object, input = args
    return false if (!object.nil? && !self.over?(object)) || !self.active?
    return Input.triggerex?(self.button?(input))
  end  
  #-----------------------------------------------------------------------------
  # checks if mouse is left clicking a sprite / continuous (can define custom width and height)
  #-----------------------------------------------------------------------------
  def press?(*args)
    object, input, width, height = args
    return false if (!object.nil? && !self.over?(object,width,height)) || !self.active?
    return Input.pressex?(self.button?(input))
  end
  #-----------------------------------------------------------------------------
  # checks if the mouse is in a certain area of the App window
  #-----------------------------------------------------------------------------
  def inArea?(*args)
    x, y, w, h = args
    return self.over?(Rect.new(x,y,w,h))
  end
  #-----------------------------------------------------------------------------
  # checks if the mouse is left clicking in a certain area of the App window
  #-----------------------------------------------------------------------------
  def areaClick?(*args)
    x, y, w, h, input = args
    return self.click?(Rect.new(x,y,w,h),input)
  end
  #-----------------------------------------------------------------------------
  # checks if the mouse is right clicking in a certain area of the App window
  #-----------------------------------------------------------------------------
  def areaPress?(*args)
    x, y, w, h, input = args
    return self.press?(Rect.new(x,y,w,h),input)
  end
  #-----------------------------------------------------------------------------
  # checks if the mouse is idle/ not moving around
  #-----------------------------------------------------------------------------
  def isStatic?
    ret=false
    ret=true if @static_x==@x && @static_y==@y
    if !(@static_x==@x) || !(@static_y==@y)
      @static_x=@x
      @static_y=@y
    end
    return ret
  end
  #-----------------------------------------------------------------------------
  # same thing as above, but named differently for the BW kit
  #-----------------------------------------------------------------------------
  def notMoved?
    return isStatic
  end
  #-----------------------------------------------------------------------------
  # checks if mouse is scrolling upwards (works with multi-touch gestures)
  #-----------------------------------------------------------------------------
  def scroll_up?
    return false if !self.active?
    ret = false
    ret = true if @delta-@wheel>0
    @inactive_timer = 0 if ret
    if @delta!=@wheel && ret
      @wheel = @delta
    end
    return ret
  end
  #-----------------------------------------------------------------------------
  # checks if mouse is scrolling downwards (works with multi-touch gestures)
  #-----------------------------------------------------------------------------
  def scroll_down?
    return false if !self.active?
    ret = false
    ret = true if @delta-@wheel<0
    @inactive_timer = 0 if ret
    if @delta!=@wheel && ret
      @wheel = @delta
    end
    return ret
  end
  #-----------------------------------------------------------------------------
  # Legacy functions
  #-----------------------------------------------------------------------------
  def leftClick?(object=nil,width=nil,height=nil)
    return self.click?(object,0,width,height)
  end
  
  def rightClick?(object=nil,width=nil,height=nil)
    return self.click_old?(object,1,width,height)
  end
  
  def leftPress?(object=nil,width=nil,height=nil)
    return self.press?(object,0,width,height)
  end
  
  def rightPress?(object=nil,width=nil,height=nil)
    return self.press?(object,1,width,height)
  end
      
  def inAreaLeft?(x,y,w,h)
    self.areaClick?(x,y,w,h,0)
  end
  
  def inAreaRight?(x,y,w,h)
    self.areaClick?(x,y,w,h,1)
  end
  
  def inAreaLeftPress?(x,y,w,h)
    self.areaPress?(x,y,w,h,0)
  end
  
  def inAreaRightPress?(x,y,w,h)
    self.areaPress?(x,y,w,h,1)
  end
  
  def drag_object_x?(object,rect=nil)
    return self.drag_object?(object,"horizontal",rect)
  end
  
  def drag_object_y?(object,rect=nil)
    return self.drag_object?(object,"vertical",rect)
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Mouse update methods for the Input module
#===============================================================================
module Input
  #-----------------------------------------------------------------------------
  Mouse_Left = 0x01
  Mouse_Right = 0x02
  Mouse_Middle = 0x04
  #-----------------------------------------------------------------------------
  class << Input
    alias update_mouse update
  end
  #-----------------------------------------------------------------------------
  def self.update
    $mouse.update if defined?($mouse) && $mouse
    update_mouse
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Initializes the Game_Mouse class
#===============================================================================
$mouse = Game_Mouse.new