def pbPersonalityTest
	lonely = 0
	brave = 0
	relaxed = 0
	rash = 0
	bashful = 0
	careful = 0
	hardy = 0
	serious = 0
	naive = 0
	lax = 0
	gentle = 0
	quirky = 0
	bold = 0
	sassy = 0
	jolly = 0
	impish = 0
	docile = 0
	naughty = 0
	calm = 0
	quiet = 0
	adamant = 0
	mild = 0
	modest = 0
	hasty = 0
	timid = 0

# Question 1
    cmd=pbMessage("You're cooking a new recipe, but midway through preparations, you realize you're missing a few ingredients. What do you do?",["Go to the store and buy them.","Substitute them with something else."])
    if cmd == 0
        careful += 2
        serious += 1
    elsif cmd == 1
        lax += 2
        quirky += 1
    end
# Question 2
	cmd=pbMessage("You've just seen someone trip! What do you do?",["Go over to them and help them up.","Take them to the hospital.","Quietly laugh. How did they manage that?!"])
	if cmd == 0
		mild += 2
		brave += 1
	elsif cmd == 1
		hasty += 2
		careful += 1
	elsif cmd == 2
		naughty +=2
		impish +=1
	end
# Question 3
	cmd=pbMessage("You're in a play with friends. What kind of role do you prefer?",["The starring role. I want all eyes on me!","The supportive best friend.","The tree in the back."])
	if cmd == 0
		sassy += 2
		jolly += 1
	elsif cmd == 1
		modest += 2
		calm += 1
	elsif cmd == 2
		bashful +=2
		timid +=1
	end
# Question 4
	cmd=pbMessage("Your friends seem to be having a fun chat out of earshot. What do you do?",["Leave. I'm probably left out for a reason.","Try to join in when there's an opportunity.","Interrupt and redirect the conversation."])
	if cmd == 0
		lonely += 2
		bashful += 1
	elsif cmd == 1
		timid += 2
		mild += 1
	elsif cmd == 2
		bold +=2
		sassy +=1
	end
# Question 5
	cmd=pbMessage("You find something at a great bargain! What do you do?",["Jump at the deal and buy it.","Consider if I really need it before deciding."])
	if cmd == 0
		hasty += 2
		adamant += 1
	elsif cmd == 1
		careful += 2
		mild += 1
	end
# Question 6
	cmd=pbMessage("You're going on a day trip to the mountains. What are you most excited to do?",["Hiking. It's perfect to clear my mind.","Roasting marshmallows. Delicious!","Telling ghost stories. Boo!"])
	if cmd == 0
		serious += 2
		hardy += 1
	elsif cmd == 1
		quirky += 2
		relaxed += 1
	elsif cmd == 2
		impish +=2
		jolly +=1
	end
# Question 7
	cmd=pbMessage("You are planning a vacation! Where would you prefer to go?",["Somewhere totally new.","Somewhere close to home."])
	if cmd == 0
		bold += 2
		brave += 1
	elsif cmd == 1
		timid += 2
		quiet += 1
	end
# Question 8
	cmd=pbMessage("If you face a problem at work, what is the first thing you do?",["Pretend I never noticed.","Experiment to see what fixes it.","Ask for help. Someone else could do better."])
	if cmd == 0
		naughty += 2
		hasty += 1
	elsif cmd == 1
		sassy += 2
		careful += 1
	elsif cmd == 2
		modest +=2
		docile +=1
	end
# Question 9
	cmd=pbMessage("You are at a restaurant you've been to before. What do you order?",["Play it safe and stick with my usual order.","Whatever looks good in the menu!","Go with the waiter's recommendation."])
	if cmd == 0
		adamant += 2
		modest += 1
	elsif cmd == 1
		jolly += 2
		lax += 1
	elsif cmd == 2
		docile +=2
		calm +=1
	end
# Question 10
	cmd=pbMessage("How do you go about making big decisions?",["Go with my gut then move on.","Weigh out the pros and cons."])
	if cmd == 0
		rash += 2
		adamant += 1
	elsif cmd == 1
		serious += 2
		modest += 1
	end
# Question 11
	cmd=pbMessage("How do you usually participate in group projects?",["Assume the role of the leader.","Do whatever no one else wants to do.","Act as moral support."])
	if cmd == 0
		hardy += 2
		rash += 1
	elsif cmd == 1
		docile += 2
		lonely += 1
	elsif cmd == 2
		naive +=2
		gentle +=1
	end
