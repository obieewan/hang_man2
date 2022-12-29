defmodule Hangman do #API module

  alias Hangman.Impl.Game #aliases the last word in the module chain

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @opaque game :: Game.t #any is base of all types any single type compatible with any
  @type tally :: %{
    turns_left: integer,
    game_state:  state,
    letters: list(String.t),
    used: list(String.t),
  }

  @spec new_game() :: game
  defdelegate new_game, to: Game #clear shows that the actual implementation of new game is in the Game module
  #makes it explicit that this is referrring that this is just an API

  @spec make_move(game, String.t) :: {game, tally} #expected to receive guess as string
  def make_move(game, guess) do
  end

end
