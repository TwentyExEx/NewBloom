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
	cmd=pbMessage("Do you like to do things according to plan?",["Definitely! I plan everything meticulously.","I can be pretty spontaneous."])
	if cmd == 0
		careful =+ 2
		serious =+ 1
	elsif cmd == 1
		lax =+ 2
		quirky =+ 1
	end

# Question 2
	cmd=pbMessage("Your friend takes a spectacular fall! What do you do?",["Follow after them and help them up.","Call for medical assistance.","Point and laugh. How did they manage that?!"])
	if cmd == 0
		mild =+ 2
		brave =+ 1
	elsif cmd == 1
		hasty =+ 2
		careful =+ 1
	elsif cmd == 2
		naughty =+2
		impish =+1
	end

# Question 3
	cmd=pbMessage("You're in a play with friends. What kind of role do you prefer?",["The starring role. I want all eyes on me!","The supportive best friend.","The tree in the back."])
	if cmd == 0
		sassy =+ 2
		jolly =+ 1
	elsif cmd == 1
		modest =+ 2
		calm =+ 1
	elsif cmd == 2
		bashful =+2
		timid =+1
	end

# Question 4
	cmd=pbMessage("Your friends seem to be having a fun chat out of earshot. What do you do?",["Leave. I’m probably left out for a reason.","Try to join in when there’s an opportunity.","Interrupt and redirect the conversation."])
	if cmd == 0
		lonely =+ 2
		bashful =+ 1
	elsif cmd == 1
		timid =+ 2
		mild =+ 1
	elsif cmd == 2
		bold =+2
		sassy =+1
	end

	natures = [lonely,brave,relaxed,rash,bashful,careful,hardy,serious,naive,lax,gentle,quirky,bold,sassy,jolly,impish,docile,naughty,calm,quiet,adamant,mild,modest,hasty,timid]

	playernature = natures.index(natures.max)+1

	if playernature == 1
		pbAddPokemon(:BULBASAUR,5)
	elsif playernature == 2
		pbAddPokemon(:CHARMANDER,5)
	elsif playernature == 3
		pbAddPokemon(:SQUIRTLE,5)
	elsif playernature == 4
		pbAddPokemon(:PIKACHU,5)
	elsif playernature == 5
		pbAddPokemon(:CHIKORITA,5)
	elsif playernature == 6
		pbAddPokemon(:CYNDAQUIL,5)
	elsif playernature == 7
		pbAddPokemon(:TOTODILE,5)
	elsif playernature == 8
		pbAddPokemon(:TREECKO,5)
	elsif playernature == 9
		pbAddPokemon(:TORCHIC,5)
	elsif playernature == 10
		pbAddPokemon(:MUDKIP,5)
	elsif playernature == 11
		pbAddPokemon(:TURTWIG,5)
	elsif playernature == 12
		pbAddPokemon(:CHIMCHAR,5)
	elsif playernature == 13
		pbAddPokemon(:PIPLUP,5)
	elsif playernature == 14
		pbAddPokemon(:SNIVY,5)
	elsif playernature == 15
		pbAddPokemon(:TEPIG,5)
	elsif playernature == 16
		pbAddPokemon(:OSHAWOTT,5)
	elsif playernature == 17
		pbAddPokemon(:CHESPIN,5)
	elsif playernature == 18
		pbAddPokemon(:FENNEKIN,5)
	elsif playernature == 19
		pbAddPokemon(:FROAKIE,5)
	elsif playernature == 20
		pbAddPokemon(:ROWLET,5)
	elsif playernature == 21
		pbAddPokemon(:LITTEN,5)
	elsif playernature == 22
		pbAddPokemon(:POPPLIO,5)
	elsif playernature == 23
		pbAddPokemon(:GROOKEY,5)
	elsif playernature == 24
		pbAddPokemon(:SCORBUNNY,5)
	elsif playernature == 25
		pbAddPokemon(:SOBBLE,5)
	end
end