# Question 12
	cmd=pbMessage("Your friend just got a new pet! What do you do?",["Carefully try to pet it.","Let it adjust to me before approaching it.","Pick it up and pet it."])
	if cmd == 0
		gentle += 2
		timid += 1
	elsif cmd == 1
		calm += 2
		relaxed += 1
	elsif cmd == 2
		rash +=2
		bold +=1
	end
# Question 13
	cmd=pbMessage("What is your workflow like when doing tasks?",["Work hard until the task is complete.","Accomplish it little by little.","Procrastinate, then rush to finish it."])
	if cmd == 0
		hardy += 2
		serious += 1
	elsif cmd == 1
		relaxed += 2
		naive += 1
	elsif cmd == 2
		lax +=2
		naughty +=1
	end
# Question 14
	cmd=pbMessage("You have a crush on someone in your class. What do you do?",["Share my lunch with them!","Nothing. It's too embarrassing...","Confess to them in a letter."])
	if cmd == 0
		naive += 2
		quirky += 1
	elsif cmd == 1
		bashful += 2
		lonely += 1
	elsif cmd == 2
		brave +=2
		gentle +=1
	end
# Question 15
	cmd=pbMessage("What do you spend more of your time thinking about?",["How things are.","How things should be.","What I should have for dinner."])
	if cmd == 0
		adamant += 2
		hardy += 1
	elsif cmd == 1
		mild += 2
		quiet += 1
	elsif cmd == 2
		quirky +=2
		naive +=1
	end
# Question 16
	cmd=pbMessage("The people at the next table are singing for someone's birthday. What do you do?",["Join in. The more the merrier!","Stay silent. None of my business."])
	if cmd == 0
		jolly += 2
		hasty += 1
	elsif cmd == 1
		quiet += 2
		bashful += 1
	end
# Question 17
	cmd=pbMessage("Your friend hasn't replied to your texts in a while. What do you think?",["They're probably just busy.","I probably did something that upset them."])
	if cmd == 0
		relaxed += 2
		sassy += 1
	elsif cmd == 1
		lonely += 2
		impish += 1
	end
# Question 18
	cmd=pbMessage("You make a joke and nobody hears it, but someone else repeats it and everyone laughs. What do you do?",["Laugh along. It's no big deal.","Tell everyone you said it first."])
	if cmd == 0
		calm += 2
		lax += 1
	elsif cmd == 1
		impish += 2
		rash += 1
	end
# Question 19
	cmd=pbMessage("Your friend has painted some art! It's not very good. What do you do?",["Tell the truth. No point lying to them.","Nothing. Can't lie if I don't talk.","Talk only about the good parts."])
	if cmd == 0
		brave += 2
		bold += 1
	elsif cmd == 1
		quiet += 2
		naughty += 1
	elsif cmd == 2
		gentle +=2
		docile +=1
	end
# Question 20
	cmd=pbMessage("There's one last slot in your Pokémon team. Describe what kind of Pokémon you'd give that spot to.",["Edgy and intimidating.","Majestic and beautiful.","Smart and cunning."])
	if cmd == 0
		lonely += 1
		careful += 1
		naive += 1
		bold += 1
		impish += 1
		docile += 1
		adamant += 1
		modest += 1
	elsif cmd == 1
		brave += 1
		bashful += 1
		lax += 1
		gentle += 1
		jolly += 1
		naughty += 1
		mild += 1
		hasty += 1
	elsif cmd == 2
		relaxed +=1
		hardy +=1
		serious += 1
		quirky += 1
		sassy += 1
		calm += 1
		quiet += 1
		timid += 1
	end

	natures = [lonely,brave,relaxed,rash,bashful,careful,hardy,serious,naive,lax,gentle,quirky,bold,sassy,jolly,impish,docile,naughty,calm,quiet,adamant,mild,modest,hasty,timid]

	count = 0
	natures.each do | num |
		if num.equal? natures.max
			count += 1
		end
	end

	if count > 1 # If there's a tie
		p "It's a tie!"
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

	if @playernature == 1 # Lonely
		pbMessage("You have a Lonely nature.")
	elsif @playernature == 2 # Brave
		
	elsif @playernature == 3 # Relaxed
		
	elsif @playernature == 4 # Rash
		
	elsif @playernature == 5 # Bashfu;
		
	elsif @playernature == 6 # Careful
		
	elsif @playernature == 7 # Hardy
		
	elsif @playernature == 8 # Serious
		
	elsif @playernature == 9 # Naive
		
	elsif @playernature == 10 # Lax
		
	elsif @playernature == 11 # Gentle
		
	elsif @playernature == 12 # Quirky
		
	elsif @playernature == 13 # Bold
		
	elsif @playernature == 14 # Sasst
		
	elsif @playernature == 15 # Jolly
		
	elsif @playernature == 16 # Impish
		
	elsif @playernature == 17 # Docile
		
	elsif @playernature == 18 # Naughty
		
	elsif @playernature == 19 # Calm
		
	elsif @playernature == 20 # Quiet
		
	elsif @playernature == 21 # Adamant
		
	elsif @playernature == 22 # Mild
		
	elsif @playernature == 23 # Modest
		
	elsif @playernature == 24 # Hasty
		
	elsif @playernature == 25 # Timid
		
	end
