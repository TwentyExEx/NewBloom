def pbBossScale
  if $game_variables[31]==1 # If first biome boss 
    @bosslevel = [12,18,23,27,34,36,40,45,48,53,58,62,64] # All level variations of boss teams
    teamavg = pbBalancedLevel($Trainer.party)-2 # Get average of team
    # p "current team avg"
    # p teamavg
    computed = @bosslevel.map { |i| (teamavg - i).abs }
    index = computed.index(computed.min) 
    $bosslevelset = @bosslevel[index] # Closest value is set to boss level
    # p "current boss level"
    # p $bosslevelset
  else
    # p "last boss level"
    # p $game_variables[85]
    newteamavg = pbBalancedLevel($Trainer.party)-2
    # p "new team avg"
    # p newteamavg
    computed = @bosslevel.map { |i| (newteamavg - i).abs }
    index = computed.index(computed.min) 
    newbosslevel = @bosslevel[index] # Closest value is set to boss level
    # p "current boss level"
    # p newbosslevel
    if newbosslevel > $game_variables[85]
      # p "new boss level is higher"
      # p "new boss level is closest to team avg"
      teamavg = pbBalancedLevel($Trainer.party)-2
      # p "new team avg"
      # p teamavg
      computed = @bosslevel.map { |i| (teamavg - i).abs }
      index = computed.index(computed.min)
      $bosslevelset = @bosslevel[index]
      # p "new boss level"
      # p $bosslevelset
    else
      # p "new boss level is equal or lower"
      computed = @bosslevel.map { |i| ($game_variables[85] - i).abs }
      index = computed.index(computed.min)
      if @bosslevel[index] != 64
        # p "new boss level is the next level of last boss level"
        # p "last boss level"
        # p $game_variables[85]
        $bosslevelset = @bosslevel[index+1]
        # p "new boss level"
        # p $bosslevelset
      else
        # p "boss level is max level"
        # p "retain boss level"
        # p $bosslevelset
      end
    end
  end
end

def pbBossLevelStore
  # Run this when player wins
  $game_variables[85] = $bosslevelset
  $game_variables[31] += 1
  # p "saved boss level"
  # p $game_variables[85]
end