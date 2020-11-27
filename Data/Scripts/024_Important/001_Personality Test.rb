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
		pbMessage("You have a Lonely nature.")
		pbMessage("A trainer like you would best suit Bulbasaur.")
	elsif @playernature == natures.index(@brave)+1 || @playernature ==  2
		pbMessage("You have a Brave nature.")
		pbMessage("A trainer like you would best suit Charmander.")
	elsif @playernature == natures.index(@relaxed)+1 || @playernature ==  3
		pbMessage("You have a Relaxed nature.")
		pbMessage("A trainer like you would best suit Squirtle.")
	elsif @playernature == natures.index(@rash)+1 || @playernature ==  4
		pbMessage("You have a Rash nature.")
		pbMessage("A trainer like you would best suit Pikachu.")
	elsif @playernature == natures.index(@bashful)+1 || @playernature ==  5
		pbMessage("You have a Bashful nature.")
		pbMessage("A trainer like you would best suit Chikorita.")
	elsif @playernature == natures.index(@careful)+1 || @playernature ==  6
		pbMessage("You have a Careful nature.")
		pbMessage("A trainer like you would best suit Cyndaquil.")
	elsif @playernature == natures.index(@hardy)+1 || @playernature ==  7
		pbMessage("You have a Hardy nature.")
		pbMessage("A trainer like you would best suit Totodile.")
	elsif @playernature == natures.index(@serious)+1 || @playernature ==  8
		pbMessage("You have a Serious nature.")
		pbMessage("A trainer like you would best suit Treecko.")
	elsif @playernature == natures.index(@naive)+1 || @playernature ==  9
		pbMessage("You have a Naive nature.")
		pbMessage("A trainer like you would best suit Torchic.")
	elsif @playernature == natures.index(@lax)+1 || @playernature ==  10
		pbMessage("You have a Lax nature.")
		pbMessage("A trainer like you would best suit Mudkip.")
	elsif @playernature == natures.index(@gentle)+1 || @playernature ==  11
		pbMessage("You have a Gentle nature.")
		pbMessage("A trainer like you would best suit Turtwig.")
	elsif @playernature == natures.index(@quirky)+1 || @playernature ==  12
		pbMessage("You have a Quirky nature.")
		pbMessage("A trainer like you would best suit Chimchar.")
	elsif @playernature == natures.index(@bold)+1 || @playernature ==  13
		pbMessage("You have a Bold nature.")
		pbMessage("A trainer like you would best suit Piplup.")
	elsif @playernature == natures.index(@sassy)+1 || @playernature ==  14
		pbMessage("You have a Sassy nature.")
		pbMessage("A trainer like you would best suit Snivy.")
	elsif @playernature == natures.index(@jolly)+1 || @playernature ==  15
		pbMessage("You have a Jolly nature.")
		pbMessage("A trainer like you would best suit Tepig.")
	elsif @playernature == natures.index(@impish)+1 || @playernature ==  16
		pbMessage("You have a Impish nature.")
		pbMessage("A trainer like you would best suit Oshawott.")
	elsif @playernature == natures.index(@docile)+1 || @playernature ==  17
		pbMessage("You have a Docile nature.")
		pbMessage("A trainer like you would best suit Chespin.")
	elsif @playernature == natures.index(@naughty)+1 || @playernature ==  18
		pbMessage("You have a Naughty nature.")
		pbMessage("A trainer like you would best suit Fennekin.")
	elsif @playernature == natures.index(@calm)+1 || @playernature ==  19
		pbMessage("You have a Calm nature.")
		pbMessage("A trainer like you would best suit Froakie.")
	elsif @playernature == natures.index(@quiet)+1 || @playernature ==  20
		pbMessage("You have a Quiet nature.")
		pbMessage("A trainer like you would best suit Rowlet.")
	elsif @playernature == natures.index(@adamant)+1 || @playernature ==  21
		pbMessage("You have an Adamant nature.")
		pbMessage("A trainer like you would best suit Litten.")
	elsif @playernature == natures.index(@mild)+1 || @playernature ==  22
		pbMessage("You have a Mild nature.")
		pbMessage("A trainer like you would best suit Popplio.")
	elsif @playernature == natures.index(@modest)+1 || @playernature ==  23
		pbMessage("You have a Modest nature.")
		pbMessage("A trainer like you would best suit Grookey.")
	elsif @playernature == natures.index(@hasty)+1 || @playernature ==  24
		pbMessage("You have a Hasty nature.")
		pbMessage("A trainer like you would best suit Scorbunny.")
	elsif @playernature == natures.index(@timid)+1 || @playernature ==  25
		pbMessage("You have a Timid nature.")
		pbMessage("A trainer like you would best suit Sobble.")
	end