end

def pbSelectStarter
	cmd=pbMessage("What region is this starter from?",["Kanto","Johto","Hoenn","Sinnoh","Unova","Kalos","Alola","Galar"])
	if cmd == 0
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Bulbasaur","Charmander","Squirtle","Pikachu"])
	elsif cmd == 1
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chikorita","Cyndaquil","Totodile"])
	elsif cmd == 2
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Treecko","Torchic","Mudkip"])
	elsif cmd == 3
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Turtwig","Chimchar","Piplup"])
	elsif cmd == 4
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Snivy","Tepig","Oshawott"])
	elsif cmd == 5
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Chespin","Fennekin","Froakie"])
	elsif cmd == 6
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Rowlet","Litten","Popplio"])
	elsif cmd == 7
		cmd=pbMessage("Select the Pokémon you want to journey with.",["Grookey","Scorbunny","Sobble"])
	end
end

def pbNatureStarter
	if @playernature == 1 # Lonely
		pbAddPokemon(:BULBASAUR,5)
	elsif @playernature == 2 # Brave
		pbAddPokemon(:CHARMANDER,5)
	elsif @playernature == 3 # Relaxed
		pbAddPokemon(:SQUIRTLE,5)
	elsif @playernature == 4 # Rash
		pbAddPokemon(:PIKACHU,5)
	elsif @playernature == 5 # Bashfu;
		pbAddPokemon(:CHIKORITA,5)
	elsif @playernature == 6 # Careful
		pbAddPokemon(:CYNDAQUIL,5)
	elsif @playernature == 7 # Hardy
		pbAddPokemon(:TOTODILE,5)
	elsif @playernature == 8 # Serious
		pbAddPokemon(:TREECKO,5)
	elsif @playernature == 9 # Naive
		pbAddPokemon(:TORCHIC,5)
	elsif @playernature == 10 # Lax
		pbAddPokemon(:MUDKIP,5)
	elsif @playernature == 11 # Gentle
		pbAddPokemon(:TURTWIG,5)
	elsif @playernature == 12 # Quirky
		pbAddPokemon(:CHIMCHAR,5)
	elsif @playernature == 13 # Bold
		pbAddPokemon(:PIPLUP,5)
	elsif @playernature == 14 # Sasst
		pbAddPokemon(:SNIVY,5)
	elsif @playernature == 15 # Jolly
		pbAddPokemon(:TEPIG,5)
	elsif @playernature == 16 # Impish
		pbAddPokemon(:OSHAWOTT,5)
	elsif @playernature == 17 # Docile
		pbAddPokemon(:CHESPIN,5)
	elsif @playernature == 18 # Naughty
		pbAddPokemon(:FENNEKIN,5)
	elsif @playernature == 19 # Calm
		pbAddPokemon(:FROAKIE,5)
	elsif @playernature == 20 # Quiet
		pbAddPokemon(:ROWLET,5)
	elsif @playernature == 21 # Adamant
		pbAddPokemon(:LITTEN,5)
	elsif @playernature == 22 # Mild
		pbAddPokemon(:POPPLIO,5)
	elsif @playernature == 23 # Modest
		pbAddPokemon(:GROOKEY,5)
	elsif @playernature == 24 # Hasty
		pbAddPokemon(:SCORBUNNY,5)
	elsif @playernature == 25 # Timid
		pbAddPokemon(:SOBBLE,5)
	end
end