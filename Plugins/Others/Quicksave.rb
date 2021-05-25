#==============================================================================#
#                                   Quicksave                                  #
#                                    by Marin                                  #
#==============================================================================#
#         Saves the game with a little animation upon pressing F8.             #
#==============================================================================#
#                    Please give credit when using this.                       #
#==============================================================================#

PluginManager.register({
  :name => "Quicksave",
  :version => "1.1",
  :credits => "Marin",
  :link => "https://reliccastle.com/resources/136/"
})

class Scene_Map
  alias quicksave_update update
  def update
    quicksave_update
    if Input.triggerex?(0x53) && !$game_player.moving? && @mode.nil?
      autoresume=false
      Game.save
      pbSEPlay("GUI save choice") if FileTest.audio_exist?("Audio/SE/GUI save choice")
      @wait_count = 4 * Graphics.frame_rate/20
      pbMessage("Your game has been saved.\\wtnp[6]")
    end
  end
end