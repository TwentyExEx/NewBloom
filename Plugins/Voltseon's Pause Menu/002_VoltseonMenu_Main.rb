#-------------------------------------------------------------------------------
# Base class for defining a menu entry
#-------------------------------------------------------------------------------
class MenuEntry
	attr_reader :name

	def icon
		return MENU_FILE_PATH + @icon
	end

	def selected
		echoln "This Entry works!"
	end

	def selectable?
		return false
	end
end

#-------------------------------------------------------------------------------
# Base class for defining a menu component
#-------------------------------------------------------------------------------
class Component
	attr_accessor :viewport
	attr_accessor :sprites

	def startComponent(viewport,spritehash)
		@viewport = viewport
		@sprites = spritehash
	end

	def shouldDraw?
		return false
	end

	def refresh
		return false
	end

	def dispose
		pbDisposeSpriteHash(@sprites)
	end
end

#-------------------------------------------------------------------------------
# Main Pause Menu class
#-------------------------------------------------------------------------------
class PokemonPauseMenu_Scene
  attr_accessor :shouldExit
	attr_accessor :shouldRefresh

  def initialize
		@viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
		@sprites = {}
		# Background
		@sprites["backshade"] = Sprite.new(@viewport)
		@sprites["backshade"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
		@sprites["backshade"].bitmap.fill_rect(0,0,Graphics.width,Graphics.height,BACKGROUND_TINT)
		@sprites["backshade"].z = -10
		# Location window
		@sprites["location"] = Sprite.new(@viewport)
		# Menu arrows
		if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/arrow_left_#{$PokemonGlobal.current_menu_theme}")
			filename = MENU_FILE_PATH + "Backgrounds/arrow_left_#{$PokemonGlobal.current_menu_theme}"
		else
			filename = MENU_FILE_PATH + "Backgrounds/arrow_left_0"
		end
		@sprites["leftarrow"] = AnimatedSprite.new(filename,8,40,28,2,@viewport)
		@sprites["leftarrow"].x       = 180
		@sprites["leftarrow"].y       = 328
		@sprites["leftarrow"].z       = 2
		@sprites["leftarrow"].visible = true
		@sprites["leftarrow"].play
		if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/arrow_right_#{$PokemonGlobal.current_menu_theme}")
			filename = MENU_FILE_PATH + "Backgrounds/arrow_right_#{$PokemonGlobal.current_menu_theme}"
		else
			filename = MENU_FILE_PATH + "Backgrounds/arrow_right_0"
		end
		@sprites["rightarrow"] = AnimatedSprite.new(filename,8,40,28,2,@viewport)
		@sprites["rightarrow"].x       = 292
		@sprites["rightarrow"].y       = 328
		@sprites["rightarrow"].z       = 2
		@sprites["rightarrow"].visible = true
		@sprites["rightarrow"].play
		# Helpful Variables
		@shouldExit = false
		@shouldRefresh = true
		@hidden = false
		$theme_changed = false
	end

	def pbStartScene
		@viewport.z = 99999
		@components = []
		MENU_COMPONENTS.each do |c|
			next if c[/VoltseonsPauseMenu/i]
			component = Object.const_get(c).new
			@components.push(component) if component.shouldDraw?
		end
		@components.each do |component|
			component.startComponent(@viewport, @sprites)
		end
		@pauseMenu = VoltseonsPauseMenu.new
		@pauseMenu.startComponent(@viewport, @sprites, self)
		pbSEPlay(MENU_OPEN_SOUND)
		pbRefresh
		@pauseMenu.refreshMenu
		pbShowMenu
	end

	def pbHideMenu
		duration = Graphics.frame_rate/6
		duration.times do
			@sprites.each do |key,sprite|
				if key[/backshade/]
					sprite.opacity -= (255/duration)
					sprite.opacity.clamp(0,255)
				elsif key[/location/]
					sprite.x -= (sprite.bitmap.width/duration)
				else
					if sprite.y >= (Graphics.height/2) || key[/pokeoverlay/] || key[/menuback/]
						sprite.y += ((Graphics.height/2)/duration)
					else
						sprite.y -= ((Graphics.height/2)/duration)
					end
				end
			end
			Graphics.update
		end
		@hidden = true
  end

	def pbShowMenu
		xvals = {}
		yvals = {}
		if !@hidden
			@sprites.each do |key,sprite|
				xvals[key] = sprite.x
				yvals[key] = sprite.y
			end
			@sprites.each do |key,sprite|
				if key[/backshade/]
					sprite.opacity = 0
				elsif key[/location/]
					sprite.x -= sprite.bitmap.width
				else
					if sprite.y >= (Graphics.height/2) || key[/pokeoverlay/] || key[/menuback/]
						sprite.y += (Graphics.height/2)
					else
						sprite.y -= (Graphics.height/2)
					end
				end
			end
		end
		duration = Graphics.frame_rate/6
		duration.times do
			@sprites.each do |key,sprite|
				if key[/backshade/]
					sprite.opacity += (255/duration)
					sprite.opacity.clamp(0,255)
				elsif key[/location/]
					sprite.x += (sprite.bitmap.width/duration)
				else
					if sprite.y >= (Graphics.height/2) || key[/pokeoverlay/] || key[/menuback/]
						sprite.y -= ((Graphics.height/2)/duration)
					else
						sprite.y += ((Graphics.height/2)/duration)
					end
				end
			end
			Graphics.update
		end
		if !@hidden
			@sprites.each do |key,sprite|
				@sprites[key].x = xvals[key]
				@sprites[key].y = yvals[key]
			end
		end
		@hidden = false
	end

	def update
		@hasTerminated = false
		loop do
			Graphics.update
			Input.update
			pbUpdateSpriteHash(@sprites)
			@pauseMenu.update
			return if @hasTerminated # If pbEndScene was already called, don't call it again.
			pbRefresh if @shouldRefresh
			pbUpdateSceneMap
			if @shouldExit
				pbEndScene
				break
			end
		end
	end

	def pbRefresh
		return if @shouldExit
		# Refresh the location text
		@sprites["location"].bitmap.clear if @sprites["location"].bitmap
		if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/bg_location_#{$PokemonGlobal.current_menu_theme}")
			filename = MENU_FILE_PATH + "Backgrounds/bg_location_#{$PokemonGlobal.current_menu_theme}"
		else
			filename = MENU_FILE_PATH + "Backgrounds/bg_location_0"
		end
		@sprites["location"].bitmap = Bitmap.new(filename)
		mapname = $game_map.name
		baseColor = LOCATION_TEXTCOLOR[$PokemonGlobal.current_menu_theme].is_a?(Color) ? LOCATION_TEXTCOLOR[$PokemonGlobal.current_menu_theme] : Color.new(248,248,248)
		shadowColor = LOCATION_TEXTOUTLINE[$PokemonGlobal.current_menu_theme].is_a?(Color) ? LOCATION_TEXTOUTLINE[$PokemonGlobal.current_menu_theme] : Color.new(48,48,48)
		xOffset = @sprites["location"].bitmap.width - 64
		pbSetSystemFont(@sprites["location"].bitmap)
		pbDrawTextPositions(@sprites["location"].bitmap,[["#{$game_map.name}",xOffset,4,1,baseColor,shadowColor,true]])
		@sprites["location"].x = -@sprites["location"].bitmap.width + (@sprites["location"].bitmap.text_size($game_map.name).width + 64 + 32)
		@components.each do |component|
			component.refresh
		end
		@shouldRefresh = false
	end

	def pbEndScene
		pbSEPlay(MENU_CLOSE_SOUND)
		pbHideMenu
		@hasTerminated = true
		@pauseMenu.dispose
		@components.each do |component|
			component.dispose
		end
		pbDisposeSpriteHash(@sprites)
		@viewport.dispose
	end
end

#-------------------------------------------------------------------------------
# Overriding the default Pause Menu Screen calls
#-------------------------------------------------------------------------------
class PokemonPauseMenu
	def initialize(scene)
		@scene = scene
	end

	def pbShowMenu
		@scene.pbRefresh
		@scene.pbShowMenu
	end

	def pbStartPokemonMenu
		@scene.pbStartScene
		@scene.update
	end
end

#-------------------------------------------------------------------------------
# Debug command to change menu themes
#-------------------------------------------------------------------------------
DebugMenuCommands.register("setmenutheme", {
  "parent"      => "playermenu",
  "name"        => _INTL("Set Menu Theme"),
  "description" => _INTL("Change the Menu Theme for Voltseon's Pause Menu..."),
  "effect"      => proc {
		oldval = $PokemonGlobal.current_menu_theme
    params = ChooseNumberParams.new
		maxval = 0
		loop do
			if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/bg_#{maxval}")
				maxval += 1
			else
				break
			end
		end
		if maxval < 1
			pbMessage("There are no alternate themes to change to.")
			next
		end
		maxval -= 1
    params.setRange(0, maxval)
    params.setDefaultValue($PokemonGlobal.current_menu_theme)
    $PokemonGlobal.current_menu_theme = pbMessageChooseNumber(_INTL("Set the menu theme. (0 - #{maxval})"), params)
    pbMessage(_INTL("The menu theme has been set to {1}.", $PokemonGlobal.current_menu_theme))
		$theme_changed = (oldval != $PokemonGlobal.current_menu_theme)
  }
})

#-------------------------------------------------------------------------------
# Attribute in PokemonGlobal to save the current menu theme in the save file
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
	attr_writer :current_menu_theme

	def current_menu_theme
		@current_menu_theme = DEFAULT_MENU_THEME if !@current_menu_theme
		return @current_menu_theme
	end
end

# The person reading this is very cool!
# Thanks (:
