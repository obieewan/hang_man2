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
    {game, tally(game)}
  end


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



end
