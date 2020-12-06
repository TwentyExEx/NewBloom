def pbFirstBiomeBoss
  bosslevels = [12,18,23,27,34,36,40,45,48,53,58,62,64] # Possible levels for boss teams
  $balance = pbBalancedLevel($Trainer.party) # Average of your current team

  # Sorts array values by how close they are to $balance
  @bosslevels.sort.group_by {|e| e <=> $balance}; 
  @bosslevelselect = @bosslevels.try(:[], 0).first || @bosslevels.try(:[], -1).last || @bosslevels[1].first # Sets boss level to closest level
  p @bosslevelselect
end 

def pbNextBiomeBoss
$balance = pbBalancedLevel($Trainer.party) # Average of your current team
# Compares @bosslevelselect that was stored from previous boss battle to new $balance
  if $balance >= @bosslevelselect
    # Gets next index in array @bosslevels
  elsif $balance < @bosslevelselect
    #  
  end
end