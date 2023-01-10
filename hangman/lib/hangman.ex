defmodule Hangman do #API module

  alias Hangman.Impl.Game #aliases the last word in the module chain
  alias Hangman.Type

  #opaque defines a type not usable outside module
  @opaque game :: Game.t #any is base of all types any single type compatible with any
  @type tally :: Type.tally
  

  @spec new_game() :: game
  defdelegate new_game, to: Game #clear shows that the actual implementation of new game is in the Game module
  #makes it explicit that this is referrring that this is just an API
  #
  
  @spec make_move(game, String.t) :: { game, Type.tally }
  defdelegate make_move(game, guess), to: Game

  #added API function for tally
  #this gonna call the tally function from the impl
  @spec tally(game) :: Type.tally()
  defdelegate tally(game), to: Game


end
