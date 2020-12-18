def pbPersonalityTest
	@lonely = 0
	@brave = 0
	@relaxed = 0
	@rash = 0
	@bashful = 0
	@careful = 0
	@hardy = 0
	@serious = 0
	@naive = 0
	@lax = 0
	@gentle = 0
	@quirky = 0
	@bold = 0
	@sassy = 0
	@jolly = 0
	@impish = 0
	@docile = 0
	@naughty = 0
	@calm = 0
	@quiet = 0
	@adamant = 0
	@mild = 0
	@modest = 0
	@hasty = 0
	@timid = 0

# Question 1
    cmd=pbMessage("You're cooking a new recipe, but midway through preparations, you realize you're missing a few ingredients. What do you do?",["Go to the store and buy them.","Substitute them with something else."])
    if cmd == 0
        @careful += 2
        @serious += 1
    elsif cmd == 1
        @lax += 2
        @quirky += 1
    end
# Question 2
	cmd=pbMessage("You've just seen someone trip! What do you do?",["Go over to them and help them up.","Take them to the hospital.","Quietly laugh. How did they manage that?!"])
	if cmd == 0
		@mild += 2
		@brave += 1
	elsif cmd == 1
		@hasty += 2
		@careful += 1
	elsif cmd == 2
		@naughty +=2
		@impish +=1
	end
# Question 3
	cmd=pbMessage("You're in a play with friends. What kind of role do you prefer?",["The starring role. I want all eyes on me!","The supportive best friend.","The tree in the back."])
	if cmd == 0
		@sassy += 2
		@jolly += 1
	elsif cmd == 1
		@modest += 2
		@calm += 1
	elsif cmd == 2
		@bashful +=2
		@timid +=1
	end
# Question 4
	cmd=pbMessage("Your friends seem to be having a fun chat out of earshot. What do you do?",["Leave. I'm probably left out for a reason.","Try to join in when there's an opportunity.","Interrupt and redirect the conversation."])
	if cmd == 0
		@lonely += 2
		@bashful += 1
	elsif cmd == 1
		@timid += 2
		@mild += 1
	elsif cmd == 2
		@bold +=2
		@sassy +=1
	end
# Question 5
	cmd=pbMessage("You find something at a great bargain! What do you do?",["Jump at the deal and buy it.","Consider if I really need it before deciding."])
	if cmd == 0
		@hasty += 2
		@adamant += 1
	elsif cmd == 1
		@careful += 2
		@mild += 1
	end
# Question 6
	cmd=pbMessage("You're going on a day trip to the mountains. What are you most excited to do?",["Hiking. It's perfect to clear my mind.","Roasting marshmallows. Delicious!","Telling ghost stories. Boo!"])
	if cmd == 0
		@serious += 2
		@hardy += 1
	elsif cmd == 1
		@quirky += 2
		@relaxed += 1
	elsif cmd == 2
		@impish +=2
		@jolly +=1
	end
# Question 7
	cmd=pbMessage("You are planning a vacation! Where would you prefer to go?",["Somewhere totally new.","Somewhere close to home."])
	if cmd == 0
		@bold += 2
		@brave += 1
	elsif cmd == 1
		@timid += 2
		@quiet += 1
	end
# Question 8
	cmd=pbMessage("If you face a problem at work, what is the first thing you do?",["Pretend I never noticed.","Experiment to see what fixes it.","Ask for help. Someone else could do better."])
	if cmd == 0
		@naughty += 2
		@hasty += 1
	elsif cmd == 1
		@sassy += 2
		@careful += 1
	elsif cmd == 2
		@modest +=2
		@docile +=1
	end
# Question 9
	cmd=pbMessage("You are at a restaurant you've been to before. What do you order?",["Play it safe and stick with my usual order.","Whatever looks good in the menu!","Go with the waiter's recommendation."])
	if cmd == 0
		@adamant += 2
		@modest += 1
	elsif cmd == 1
		@jolly += 2
		@lax += 1
	elsif cmd == 2
		@docile +=2
		@calm +=1
	end
# Question 10
	cmd=pbMessage("How do you go about making big decisions?",["Go with my gut then move on.","Weigh out the pros and cons."])
	if cmd == 0
		@rash += 2
		@adamant += 1
	elsif cmd == 1
		@serious += 2
		@modest += 1
	end
