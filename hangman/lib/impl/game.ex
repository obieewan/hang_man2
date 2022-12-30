defmodule Hangman.Impl.Game do 

  alias Hangman.Type


  #for defstruct: the name of the struct is the module name defstruct(
  # logical structure of what we are returning
  #we'll be able to access the type of this module as Hangman.Impl.Game.t
  @type t :: %__MODULE__{
    turns_left: integer, 
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  defstruct(
    turns_left: 7, 
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )  
  ################################
  #spec is type of the module t @type
  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.random_word)
  end
  
  #this expects a word the from dictionary as string as type
  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
    letters: word |> String.codepoints 
    }
  end

  #################################
           
  
  @spec make_move(t, String.t) :: {t, Type.tally} #expected to receive guess as string
  #this function is called only if the game_state is won or lost
  #returns with the existing state
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
    #piped to a function returns to existing state if :won or :lost
  end

  #if not :won or :lost it will accept a guess letter  
  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess) 
    #created a function that accepts guess
    #returns true or false if the guess already use
    |> return_with_tally
  end
  ############################## 
  
  defp accept_guess(game, _guess, _already_used = true) do
    #generate a new map based on the contents of game with game state set to already used
    # returns an identical struct except the game_state
    %{ game | game_state: :already_used}
  end

  #treat it as false for used letter
  #update the letters in used map using MapSet.put
  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
  end

  ############################## 

  #tally expecting game as map
  #this is a tally function
  defp tally(game) do
    %{
    turns_left: game.turns_left,
    game_state:  game.game_state,
    letters: [],
    used: game.used |> MapSet.to_list |> Enum.sort 
    }   
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end



end