end

def pbSelectStarter
	cmd=pbMessage("What region is this starter from?",["Kanto","Johto","Hoenn","Sinnoh","Unova","Kalos","Alola","Galar","Cancel"])
	if cmd == 0
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Bulbasaur","Charmander","Squirtle","Pikachu","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Bulbasaur?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 1
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Charmander?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 2
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Squirtle?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 3
					else pbSelectStarter end
			elsif cmd == 3
				cmd=pbMessage("Are you sure you want to choose Pikachu?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 4
					else pbSelectStarter end
			elsif cmd == 4
				pbSelectStarter
			end
	elsif cmd == 1
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chikorita","Cyndaquil","Totodile","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Chikorita?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 5
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Cyndaquil?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 6
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Totodile?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 7
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 2
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Treecko","Torchic","Mudkip","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Treecko?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 8
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Torchic?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 9
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Mudkip?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 10
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 3
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Turtwig","Chimchar","Piplup","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Turtwig?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 11
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Chimchar?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 12
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Piplup?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 13
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 4
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Snivy","Tepig","Oshawott","Cancel"])
			if cmd == 0
				cmd=pbMessage("Are you sure you want to choose Snivy?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 14
					else pbSelectStarter end
			elsif cmd == 1
				cmd=pbMessage("Are you sure you want to choose Tepig?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 15
					else pbSelectStarter end
			elsif cmd == 2
				cmd=pbMessage("Are you sure you want to choose Oshawott?",["Yes","No"])
					if cmd == 0
						$game_variables[77] = 16
					else pbSelectStarter end
			elsif cmd == 3
				pbSelectStarter
			end
	elsif cmd == 5
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chespin","Fennekin","Froakie","Cancel"])
		    if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Chespin?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 17
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Fennekin?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 18
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Froakie?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 19
                    else pbSelectStarter end
            elsif cmd == 3
                pbSelectStarter
            end
	elsif cmd == 6
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Rowlet","Litten","Popplio","Cancel"])
            if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Rowlet?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 20
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Litten?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 21
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Popplio?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 22
                    else pbSelectStarter end
            elsif cmd == 3
                pbSelectStarter
            end
	elsif cmd == 7
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Grookey","Scorbunny","Sobble","Cancel"])
            if cmd == 0
                cmd=pbMessage("Are you sure you want to choose Grookey?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 23
                    else pbSelectStarter end
            elsif cmd == 1
                cmd=pbMessage("Are you sure you want to choose Scorbunny?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 24
                    else pbSelectStarter end
            elsif cmd == 2
                cmd=pbMessage("Are you sure you want to choose Sobble?",["Yes","No"])
                    if cmd == 0
                        $game_variables[77] = 25
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
	if @playernature = @lonely
		$game_variables[77] = 1
	elsif @playernature = @brave
		$game_variables[77] = 2
	elsif @playernature = @relaxed
		$game_variables[77] = 3
	elsif @playernature = @rash
		$game_variables[77] = 4
	elsif @playernature = @bashful
		$game_variables[77] = 5
	elsif @playernature = @careful
		$game_variables[77] = 6
	elsif @playernature = @hardy
		$game_variables[77] = 7
	elsif @playernature = @serious
		$game_variables[77] = 8
	elsif @playernature = @naive
		$game_variables[77] = 9
	elsif @playernature = @lax
		$game_variables[77] = 10
	elsif @playernature = @gentle
		$game_variables[77] = 11
	elsif @playernature = @quirky
		$game_variables[77] = 12
	elsif @playernature = @bold
		$game_variables[77] = 13
	elsif @playernature = @sassy
		$game_variables[77] = 14
	elsif @playernature = @jolly
		$game_variables[77] = 15
	elsif @playernature = @impish
		$game_variables[77] = 16
	elsif @playernature = @docile
		$game_variables[77] = 17
	elsif @playernature = @naughty
		$game_variables[77] = 18
	elsif @playernature = @calm
		$game_variables[77] = 19
	elsif @playernature = @quiet
		$game_variables[77] = 20
	elsif @playernature = @adamant
		$game_variables[77] = 21
	elsif @playernature = @mild
		$game_variables[77] = 22
	elsif @playernature = @modest
		$game_variables[77] = 23
	elsif @playernature = @hasty
		$game_variables[77] = 24
	elsif @playernature = @timid
		$game_variables[77] = 25
	end
end