# Question 11
	cmd=pbMessage("How do you usually participate in group projects?",["Assume the role of the leader.","Do whatever no one else wants to do.","Act as moral support."])
	if cmd == 0
		@hardy += 2
		@rash += 1
	elsif cmd == 1
		@docile += 2
		@lonely += 1
	elsif cmd == 2
		@naive +=2
		@gentle +=1
	end
# Question 12
	cmd=pbMessage("Your friend just got a new pet! What do you do?",["Carefully try to pet it.","Let it adjust to me before approaching it.","Pick it up and pet it."])
	if cmd == 0
		@gentle += 2
		@timid += 1
	elsif cmd == 1
		@calm += 2
		@relaxed += 1
	elsif cmd == 2
		@rash +=2
		@bold +=1
	end
# Question 13
	cmd=pbMessage("What is your workflow like when doing tasks?",["Work hard until the task is complete.","Accomplish it little by little.","Procrastinate, then rush to finish it."])
	if cmd == 0
		@hardy += 2
		@serious += 1
	elsif cmd == 1
		@relaxed += 2
		@naive += 1
	elsif cmd == 2
		@lax +=2
		@naughty +=1
	end
# Question 14
	cmd=pbMessage("You have a crush on someone in your class. What do you do?",["Share my lunch with them!","Nothing. It's too embarrassing...","Confess to them in a letter."])
	if cmd == 0
		@naive += 2
		@quirky += 1
	elsif cmd == 1
		@bashful += 2
		@lonely += 1
	elsif cmd == 2
		@brave +=2
		@gentle +=1
	end
# Question 15
	cmd=pbMessage("What do you spend more of your time thinking about?",["How things are.","How things should be.","What I should have for dinner."])
	if cmd == 0
		@adamant += 2
		@hardy += 1
	elsif cmd == 1
		@mild += 2
		@quiet += 1
	elsif cmd == 2
		@quirky +=2
		@naive +=1
	end
# Question 16
	cmd=pbMessage("The people at the next table are singing for someone's birthday. What do you do?",["Join in. The more the merrier!","Stay silent. None of my business."])
	if cmd == 0
		@jolly += 2
		@hasty += 1
	elsif cmd == 1
		@quiet += 2
		@bashful += 1
	end
# Question 17
	cmd=pbMessage("Your friend hasn't replied to your texts in a while. What do you think?",["They're probably just busy.","I probably did something that upset them."])
	if cmd == 0
		@relaxed += 2
		@sassy += 1
	elsif cmd == 1
		@lonely += 2
		@impish += 1
	end
# Question 18
	cmd=pbMessage("You make a joke and nobody hears it, but someone else repeats it and everyone laughs. What do you do?",["Laugh along. It's no big deal.","Tell everyone you said it first."])
	if cmd == 0
		@calm += 2
		@lax += 1
	elsif cmd == 1
		@impish += 2
		@rash += 1
	end
# Question 19
	cmd=pbMessage("Your friend has painted some art! It's not very good. What do you do?",["Tell the truth. No point lying to them.","Nothing. Can't lie if I don't talk.","Talk only about the good parts."])
	if cmd == 0
		@brave += 2
		@bold += 1
	elsif cmd == 1
		@quiet += 2
		@naughty += 1
	elsif cmd == 2
		@gentle +=2
		@docile +=1
	end
