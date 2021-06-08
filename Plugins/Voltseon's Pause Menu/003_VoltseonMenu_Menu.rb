#-------------------------------------------------------------------------------
# Main Pause Menu component
#-------------------------------------------------------------------------------
class VoltseonsPauseMenu < Component
	def startComponent(viewport, spritehash, menu)
		super(viewport,spritehash)
		@menu = menu
		@entries = []
		@originY = Graphics.height/2 - ICON_HEIGHT / 2
		@currentSelection = 0
		@shouldRefresh = true
		# Background image
		@sprites["menuback"] = Sprite.new(@viewport)
		if pbResolveBitmap(MENU_FILE_PATH + "Backgrounds/bg_#{$PokemonGlobal.current_menu_theme}")
			@sprites["menuback"].bitmap = Bitmap.new(MENU_FILE_PATH + "Backgrounds/bg_#{$PokemonGlobal.current_menu_theme}")
		else
			@sprites["menuback"].bitmap = Bitmap.new(MENU_FILE_PATH + "Backgrounds/bg_0")
		end
		@sprites["menuback"].z        = -5
		# Did you know that the first pokémon you see in Red and Blue, Nidorino plays a Nidorina cry?
		# This could have been prevented if they just used vCry("Nidorino") ;)
		# Voltseon's Handy Tools is available at https://reliccastle.com/resources/400/4
		calculateMenuEntries
		calculateDisplayIndex
		redrawMenuIcons
		@sprites["dummyiconL"] = IconSprite.new(0,0,@viewport)
		@sprites["dummyiconL"].y = 342
		@sprites["dummyiconL"].ox = ICON_WIDTH/2
		@sprites["dummyiconL"].oy = ICON_HEIGHT/2

		@sprites["dummyiconR"] = IconSprite.new(0,0,@viewport)
		@sprites["dummyiconR"].y = 342
		@sprites["dummyiconR"].ox = ICON_WIDTH/2
		@sprites["dummyiconR"].oy = ICON_HEIGHT/2
		calculateXPositions(true)
		@sprites["entrytext"] = BitmapSprite.new(256,40,@viewport)
		@sprites["entrytext"].y = @originY + 32
		@sprites["entrytext"].ox = 128
		@sprites["entrytext"].x = Graphics.width/2
		@doingStartup = true
	end

	def update
		exit = false # should the menu-loop continue
		if Input.trigger?(Input::B)
			@menu.shouldExit = true
			return
		elsif Input.press?(Input::LEFT)
			shiftCursor(-1)
		elsif Input.press?(Input::RIGHT) && @displayIndexes.length > 1
			shiftCursor(1)
		elsif Input.trigger?(Input::C)
			exit = @entries[@currentSelection].selected(@menu) # trigger selected entry.
			calculateMenuEntries
			calculateDisplayIndex
			redrawMenuIcons
			calculateXPositions(true)
			@shouldRefresh = true
		end
		if @shouldRefresh && !@menu.shouldExit
			refreshMenu
			@menu.shouldRefresh = true
			@shouldRefresh = false
		end
		@menu.shouldExit = exit
	end

	# direction is either 1 (right) or -1 (left)
	def shiftCursor(direction)
		@currentSelection += direction
		# keep selection within array bounds
		@currentSelection = @entries.length-1 if @currentSelection < 0
		@currentSelection = 0 if @currentSelection >= @entries.length
		# Shift array elements
		if direction < 0
			el = @entries.length - 1
			temp = @entryIndexes[el].clone
			@entryIndexes[el] = nil
			e_temp = @entryIndexes.clone
			for i in 0...(el + 1)
				@entryIndexes[i + 1] = e_temp[i]
			end
			@entryIndexes[0] = temp
			@entryIndexes.compact!
		else
			ret = @entryIndexes.shift
			@entryIndexes.push(ret)
		end
		@shouldRefresh = true
		pbSEPlay(MENU_CURSOR_SOUND)
		# Animation stuff
		offset = 63/(@displayIndexes.length/2) rescue 63
		offset = offset.clamp(21,63)
		duration = (Graphics.frame_rate/8)
		middle = @displayIndexes.length/2
		duration.times do
			for key in @sprites.keys
				next if !key[/icon/]
				total = (direction > 0)? @iconsDeviationL[key] : @iconsDeviationR[key]
				amt2 = (total/(duration * 1.0))
				amt = ((direction > 0) ? amt2.floor : amt2.ceil).to_i
				@sprites[key].x += amt
				finalpos = (@iconsBaseX[key] + total)
				baseX = direction > 0 ? (@sprites[key].x <= finalpos) : (@sprites[key].x >= finalpos)
				@sprites[key].x = (@iconsBaseX[key] + total) if baseX
			end
			@sprites["icon#{middle}"].zoom_x -= (ACTIVE_SCALE - 1.0)/(duration)
			@sprites["icon#{middle}"].zoom_y -= (ACTIVE_SCALE - 1.0)/(duration)
			mdr = middle + direction
			mdr = mdr.clamp(0,6)
			@sprites["icon#{mdr}"].zoom_x += (ACTIVE_SCALE - 1.0)/(duration)
			@sprites["icon#{mdr}"].zoom_y += (ACTIVE_SCALE - 1.0)/(duration)
			pbUpdateSpriteHash(@sprites)
			Graphics.update
		end
		calculateXPositions
	end

	# Calculate indexes of sprites to be displayed
	def calculateDisplayIndex
		@displayIndexes = @entryIndexes.clone
		if @entryIndexes.length%2 == 0
			@displayIndexes[0] = nil
			@displayIndexes.compact!
		end
		if @displayIndexes.length > 7
			offset = (@entryIndexes.length - 7) - 1
			startVal = @entryIndexes.length - (offset + 7)
			endVal = @entryIndexes.length - offset
			@displayIndexes = @displayIndexes[startVal...endVal]
		end
	end

	# Get all the entries to be displayed
	def calculateMenuEntries
		oldentries = @entries.length
		@entries = []
		MENU_ENTRIES.each do |entry|
			menuEntry = Object.const_get(entry).new
			@entries.push(menuEntry) if menuEntry.selectable?
		end
		if @entries.length != oldentries && oldentries != 0
			@currentSelection += (@entries.length - oldentries)
			@currentSelection = @currentSelection.clamp(0,@entries.length - 1)
		end
		@entryIndexes = []
		middle = @entries.length/2
		@entryIndexes[middle] = @currentSelection
		current = @currentSelection + 1
		# Calculating an array in the fashion [...,5,6,0,1,2....]
		for i in (middle + 1)...@entries.length
			current = 0 if current >= @entries.length
			@entryIndexes[i] = current
			current += 1
		end
		for i in 0...middle
			current = 0 if current >= @entries.length
			@entryIndexes[i] = current
			current += 1
		end
	end

	def redrawMenuIcons
		for key in @sprites.keys
			next if !key[/icon/] || key[/dummy/]
			@sprites[key].dispose
			@sprites[key] = nil
			@sprites.delete(key)
		end
		middle = @displayIndexes.length/2
		for i in 0...@displayIndexes.length
			@sprites["icon#{i}"] = IconSprite.new(0,0,@viewport)
			@sprites["icon#{i}"].visible = true
			@sprites["icon#{i}"].y = 342
			@sprites["icon#{i}"].ox = ICON_WIDTH/2
			@sprites["icon#{i}"].oy = ICON_HEIGHT/2
		end
		if @displayIndexes.length == 2
			@sprites["icon1"] = IconSprite.new(0,0,@viewport)
			@sprites["icon1"].visible = true
			@sprites["icon1"].y = 342
			@sprites["icon1"].ox = ICON_WIDTH/2
			@sprites["icon1"].oy = ICON_HEIGHT/2
		end
	end

	# Calculate x positions of icons after animation is complete
	def calculateXPositions(recalc = false)
		middle = @displayIndexes.length/2
		@sprites["icon#{middle}"].x = 256
		offset = 63/(@displayIndexes.length/2) rescue 63
		offset = offset.clamp(21,63)
		@sprites["dummyiconL"].x = 1 + (ICON_WIDTH/2) - (ICON_WIDTH + offset)
		for i in 0...middle
			finalx = 1 + (ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2)
			finalx += ((ICON_WIDTH + offset) * i)
			@sprites["icon#{i}"].x = finalx
		end
		lastx = 0
		for i in (middle + 1)...@displayIndexes.length
			finalx = 256 + (ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2)
			finalx += ((ICON_WIDTH + offset) * (i - middle))
			@sprites["icon#{i}"].x = finalx
			lastx = finalx
		end
		@sprites["dummyiconR"].x = lastx + (ICON_WIDTH + offset)
		return if !recalc
		@iconsBaseX = {}
		@iconsDeviationL = {}
		@iconsDeviationR = {}
		for key in @sprites.keys
			next if !key[/icon/]
			@iconsBaseX[key] = @sprites[key].x
			if key[/#{middle}/]
				@iconsDeviationL[key] = - ((ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2) + (ICON_WIDTH + offset))
				@iconsDeviationR[key] = ((ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2) + (ICON_WIDTH + offset))
			elsif key[/#{middle + 1}/]
				@iconsDeviationL[key] = - ((ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2) + (ICON_WIDTH + offset))
				@iconsDeviationR[key] = (ICON_WIDTH + offset)
			elsif key[/#{middle - 1}/]
				@iconsDeviationL[key] = - (ICON_WIDTH + offset)
				@iconsDeviationR[key] = ((ICON_WIDTH/2) + ((offset - 21) * @displayIndexes.length/2) + (ICON_WIDTH + offset))
			else
				@iconsDeviationL[key] = - (ICON_WIDTH + offset)
				@iconsDeviationR[key] = (ICON_WIDTH + offset)
			end
		end
	end

	def refreshMenu
		calculateDisplayIndex
		middle = @displayIndexes.length/2
		for i in 0...@displayIndexes.length
			@sprites["icon#{i}"].setBitmap(@entries[@displayIndexes[i]].icon)
			@sprites["icon#{i}"].zoom_x = 1
			@sprites["icon#{i}"].zoom_y = 1
		end
		@sprites["icon#{middle}"].zoom_x = ACTIVE_SCALE
		@sprites["icon#{middle}"].zoom_y = ACTIVE_SCALE
		if @entries.length <= 8
			b2 = @entries[@entryIndexes[0]].icon
			b1 = ((@entries.length%2==0)? @entries[@entryIndexes[0]] : @entries[@entryIndexes[@displayIndexes.length - 1]]).icon
		else
			offset = (@entryIndexes.length - 7) - 1
			b1 = @entries[@entryIndexes[offset - 1]].icon
			b2 = @entries[@entryIndexes[@displayIndexes.length + offset]].icon
		end
		@sprites["dummyiconL"].setBitmap(b1)
		@sprites["dummyiconR"].setBitmap(b2)
		return if !SHOW_MENU_NAMES
		@sprites["entrytext"].bitmap.clear
		text = @entries[@currentSelection].name
		pbSetSystemFont(@sprites["entrytext"].bitmap)
		baseColor = MENU_TEXTCOLOR[$PokemonGlobal.current_menu_theme].is_a?(Color) ? MENU_TEXTCOLOR[$PokemonGlobal.current_menu_theme] : Color.new(248,248,248)
		shadowColor = MENU_TEXTOUTLINE[$PokemonGlobal.current_menu_theme].is_a?(Color) ? MENU_TEXTOUTLINE[$PokemonGlobal.current_menu_theme] : Color.new(48,48,48)
		pbDrawTextPositions(@sprites["entrytext"].bitmap,[[text,128,0,2,baseColor,shadowColor]])
	end
end