# Question 20
	cmd=pbMessage("There's one last slot in your Pokémon team. Describe what kind of Pokémon you'd give that spot to.",["Edgy and intimidating.","Majestic and beautiful.","Smart and cunning."])
	if cmd == 0
		@lonely += 1
		@careful += 1
		@naive += 1
		@bold += 1
		@impish += 1
		@docile += 1
		@adamant += 1
		@modest += 1
	elsif cmd == 1
		@brave += 1
		@bashful += 1
		@lax += 1
		@gentle += 1
		@jolly += 1
		@naughty += 1
		@mild += 1
		@hasty += 1
	elsif cmd == 2
		@relaxed +=1
		@hardy +=1
		@serious += 1
		@quirky += 1
		@sassy += 1
		@calm += 1
		@quiet += 1
		@timid += 1
	end

	natures = [@lonely,@brave,@relaxed,@rash,@bashful,@careful,@hardy,@serious,@naive,@lax,@gentle,@quirky,@bold,@sassy,@jolly,@impish,@docile,@naughty,@calm,@quiet,@adamant,@mild,@modest,@hasty,@timid]

	count = 0
	natures.each do | num |
		if num.equal? natures.max
			count += 1
		end
	end

	if count > 1 # If there's a tie
		tiebreaker = Array.new
		natures.each_with_index do | element, index |
			if element.equal? natures.max
				tiebreaker << index
			end
		end
	 	@playernature = tiebreaker.sample
	else
		@playernature = natures.index(natures.max)+1
	end

	$game_variables[76] = @playernature

	if @playernature == natures.index(@lonely)+1 || @playernature ==  1
		@playernature = "LONELY"
		pbMessage("You have a Lonely nature.")
		pbMessage("A trainer like you would best suit Bulbasaur.")
	elsif @playernature == natures.index(@brave)+1 || @playernature ==  2
		@playernature = "BRAVE"
		pbMessage("You have a Brave nature.")
		pbMessage("A trainer like you would best suit Charmander.")
	elsif @playernature == natures.index(@relaxed)+1 || @playernature ==  3
		@playernature = "RELAXED"
		pbMessage("You have a Relaxed nature.")
		pbMessage("A trainer like you would best suit Squirtle.")
	elsif @playernature == natures.index(@rash)+1 || @playernature ==  4
		@playernature = "RASH"
		pbMessage("You have a Rash nature.")
		pbMessage("A trainer like you would best suit Pikachu.")
	elsif @playernature == natures.index(@bashful)+1 || @playernature ==  5
		@playernature = "BASHFUL"
		pbMessage("You have a Bashful nature.")
		pbMessage("A trainer like you would best suit Chikorita.")
	elsif @playernature == natures.index(@careful)+1 || @playernature ==  6
		@playernature = "CAREFUL"
		pbMessage("You have a Careful nature.")
		pbMessage("A trainer like you would best suit Cyndaquil.")
	elsif @playernature == natures.index(@hardy)+1 || @playernature ==  7
		@playernature = "HARDY"
		pbMessage("You have a Hardy nature.")
		pbMessage("A trainer like you would best suit Totodile.")
	elsif @playernature == natures.index(@serious)+1 || @playernature ==  8
		@playernature = "SERIOUS"
		pbMessage("You have a Serious nature.")
		pbMessage("A trainer like you would best suit Treecko.")
	elsif @playernature == natures.index(@naive)+1 || @playernature ==  9
		@playernature = "NAIVE"
		pbMessage("You have a Naive nature.")
		pbMessage("A trainer like you would best suit Torchic.")
	elsif @playernature == natures.index(@lax)+1 || @playernature ==  10
		@playernature = "LAX"
		pbMessage("You have a Lax nature.")
		pbMessage("A trainer like you would best suit Mudkip.")
	elsif @playernature == natures.index(@gentle)+1 || @playernature ==  11
		@playernature = "GENTLE"
		pbMessage("You have a Gentle nature.")
		pbMessage("A trainer like you would best suit Turtwig.")
	elsif @playernature == natures.index(@quirky)+1 || @playernature ==  12
		@playernature = "QUIRKY"
		pbMessage("You have a Quirky nature.")
		pbMessage("A trainer like you would best suit Chimchar.")
	elsif @playernature == natures.index(@bold)+1 || @playernature ==  13
		@playernature = "BOLD"
		pbMessage("You have a Bold nature.")
		pbMessage("A trainer like you would best suit Piplup.")
	elsif @playernature == natures.index(@sassy)+1 || @playernature ==  14
		@playernature = "SASSY"
		pbMessage("You have a Sassy nature.")
		pbMessage("A trainer like you would best suit Snivy.")
	elsif @playernature == natures.index(@jolly)+1 || @playernature ==  15
		@playernature = "JOLLY"
		pbMessage("You have a Jolly nature.")
		pbMessage("A trainer like you would best suit Tepig.")
	elsif @playernature == natures.index(@impish)+1 || @playernature ==  16
		@playernature = "IMPISH"
		pbMessage("You have a Impish nature.")
		pbMessage("A trainer like you would best suit Oshawott.")
	elsif @playernature == natures.index(@docile)+1 || @playernature ==  17
		@playernature = "DOCILE"
		pbMessage("You have a Docile nature.")
		pbMessage("A trainer like you would best suit Chespin.")
	elsif @playernature == natures.index(@naughty)+1 || @playernature ==  18
		@playernature = "NAUGHTY"
		pbMessage("You have a Naughty nature.")
		pbMessage("A trainer like you would best suit Fennekin.")
	elsif @playernature == natures.index(@calm)+1 || @playernature ==  19
		@playernature = "CALM"
		pbMessage("You have a Calm nature.")
		pbMessage("A trainer like you would best suit Froakie.")
	elsif @playernature == natures.index(@quiet)+1 || @playernature ==  20
		@playernature = "QUIET"
		pbMessage("You have a Quiet nature.")
		pbMessage("A trainer like you would best suit Rowlet.")
	elsif @playernature == natures.index(@adamant)+1 || @playernature ==  21
		@playernature = "ADAMANT"
		pbMessage("You have an Adamant nature.")
		pbMessage("A trainer like you would best suit Litten.")
	elsif @playernature == natures.index(@mild)+1 || @playernature ==  22
		@playernature = "MILD"
		pbMessage("You have a Mild nature.")
		pbMessage("A trainer like you would best suit Popplio.")
	elsif @playernature == natures.index(@modest)+1 || @playernature ==  23
		@playernature = "MODEST"
		pbMessage("You have a Modest nature.")
		pbMessage("A trainer like you would best suit Grookey.")
	elsif @playernature == natures.index(@hasty)+1 || @playernature ==  24
		@playernature = "HASTY"
		pbMessage("You have a Hasty nature.")
		pbMessage("A trainer like you would best suit Scorbunny.")
	elsif @playernature == natures.index(@timid)+1 || @playernature ==  25
		@playernature = "TIMID"
		pbMessage("You have a Timid nature.")
		pbMessage("A trainer like you would best suit Sobble.")
	end
end

def pbSelectStarter
	cmd=pbMessage("What region is this starter from?",["Kanto","Johto","Hoenn","Sinnoh","Unova","Kalos","Alola","Galar","Cancel"])
	if cmd == 0
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Bulbasaur","Charmander","Squirtle","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Bulbasaur?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "BULBASAUR"
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Charmander?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "CHARMANDER"
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Squirtle?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "SQUIRTLE"
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 1
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chikorita","Cyndaquil","Totodile","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Chikorita?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "CHIKORITA"
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Cyndaquil?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "CYNDAQUIL"
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Totodile?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "TOTODILE"
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 2
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Treecko","Torchic","Mudkip","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Treecko?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "TREECKO"
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Torchic?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "TORCHIC"
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Mudkip?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "MUDKIP"
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 3
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Turtwig","Chimchar","Piplup","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Turtwig?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "TURTWIG"
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Chimchar?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "CHIMCHAR"
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Piplup?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "PIPLUP"
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 4
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Snivy","Tepig","Oshawott","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Snivy?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "SNIVY"
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Tepig?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "TEPIG"
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Oshawott?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = "OSHAWOTT"
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 5
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chespin","Fennekin","Froakie","Cancel"])
		    if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Chespin?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "CHESPIN"
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Fennekin?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "FENNEKIN"
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Froakie?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "FROAKIE"
                    else pbSelectStarter end
            elsif cmd == 3
                pbSelectStarter
            end
	elsif cmd == 6
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Rowlet","Litten","Popplio","Cancel"])
            if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Rowlet?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "ROWLET"
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Litten?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "LITTEN"
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Popplio?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "POPPLIO"
                    else pbSelectStarter end
            elsif cmd == 3
                pbSelectStarter
            end
	elsif cmd == 7
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Grookey","Scorbunny","Sobble","Cancel"])
            if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Grookey?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "GROOKEY"
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Scorbunny?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "SCORBUNNY"
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Sobble?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = "SOBBLE"
                    else pbSelectStarter end
            elsif cmd == 3
                pbSelectStarter
            end
	elsif cmd == 8
		cmd=pbMessage("What would you like to do?",["Retake test","Manually choose starter"])
			if cmd == 0
				pbPersonalityTest
			elsif cmd == 1
				pbSelectStarter
			end
	end
end

def pbNatureStarter
	if @playernature == "LONELY"
		$game_variables[77] = "BULBASAUR"
	elsif @playernature == "BRAVE"
		$game_variables[77] = "CHARMANDER"
	elsif @playernature == "RELAXED"
		$game_variables[77] = "SQUIRTLE"
	elsif @playernature == "RASH"
		$game_variables[77] = "PIKACHU"
	elsif @playernature == "BASHFUL"
		$game_variables[77] = "CHIKORITA"
	elsif @playernature == "CAREFUL"
		$game_variables[77] = "CYNDAQUIL"
	elsif @playernature == "HARDY"
		$game_variables[77] = "TOTODILE"
	elsif @playernature == "SERIOUS"
		$game_variables[77] = "TREECKO"
	elsif @playernature == "NAIVE"
		$game_variables[77] = "TORCHIC"
	elsif @playernature == "LAX"
		$game_variables[77] = "MUDKIP"
	elsif @playernature == "GENTLE"
		$game_variables[77] = "TURTWIG"
	elsif @playernature == "QUIRKY"
		$game_variables[77] = "CHIMCHAR"
	elsif @playernature == "BOLD"
		$game_variables[77] = "PIPLUP"
	elsif @playernature == "SASSY"
		$game_variables[77] = "SNIVY"
	elsif @playernature == "JOLLY"
		$game_variables[77] = "TEPIG"
	elsif @playernature == "IMPISH"
		$game_variables[77] = "OSHAWOTT"
	elsif @playernature == "DOCILE"
		$game_variables[77] = "CHESPIN"
	elsif @playernature == "NAUGHTY"
		$game_variables[77] = "FENNEKIN"
	elsif @playernature == "CALM"
		$game_variables[77] = "FROAKIE"
	elsif @playernature == "QUIET"
		$game_variables[77] = "ROWLET"
	elsif @playernature == "ADAMANT"
		$game_variables[77] = "LITTEN"
	elsif @playernature == "MILD"
		$game_variables[77] = "POPPLIO"
	elsif @playernature == "MODEST"
		$game_variables[77] = "GROOKEY"
	elsif @playernature == "HASTY"
		$game_variables[77] = "SCORBUNNY"
	elsif @playernature == "TIMID"
		$game_variables[77] = "SOBBLE"
	end
end

def pbGetStarter
	if $game_variables[77] == "BULBASAUR"
		pbAddPokemon(:BULBASAUR,5)
	elsif $game_variables[77] == "CHARMANDER"
		pbAddPokemon(:CHARMANDER,5)
	elsif $game_variables[77] == "SQUIRTLE"
		pbAddPokemon(:SQUIRTLE,5)
	elsif $game_variables[77] == "PIKACHU"
		pbAddPokemon(:PIKACHU,5)
	elsif $game_variables[77] == "CHIKORITA"
		pbAddPokemon(:CHIKORITA,5)
	elsif $game_variables[77] == "CYNDAQUIL"
		pbAddPokemon(:CYNDAQUIL,5)
	elsif $game_variables[77] == "TOTODILE"
		pbAddPokemon(:TOTODILE,5)
	elsif $game_variables[77] == "TREECKO"
		pbAddPokemon(:TREECKO,5)
	elsif $game_variables[77] == "TORCHIC"
		pbAddPokemon(:TORCHIC,5)
	elsif $game_variables[77] == "MUDKIP"
		pbAddPokemon(:MUDKIP,5)
	elsif $game_variables[77] == "TURTWIG"
		pbAddPokemon(:TURTWIG,5)
	elsif $game_variables[77] == "CHIMCHAR"
		pbAddPokemon(:CHIMCHAR,5)
	elsif $game_variables[77] == "PIPLUP"
		pbAddPokemon(:PIPLUP,5)
	elsif $game_variables[77] == "SNIVY"
		pbAddPokemon(:SNIVY,5)
	elsif $game_variables[77] == "TEPIG"
		pbAddPokemon(:TEPIG,5)
	elsif $game_variables[77] == "OSHAWOTT"
		pbAddPokemon(:OSHAWOTT,5)
	elsif $game_variables[77] == "CHESPIN"
		pbAddPokemon(:CHESPIN,5)
	elsif $game_variables[77] == "FENNEKIN"
		pbAddPokemon(:FENNEKIN,5)
	elsif $game_variables[77] == "FROAKIE"
		pbAddPokemon(:FROAKIE,5)
	elsif $game_variables[77] == "ROWLET"
		pbAddPokemon(:ROWLET,5)
	elsif $game_variables[77] == "LITTEN"
		pbAddPokemon(:LITTEN,5)
	elsif $game_variables[77] == "POPPLIO"
		pbAddPokemon(:POPPLIO,5)
	elsif $game_variables[77] == "GROOKEY"
		pbAddPokemon(:GROOKEY,5)
	elsif $game_variables[77] == "SCORBUNNY"
		pbAddPokemon(:SCORBUNNY,5)
	elsif $game_variables[77] == "SOBBLE"
		pbAddPokemon(:SOBBLE,5)
	end
end